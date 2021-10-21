module Halogen.LocalStorage (localStorageEvents) where

import Prologue
import Control.Coroutine (connect, consumer, runProcess)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Halogen.Subscription as HS
import LocalStorage (RawStorageEvent)
import LocalStorage as LocalStorage

-- This EventSource allows you to subscribe to local storage events from within
-- a Halogen handle action, and dispatch custom actions using the `toAction` wrapper.
localStorageEvents
  :: forall action
   . (RawStorageEvent -> action)
  -> (HS.Emitter action)
localStorageEvents toAction = do
  HS.makeEmitter \push -> do
    launchAff_
      $ runProcess
      $ connect LocalStorage.listen
      $ consumer
      $ \event -> do
          liftEffect $ push $ toAction event
          pure Nothing
    pure $ pure unit
