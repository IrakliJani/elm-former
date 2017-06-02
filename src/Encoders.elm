module Encoders exposing (encodeJson)

import Json.Encode exposing (..)
import Dict exposing (Dict)
import Types exposing (Widget(..))


encodeJson : Dict String Widget -> String
encodeJson model =
    let
        mapValue value =
            case value of
                Input s ->
                    string s

                Textarea s ->
                    string s

                Checkbox b ->
                    bool b

        valueList =
            model
                |> Dict.toList
                |> List.map (Tuple.mapSecond mapValue)
    in
        encode 4 <| object valueList
