{-# LANGUAGE BlockArguments,
             LambdaCase,
             RecordWildCards,
             DeriveGeneric,
             DeriveAnyClass,
             OverloadedStrings
#-}

module Lib where


import Control.Arrow
import Control.Monad
import qualified Data.Aeson as Aeson
import qualified Data.ByteString.Lazy as LBytes
import Data.Foldable (foldMap)
import Data.Function ((&))
import Data.Text (Text)
import qualified Data.Text as Text
import qualified Discord as Discord
import qualified Discord.Internal.Rest as Discord
import qualified Discord.Internal.Rest.Channel as Discord
import GHC.Generics (Generic)
import System.IO as IO
import System.Random as Random


data Config
  = Config
      { discordSecret :: Text
      }
  deriving (Show, Generic, Aeson.FromJSON)


loadConfig :: IO (Maybe Config)
loadConfig = Aeson.decode <$> LBytes.readFile "config.json"

handleDiscordEvent :: Discord.DiscordHandle -> Discord.Event -> IO ()
handleDiscordEvent = flip $ \case
  Discord.MessageCreate msg -> handleDiscordMessage msg
  event -> const $ print event

handleDiscordMessage :: Discord.Message -> Discord.DiscordHandle -> IO ()
handleDiscordMessage (Discord.Message {..}) handle = do
  when ("Tombot" `Text.isPrefixOf` messageText) do
    e <- Discord.restCall handle <<< Discord.CreateMessage messageChannel =<< babby
    print e

  where
    babbys =
      [ "*gurgles*"
      , "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA!!!!!!!!!!"
      , "overthrow the banking oligarchy"
      , "abababbebebabebba"
      , "oooooououeueeuuuou"
      , "higihgijghjhjjgh"
      , "eeeeeeeeeeeeeeee"
      ]
    babby = (babbys !!) <$> Random.randomRIO (0, length babbys)

someFunc :: IO ()
someFunc = do
  putStrLn "Initiating the pipo"
  putStrLn "https://youtu.be/_DiUa8hgNow"
  config <- loadConfig
  print config
  error <- config & foldMap (Discord.runDiscord <<< opts)
  print error

  where
    opts (Config {..}) = Discord.def
      { Discord.discordToken = "Bot " <> discordSecret
      , Discord.discordOnEvent = handleDiscordEvent
      , Discord.discordOnLog = \text -> putStr "Log " >> print text
      }
