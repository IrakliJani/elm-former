module Main exposing (..)

import Html exposing (Html, div, text, input)
import Html.Attributes exposing (placeholder)
import Html.Events exposing (onInput)
import Json.Decode as D
import Dict exposing (Dict)
import Char


-- MODEL


type Widget
    = Input


type alias Entry =
    { widget : Widget
    , name : String
    }


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


declarationDecoder : String -> Result String (List Entry)
declarationDecoder =
    D.decodeString (D.list entryDecoder)


entryDecoder : D.Decoder Entry
entryDecoder =
    let
        toWidget : String -> D.Decoder Widget
        toWidget s =
            case s of
                "input" ->
                    D.succeed <| Input

                _ ->
                    D.fail <| "unknown widget type: " ++ s
    in
        D.map2 Entry
            (D.field "type" D.string |> D.andThen toWidget)
            (D.field "name" D.string)


init : ( Model, Cmd Msg )
init =
    Dict.empty ! []



-- UPDATE


type Msg
    = NoOp
    | Update String String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        Update key value ->
            Dict.update key (always <| Just value) model
                ! []



-- VIEW


capitalize : String -> String
capitalize str =
    case String.toList str of
        c :: cs ->
            String.fromList <| Char.toUpper c :: cs

        [] ->
            ""


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


view : Result String (List Entry) -> Model -> Html Msg
view declaration model =
    div [] <|
        case declaration of
            Ok d ->
                List.map widget d

            Err e ->
                [ text <| "Error parsing json: " ++ e ]



-- MAIN


main : Program Never Model Msg
main =
    let
        declaration =
            declarationDecoder json
    in
        Html.program
            { init = init
            , update = update
            , view = view declaration
            , subscriptions = always Sub.none
            }
