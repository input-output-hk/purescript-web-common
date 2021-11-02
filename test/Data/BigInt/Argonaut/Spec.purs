module Data.BigInt.Argonaut.Spec
  ( bigIntSpec
  ) where

import Prologue

import Data.Argonaut.Decode (JsonDecodeError)
import Data.Argonaut.Extra (encodeStringifyJson, parseDecodeJson)
import Data.BigInt as BI
import Data.BigInt.Argonaut (BigInt, fromInt, withJsonPatch)
import Data.BigInt.Argonaut as BigInt
import Data.Generic.Rep (class Generic)
import Data.Newtype (unwrap)
import Data.String (codePointFromChar, dropWhile, null)
import Data.String.Gen (genDigitString)
import Test.QuickCheck (class Arbitrary, (===))
import Test.QuickCheck.Gen (suchThat)
import Test.Spec (Spec, around_, describe, it)
import Test.Spec.Assertions (shouldEqual, shouldNotEqual)
import Test.Spec.QuickCheck (quickCheck)
import Text.Pretty (genericPretty, pretty)

newtype DigitString = DigitString String

data TestData = TestData String BigInt

derive instance genericTestData :: Generic TestData _

instance arbitraryDigitString :: Arbitrary DigitString where
  arbitrary =
    map DigitString
      $ flip suchThat (not null)
      $ map (dropWhile (eq (codePointFromChar '0')))
      $ genDigitString

bigIntSpec :: Spec Unit
bigIntSpec =
  describe "Data.BigInt.Argonaut" do
    around_ withJsonPatch $ it "obeys the roundtrip law under withJsonPatch" do
      quickCheck \(DigitString s) ->
        let
          decoded :: Either JsonDecodeError BigInt
          decoded = parseDecodeJson s
        in
          encodeStringifyJson <$> decoded === Right s
    it "does not always obey the roundtrip law when not under withJsonPatch" do
      let
        s = "23457890122347890123478901234123409871234"

        decoded :: Either JsonDecodeError BigInt
        decoded = parseDecodeJson s
      (encodeStringifyJson <$> decoded) `shouldNotEqual` Right s
    around_ withJsonPatch $ it "decodes a valid BigInt" do
      quickCheck \(DigitString s) ->
        let
          decoded :: Either JsonDecodeError BigInt
          decoded = parseDecodeJson s
        in
          (unwrap <<< add (fromInt 10))
            <$> decoded === (add (BI.fromInt 10) <<< unwrap)
            <$> decoded
    it "Renders prettily as just the integer value" do
      show (pretty $ BigInt.fromInt 10) `shouldEqual` "10"
    it "Renders from withing genericPretty" do
      show (genericPretty $ TestData "hello" $ BigInt.fromInt 10)
        `shouldEqual`
          "TestData \"hello\" 10"
    it "Renders with \"fromString\" with show" do
      show (BigInt.fromInt 10) `shouldEqual` "fromString \"10\""
