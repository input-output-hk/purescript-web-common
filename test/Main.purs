module Test.Main where

import Prologue

import Data.Array.Extra.Spec (arrayExtraSpec)
import Data.BigInt.Argonaut.Spec (bigIntSpec)
import Data.Cursor.Spec (cursorSpec)
import Data.Foldable.Extra.Spec (foldableExtraSpec)
import Data.Map.Ordered.Spec (orderedMapSpec)
import Data.String.Extra.Spec (stringExtraSpec)
import Effect (Effect)
import Effect.Aff (launchAff_)
import PlutusTx.AssocMap.Spec (assocMapSpec)
import Test.Spec.Reporter (consoleReporter)
import Test.Spec.Runner (runSpec)

main :: Effect Unit
main =
  launchAff_ do
    runSpec [ consoleReporter ] do
      cursorSpec
      arrayExtraSpec
      foldableExtraSpec
      stringExtraSpec
      assocMapSpec
      bigIntSpec
      orderedMapSpec
