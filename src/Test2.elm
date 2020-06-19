module Test2 exposing (main)

import Browser
import Browser.Navigation
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Url


type alias Model =
    { count : Int
    , key : Browser.Navigation.Key
    }


init : a -> Url.Url -> Browser.Navigation.Key -> ( Model, Cmd msg )
init _ url key =
    ( { count = 0
      , key = key
      }
    , Cmd.none
    )


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    let
        _ =
            Debug.log "" <| "* UPDATE (" ++ String.left 11 (Debug.toString msg) ++ ")"
    in
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , Browser.Navigation.pushUrl model.key (Url.toString url)
                    )

                Browser.External href ->
                    ( model
                    , Browser.Navigation.load href
                    )

        UrlChanged url ->
            if String.contains "increment" url.path then
                ( { model | count = model.count + 1 }, Cmd.none )

            else if String.contains "decrement" url.path then
                ( { model | count = model.count - 1 }, Cmd.none )

            else
                ( model, Cmd.none )


view : { a | count : Int } -> { body : List (Html Msg), title : String }
view model =
    let
        _ =
            Debug.log "" "* VIEW"
    in
    { title = "Title"
    , body =
        [ a [ href "increment" ] [ text "+1" ]
        , div [] [ text <| String.fromInt model.count ]
        , a [ href "decrement" ] [ text "-1" ]
        ]
    }


subscriptions : a -> Sub msg
subscriptions model =
    let
        _ =
            Debug.log "" "* SUBSCRIPTIONS"
    in
    Sub.none


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = LinkClicked
        , onUrlChange = UrlChanged
        }
