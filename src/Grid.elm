module Grid exposing
    ( grid, row, col
    , sm, md, lg, xl
    , styles
    , auto, columns, offset
    , start, end, center, between, around
    , top, middle, bottom, stretch, baseline
    , first, last, reverse
    )

{-| Responsive grids based on flexbox. This module provides a DSL for building
such grids.


# Grid constructors

@docs grid, row, col


# Device builders

@docs sm, md, lg, xl


# Inject any CSS styles

@docs styles


# Column size and offset

@docs auto, columns, offset


# Justify content

@docs start, end, center, between, around


# Align Items

@docs top, middle, bottom, stretch, baseline


# Ordering and direction

@docs first, last, reverse

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



-- Responsive style builders.


type Compatible
    = Compatible


type Builder a ctx
    = Builder Device ctx (ctx -> List Css.Style)


{-| Adds any CSS style you like to a grid element.
-}
styles : List Css.Style -> Device -> ctx -> Builder a ctx
styles styleList device ctx =
    Builder device ctx (always styleList)


applyDevice : Device -> List (Device -> ctx -> Builder a ctx) -> List (ctx -> Builder a ctx)
applyDevice device builders =
    List.map (\buildFn -> buildFn device) builders


applyDevicesToBuilders : List (Builder a ctx) -> DeviceStyles -> Css.Style
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


{-| Small device grid property builder.
-}
sm : List (Device -> ctx -> Builder a ctx) -> List (ctx -> Builder a ctx)
sm builders =
    applyDevice Sm builders


{-| Medium device grid property builder.
-}
md : List (Device -> ctx -> Builder a ctx) -> List (ctx -> Builder a ctx)
md builders =
    applyDevice Md builders


{-| Large device grid property builder.
-}
lg : List (Device -> ctx -> Builder a ctx) -> List (ctx -> Builder a ctx)
lg builders =
    applyDevice Lg builders


{-| Extra large device grid property builder.
-}
xl : List (Device -> ctx -> Builder a ctx) -> List (ctx -> Builder a ctx)
xl builders =
    applyDevice Xl builders



-- Grid  data models


type Grid
    = Grid
    | Row
    | Column


type alias GridBuilder a =
    Builder a Grid



-- Grid constructors


{-| The outer builder of a responsive grid.
-}
grid :
    List (List (Grid -> GridBuilder { a | grid : Compatible }))
    -> List (Attribute msg)
    -> List (DeviceStyles -> Html msg)
    -> DeviceStyles
    -> Html msg
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
        attributes
        (List.map (\deviceStyleFn -> deviceStyleFn devices) innerHtml)


{-| The row builder for a responsive grid, on which row compatible properties can be defined.
-}
row :
    List (List (Grid -> GridBuilder { a | row : Compatible }))
    -> List (Attribute msg)
    -> List (DeviceStyles -> Html msg)
    -> DeviceStyles
    -> Html msg
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
        attributes
        (List.map (\deviceStyleFn -> deviceStyleFn devices) innerHtml)


{-| The column builder for a responsive grid, on which column compatible properties can be defined.
-}
col :
    List (List (Grid -> GridBuilder { a | col : Compatible }))
    -> List (Attribute msg)
    -> List (Html msg)
    -> DeviceStyles
    -> Html msg
col builders attributes innerHtml devices =
    let
        flatBuilders : List (GridBuilder { a | col : Compatible })
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
        attributes
        innerHtml



--- Column size and offset


{-| Auto column width means that a column expands to fill the available width.
-}
auto : Device -> Grid -> GridBuilder { a | row : Never }
auto =
    columns 0


{-| Defines how many column widths a column will take up. Zero means use 'auto'
width and expand to fill available space.

When applied to a row or grid, this sets the total number of columns available.
When applied to a column, this sets the number of columns taken up out of the
total available.

-}
columns : Float -> Device -> Grid -> GridBuilder { a | row : Never }
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
offset : Float -> Device -> Grid -> GridBuilder { a | grid : Never, row : Never }
offset n =
    if n > 0 then
        styles
            [ marginLeft (pct (n / 12 * 100)) ]

    else
        empty



-- Justify Content


{-| Puts the content of a row or column at the start.
-}
start : Device -> Grid -> GridBuilder { a | grid : Never }
start =
    styles
        [ justifyContent flexStart
        , textAlign Css.start
        ]


{-| Puts the content of a row or column at the end.
-}
end : Device -> Grid -> GridBuilder { a | grid : Never }
end =
    styles
        [ justifyContent flexEnd
        , textAlign Css.end
        ]


{-| Centers a row or column.
-}
center : Device -> Grid -> GridBuilder { a | grid : Never }
center =
    styles
        [ justifyContent Css.center
        , textAlign Css.center
        ]


{-| Only pad spacing between items in a row.
-}
between : Device -> Grid -> GridBuilder { a | grid : Never, col : Never }
between =
    styles [ justifyContent spaceBetween ]


{-| Pad spacing around items in a row, with space on the left and right hand sides.
-}
around : Device -> Grid -> GridBuilder { a | grid : Never, col : Never }
around =
    styles [ justifyContent spaceAround ]



-- Direction


{-| Reverses the order of items in a column or row.
-}
reverse : Device -> Grid -> GridBuilder { a | grid : Never }
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
top : Device -> Grid -> GridBuilder { a | grid : Never, column : Never }
top =
    styles [ alignItems flexStart ]


{-| Aligns items in the middle of a row.
-}
middle : Device -> Grid -> GridBuilder { a | grid : Never, column : Never }
middle =
    styles [ alignItems Css.center ]


{-| Aligns items at the bottom of a row.
-}
bottom : Device -> Grid -> GridBuilder { a | grid : Never, column : Never }
bottom =
    styles [ alignItems flexEnd ]


{-| Stretches items to fill the row height-wise.
-}
stretch : Device -> Grid -> GridBuilder { a | grid : Never, column : Never }
stretch =
    styles [ alignItems Css.stretch ]


{-| Aligns items so their balines align at the top of a row.
-}
baseline : Device -> Grid -> GridBuilder { a | grid : Never, column : Never }
baseline =
    styles [ alignItems Css.baseline ]



-- Ordering


{-| Orders a row or column so it comes first.
-}
first : Device -> Grid -> GridBuilder { a | grid : Never }
first =
    styles [ order (num -1) ]


{-| Orders a row or column so it comes last.
-}
last : Device -> Grid -> GridBuilder { a | grid : Never }
last =
    styles [ order (num 1) ]



-- Helper functions


empty : Device -> Grid -> GridBuilder a
empty =
    \device grd -> Builder device grd (always [])
