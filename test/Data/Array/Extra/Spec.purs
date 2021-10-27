module Data.Array.Extra.Spec
  ( arrayExtraSpec
  ) where

import Prelude
import Control.Monad.Gen (chooseInt)
import Data.Array (length)
import Data.Array.Extra (collapse, move)
import Data.Map (Map)
import Data.Map as Map
import Data.Tuple.Nested ((/\))
import Test.QuickCheck (arbitrary, (===))
import Test.QuickCheck.Gen (Gen)
import Test.Spec.QuickCheck (quickCheck)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)

arrayExtraSpec :: Spec Unit
arrayExtraSpec =
  describe "Data.Array.Extra" do
    moveSpec
    collapseSpec

moveSpec :: Spec Unit
moveSpec = do
  describe "move" do
    it "length is always preserved" do
      quickCheck do
        xs <- arbitrary :: Gen (Array String)
        source <- chooseInt (-2) (length xs + 2)
        destination <- chooseInt (-2) (length xs + 2)
        pure $ length xs === length (move source destination xs)
    it "identity move" do
      quickCheck do
        before <- arbitrary :: Gen (Array String)
        source <- chooseInt 0 (length before - 1)
        let
          after = move source source before
        pure $ before === after
    it "Concrete example - source to left of destination" do
      shouldEqual
        [ 1, 0, 2, 3, 4 ]
        (move 0 1 [ 0, 1, 2, 3, 4 ])
    it "Concrete example - source to right of destination" do
      shouldEqual
        [ 1, 0, 2, 3, 4 ]
        (move 1 0 [ 0, 1, 2, 3, 4 ])
    it "Concrete example - source less than destination" do
      shouldEqual
        [ 0, 2, 3, 1, 4 ]
        (move 1 3 [ 0, 1, 2, 3, 4 ])
    it "Concrete example - source more than destination" do
      shouldEqual
        [ 0, 3, 1, 2, 4 ]
        (move 3 1 [ 0, 1, 2, 3, 4 ])

collapseSpec :: Spec Unit
collapseSpec = do
  describe "collapse" do
    it "Empty." do
      shouldEqual
        (collapse ([] :: Array (Map Boolean String)))
        []
    it "Concrete example." do
      shouldEqual
        ( collapse
            [ Map.fromFoldable [ "Foo" /\ true, "Bar" /\ false ]
            , Map.fromFoldable [ "Quux" /\ true, "Loop" /\ true ]
            ]
        )
        [ 0 /\ "Bar" /\ false
        , 0 /\ "Foo" /\ true
        , 1 /\ "Loop" /\ true
        , 1 /\ "Quux" /\ true
        ]
