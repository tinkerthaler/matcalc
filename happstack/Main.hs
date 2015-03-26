{-# LANGUAGE OverloadedStrings #-}
module Main (main) where

import Control.Concurrent (forkIO, killThread)
import Control.Monad.Trans (liftIO)
import Happstack.Server.SimpleHTTP

import Rest.Driver.Happstack (apiToHandler')

import Api (api)
import ApiTypes (ServerData (..), runMatCalcApi)
import Example (exampleMatCalc)

-- | Run the server
main :: IO ()
main = do
  -- Set up the server state
  --serverData <- exampleMatCalc
  let serverData = exampleMatCalc

  -- Start happstack
  putStrLn "Starting happstack server on http://localhost:3000"
--  tid <- forkIO $ simpleHTTP (Conf 3000 Nothing Nothing 60 Nothing) (handle serverData)
  tid <- forkIO $ simpleHTTP (Conf 3000 Nothing Nothing 60 Nothing) handle

  -- Exit gracefully
  waitForTermination
  killThread tid

-- | Request handler
--handle :: ServerData -> ServerPartT IO Response
--handle serverData = apiToHandler' (liftIO . runMatCalcApi serverData) api
handle :: ServerPartT IO Response
handle = apiToHandler' liftIO api


