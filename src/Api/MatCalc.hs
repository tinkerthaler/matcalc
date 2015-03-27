module Api.MatCalc (resource) where

import Control.Monad.Reader (ReaderT)
import Control.Monad.Trans (liftIO)
import qualified MatCalc as S hiding (Calc, Shape)
import qualified Type.Calc as T
import qualified Type.Shape as T

import Rest (Handler, Resource, Void, mkResourceReader, mkResourceId, xmlJson, xmlJsonO, xmlJsonE)
import qualified Rest.Resource as R
import Rest.Handler (mkInputHandler)
import Control.Monad.Error (ErrorT, throwError, strMsg)
--import Rest.Handler (mkIdHandler)
import Rest.Schema (unnamedSingle, noListing)
import Control.Monad (liftM)
import qualified Data.Text as Text

--import ApiTypes (MatCalcApi)

-- | Defines the /customer api end-point.
resource :: Resource IO IO () Void Void
resource = mkResourceId
  { R.name   = "matcalc" -- Name of the HTTP path segment.
  --, R.schema = noListing $ unnamedSingle id
  , R.schema = noListing $ unnamedSingle $ \_ -> ()
  , R.list   = undefined -- requested by GET /customer, gives a paginated listing of customers.
  , R.create    = Just post
  }

post :: Handler IO
post = mkInputHandler xmlJson $ \s ->
                        liftIO $ runCalc s

runCalc :: T.Shape -> IO T.Calc
runCalc s = S.calc S.Interior S.Paint $ S.Surface $ s
