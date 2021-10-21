module Data.Argonaut.Extra where

import Prologue

import Data.Argonaut.Core (stringify)
import Data.Argonaut.Decode (class DecodeJson, JsonDecodeError, decodeJson, parseJson)
import Data.Argonaut.Encode (class EncodeJson, encodeJson)

parseDecodeJson
  :: forall a. DecodeJson a => String -> Either JsonDecodeError a
parseDecodeJson = decodeJson <=< parseJson

encodeStringifyJson
  :: forall a. EncodeJson a => a -> String
encodeStringifyJson = encodeJson >>> stringify
