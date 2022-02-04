module Clipboard
  ( class MonadClipboard
  , handleAction
  , Action(..)
  , copy
  ) where

import Prologue hiding (div)
import Control.Monad.Reader.Trans (ReaderT)
import Control.Monad.State.Trans (StateT)
import Control.Monad.Trans.Class (lift)
import Data.Generic.Rep (class Generic)
import Data.Show.Generic (genericShow)
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Effect.Uncurried (EffectFn1, runEffectFn1)
import Halogen (HalogenM)

data Action
  = CopyToClipboard String

derive instance genericAction :: Generic Action _

instance showAction :: Show Action where
  show = genericShow

class MonadClipboard m where
  copy :: String -> m Unit

instance monadClipboardEffect :: MonadClipboard Effect where
  copy = runEffectFn1 _copy

instance monadClipboardAff :: MonadClipboard Aff where
  copy = liftEffect <<< copy

instance monadClipboardHalogenM ::
  ( Monad m
  , MonadClipboard m
  ) =>
  MonadClipboard (HalogenM state action slots output m) where
  copy = lift <<< copy

instance monadClipboardStateT ::
  ( Monad m
  , MonadClipboard m
  ) =>
  MonadClipboard (StateT s m) where
  copy = lift <<< copy

instance monadClipboardReaderT ::
  ( Monad m
  , MonadClipboard m
  ) =>
  MonadClipboard (ReaderT env m) where
  copy = lift <<< copy

handleAction :: forall m. MonadClipboard m => Action -> m Unit
handleAction (CopyToClipboard str) = copy str

foreign import _copy :: EffectFn1 String Unit
