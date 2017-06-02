module Encoders exposing (encodeJson)

import Json.Encode exposing (..)
import Dict exposing (Dict)


encodeJson : Dict String String -> String
encodeJson model =
    let
        valueList =
            model
                |> Dict.toList
                |> List.map (Tuple.mapSecond string)
    in
        encode 4 <| object valueList
