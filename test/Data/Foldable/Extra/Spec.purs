module Data.Foldable.Extra.Spec
  ( foldableExtraSpec
  ) where

import Prelude

import Data.Array (length, replicate)
import Data.Array.NonEmpty.Internal (NonEmptyArray(..))
import Data.Foldable (foldMap, null)
import Data.Foldable.Extra (countConsecutive, interleave)
import Data.Generic.Rep (class Generic)
import Data.Show.Generic (genericShow)
import Data.Tuple (uncurry)
import Data.Tuple.Nested (type (/\), (/\))
import Test.QuickCheck (class Arbitrary, arbitrary, (<=?), (===))
import Test.QuickCheck.Gen (Gen, frequency, suchThat)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)
import Test.Spec.QuickCheck (quickCheck)

foldableExtraSpec :: Spec Unit
foldableExtraSpec =
  describe "Data.Foldable.Extra" do
    interleaveSpec
    countConsecutiveSpec

interleaveSpec :: Spec Unit
interleaveSpec = do
  describe "interleave" do
    it "Empty arrays are unchanged" do
      quickCheck do
        sep <- arbitrary :: Gen String
        pure $ interleave sep [] === []
    it "Singleton arrays are unchanged" do
      quickCheck do
        sep <- arbitrary :: Gen String
        x <- arbitrary
        pure $ interleave sep [ x ] === [ x ]
    it "Non-empty arrays increase their length by (2n - 1)" do
      quickCheck do
        sep <- arbitrary :: Gen String
        xs :: Array String <- arbitrary `suchThat` (not <<< null)
        pure $ length (interleave sep xs) === (2 * length xs) - 1
    it "Simple concrete example" do
      shouldEqual
        (interleave 0 [ 1, 2, 3 ])
        [ 1, 0, 2, 0, 3 ]

data Msg
  = Startup
  | Heartbeat
  | Healthy Boolean
  | Shutdown

derive instance eqMsg :: Eq Msg

derive instance genericMsg :: Generic Msg _

instance showMsg :: Show Msg where
  show = genericShow

instance arbitraryMsg :: Arbitrary Msg where
  arbitrary =
    frequency
      $ NonEmptyArray
      $
        [ (20.0 /\ pure Heartbeat)
        , 1.0 /\ pure Startup
        , 3.0 /\ pure (Healthy true)
        , 2.0 /\ pure (Healthy false)
        , 1.0 /\ pure Shutdown
        ]

countConsecutiveSpec :: Spec Unit
countConsecutiveSpec = do
  describe "countConsecutive" do
    it "Empty." do
      shouldEqual [] (countConsecutive ([] :: Array String))
    it "The resulting sequence is never larger." do
      quickCheck \msgs ->
        length (countConsecutive msgs) <=? length (msgs :: Array Msg)
    it
      "We can reconstruct the original sequence by replicating each message the given number of times.."
      do
        quickCheck \msgs ->
          let
            counted :: Array (Int /\ Msg)
            counted = countConsecutive msgs
          in
            msgs === foldMap (uncurry replicate) counted
    it "Concrete example." do
      shouldEqual
        ( countConsecutive
            [ Startup
            , Heartbeat
            , Heartbeat
            , Heartbeat
            , Heartbeat
            , Heartbeat
            , Healthy true
            , Healthy true
            , Heartbeat
            , Heartbeat
            , Heartbeat
            , Shutdown
            ]
        )
        [ 1 /\ Startup
        , 5 /\ Heartbeat
        , 2 /\ Healthy true
        , 3 /\ Heartbeat
        , 1 /\ Shutdown
        ]
