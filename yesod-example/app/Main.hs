{-# LANGUAGE DeriveAnyClass        #-}
{-# LANGUAGE DeriveGeneric         #-}
{-# LANGUAGE OverloadedStrings     #-}
{-# LANGUAGE QuasiQuotes           #-}
{-# LANGUAGE ScopedTypeVariables   #-}
{-# LANGUAGE TemplateHaskell       #-}
{-# LANGUAGE TypeFamilies          #-}
module Main (main) where

import Control.Monad.IO.Class (liftIO)
import Data.Aeson
import GHC.Generics
import Yesod
import qualified Network.Wai as W

data HelloWorld = HelloWorld

mkYesod "HelloWorld" [parseRoutes|
/ HomeR GET
/fancy DoFancyThingR POST
|]

instance Yesod HelloWorld

getHomeR :: Handler Html
getHomeR = defaultLayout [whamlet|Hello, World!|]

data TalkSnark = TalkSnark { lambdaconf :: String }
  deriving (Eq, Ord, Show, ToJSON, FromJSON, Generic)

postDoFancyThingR :: Handler Html
postDoFancyThingR = do
  req :: W.Request <- reqWaiRequest <$> getRequest 
  reqBody <- liftIO $ W.requestBody req
  let
      reqTalkSnark :: Maybe TalkSnark
      reqTalkSnark = decodeStrict reqBody
  case reqTalkSnark of
    Nothing -> defaultLayout [whamlet|I couldn't parse that. :(|]
    Just ts -> defaultLayout [whamlet|You think LambdaConf #{ts.lambdaconf}|]

  
main :: IO ()
main = warp 3000 HelloWorld
