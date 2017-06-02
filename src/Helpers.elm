module Helpers exposing (..)

import Char


(=>) : a -> b -> ( a, b )
(=>) =
    (,)
infixl 0 =>
