module Widget.Textarea exposing (view)

import Html exposing (Html, div, textarea)
import Html.Events exposing (onInput)
import Html.Attributes exposing (placeholder)


view :
    (String -> msg)
    -> { a | placeholder : Maybe String }
    -> Html msg
view update entry =
    div []
        [ textarea
            [ placeholder <| Maybe.withDefault "" entry.placeholder
            , onInput <| update
            ]
            []
        ]
