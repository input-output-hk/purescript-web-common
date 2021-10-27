module Data.String.Extra.Spec
  ( stringExtraSpec
  ) where

import Prelude
import Data.String as String
import Data.String.Extra (abbreviate, leftPadTo, repeat, toHex)
import Test.QuickCheck (arbitrary, (<=?), (===))
import Test.QuickCheck.Gen (Gen, chooseInt)
import Test.Spec.QuickCheck (quickCheck)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)

stringExtraSpec :: Spec Unit
stringExtraSpec =
  describe "Data.String.Extra" do
    abbreviateSpec
    toHexSpec
    leftPadToSpec
    repeatSpec

abbreviateSpec :: Spec Unit
abbreviateSpec = do
  describe "abbreviate" do
    it "Always limits the string length" do
      quickCheck \str -> String.length (abbreviate 7 str) <=? 10
    it "Never affects the start of the string" do
      quickCheck \str ->
        String.take 5 str
          === String.take 5 (abbreviate 10 str)
    it "Repeated application gives the same result" do
      quickCheck
        $ do
            str <- arbitrary :: Gen String
            n <- chooseInt 0 (String.length str * 2)
            pure $ abbreviate n (abbreviate n str) === abbreviate n str

toHexSpec :: Spec Unit
toHexSpec = do
  describe "toHex" do
    it "A few examples" do
      toHex "A" `shouldEqual` "41"
      toHex "Tester" `shouldEqual` "546573746572"

leftPadToSpec :: Spec Unit
leftPadToSpec = do
  describe "leftPadTo" do
    it "0 is identity" do
      quickCheck \prefix str -> str === leftPadTo 0 prefix str
    it "A few examples" do
      leftPadTo 2 "0" "f" `shouldEqual` "0f"
      leftPadTo 3 " " "f" `shouldEqual` "  f"
      leftPadTo 1 "0" "f" `shouldEqual` "f"

repeatSpec :: Spec Unit
repeatSpec = do
  describe "repeat" do
    it "0 is empty" do
      quickCheck \str -> repeat 0 str === ""
    it "A few examples" do
      repeat 3 "abc" `shouldEqual` "abcabcabc"
      repeat 2 "Test" `shouldEqual` "TestTest"
