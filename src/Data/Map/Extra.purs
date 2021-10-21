module Data.Map.Extra (findIndex) where

import Prelude
import Data.Map (Map, keys)
import Data.Maybe (Maybe)
import Data.Set (filter, findMin)

findIndex :: forall k v. Ord k => (k -> Boolean) -> Map k v -> Maybe k
findIndex f map = findMin $ filter f $ keys map
