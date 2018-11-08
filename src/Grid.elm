module Grid exposing
    ( around
    , auto
    , between
    , bottom
    , center
    , col
    , columns
    , end
    , first
    , grid
    , last
    , lg
    , md
    , middle
    , offset
    , reverse
    , row
    , sm
    , start
    , styles
    , top
    , xl
    )

{-| Responsive grids based on flexbox. This module provides a DSL for building
such grids.
-}

import Css
    exposing
        ( alignItems
        , auto
        , borderBox
        , boxSizing
        , columnReverse
        , displayFlex
        , flexBasis
        , flexDirection
        , flexEnd
        , flexGrow
        , flexShrink
        , flexStart
        , flexWrap
        , justifyContent
        , marginLeft
        , marginRight
        , maxWidth
        , num
        , order
        , pct
        , property
        , rowReverse
        , spaceAround
        , spaceBetween
        , textAlign
        , wrap
        )
import Html.Styled exposing (Attribute, Html, div, styled, text)
import Responsive
    exposing
        ( BaseStyle
        , Device(..)
        , DeviceSpec
        , DeviceStyles
        , deviceStyle
        , deviceStyles
        , mapMaybeDeviceSpec
        , rhythm
        )



-- Grid  data models


type Compatible
    = Compatible


type Grid
    = Grid
    | Row
    | Column


type Builder a
    = Builder Device Grid (Grid -> List Css.Style)



-- Grid constructors


type alias GridT a msg =
    List (List (Grid -> Builder { a | grid : Compatible })) -> List (Attribute msg) -> List (DeviceStyles -> Html msg) -> DeviceStyles -> Html msg


{-| The outer builder of a responsive grid.
-}
grid : GridT a msg
grid builders attributes innerHtml devices =
    let
        flatBuilders =
            List.concat builders
                |> List.map (\gridFn -> gridFn Column)
    in
    styled div
        [ marginRight Css.auto
        , marginLeft Css.auto
        , applyDevicesToBuilders flatBuilders devices
        ]
        []
        (List.map (\deviceStyleFn -> deviceStyleFn devices) innerHtml)


type alias RowT a msg =
    List (List (Grid -> Builder { a | row : Compatible })) -> List (Attribute msg) -> List (DeviceStyles -> Html msg) -> DeviceStyles -> Html msg


{-| The row builder for a responsive grid, on which row compatible properties can be defined.
-}
row : RowT a msg
row builders attributes innerHtml devices =
    let
        flatBuilders =
            List.concat builders
                |> List.map (\gridFn -> gridFn Column)
    in
    styled div
        [ boxSizing borderBox
        , displayFlex
        , property "flex" "0 1 auto"
        , flexDirection Css.row
        , flexWrap wrap
        , applyDevicesToBuilders flatBuilders devices
        ]
        []
        (List.map (\deviceStyleFn -> deviceStyleFn devices) innerHtml)


type alias ColT a msg =
    List (List (Grid -> Builder { a | col : Compatible })) -> List (Attribute msg) -> List (Html msg) -> DeviceStyles -> Html msg


{-| The column builder for a responsive grid, on which column compatible properties can be defined.
-}
col : ColT a msg
col builders attributes innerHtml devices =
    let
        flatBuilders : List (Builder { a | col : Compatible })
        flatBuilders =
            List.concat builders
                |> List.map (\gridFn -> gridFn Column)
    in
    styled div
        [ boxSizing borderBox
        , flexShrink (num 0)
        , flexGrow (num 0)
        , applyDevicesToBuilders flatBuilders devices
        ]
        []
        innerHtml


{-| Small device grid property builder.
-}
sm : List (Device -> Grid -> Builder a) -> List (Grid -> Builder a)
sm builders =
    applyDevice Sm builders


{-| Medium device grid property builder.
-}
md : List (Device -> Grid -> Builder a) -> List (Grid -> Builder a)
md builders =
    applyDevice Md builders


{-| Largs device grid property builder.
-}
lg : List (Device -> Grid -> Builder a) -> List (Grid -> Builder a)
lg builders =
    applyDevice Lg builders


{-| Extra large device grid property builder.
-}
xl : List (Device -> Grid -> Builder a) -> List (Grid -> Builder a)
xl builders =
    applyDevice Xl builders


empty : Device -> Grid -> Builder a
empty =
    \device grd -> Builder device grd (always [])


styles : List Css.Style -> Device -> Grid -> Builder a
styles styleList device grd =
    Builder device grd (always styleList)


{-| Auto column width means that a column expands to fill the available width.
-}
auto =
    columns 0


{-| Defines how many column widths a column will take up. Zero means use 'auto'
width and expand to fill available space.
-}
columns : Float -> Device -> Grid -> Builder { a | row : Never }
columns n =
    if n > 0 then
        styles
            [ flexBasis (pct (n / 12 * 100))
            , maxWidth (pct (n / 12 * 100))
            ]

    else
        styles
            [ flexBasis (pct (n / 12 * 100))
            , maxWidth (pct 100)
            , flexGrow (num 1)
            ]


{-| Defines how many column widths a column is offset from the left hand side by.
-}
offset : Float -> Device -> Grid -> Builder { a | grid : Never, row : Never }
offset n =
    if n > 0 then
        styles
            [ marginLeft (pct (n / 12 * 100)) ]

    else
        empty



-- Justify Content


{-| Puts the content of a row or column at the start.
-}
start : Device -> Grid -> Builder { a | grid : Never }
start =
    styles
        [ justifyContent flexStart
        , textAlign Css.start
        ]


{-| Puts the content of a row or column at the end.
-}
end : Device -> Grid -> Builder { a | grid : Never }
end =
    styles
        [ justifyContent flexEnd
        , textAlign Css.end
        ]


{-| Centers a row or column.
-}
center : Device -> Grid -> Builder { a | grid : Never }
center =
    styles
        [ justifyContent Css.center
        , textAlign Css.center
        ]


{-| Only pad spacing between items in a row.
-}
between : Device -> Grid -> Builder { a | grid : Never, col : Never }
between =
    styles [ justifyContent spaceBetween ]


{-| Pad spacing around items in a row, with space on the left and right hand sides.
-}
around : Device -> Grid -> Builder { a | grid : Never, col : Never }
around =
    styles [ justifyContent spaceAround ]



-- Direction


{-| Reverses the order of items in a column or row.
-}
reverse : Device -> Grid -> Builder { a | grid : Never }
reverse device grd =
    Builder device grd <|
        \container ->
            case container of
                Row ->
                    [ flexDirection rowReverse ]

                Column ->
                    [ flexDirection columnReverse ]

                _ ->
                    []



-- Align Items


{-| Aligns items at the top of a row.
-}
top : Device -> Grid -> Builder { a | grid : Never, column : Never }
top =
    styles [ alignItems flexStart ]


{-| Aligns items in the middle of a row.
-}
middle : Device -> Grid -> Builder { a | grid : Never, column : Never }
middle =
    styles [ alignItems Css.center ]


{-| Aligns items at the bottom of a row.
-}
bottom : Device -> Grid -> Builder { a | grid : Never, column : Never }
bottom =
    styles [ alignItems flexEnd ]


{-| Stretches items to fill the row height-wise.
-}
stretch : Device -> Grid -> Builder { a | grid : Never, column : Never }
stretch =
    styles [ alignItems Css.stretch ]


{-| Aligns items so their balines align at the top of a row.
-}
baseline : Device -> Grid -> Builder { a | grid : Never, column : Never }
baseline =
    styles [ alignItems Css.baseline ]



-- Ordering


{-| Orders a row or column so it comes first.
-}
first : Device -> Grid -> Builder { a | grid : Never }
first =
    styles [ order (num -1) ]


{-| Orders a row or column so it comes last.
-}
last : Device -> Grid -> Builder { a | grid : Never }
last =
    styles [ order (num 1) ]



-- Helper functions


applyDevice : Device -> List (Device -> Grid -> Builder a) -> List (Grid -> Builder a)
applyDevice device builders =
    List.map (\buildFn -> buildFn device) builders


applyDevicesToBuilders buildersList devices =
    deviceStyles devices
        (\base ->
            List.map
                (\(Builder device grd fn) ->
                    if device == base.device then
                        fn grd

                    else
                        []
                )
                buildersList
                |> List.concat
        )
