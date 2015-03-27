{-# LANGUAGE
    DeriveDataTypeable
  , DeriveGeneric
  , TemplateHaskell
  , TypeFamilies
  #-}
module Type.CalcError where

import Data.Aeson
import Data.JSON.Schema
import Data.Typeable
import GHC.Generics
import Generics.Regular
import Generics.Regular.XmlPickler
import Rest.Error
import Text.XML.HXT.Arrow.Pickle

data CalcError = Invalid { msg :: String }
  deriving (Eq, Generic, Ord, Show, Typeable)

deriveAll ''CalcError "PFCalcError"
type instance PF CalcError = PFCalcError

instance XmlPickler CalcError where xpickle = gxpickle
instance JSONSchema CalcError where schema = gSchema
instance FromJSON   CalcError
instance ToJSON     CalcError

instance ToResponseCode CalcError where
  toResponseCode _ = 400
