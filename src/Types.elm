module Types exposing (..)


type Widget
    = Input String
    | Textarea String
    | Checkbox Bool


type alias Entry =
    { widget : Widget
    , key : String
    , placeholder : Maybe String
    }
