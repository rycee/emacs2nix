{-# LANGUAGE OverloadedStrings #-}

module Distribution.Nix.Name
       ( Name
       , fromText, fromName
       ) where

import Data.Char ( isDigit )
import Data.Text ( Text )
import qualified Data.Text as T
import Data.Text.ICU.Replace ( replaceAll )

import Distribution.Nix.Pretty

newtype Name = Name { fromName :: Text }

instance Pretty Name where
  pretty = text . fromName

fromText :: Text -> Name
fromText = Name
           . prefixDigits

           . replaceAll "@" "-at-"
           . replaceAll "^@" "at-"
           . replaceAll "@$" "-at"
           . replaceAll "^@$" "at"

           . replaceAll "+" "-plus-"
           . replaceAll "^+" "plus-"
           . replaceAll "+$" "-plus"
           . replaceAll "^+$" "plus"
  where
    -- Nix does not allow identifiers to begin with digits
    prefixDigits txt
      | T.null txt = txt
      | isDigit (T.head txt) = T.cons '_' txt
      | otherwise = txt
