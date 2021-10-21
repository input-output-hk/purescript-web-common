module AjaxUtils
  ( AjaxErrorPaneAction(..)
  , ajaxErrorPane
  , closeableAjaxErrorPane
  , ajaxErrorRefLabel
  ) where

import Prelude hiding (div)
import Affjax (printError)
import Affjax.StatusCode (StatusCode(..))
import Bootstrap (alertDanger_, btn, floatRight)
import Data.Argonaut.Core (stringify)
import Data.Argonaut.Decode (printJsonDecodeError)
import Halogen (RefLabel(RefLabel))
import Halogen.HTML (ClassName(..), HTML, br_, button, div, p_, text)
import Halogen.HTML.Events (onClick)
import Halogen.HTML.Properties (class_, classes, ref)
import Icons (Icon(..), icon)
import Servant.PureScript (AjaxError, ErrorDescription(..))

data AjaxErrorPaneAction
  = CloseErrorPane

ajaxErrorPane :: forall p i. AjaxError -> HTML p i
ajaxErrorPane error =
  div
    [ class_ ajaxErrorClass
    , ref ajaxErrorRefLabel
    ]
    [ alertDanger_
        [ showAjaxError error
        , br_
        , text "Please try again or contact support for assistance."
        ]
    ]

closeableAjaxErrorPane :: forall p. AjaxError -> HTML p AjaxErrorPaneAction
closeableAjaxErrorPane error =
  div
    [ class_ ajaxErrorClass ]
    [ alertDanger_
        [ button
            [ classes [ btn, floatRight, ClassName "ajax-error-close-button" ]
            , onClick $ const $ CloseErrorPane
            ]
            [ icon Close ]
        , p_ [ showAjaxError error ]
        ]
    ]

ajaxErrorRefLabel :: RefLabel
ajaxErrorRefLabel = RefLabel "ajax-error"

ajaxErrorClass :: ClassName
ajaxErrorClass = ClassName "ajax-error"

showAjaxError :: forall p i. AjaxError -> HTML p i
showAjaxError = _.description >>> showErrorDescription

showErrorDescription :: forall p i. ErrorDescription -> HTML p i
showErrorDescription (UnexpectedHTTPStatus { status: StatusCode 404 }) = text
  "Data not found."

showErrorDescription (UnexpectedHTTPStatus { body, status }) =
  text
    $ "Server error "
        <> show status
        <> ": "
        <> stringify body

showErrorDescription (DecodingError err) =
  text $ "DecodingError: "
    <> printJsonDecodeError err

showErrorDescription (ConnectingError err) = text $ "ConnectionError: " <>
  printError err
