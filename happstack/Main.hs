{-# LANGUAGE OverloadedStrings #-}
module Main (main) where

import Control.Concurrent (forkIO, killThread)
import Control.Monad.Trans (liftIO)
import Happstack.Server.SimpleHTTP

import Rest.Driver.Happstack (apiToHandler')

import Api (api)

-- | Run the server
main :: IO ()
main = do
  -- Start happstack
  putStrLn "Starting happstack server on http://localhost:3000"
  tid <- forkIO $ simpleHTTP (Conf 3000 Nothing Nothing 60 Nothing) handle

  -- Exit gracefully
  waitForTermination
  killThread tid

-- | Request handler
handle :: ServerPartT IO Response
handle = apiToHandler' liftIO api


