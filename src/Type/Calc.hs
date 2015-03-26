{-# OPTIONS_GHC -fno-warn-orphans #-}
{-# LANGUAGE
    DeriveDataTypeable
  , DeriveGeneric
  , TemplateHaskell
  , TypeFamilies
  #-}
module Type.Calc (Calc) where

import Data.Aeson
import Data.JSON.Schema
import Data.Time (UTCTime)
import Generics.Regular
import Generics.Regular.XmlPickler
import Text.XML.HXT.Arrow.Pickle

import MatCalc (Calc)

deriveAll ''Calc "PFCalc"
type instance PF Calc = PFCalc

instance XmlPickler Float where
    xpickle = xpPrim

instance XmlPickler Calc where xpickle = gxpickle
instance JSONSchema Calc where schema = gSchema
instance ToJSON     Calc
instance FromJSON   Calc

instance XmlPickler UTCTime where xpickle = xpPrim
