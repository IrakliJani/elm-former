module Widget.Checkbox exposing (view)

import Html exposing (Html, div, input)
import Html.Events exposing (onCheck)
import Html.Attributes exposing (type_)


view :
    (Bool -> msg)
    -> { a | placeholder : Maybe String }
    -> Html msg
view update entry =
    div []
        [ input
            [ type_ "checkbox"
            , onCheck <| update
            ]
            []
        ]
