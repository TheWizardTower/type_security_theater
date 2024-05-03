{-# LANGUAGE ScopedTypeVariables #-}

module Main (main) where

import Control.Exception (ErrorCall, Exception, catch)
import Control.Monad (void)
import Control.Monad.Except (ExceptT, runExceptT)
import Control.Monad.Trans (lift)
import GHC.IO.Exception (IOException (..))
import System.IO (IOMode (..), hPutStr, openFile, stderr)

main :: IO ()
main = do
    putStrLn "\n\n\nRunning without ExceptT:"
    catch
      (myBugFreeFunction)
      (handler "My bug free code exploded!")
    hPutStr stderr "\n\n"
    putStrLn "Running with ExceptT:"
    catch
      (void $ runExceptT myBugFreeExceptTFunction)
      (handler "My bug free ExceptT code exploded!")

    putStrLn "\n\n\nRunning without ExceptT:"
    hPutStr stderr "\n\n"
    catch
      (myBugFreeFileRead)
      (handlerFile "My bug free file read function failed!")
    putStrLn "\n\nRunning with ExceptT:"
    hPutStr stderr "\n\n"
    catch
      (void $ runExceptT myBugFreeExceptTFileRead)
      (handlerFile "My bug free ExceptT file read function failed!")
    hPutStr stderr "\n\n"

    putStrLn "End of main!"

handler :: String -> ErrorCall -> IO ()
handler msg e = handlerInner msg e

handlerFile :: String -> IOException -> IO ()
handlerFile msg e = handlerInner msg e

handlerInner :: (Exception e) => String -> e -> IO ()
handlerInner msg e = hPutStr stderr $ msg <> " " <> show e

myBugFreeFunction :: IO ()
myBugFreeFunction = do
    let myElem = head []
    putStrLn myElem
    putStrLn "End of bug-free function!"

myBugFreeExceptTFunction :: ExceptT ErrorCall IO ()
myBugFreeExceptTFunction = do
    let myElem = head []
    lift $ do
        putStrLn myElem
        putStrLn "End of bug-free ExceptT function!"

myBugFreeFileRead :: IO ()
myBugFreeFileRead = do
    _ <- openFile "sir-not-appearing-in-this-talk.txt" ReadMode
    putStrLn "End of bug-free file read function!"

myBugFreeExceptTFileRead :: ExceptT IOException IO ()
myBugFreeExceptTFileRead = do
    lift $ do
        _ <- openFile "sir-not-appearing-in-this-talk.txt" ReadMode
        putStrLn "End of bug-free ExceptT file read function!"
