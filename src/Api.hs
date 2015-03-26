-- | The API path hierarchy
module Api where

import Rest.Api

import qualified Api.MatCalc              as MatCalc

-- | Defines a versioned api
api :: Api IO
api = [(mkVersion 1 0 0, Some1 mc)]

-- _ The entire routing table for v1.0.0 of the material calculator
mc :: Router IO IO
mc =
  root -/ matcalc
  where
    matcalc         = route MatCalc.resource
