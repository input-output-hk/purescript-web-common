module Test.Main where

import Prologue
import Data.Array.Extra.Spec (arrayExtraSpec)
import Data.Foldable.Extra.Spec (foldableExtraSpec)
import Data.String.Extra.Spec (stringExtraSpec)
import Data.Cursor.Spec (cursorSpec)
import Effect (Effect)
import Effect.Aff (launchAff_)
import PlutusTx.AssocMap.Spec (assocMapSpec)
import Test.Spec.Reporter (consoleReporter)
import Test.Spec.Runner (runSpec)

main :: Effect Unit
main =
  launchAff_
    $ runSpec [ consoleReporter ] do
        cursorSpec
        arrayExtraSpec
        foldableExtraSpec
        stringExtraSpec
        assocMapSpec
