module Main.View exposing (..)

import Array exposing (Array)
import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (href, class, style, id)
import Html.Lazy
import Material.Layout as Layout
import Material.Options as Options exposing (css, when)
import Material.Toggles as Toggles
import Material.Typography as Typography
import ViewUtils
import Layout.Types
import Typography.View
import Buttons.View
import Cards.View
import Tables.View
import Forms.View
import Multiselect.View
import Dialogs.View
import Main.Types exposing (..)


nth : Int -> List a -> Maybe a
nth k xs =
    List.drop k xs |> List.head


view : Model -> Html Msg
view =
    Html.Lazy.lazy view_


view_ : Model -> Html Msg
view_ model =
    let
        top =
            (Array.get model.selectedTab tabViews |> Maybe.withDefault e404) model
    in
        Layout.render Mdl
            model.mdl
            [ Layout.selectedTab model.selectedTab
            , Layout.onSelectTab SelectTab
            , Layout.fixedHeader |> ViewUtils.when model.layout.fixedHeader
            , Layout.fixedDrawer |> ViewUtils.when model.layout.fixedDrawer
            , Layout.fixedTabs |> ViewUtils.when model.layout.fixedTabs
            , (case model.layout.header of
                Layout.Types.Waterfall x ->
                    Layout.waterfall x

                Layout.Types.Seamed ->
                    Layout.seamed

                Layout.Types.Standard ->
                    Options.nop

                Layout.Types.Scrolling ->
                    Layout.scrolling
              )
                |> ViewUtils.when model.layout.withHeader
            , if model.transparentHeader then
                Layout.transparentHeader
              else
                Options.nop
            ]
            { header = header model
            , drawer = []
            , tabs =
                ( tabTitles
                , []
                )
            , main = [ top ]
            }
            |> (\contents ->
                    div []
                        [ if model.debugStylesheet then
                            Html.node "link"
                                [ Html.Attributes.attribute "rel" "stylesheet"
                                , Html.Attributes.attribute "href" "styles/debug.css"
                                ]
                                []
                          else
                            div [] []
                        , contents
                          {-
                             Dialogs need to be pulled up here to make the dialog
                             polyfill work on some browsers.
                          -}
                        , case nth model.selectedTab tabs of
                            Just ( "Tables", _, _ ) ->
                                Html.map TablesMsg (Tables.View.dialog model.tables)

                            Just ( "Dialogs", _, _ ) ->
                                Html.map DialogsMsg (Dialogs.View.dialog model.dialogs)

                            _ ->
                                div [] []
                        ]
               )


header : Model -> List (Html Msg)
header model =
    if model.layout.withHeader then
        [ Layout.row
            []
            [ a
                [ Html.Attributes.id "thesett-logo"
                , href "/"
                ]
                []
            , Layout.spacer
            , div [ id "debug-box" ]
                [ Toggles.switch Mdl
                    [ 0 ]
                    model.mdl
                    [ Toggles.ripple
                    , Toggles.value model.debugStylesheet
                    , Toggles.onClick ToggleDebug
                    ]
                    [ text "Debug Style" ]
                ]
            ]
        ]
    else
        []


tabs : List ( String, String, Model -> Html Msg )
tabs =
    [ ( "Typography", "typography", .typography >> Typography.View.root >> Html.map TypographyMsg )
    , ( "Buttons", "buttons", .buttons >> Buttons.View.root >> Html.map ButtonsMsg )
    , ( "Cards", "cards", .cards >> Cards.View.root >> Html.map CardsMsg )
    , ( "Tables", "tables", .tables >> Tables.View.root >> Html.map TablesMsg )
    , ( "Forms", "forms", .forms >> Forms.View.root >> Html.map FormsMsg )
    , ( "Multiselect", "multiselect", .multiselect >> Multiselect.View.root >> Html.map MultiselectMsg )
    , ( "Dialogs", "dialogs", .dialogs >> Dialogs.View.root >> Html.map DialogsMsg )
    ]


tabTitles : List (Html a)
tabTitles =
    List.map (\( x, _, _ ) -> text x) tabs


tabViews : Array (Model -> Html Msg)
tabViews =
    List.map (\( _, _, v ) -> v) tabs |> Array.fromList


tabUrls : Array String
tabUrls =
    List.map (\( _, x, _ ) -> x) tabs |> Array.fromList


urlTabs : Dict String Int
urlTabs =
    List.indexedMap (\idx ( _, x, _ ) -> ( x, idx )) tabs |> Dict.fromList


e404 : Model -> Html Msg
e404 _ =
    div
        []
        [ Options.styled Html.h1
            [ Options.cs "mdl-typography--display-4"
            , Typography.center
            ]
            [ text "404" ]
        ]



-- Old stuff


drawer : Model -> List (Html Msg)
drawer model =
    [ Layout.title [] [ text "ToolBox" ]
    , Toggles.switch Mdl
        [ 0 ]
        model.mdl
        [ Toggles.ripple
        , Toggles.value model.debugStylesheet
        , Toggles.onClick ToggleDebug
        ]
        [ text "Debug" ]
    ]


stylesheet : Html a
stylesheet =
    Options.stylesheet """
  .mdl-layout__header--transparent {
    background: url(_https://getmdl.io/assets/demos/transparent.jpg_) center / cover;
  }
"""
