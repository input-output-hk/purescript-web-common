-- Unfortunately PSGenerator can't handle 'PlutusTx.Ratio' data constructor ':%',
-- so we are forced to create a mapping on PureScript side with custom 'Encode' and 'DecodeJson' instances.
module PlutusTx.Ratio (Ratio(..), (%), reduce, numerator, denominator) where

import Prelude
import Data.Argonaut.Decode (class DecodeJson)
import Data.Argonaut.Decode.Aeson as D
import Data.Argonaut.Encode (class EncodeJson)
import Data.Argonaut.Encode.Aeson ((>$<))
import Data.Argonaut.Encode.Aeson as E
import Data.Profunctor.Strong ((&&&))
import Data.Ratio as R
import Data.Tuple (uncurry)
import Text.Pretty (class Args, class Pretty, text)

newtype Ratio a
  = Ratio (R.Ratio a)

instance showRatio :: (Show a) => Show (Ratio a) where
  show (Ratio x) = show x

instance argsRatio :: Args (Ratio a) where
  hasArgs _ = false
  hasNestedArgs _ = false

instance prettyRatio :: Show a => Pretty (Ratio a) where
  pretty r = text $ "(" <> show (numerator r) <> "%" <> show (denominator r) <>
    ")"

instance eqRatio :: Eq a => Eq (Ratio a) where
  eq (Ratio a) (Ratio b) = eq a b

instance ordRatio :: (Ord a, EuclideanRing a) => Ord (Ratio a) where
  compare (Ratio x) (Ratio y) = compare x y

instance semiringRatio :: (Ord a, EuclideanRing a) => Semiring (Ratio a) where
  one = Ratio one
  mul (Ratio a) (Ratio b) = Ratio (mul a b)
  zero = Ratio zero
  add (Ratio a) (Ratio b) = Ratio (add a b)

instance ringRatio :: (Ord a, EuclideanRing a) => Ring (Ratio a) where
  sub (Ratio a) (Ratio b) = Ratio (sub a b)

instance commutativeRingRatio ::
  ( Ord a
  , EuclideanRing a
  ) =>
  CommutativeRing (Ratio a)

instance euclideanRingRatio ::
  ( Ord a
  , EuclideanRing a
  ) =>
  EuclideanRing (Ratio a) where
  degree _ = 1
  div (Ratio a) (Ratio b) = Ratio (div a b)
  mod _ _ = zero

instance divisionRingRatio :: (Ord a, EuclideanRing a) => DivisionRing (Ratio a) where
  recip (Ratio a) = Ratio (recip a)

instance encodeJsonRatio :: (EncodeJson a) => EncodeJson (Ratio a) where
  encodeJson = E.encode $ toTuple >$< E.value
    where
    toTuple = numerator &&& denominator

instance decodeRatio ::
  ( EuclideanRing a
  , Ord a
  , DecodeJson a
  ) =>
  DecodeJson (Ratio a) where
  decodeJson = D.decode $ uncurry reduce <$> D.value

numerator :: forall a. Ratio a -> a
numerator (Ratio r) = R.numerator r

denominator :: forall a. Ratio a -> a
denominator (Ratio r) = R.denominator r

reduce :: forall a. Ord a => EuclideanRing a => a -> a -> Ratio a
reduce n d = Ratio (R.reduce n d)

infixl 7 reduce as %
