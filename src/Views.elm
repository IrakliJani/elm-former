module Views exposing (..)

import Html exposing (Html, div, pre, text)
import Html.Attributes exposing (style)
import Helpers exposing ((=>))


jsonView : String -> String -> Html msg
jsonView title json =
    div [ style [ "marginTop" => "30px" ] ]
        [ div []
            [ text title ]
        , pre
            [ style
                [ "background" => "#EFEFEF"
                , "padding" => "5px 10px"
                ]
            ]
            [ text json ]
        ]
