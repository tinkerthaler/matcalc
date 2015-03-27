{-# OPTIONS_GHC -fno-warn-orphans #-}
{-# LANGUAGE
    DeriveDataTypeable
  , DeriveGeneric
  , TemplateHaskell
  , TypeFamilies
  , TypeSynonymInstances
  , FlexibleInstances
  #-}
module Api.Type.Shape (Shape (..)) where

import Data.Aeson
import Data.JSON.Schema
import Generics.Regular
import Generics.Regular.XmlPickler
import Text.XML.HXT.Arrow.Pickle

import MatCalc (Shape(..))

deriveAll ''Shape "PFShape"
type instance PF Shape = PFShape

instance XmlPickler Float where
    xpickle = xpPrim

instance XmlPickler Shape where xpickle = gxpickle
instance JSONSchema Shape where schema = gSchema
instance ToJSON     Shape
instance FromJSON   Shape

instance XmlPickler Char where xpickle = xpPrim
instance JSONSchema Char where schema = gSchema
--instance ToJSON     Char
--instance FromJSON   Char
