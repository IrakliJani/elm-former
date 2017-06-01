module Main exposing (..)

import Html exposing (Html, div, text, input)
import Html.Attributes exposing (placeholder)
import Char
import Json.Decode as D


-- MODEL


type Widget
    = Input


type alias Entry =
    { widget : Widget
    , name : String
    }


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


type alias Model =
    {}


init : ( Model, Cmd Msg )
init =
    {} ! []



-- UPDATE


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []



-- VIEW


capitalize : String -> String
capitalize str =
    case String.toList str of
        c :: cs ->
            String.fromList <| Char.toUpper c :: cs

        [] ->
            ""


coolInput : Entry -> Html Msg
coolInput e =
    div [] [ input [ placeholder <| capitalize e.name ] [] ]


widget : Entry -> Html Msg
widget e =
    case e.widget of
        Input ->
            coolInput e


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
