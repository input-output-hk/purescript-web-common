module Halogen.ElementVisible where

import Prelude
import Data.Array (head)
import Data.Traversable (traverse_)
import Halogen.Subscription as HS
import Web.DOM (Element)
import Web.DOM.IntersectionObserver (intersectionObserver, observe, unobserve)

-- This Halogen Emitter uses the IntersectionObserver to detect if an element is visible in the
-- viewport.
-- The `toAction` callback allows the subscriber to dispatch a particular action when the element is
-- visible or not.
elementVisible
  :: forall action
   . (Boolean -> action)
  -> Element
  -> HS.Emitter action
elementVisible toAction element =
  HS.makeEmitter \push -> do
    observer <-
      intersectionObserver {} \entries _ ->
        traverse_ (push <<< toAction <<< _.isIntersecting) $ head entries
    observe element observer
    pure $ unobserve element observer
