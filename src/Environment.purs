module Environment where

import Effect (Effect)

data Environment
  = Browser
  | NodeJs

foreign import detectEnvironment
  :: Environment -> Environment -> Effect Environment

currentEnvironment :: Effect Environment
currentEnvironment = detectEnvironment Browser NodeJs
