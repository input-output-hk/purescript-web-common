module Component.IconButton.View (iconButton) where

import Prologue
import Component.Icons (Icon, icon_)
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP

iconButton :: forall w action. Icon -> Maybe action -> HH.HTML w action
iconButton ic Nothing = HH.button [ HP.disabled true ] [ icon_ ic ]

iconButton ic (Just onClick) = HH.button [ HE.onClick (const onClick) ]
  [ icon_ ic ]
