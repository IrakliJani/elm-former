module Views exposing (..)

import Html exposing (Html, pre, text)
import Html.Attributes exposing (style)
import Helpers exposing ((=>))


jsonView : String -> Html msg
jsonView json =
    pre
        [ style
            [ "background" => "#EFEFEF"
            , "padding" => "10px"
            ]
        ]
        [ text json ]
