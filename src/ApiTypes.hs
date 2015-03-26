{-# LANGUAGE GeneralizedNewtypeDeriving #-}
module ApiTypes where

import Control.Applicative (Applicative)
--import Control.Concurrent.STM (TVar)
import Control.Monad.Reader (MonadReader, ReaderT (..))
import Control.Monad.Trans (MonadIO)
--import Data.HashMap.Strict (HashMap)
--import Data.Set (Set)

data ServerData = ServerData
  {}
--  { customers    :: TVar (Set Customer)
--  , invoices    :: TVar (Set Invoice)
--  , comments :: TVar (HashMap Invoice.Id (Set Comment))
--  }

newtype MatCalcApi a = MatCalcApi { unMatCalcApi :: ReaderT ServerData IO a }
  deriving ( Applicative
           , Functor
           , Monad
           , MonadIO
           , MonadReader ServerData
           )

runMatCalcApi :: ServerData -> MatCalcApi a -> IO a
runMatCalcApi serverdata = flip runReaderT serverdata . unMatCalcApi
