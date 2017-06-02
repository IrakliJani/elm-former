module Helpers exposing (..)

import Char


(=>) : a -> b -> ( a, b )
(=>) =
    (,)
infixl 0 =>


capitalize : String -> String
capitalize str =
    case String.toList str of
        c :: cs ->
            String.fromList <| Char.toUpper c :: cs

        [] ->
            ""
