module GlobRegex
    (
      globToRegex
    , matchesGlob
    , GlobError
    ) where

import Text.Regex.Posix ((=~))


type GlobError = String 


globToRegex :: String -> Either GlobError String
globToRegex cs = (\reg ->'^' : reg ++ "$") <$> globToRegex' cs

globToRegex' :: String -> Either GlobError String
globToRegex' ""             = Right ""
globToRegex' ('*':cs)       = (".*" ++) <$> globToRegex' cs
globToRegex' ('?':cs)       = ('.' :) <$> globToRegex' cs
globToRegex' ('[':'!':c:cs) = ("[^"++) <$> (c:) <$> charClass cs
globToRegex' ('[':c:cs)     = ('[':) <$> (c:) <$> charClass cs
globToRegex' ('[':_)        = Left "unterminated character class"
globToRegex' (c:cs)         = (escape c ++)<$> globToRegex' cs

escape :: Char -> String
escape c | c `elem` regexChars = '\\' : [c]
         | otherwise = [c]
    where regexChars = "\\+()^$.{}]|"

charClass :: String -> Either GlobError String
charClass (']':cs) = (']' :) <$> globToRegex' cs
charClass (c:cs)   = (c :) <$> charClass cs
charClass []       = Left "unterminated character class"

matchesGlob :: FilePath -> String -> Either GlobError Bool
matchesGlob name pat = (name =~) <$> globToRegex pat
