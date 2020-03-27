port module Main exposing (Model, Msg(..), init, main, subscriptions, update, view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (class, cols, rows, value)
import Html.Events exposing (onClick, onInput)



-- MAIN


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type alias Field =
    { name : String
    , value : String
    }


type alias Model =
    List Field


init : () -> ( Model, Cmd Msg )
init _ =
    ( [ { name = "Value:"
        , value = ""
        }
      , { name = "Reasons:"
        , value = ""
        }
      , { name = "Patients' reasons:"
        , value = ""
        }
      , { name = "Nursing Implications:"
        , value = ""
        }
      , { name = "Medical Treatment:"
        , value = ""
        }
      ]
    , Cmd.none
    )



-- UPDATE


type Msg
    = UpdateField String String
    | SubmitForm


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateField name newValue ->
            let
                maybeField =
                    List.head (List.filter (\f -> f.name == name) model)
            in
            case maybeField of
                Just field ->
                    let
                        updatedModel =
                            List.map
                                (\f ->
                                    if f.name == field.name then
                                        { f | value = newValue }

                                    else
                                        f
                                )
                                model
                    in
                    ( updatedModel
                    , Cmd.none
                    )

                Nothing ->
                    ( model, Cmd.none )

        -- SUBSCRIPTIONS
        SubmitForm ->
            if formIsValid model then
                ( model, copyToClipboard (fieldsToHtml model) )

            else
                ( model, alertBad "Clinical Deficiency!" )


port alertBad : String -> Cmd msg


port copyToClipboard : String -> Cmd msg


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h1 [ class "title" ] [ text "\"To the Point!\"" ]
        , button [ class "copy-button", onClick SubmitForm ] [ text "COPYPASTA TIME!" ]
        , form []
            (List.map viewField model)
        ]


viewField : Field -> Html Msg
viewField field =
    div [ class "field" ]
        [ label [] [ text field.name ]
        , textarea
            [ rows 10
            , cols 50
            , onInput (UpdateField field.name)
            , value field.value
            ]
            [ text field.value ]
        ]


formIsValid : List Field -> Bool
formIsValid =
    List.all (\field -> not (String.isEmpty field.value))


fieldsToHtml : List Field -> String
fieldsToHtml fields =
    let
        htmlStrings =
            List.map (\f -> "<p>" ++ f.name ++ f.value ++ "</p>") fields

        finalHtml =
            List.foldl (\acc str -> acc ++ str) "" htmlStrings
    in
    finalHtml
