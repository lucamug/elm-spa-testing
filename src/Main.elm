module Main exposing (main)

import Browser
import Browser.Navigation
import Generated.Pages
import Generated.Route
import Global
import Html
import Url


main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = LinkClicked
        , onUrlChange = UrlChanged
        }



-- INIT


type alias Flags =
    ()


type alias Model =
    { key : Browser.Navigation.Key
    , url : Url.Url
    , global : Global.Model
    , page : Generated.Pages.Model
    }


init : Flags -> Url.Url -> Browser.Navigation.Key -> ( Model, Cmd Msg )
init flags url key =
    let
        ( global, globalCmd ) =
            Global.init flags url key

        ( page, pageCmd, pageGlobalCmd ) =
            Generated.Pages.init (fromUrl url) global
    in
    ( Model key url global page
    , Cmd.batch
        [ Cmd.map Global globalCmd
        , Cmd.map Global pageGlobalCmd
        , Cmd.map Page pageCmd
        ]
    )


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | Global Global.Msg
    | Page Generated.Pages.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked (Browser.Internal url) ->
            ( model, Browser.Navigation.pushUrl model.key (Url.toString url) )

        LinkClicked (Browser.External href) ->
            ( model, Browser.Navigation.load href )

        UrlChanged url ->
            let
                ( page, pageCmd, globalCmd ) =
                    Generated.Pages.init (fromUrl url) model.global
            in
            ( { model | url = url, page = page }
            , Cmd.batch
                [ Cmd.map Page pageCmd
                , Cmd.map Global globalCmd
                ]
            )

        Global globalMsg ->
            let
                ( global, globalCmd ) =
                    Global.update globalMsg model.global
            in
            ( { model | global = global }
            , Cmd.map Global globalCmd
            )

        Page pageMsg ->
            let
                ( page, pageCmd, globalCmd ) =
                    Generated.Pages.update pageMsg model.page model.global
            in
            ( { model | page = page }
            , Cmd.batch
                [ Cmd.map Page pageCmd
                , Cmd.map Global globalCmd
                ]
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ model.global
            |> Global.subscriptions
            |> Sub.map Global
        , model.page
            |> (\page ->
                    let
                        _ =
                            Debug.log "Main.subscriptions page" page
                    in
                    Generated.Pages.subscriptions page model.global
               )
            |> Sub.map Page
        ]


view : Model -> Browser.Document Msg
view model =
    let
        _ =
            Debug.log "Main.view" ()

        documentMap :
            (msg1 -> msg2)
            -> Browser.Document msg1
            -> Browser.Document msg2
        documentMap fn doc =
            { title = doc.title
            , body = List.map (Html.map fn) doc.body
            }
    in
    Global.view
        { page = Generated.Pages.view model.page model.global |> documentMap Page
        , global = model.global
        , toMsg = Global
        }


fromUrl : Url.Url -> Generated.Route.Route
fromUrl =
    Generated.Route.fromUrl >> Maybe.withDefault Generated.Route.NotFound
