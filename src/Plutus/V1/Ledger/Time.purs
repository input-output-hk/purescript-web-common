-- As 'POSIXTime' from 'Plutus.V1.Ledger.Time' has a custom 'FromJSON' and 'ToJSON'
-- instances, we declare the corresponding 'POSIXTime' PureScript type here since
-- the PSGenerator Generic instances won't match.
module Plutus.V1.Ledger.Time
  ( POSIXTime(..)
  , _POSIXTime
  ) where

import Prelude
import Data.Argonaut.Decode (class DecodeJson)
import Data.Argonaut.Decode.Aeson as D
import Data.Argonaut.Encode (class EncodeJson)
import Data.Argonaut.Encode.Aeson ((>$<))
import Data.Argonaut.Encode.Aeson as E
import Data.BigInt.Argonaut (BigInt)
import Data.Generic.Rep (class Generic)
import Data.Lens (Iso')
import Data.Lens.Iso.Newtype (_Newtype)
import Data.Newtype (class Newtype, unwrap, wrap)
import Data.Show.Generic (genericShow)
import Text.Pretty (class Args, class Pretty, pretty)

newtype POSIXTime
  = POSIXTime { getPOSIXTime :: BigInt }

derive instance eqPOSIXTime :: Eq POSIXTime

derive instance ordPOSIXTime :: Ord POSIXTime

instance showPOSIXTime :: Show POSIXTime where
  show x = genericShow x

instance encodeJsonPOSIXTime :: EncodeJson POSIXTime where
  encodeJson = E.encode $ (unwrap >>> _.getPOSIXTime) >$< E.value

instance decodeJsonPOSIXTime :: DecodeJson POSIXTime where
  decodeJson = D.decode $ (wrap <<< { getPOSIXTime: _ }) <$> D.value

derive instance genericPOSIXTime :: Generic POSIXTime _

derive instance newtypePOSIXTime :: Newtype POSIXTime _

derive newtype instance semiRingPOSIXTime :: Semiring POSIXTime

derive newtype instance ringPOSIXTime :: Ring POSIXTime

instance prettyPOSIXTime :: Pretty POSIXTime where
  pretty (POSIXTime a) = pretty a.getPOSIXTime

instance argsPOSIXTime :: Args POSIXTime where
  hasArgs _ = false
  hasNestedArgs _ = false

instance commutativeRingPOSIXTime :: CommutativeRing POSIXTime

--------------------------------------------------------------------------------
_POSIXTime :: Iso' POSIXTime { getPOSIXTime :: BigInt }
_POSIXTime = _Newtype

--------------------------------------------------------------------------------
