{-# LANGUAGE GeneralizedNewtypeDeriving #-}
module ApiTypes where

import Control.Applicative (Applicative)
import Control.Monad.Reader (MonadReader, ReaderT (..))
import Control.Monad.Trans (MonadIO)

data ServerData = ServerData

newtype MatCalcApi a = MatCalcApi { unMatCalcApi :: ReaderT ServerData IO a }
  deriving ( Applicative
           , Functor
           , Monad
           , MonadIO
           , MonadReader ServerData
           )

runMatCalcApi :: ServerData -> MatCalcApi a -> IO a
runMatCalcApi serverdata = flip runReaderT serverdata . unMatCalcApi
