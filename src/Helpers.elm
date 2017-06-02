module Helpers exposing (..)

import Char


capitalize : String -> String
capitalize str =
    case String.toList str of
        c :: cs ->
            String.fromList <| Char.toUpper c :: cs

        [] ->
            ""
