module Data.Argonaut.Extra where

import Prologue

import Control.Monad.RWS (RWSResult(..), RWST(..), evalRWST)
import Control.Monad.Reader (ReaderT(..), runReaderT)
import Data.Argonaut (getField, getFieldOptional)
import Data.Argonaut.Core (stringify, Json)
import Data.Argonaut.Decode
  ( class DecodeJson
  , JsonDecodeError(..)
  , decodeJson
  , parseJson
  )
import Data.Argonaut.Decode.Decoders (decodeJArray, decodeJObject)
import Data.Argonaut.Encode (class EncodeJson, encodeJson)
import Data.Array ((!!))
import Data.Array as Array
import Data.Bifunctor (lmap)
import Data.Either (note')
import Data.Maybe (maybe)
import Data.Map (Map)
import Data.Map as Map
import Data.String (joinWith)
import Foreign.Object (Object)

parseDecodeJson
  :: forall a. DecodeJson a => String -> Either JsonDecodeError a
parseDecodeJson = decodeJson <=< parseJson

encodeStringifyJson
  :: forall a. EncodeJson a => a -> String
encodeStringifyJson = encodeJson >>> stringify

caseConstantFrom
  :: forall a b
   . Ord a
  => Show a
  => DecodeJson a
  => Map a b
  -> (Json -> Either JsonDecodeError b)
  -> Json
  -> Either JsonDecodeError b
caseConstantFrom values onFail json = case decodeJson json of
  Left _ -> onFail json
  Right value -> note' mkError $ Map.lookup value values
  where
  mkError _ =
    TypeMismatch
      $ joinWith " | " (map show $ Array.fromFoldable $ Map.keys values)

object
  :: forall a
   . String
  -> (ReaderT (Object Json) (Either JsonDecodeError) (Maybe a))
  -> Json
  -> Either JsonDecodeError a
object name decoder json =
  lmap (Named name) do
    obj <- decodeJObject json
    result <- runReaderT decoder obj
    maybe (Left $ UnexpectedValue json) Right result

getProp
  :: forall a
   . DecodeJson a
  => String
  -> ReaderT (Object Json) (Either JsonDecodeError) (Maybe a)
getProp key = ReaderT $ flip getFieldOptional key

requireProp
  :: forall a
   . DecodeJson a
  => String
  -> ReaderT (Object Json) (Either JsonDecodeError) a
requireProp key = ReaderT $ flip getField key

array
  :: forall a
   . String
  -> (RWST (Array Json) Unit Int (Either JsonDecodeError) a)
  -> Json
  -> Either JsonDecodeError a
array name decoder json =
  lmap (Named name) do
    arr <- decodeJArray json
    fst <$> evalRWST decoder arr 0

next
  :: forall a
   . DecodeJson a
  => RWST (Array Json) Unit Int (Either JsonDecodeError) a
next =
  RWST \arr ix ->
    RWSResult
      <$> pure (ix + 1)
      <*> maybe (Left $ AtIndex ix MissingValue) decodeJson (arr !! ix)
      <*> pure unit

