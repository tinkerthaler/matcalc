{-# LANGUAGE
    DeriveDataTypeable
  , DeriveGeneric
  , TemplateHaskell
  , TypeFamilies
  , OverloadedStrings
  #-}
module MatCalc where

import qualified Data.Configurator as C
import qualified Data.Maybe as M
import GHC.Generics
import Data.Typeable
--import Control.Monad

{-
Input: 5 by 5
List of materials

Output:

Area is 25 m^2

-}

-- TODO: GADT

--defaultSpreadingRate = 11 :: Float -- m^2 / L
--defaultCoats Interior= 2  :: Float
--defaultCoats Exterior= 2  :: Float

data Shape = 
	  Square Float
	| Circle Float
	| Rectangle Float Float
	| Raw Float

data Surface = Surface { unSurface :: Shape }

data SurfaceLoc = Interior | Exterior

data SurfaceType = Ceiling | Wall | Door | Window

data Material = Paint | Tape

data Unit = Meter

data Calc = Calc { c :: Float } deriving (Eq, Generic, Ord, Show, Typeable)


area :: Shape -> Float
area (Square s) = s * s
area (Rectangle s1 s2) = s1 * s2
area (Circle r) = pi * r * r
--area (Raw r) = r

perimeter :: Shape -> Float
perimeter (Square s) = 4 * s
perimeter (Rectangle s1 s2) = 2 * (s1 + s2)
perimeter (Circle r) = 2 * pi * r

{--
   Paint:
   Total surface area (square metres)
   divided by spreading rate of paint
   multiplied by number of coats
   = total litres required
 --}
calc :: SurfaceLoc -> Material -> Surface -> IO Calc
calc Interior Paint s = do
	cfg           <- C.load [ C.Required "MatCalc.cfg" ]
	desc          <- C.lookupDefault "" cfg "interior.paint.desc"
	putStrLn desc
	spreadingRate <- C.lookup cfg "interior.paint.spreadingRate"
	coats         <- C.lookup cfg "interior.paint.coats"
	return $ Calc $ area (unSurface s) / 
                         (M.fromJust spreadingRate) * 
                         (M.fromJust coats)
--calc Interior Tape  s = 
--	perimeter (unSurface s)
--calc _ _ _ = undefined

-- HELPER
toFloat :: Integral a => a -> Float
toFloat = fromInteger . toInteger