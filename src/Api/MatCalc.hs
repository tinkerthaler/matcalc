module Api.MatCalc (resource) where

import Control.Monad.Reader (ReaderT)
import Control.Monad.Trans (liftIO)
import qualified MatCalc as S hiding (Calc)
import qualified Type.Calc as T

import Rest (Handler, Resource, Void, mkResourceReader, xmlJsonO)
import qualified Rest.Resource as R
import Rest.Handler (mkIdHandler)
import Rest.Schema (unnamedSingle, noListing)

--import ApiTypes (MatCalcApi)

type WithMatCalc = ReaderT String IO

-- | Defines the /customer api end-point.
--resource :: Resource MatCalcApi WithMatCalc String Void Void
resource :: Resource IO WithMatCalc String Void Void
resource = mkResourceReader
  { R.name   = "matcalc" -- Name of the HTTP path segment.
  , R.schema = noListing $ unnamedSingle  id
  , R.list   = undefined -- requested by GET /customer, gives a paginated listing of customers.
  , R.get    = Just get
  }

--get :: Handler WithMatCalc
get :: Handler (ReaderT String IO)
get = mkIdHandler xmlJsonO $ \_ _ -> liftIO $ runCalc

runCalc :: IO T.Calc
runCalc = S.calc S.Interior S.Paint $ S.Surface $ S.Rectangle 3 6
