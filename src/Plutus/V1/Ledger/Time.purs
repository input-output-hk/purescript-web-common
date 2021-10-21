-- As 'POSIXTime' from 'Plutus.V1.Ledger.Time' has a custom 'FromJSON' and 'ToJSON'
-- instances, we declare the corresponding 'POSIXTime' PureScript type here since
-- the PSGenerator Generic instances won't match.
module Plutus.V1.Ledger.Time where

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

newtype POSIXTime
  = POSIXTime { getPOSIXTime :: BigInt }

derive instance eqPOSIXTime :: Eq POSIXTime

instance showPOSIXTime :: Show POSIXTime where
  show x = genericShow x

instance encodeJsonPOSIXTime :: EncodeJson POSIXTime where
  encodeJson = E.encode $ (unwrap >>> _.getPOSIXTime) >$< E.value

instance decodeJsonPOSIXTime :: DecodeJson POSIXTime where
  decodeJson = D.decode $ (wrap <<< { getPOSIXTime: _ }) <$> D.value

derive instance genericPOSIXTime :: Generic POSIXTime _

derive instance newtypePOSIXTime :: Newtype POSIXTime _

--------------------------------------------------------------------------------
_POSIXTime :: Iso' POSIXTime { getPOSIXTime :: BigInt }
_POSIXTime = _Newtype

--------------------------------------------------------------------------------
