module Main exposing (..)

import Html exposing (Html, div, text, input, pre)
import Html.Attributes exposing (style, placeholder)
import Html.Events exposing (onInput)
import Dict exposing (Dict)
import Types exposing (Widget(Input), Entry)
import Decoders exposing (decodeDeclaration)
import Encoders exposing (encodeJson)
import Helpers exposing ((=>), capitalize)


-- MODEL


type alias Model =
    Dict String String


json : String
json =
    """
        [
            {
                "type": "input",
                "name": "username"
            },
            {
                "type": "input",
                "name": "password"
            }
        ]
    """


init : ( Model, Cmd Msg )
init =
    Dict.empty ! []



-- UPDATE


type Msg
    = Update String String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Update key value ->
            Dict.update key (always <| Just value) model
                ! []



-- VIEW


coolInput : Entry -> Html Msg
coolInput entry =
    div []
        [ input
            [ placeholder <| capitalize entry.name
            , onInput <| Update entry.name
            ]
            []
        ]


widget : Entry -> Html Msg
widget entry =
    case entry.widget of
        Input ->
            coolInput entry


widgets : Result String (List Entry) -> Html Msg
widgets declaration =
    div [] <|
        case declaration of
            Ok d ->
                List.map widget d

            Err e ->
                [ text <| "Error parsing json: " ++ e ]


jsonView : String -> Html Msg
jsonView json =
    pre
        [ style
            [ "background" => "#EFEFEF"
            , "padding" => "10px"
            ]
        ]
        [ text json ]


view : Model -> Html Msg
view model =
    let
        declaration =
            decodeDeclaration json

        encodedJson =
            encodeJson model
    in
        div []
            [ widgets <| declaration
            , jsonView <| encodedJson
            ]



-- MAIN


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = always Sub.none
        }
