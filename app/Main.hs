module Main where

import System.Environment
import GlobRegex


type ArgError = String

data CLIArgs = CLIArgs {
   getPattern :: String
  ,getTarget :: String
} deriving (Show)


main :: IO ()
main = do 
    args <- getCLIArgs
    case args >>= checkMatch of
      Right message -> putStrLn message
      Left e -> putStrLn $ "ERROR: " ++ e

checkMatch :: CLIArgs -> Either GlobError String
checkMatch args = checkMatch' <$> matchesGlob target pattern
    where 
       checkMatch' True  = target ++ " matches " ++ pattern
       checkMatch' False = target ++ " does not match "++ pattern
       target = getTarget args
       pattern = getPattern args

getCLIArgs :: IO (Either ArgError CLIArgs)
getCLIArgs = parseArgs <$> getArgs

parseArgs:: [String] -> Either ArgError CLIArgs
parseArgs (pattern:target:_) = Right $ CLIArgs pattern target
parseArgs _ = Left "Incorrect args, expected <pattern> <target>"
