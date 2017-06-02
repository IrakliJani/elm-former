module Decoders exposing (decodeDeclaration)

import Json.Decode exposing (..)
import Types exposing (Widget(Input), Entry)


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
                    succeed <| Input

                _ ->
                    fail <| "unknown widget type: " ++ s
    in
        map2 Entry
            (field "type" string |> andThen toWidget)
            (field "name" string)
