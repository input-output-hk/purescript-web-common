module Data.Map.Ordered.Spec
  ( orderedMapSpec
  ) where

import Prelude

import Data.Map.Ordered.OMap (fromFoldable, moveLeft, moveRight)
import Data.Maybe (Maybe(..))
import Data.Tuple.Nested ((/\))
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)

orderedMapSpec :: Spec Unit
orderedMapSpec = do
  describe "moveLeft" do
    it "fails on the first element" do
      let
        m = fromFoldable [ "foo" /\ 1, "bar" /\ 2, "baz" /\ 3 ]
      moveLeft "foo" m `shouldEqual` Nothing
    it "moves the second element" do
      let
        m = fromFoldable [ "foo" /\ 1, "bar" /\ 2, "baz" /\ 3 ]
      moveLeft "bar" m `shouldEqual`
        (Just $ fromFoldable [ "bar" /\ 2, "foo" /\ 1, "baz" /\ 3 ])
  describe "moveRight" do
    it "fails on the last element" do
      let
        m = fromFoldable [ "foo" /\ 1, "bar" /\ 2, "baz" /\ 3 ]
      moveRight "baz" m `shouldEqual` Nothing
    it "moves the second element" do
      let
        m = fromFoldable [ "foo" /\ 1, "bar" /\ 2, "baz" /\ 3 ]
      moveRight "bar" m `shouldEqual`
        (Just $ fromFoldable [ "foo" /\ 1, "baz" /\ 3, "bar" /\ 2 ])
