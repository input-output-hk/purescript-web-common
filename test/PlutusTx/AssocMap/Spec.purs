module PlutusTx.AssocMap.Spec
  ( assocMapSpec
  ) where

import Prelude
import Data.BigInt.Argonaut (BigInt)
import Data.BigInt.Argonaut as BigInt
import Data.Lens (preview, set)
import Data.Lens.At (at)
import Data.Lens.Index (ix)
import Data.Maybe (Maybe(..))
import Data.Tuple (Tuple(..))
import Data.Tuple.Nested ((/\))
import PlutusTx.AssocMap (Map(..), unionWith)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)

assocMapSpec :: Spec Unit
assocMapSpec =
  describe "PlutusTx.AssocMap" do
    indexTests
    atTests
    unionWithTests
    unionWithCurrenciesTests

currencies :: String
currencies = "Currency"

usd :: String
usd = "USD"

eur :: String
eur = "EUR"

gbp :: String
gbp = "GBP"

baseValue :: Map String (Map String BigInt)
baseValue = Map [ Tuple currencies (Map [ Tuple usd $ BigInt.fromInt 10 ]) ]

indexTests :: Spec Unit
indexTests =
  describe "Index" do
    it "simple gets" do
      preview (ix currencies <<< ix usd) baseValue `shouldEqual` Just
        (BigInt.fromInt 10)
      preview (ix currencies <<< ix eur) baseValue `shouldEqual` Nothing
    it "simple sets" do
      ( baseValue
          # set (ix currencies <<< ix usd) (BigInt.fromInt 20)
          # preview (ix currencies <<< ix usd)
      )
        `shouldEqual`
          Just (BigInt.fromInt 20)

atTests :: Spec Unit
atTests =
  describe "At" do
    it "create" do
      ( Map []
          # set (at currencies) (Just (Map []))
          # set (ix currencies <<< at usd) (Just (BigInt.fromInt 10))
      )
        `shouldEqual`
          baseValue
    it "modify" do
      ( baseValue
          # set (ix currencies <<< at usd) (Just (BigInt.fromInt 20))
          # preview (ix currencies <<< ix usd)
      )
        `shouldEqual`
          (Just (BigInt.fromInt 20))
    it "delete" do
      ( baseValue
          # set (ix currencies <<< at usd) Nothing
          # preview (ix currencies <<< ix usd)
      )
        `shouldEqual`
          Nothing

unionWithTests :: Spec Unit
unionWithTests = do
  describe "unionWith" do
    let
      a =
        Map
          [ "a" /\ 1
          , "b" /\ 2
          , "c" /\ 3
          ]
    let
      b =
        Map
          [ "b" /\ 1
          , "c" /\ 2
          , "d" /\ 3
          ]
    it "Merge with (+)" do
      (unionWith (+) a b)
        `shouldEqual`
          ( Map
              [ "a" /\ 1
              , "b" /\ 3
              , "c" /\ 5
              , "d" /\ 3
              ]
          )
    it "Merge with (-)" do
      (unionWith (-) a b)
        `shouldEqual`
          ( Map
              [ "a" /\ 1
              , "b" /\ 1
              , "c" /\ 1
              , "d" /\ 3
              ]
          )

unionWithCurrenciesTests :: Spec Unit
unionWithCurrenciesTests =
  describe "unionWith - currencies" do
    let
      valueA =
        ( mkMap currencies
            [ Tuple usd 10
            , Tuple eur 20
            ]
        )

      valueB =
        ( mkMap currencies
            [ Tuple eur 30
            , Tuple gbp 40
            ]
        )
    it "addition"
      $ (unionWith (unionWith (+)) valueA valueB)
          `shouldEqual`
            ( mkMap currencies
                [ Tuple usd 10
                , Tuple eur 50
                , Tuple gbp 40
                ]
            )
    it "choice"
      $ (unionWith (unionWith const) valueA valueB)
          `shouldEqual`
            ( mkMap currencies
                [ Tuple usd 10
                , Tuple eur 20
                , Tuple gbp 40
                ]
            )

mkMap
  :: String
  -> Array (Tuple String Int)
  -> Map String (Map String BigInt)
mkMap symbol pairs =
  Map
    [ Tuple symbol (Map (mkTokenAmount <$> pairs)) ]
  where
  mkTokenAmount :: Tuple String Int -> Tuple String BigInt
  mkTokenAmount (Tuple token amount) = Tuple token (BigInt.fromInt amount)
