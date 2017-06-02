module Main exposing (..)

import Html exposing (Html, div, text, pre, input, textarea)
import Html.Attributes exposing (style, placeholder, type_)
import Html.Events exposing (onInput, onCheck)
import Dict exposing (Dict)
import Types exposing (Widget(..), Entry)
import Decoders exposing (decodeDeclaration)
import Encoders exposing (encodeJson)
import Helpers exposing ((=>))


-- MODEL


type alias Model =
    Dict String Widget


json : String
json =
    """
        [
            {
                "widget": "input",
                "key": "username",
                "placeholder": "Username"
            },
            {
                "widget": "input",
                "key": "password",
                "placeholder": "Password"
            },
            {
                "widget": "textarea",
                "key": "about",
                "placeholder": "About me"
            },
            {
                "widget": "checkbox",
                "key": "agreed",
                "placeholder": "I agree"
            }
        ]
    """


init : ( Model, Cmd Msg )
init =
    Dict.empty ! []



-- UPDATE


type Msg
    = Update String Widget


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Update key value ->
            Dict.update key (always <| Just value) model
                ! []



-- VIEW


maybePlaceholder p =
    placeholder <| Maybe.withDefault "" p


coolInput : Entry -> Html Msg
coolInput entry =
    let
        update key value =
            Update key (Input value)
    in
        div []
            [ input
                [ maybePlaceholder <| entry.placeholder
                , onInput <| update entry.key
                ]
                []
            ]


coolTextarea : Entry -> Html Msg
coolTextarea entry =
    let
        update key value =
            Update key (Textarea value)
    in
        div []
            [ textarea
                [ maybePlaceholder <| entry.placeholder
                , onInput <| update entry.key
                ]
                []
            ]


coolCheckbox : Entry -> Html Msg
coolCheckbox entry =
    let
        update key value =
            Update key (Checkbox value)
    in
        div []
            [ input
                [ maybePlaceholder <| entry.placeholder
                , type_ "checkbox"
                , onCheck <| update entry.key
                ]
                []
            ]


widget : Entry -> Html Msg
widget entry =
    case entry.widget of
        Input data ->
            coolInput entry

        Textarea data ->
            coolTextarea entry

        Checkbox data ->
            coolCheckbox entry


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
