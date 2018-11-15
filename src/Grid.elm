module Grid exposing
    ( grid, row, col
    , auto, columns, offset
    , start, end, center, between, around
    , top, middle, bottom, stretch, baseline
    , first, last, reverse
    )

{-| Responsive grids based on flexbox. This module provides a DSL for building
such grids.


# Grid constructors

@docs grid, row, col


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
import ResponsiveDSL
    exposing
        ( Builder(..)
        , Compatible(..)
        , ContainerBuilder
        , DeviceBuilder
        , ElementBuilder
        , StyleBuilder
        , applyDevice
        , applyDevicesToBuilders
        , empty
        , lg
        , md
        , sm
        , styles
        , xl
        )



{- The grid styling context. -}


type Grid
    = Grid
    | Row
    | Column



-- Grid constructors


{-| The outer builder of a responsive grid.
-}
grid : ContainerBuilder { a | grid : Compatible } Grid msg
grid builders attributes innerHtml devices =
    let
        flatBuilders =
            List.concat builders
                |> List.map (\gridFn -> gridFn Column)
    in
    styled div
        [ Css.marginRight Css.auto
        , Css.marginLeft Css.auto
        , applyDevicesToBuilders flatBuilders devices
        ]
        attributes
        (List.map (\deviceStyleFn -> deviceStyleFn devices) innerHtml)


{-| The row builder for a responsive grid, on which row compatible properties can be defined.
-}
row : ContainerBuilder { a | row : Compatible } Grid msg
row builders attributes innerHtml devices =
    let
        flatBuilders =
            List.concat builders
                |> List.map (\gridFn -> gridFn Column)
    in
    styled div
        [ Css.boxSizing Css.borderBox
        , Css.displayFlex
        , Css.property "flex" "0 1 auto"
        , Css.flexDirection Css.row
        , Css.flexWrap Css.wrap
        , applyDevicesToBuilders flatBuilders devices
        ]
        attributes
        (List.map (\deviceStyleFn -> deviceStyleFn devices) innerHtml)


{-| The column builder for a responsive grid, on which column compatible properties can be defined.
-}
col : ElementBuilder { a | col : Compatible } Grid msg
col builders attributes innerHtml devices =
    let
        flatBuilders =
            List.concat builders
                |> List.map (\gridFn -> gridFn Column)
    in
    styled div
        [ Css.boxSizing Css.borderBox
        , Css.flexShrink (Css.num 0)
        , Css.flexGrow (Css.num 0)
        , applyDevicesToBuilders flatBuilders devices
        ]
        attributes
        innerHtml



--- Column size and offset


{-| Auto column width means that a column expands to fill the available width.
-}
auto : StyleBuilder { a | row : Never } Grid
auto =
    columns 0


{-| Defines how many column widths a column will take up. Zero means use 'auto'
width and expand to fill available space.

When applied to a row or grid, this sets the total number of columns available.
When applied to a column, this sets the number of columns taken up out of the
total available.

-}
columns : Float -> StyleBuilder { a | row : Never } Grid
columns n =
    if n > 0 then
        styles
            [ Css.flexBasis (Css.pct (n / 12 * 100))
            , Css.maxWidth (Css.pct (n / 12 * 100))
            ]

    else
        styles
            [ Css.flexBasis (Css.pct (n / 12 * 100))
            , Css.maxWidth (Css.pct 100)
            , Css.flexGrow (Css.num 1)
            ]


{-| Defines how many column widths a column is offset from the left hand side by.
-}
offset : Float -> StyleBuilder { a | grid : Never, row : Never } Grid
offset n =
    if n > 0 then
        styles
            [ Css.marginLeft (Css.pct (n / 12 * 100)) ]

    else
        empty



-- Justify Content


{-| Puts the content of a row or column at the start.
-}
start : StyleBuilder { a | grid : Never } Grid
start =
    styles
        [ Css.justifyContent Css.flexStart
        , Css.textAlign Css.start
        ]


{-| Puts the content of a row or column at the end.
-}
end : StyleBuilder { a | grid : Never } Grid
end =
    styles
        [ Css.justifyContent Css.flexEnd
        , Css.textAlign Css.end
        ]


{-| Centers a row or column.
-}
center : StyleBuilder { a | grid : Never } Grid
center =
    styles
        [ Css.justifyContent Css.center
        , Css.textAlign Css.center
        ]


{-| Only pad spacing between items in a row.
-}
between : StyleBuilder { a | grid : Never, col : Never } Grid
between =
    styles [ Css.justifyContent Css.spaceBetween ]


{-| Pad spacing around items in a row, with space on the left and right hand sides.
-}
around : StyleBuilder { a | grid : Never, col : Never } Grid
around =
    styles [ Css.justifyContent Css.spaceAround ]



-- Direction


{-| Reverses the order of items in a column or row.
-}
reverse : StyleBuilder { a | grid : Never } Grid
reverse device grd =
    Builder device grd <|
        \ctx _ ->
            case ctx of
                Row ->
                    [ Css.flexDirection Css.rowReverse ]

                Column ->
                    [ Css.flexDirection Css.columnReverse ]

                _ ->
                    []



-- Align Items


{-| Aligns items at the top of a row.
-}
top : StyleBuilder { a | grid : Never, column : Never } Grid
top =
    styles [ Css.alignItems Css.flexStart ]


{-| Aligns items in the middle of a row.
-}
middle : StyleBuilder { a | grid : Never, column : Never } Grid
middle =
    styles [ Css.alignItems Css.center ]


{-| Aligns items at the bottom of a row.
-}
bottom : StyleBuilder { a | grid : Never, column : Never } Grid
bottom =
    styles [ Css.alignItems Css.flexEnd ]


{-| Stretches items to fill the row height-wise.
-}
stretch : StyleBuilder { a | grid : Never, column : Never } Grid
stretch =
    styles [ Css.alignItems Css.stretch ]


{-| Aligns items so their balines align at the top of a row.
-}
baseline : StyleBuilder { a | grid : Never, column : Never } Grid
baseline =
    styles [ Css.alignItems Css.baseline ]



-- Ordering


{-| Orders a row or column so it comes first.
-}
first : StyleBuilder { a | grid : Never } Grid
first =
    styles [ Css.order (Css.num -1) ]


{-| Orders a row or column so it comes last.
-}
last : StyleBuilder { a | grid : Never } Grid
last =
    styles [ Css.order (Css.num 1) ]
