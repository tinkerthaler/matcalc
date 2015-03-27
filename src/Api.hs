-- | The API path hierarchy
module Api where

import Rest.Api

import qualified Api.MatCalcApi              as MatCalcApi

-- | Defines a versioned api
api :: Api IO
api = [(mkVersion 1 0 0, Some1 mc)]

-- _ The entire routing table for v1.0.0 of the material calculator
mc :: Router IO IO
mc =
  root -/ matcalc2
  where
    matcalc2         = route MatCalcApi.resource
