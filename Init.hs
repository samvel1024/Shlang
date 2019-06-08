-- automatically generated by BNF Converter
module Main where

import           Control.Monad      (when)
import           System.Environment (getArgs, getProgName)
import           System.Exit        (exitFailure, exitSuccess)
import           System.IO          (hGetContents, stdin)

import           EvaluateProgram
import           LexDeclaration
import           ParDeclaration

import           ErrM

import           TypeChecker        (checkProgramTypesIO)

usage = do
  putStrLn "provide an input file name as an argument"
  exitFailure

main :: IO ()
main = do
  args <- getArgs
  input <-
    case args of
      []           -> usage
      (fileName:_) -> readFile fileName
  case pProgram (myLexer input) of
    Bad s -> do
      putStrLn "\nParse              Failed...\n"
      putStrLn "Tokens:"
      putStrLn s
      exitFailure
    Ok tree -> do
      correctTypes <- checkProgramTypesIO tree
      if correctTypes
        then runProgramIO tree
        else exitFailure
