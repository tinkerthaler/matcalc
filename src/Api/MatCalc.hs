module Api.MatCalc (resource) where

--import Control.Applicative ((<$>))
--import Control.Concurrent.STM (STM, TVar, atomically, modifyTVar, readTVar)
import Control.Monad.Error (throwError)
import Control.Monad.Reader (ReaderT)
import Control.Monad.Trans.Identity (IdentityT)
import Control.Monad.Trans (lift, liftIO)
import Control.Monad (liftM)
--import Data.Set (Set)
--import qualified Data.Foldable as F
--import qualified Data.Set      as Set
--import qualified Data.Text     as T
import qualified MatCalc as S hiding (Calc)
import qualified Type.Calc as T

import Rest (Handler, ListHandler, Resource, Void, domainReason, 
             mkInputHandler, mkListing, mkResourceReader, named, 
             singleRead, withListing, xmlJsonE, xmlJsonI, xmlJsonO, 
             mkResourceId)
import qualified Rest.Resource as R
import Rest.Error (Reason (NotFound))
import Rest.Handler (mkIdHandler)
import Rest.Schema (unnamedSingle, noListing)

import ApiTypes (MatCalcApi, ServerData (..))

type WithMatCalc = ReaderT String MatCalcApi
--type WithMatCalc = IdentityT MatCalcApi

-- | Defines the /customer api end-point.
--resource :: Resource MatCalcApi WithMatCalc String Void Void
resource :: Resource IO (ReaderT String IO) String Void Void
resource = mkResourceReader
  { R.name   = "matcalc" -- Name of the HTTP path segment.
  , R.schema = noListing $ unnamedSingle  id
  , R.list   = undefined -- requested by GET /customer, gives a paginated listing of customers.
  , R.get    = Just get
  --, R.create = Just create -- PUT /customer creates a new customer
  }

--get :: Handler WithMatCalc
get :: Handler (ReaderT String IO)
get = mkIdHandler xmlJsonO $ \_ i -> liftIO $ doXYZ

doXYZ :: IO T.Calc
doXYZ = S.calc S.Interior S.Paint $ S.Surface $ S.Rectangle 3 6

{-
  mcustomer <- liftIO . atomically . customerFromIdentifier i =<< (lift . lift) (asks customers)
  case mcustomer of
    Nothing -> throwError NotFound
    Just a  -> return a
-}