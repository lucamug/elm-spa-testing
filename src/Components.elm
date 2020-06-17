module Components exposing (layout)

import Browser exposing (Document)
import Generated.Route as Route exposing (Route)
import Html exposing (..)
import Html.Attributes as Attr exposing (class, href, style)


layout : { page : Document msg } -> Document msg
layout { page } =
    { title = page.title
    , body =
        [ div [ style "margin" "50px", style "font-family" "sans-serif" ]
            [ navbar
            , div
                [ style "padding" "50px"
                , style "margin" "20px 0"
                , style "border" "1px solid #ddd"
                ]
                page.body
            , footer
            ]
        ]
    }


navbar : Html msg
navbar =
    header []
        [ a [ href (Route.toHref Route.Top) ] [ text "home" ]
        , ul []
            [ li [] [ a [ href (Route.toHref Route.Docs1) ] [ text "Docs1" ] ]
            , li [] [ a [ href (Route.toHref Route.Docs2) ] [ text "Docs2" ] ]
            , li [] [ a [ href (Route.toHref Route.Page1) ] [ text "Page1" ] ]
            , li [] [ a [ href (Route.toHref Route.Page2) ] [ text "Page2" ] ]
            ]
        ]


footer : Html msg
footer =
    Html.footer [] [ text "built with elm ❤" ]
