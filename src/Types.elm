module Types exposing (..)


type Widget
    = Input


type alias Entry =
    { widget : Widget
    , name : String
    }
