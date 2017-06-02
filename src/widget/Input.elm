module Widget.Input exposing (view)

import Html exposing (Html, div, input)
import Html.Events exposing (onInput)
import Html.Attributes exposing (placeholder)


view :
    (String -> msg)
    -> { a | placeholder : Maybe String }
    -> Html msg
view update entry =
    div []
        [ input
            [ placeholder <| Maybe.withDefault "" entry.placeholder
            , onInput <| update
            ]
            []
        ]
