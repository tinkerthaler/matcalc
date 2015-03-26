-- | The API path hierarchy
module Api where

import Rest.Api

import ApiTypes (MatCalcApi)
import qualified Api.MatCalc              as MatCalc
--import qualified Api.Invoice              as Invoice
--import qualified Api.Customer              as Customer
--import qualified Api.Invoice.Comment      as Invoice.Comment
--import qualified Api.Test              as Test
--import qualified Api.Test.ReservedName as ReservedName
--import qualified Api.Accounting              as Accounting

-- | Defines a versioned api
api :: Api IO
api = [(mkVersion 1 0 0, Some1 mc)]

-- _ The entire routing table for v1.0.0 of the material calculator
mc :: Router IO IO
mc =
  root -/ matcalc
--       -/ invoice --/ comment
--       -/ test --/ reservedName
--       -/ accounting
  where
    matcalc         = route MatCalc.resource
--    invoice         = route Invoice.resource
--    comment      = route Invoice.Comment.resource
--    test         = route Test.resource
--    reservedName = route ReservedName.resource
--    accounting   = route Accounting.resource
