module Debug.Trace.Extra (traceTime) where

import Prologue
import Debug (class DebugWarning)

-- | Similar to Debug.Trace.trace but also reports the time taken to evaluate the thunk
foreign import _traceTime :: forall a b. a -> (Unit -> b) -> b

traceTime :: forall a b. DebugWarning => a -> (Unit -> b) -> b
traceTime = _traceTime
