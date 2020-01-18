module Parser where

import Control.Applicative
import qualified Data.Attoparsec.Text as Atto
import Data.Foldable
import Data.Text (Text)
import qualified Data.Text as Text


data Expr
  

string :: Atto.Parser Text
string = do
  Atto.char '"'
  let takeAllTheText :: Atto.Parser Text
      takeAllTheText = do
        str <- Atto.takeWhile1 (flip (notElem @[] @Char) "\"\\")
        if Text.last str == '\"'
        then pure str
        else Atto.string "\"" <|> takeAllTheText
  fold <$> Atto.many' takeAllTheText

