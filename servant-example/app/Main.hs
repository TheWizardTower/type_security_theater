{-# LANGUAGE DataKinds      #-}
{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric  #-}
{-# LANGUAGE LambdaCase     #-}
{-# LANGUAGE TypeOperators  #-}

module Main (main) where

import Servant
import Data.Aeson
import GHC.Generics
import Network.Wai.Handler.Warp
import System.IO

type ItemApi =
  Get '[PlainText] String
  :<|> "fancy" :> ReqBody '[JSON] TalkSnark :> Post '[PlainText] String

itemApi :: Proxy ItemApi
itemApi = Proxy

server :: Server ItemApi
server =
  helloWorld
  :<|> parseLambdaConf

helloWorld :: Handler String
helloWorld = return "Hello, World!"

data TalkSnark = TalkSnark { lambdaconf :: String }
  deriving (Eq, Ord, Show, ToJSON, FromJSON, Generic)

parseLambdaConf :: TalkSnark -> Handler String
parseLambdaConf ts = return $ "You think LambdaConf " <> lambdaconf ts

mkApp :: IO Application
mkApp = return $ serve itemApi server

main :: IO ()
main = do
  let port = 3001
      settings =
        setPort port $
        setBeforeMainLoop (hPutStrLn  stderr ("listening on port " <> show port)) $
        defaultSettings
  runSettings settings =<< mkApp



