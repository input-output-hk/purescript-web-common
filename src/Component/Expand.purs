module Component.Expand
  ( component
  , expand
  , expand_
  , raise
  , toggle
  , module Types
  ) where

import Prologue
import Component.Expand.State (handleAction, handleQuery, initialState)
import Component.Expand.Types
  ( Action(..)
  , Component
  , ComponentHTML
  , Slot
  , State
  )
import Component.Expand.Types
  ( Action
  , Component
  , ComponentHTML
  , Input
  , Query(..)
  , Slot
  , State(..)
  ) as Types
import Type.Proxy (Proxy(..))
import Halogen as H
import Halogen.HTML as HH

expandSlot :: Proxy "expandSlot"
expandSlot = Proxy

expand
  :: forall slots slot m parentAction parentSlots
   . Ord slot
  => Monad m
  => slot
  -> State
  -> (State -> ComponentHTML parentSlots parentAction m)
  -> H.ComponentHTML parentAction (expandSlot :: Slot parentAction slot | slots)
       m
expand slot initial render =
  HH.slot
    expandSlot
    slot
    component
    { initial, render }
    identity

expand_
  :: forall slots slot m parentAction parentSlots
   . Ord slot
  => Monad m
  => slot
  -> State
  -> (State -> ComponentHTML parentSlots Void m)
  -> H.ComponentHTML parentAction (expandSlot :: Slot Void slot | slots) m
expand_ slot initial render =
  HH.slot_ expandSlot slot component
    { initial
    , render
    }

component
  :: forall parentSlots parentAction m
   . Monad m
  => Component parentSlots parentAction m
component =
  H.mkComponent
    { initialState
    , render: \{ render, state } -> render state
    , eval:
        H.mkEval
          H.defaultEval
            { handleAction = handleAction
            , handleQuery = handleQuery
            , receive = Just <<< Receive
            }
    }

toggle :: forall parentSlots parentAction m. Action parentSlots parentAction m
toggle = AToggle

raise
  :: forall parentSlots parentAction m
   . parentAction
  -> Action parentSlots parentAction m
raise = Raise
