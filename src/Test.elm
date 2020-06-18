module Test exposing (main)

import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)


type alias Model =
    { count : Int }


init : a -> b -> c -> ( { count : number }, Cmd msg )
init _ _ _ =
    ( { count = 0 }, Cmd.none )


type Msg
    = Increment
    | Decrement
    | NoOp


update : Msg -> { a | count : number } -> ( { a | count : number }, Cmd msg )
update msg model =
    let
        _ =
            Debug.log "UPDATE" msg
    in
    case msg of
        Increment ->
            ( { model | count = model.count + 1 }, Cmd.none )

        Decrement ->
            ( { model | count = model.count - 1 }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )


view : { a | count : Int } -> { body : List (Html Msg), title : String }
view model =
    let
        _ =
            Debug.log "VIEW" ()
    in
    { title = "Title"
    , body =
        [ button [ onClick Increment ] [ text "+1" ]
        , div [] [ text <| String.fromInt model.count ]
        , button [ onClick Decrement ] [ text "-1" ]
        ]
    }


subscriptions : a -> Sub msg
subscriptions model =
    let
        _ =
            Debug.log "SUBSCRIPTIONS" ()
    in
    Sub.none


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = \_ -> NoOp
        , onUrlChange = \_ -> NoOp
        }
