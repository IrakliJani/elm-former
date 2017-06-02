module Decoders exposing (decodeDeclaration)

import Json.Decode exposing (..)
import Types exposing (Widget(..), Entry)


decodeDeclaration : String -> Result String (List Entry)
decodeDeclaration =
    decodeString (list entryDecoder)


entryDecoder : Decoder Entry
entryDecoder =
    let
        toWidget : String -> Decoder Widget
        toWidget s =
            case s of
                "input" ->
                    succeed <| Input ""

                "textarea" ->
                    succeed <| Textarea ""

                "checkbox" ->
                    succeed <| Checkbox False

                _ ->
                    fail <| "unknown widget type: " ++ s
    in
        map3 Entry
            (field "widget" string |> andThen toWidget)
            (field "key" string)
            (field "placeholder" (nullable string))
