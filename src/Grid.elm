module Grid exposing (..)

import Maybe.Extra
import Css exposing (..)
import Html.Styled exposing (styled, div, Html, Attribute)
import Responsive
    exposing
        ( Device(..)
        , DeviceSpec
        , DeviceStyles
        , BaseStyle
        , mapMaybeDeviceSpec
        , rhythm
        , deviceStyle
        , deviceStyles
        )


type alias ColLayout =
    { device : Device
    , columns : Int
    , offset : Int
    , halign : HAlign
    , valign : VAlign
    }


type alias RowLayout =
    { device : Device
    , halign : HAlign
    , valign : VAlign
    }


type HAlign
    = Start
    | Center
    | End
    | Around
    | Between
    | NoHAlign


type VAlign
    = Top
    | Middle
    | Bottom
    | NoVAlign


defaultColLayout =
    { device = Sm
    , columns = 0
    , offset = 0
    , halign = NoHAlign
    , valign = NoVAlign
    }


sm =
    { defaultColLayout
        | device = Sm
    }


md =
    { defaultColLayout
        | device = Md
    }


lg =
    { defaultColLayout
        | device = Lg
    }


xl =
    { defaultColLayout
        | device = Xl
    }


type alias ColSpec =
    DeviceSpec (Maybe ColLayout)


toColSpec : List ColLayout -> ColSpec
toColSpec layouts =
    List.foldl
        (\layout accum ->
            case layout.device of
                Sm ->
                    { accum | sm = Just layout }

                Md ->
                    { accum | md = Just layout }

                Lg ->
                    { accum | lg = Just layout }

                Xl ->
                    { accum | xl = Just layout }
        )
        { sm = Nothing, md = Nothing, lg = Nothing, xl = Nothing }
        layouts


grid =
    styled div
        [ marginRight auto
        , marginLeft auto
        ]


row =
    styled div
        [ boxSizing borderBox
        , displayFlex
        , property "flex" "0 1 auto"
        , flexDirection Css.row
        , flexWrap wrap
        ]


reverseRow =
    [ flexDirection rowReverse
    ]


reverseCol =
    [ flexDirection columnReverse ]


col : DeviceStyles -> List ColLayout -> List (Attribute msg) -> List (Html msg) -> Html msg
col devices layouts =
    let
        colSpec =
            toColSpec layouts

        style devices =
            deviceStyles devices <|
                \deviceProps ->
                    mapMaybeDeviceSpec
                        (\layout ->
                            (if deviceProps.device == layout.device then
                                List.concat
                                    [ colWidth layout
                                    , offset layout
                                    , halign layout
                                    , valign layout
                                    ]
                             else
                                []
                            )
                                |> Css.batch
                        )
                        colSpec
    in
        styled div
            [ boxSizing borderBox
            , flexShrink (num 0)
            , flexGrow (num 0)
            , style devices
            ]


colWidth layout =
    if layout.columns == 0 then
        [ flexBasis (pct ((toFloat layout.columns) / 12 * 100))
        , maxWidth (pct 100)
        , flexGrow (num 1)
        ]
    else
        [ flexBasis (pct ((toFloat layout.columns) / 12 * 100))
        , maxWidth (pct ((toFloat layout.columns) / 12 * 100))
        ]


offset layout =
    (if layout.offset > 0 then
        [ marginLeft (pct ((toFloat layout.offset) / 12 * 100)) ]
     else
        []
    )


halign layout =
    case layout.halign of
        Start ->
            start

        Center ->
            center

        End ->
            end

        Around ->
            around

        Between ->
            between

        NoHAlign ->
            []


start =
    [ justifyContent flexStart
    , textAlign Css.start
    ]


center =
    [ justifyContent Css.center
    , textAlign Css.center
    ]


end =
    [ justifyContent flexEnd
    , textAlign Css.end
    ]


around =
    [ justifyContent spaceAround
    ]


between =
    [ justifyContent spaceBetween ]


valign layout =
    case layout.valign of
        Top ->
            top

        Middle ->
            middle

        Bottom ->
            bottom

        NoVAlign ->
            []


top =
    [ alignItems flexStart ]


middle =
    [ alignItems Css.center ]


bottom =
    [ alignItems flexEnd ]


first =
    [ order (num -1) ]


last =
    [ order (num 1) ]
