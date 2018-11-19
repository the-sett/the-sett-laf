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
        ( Device(..)
        , DeviceSpec
        , DeviceStyle
        , ResponsiveStyle
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
        [ marginRight Css.auto
        , marginLeft Css.auto
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
col : ElementBuilder { a | col : Compatible } Grid msg
col builders attributes innerHtml devices =
    let
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
offset : Float -> StyleBuilder { a | grid : Never, row : Never } Grid
offset n =
    if n > 0 then
        styles
            [ marginLeft (pct (n / 12 * 100)) ]

    else
        empty



-- Justify Content


{-| Puts the content of a row or column at the start.
-}
start : StyleBuilder { a | grid : Never } Grid
start =
    styles
        [ justifyContent flexStart
        , textAlign Css.start
        ]


{-| Puts the content of a row or column at the end.
-}
end : StyleBuilder { a | grid : Never } Grid
end =
    styles
        [ justifyContent flexEnd
        , textAlign Css.end
        ]


{-| Centers a row or column.
-}
center : StyleBuilder { a | grid : Never } Grid
center =
    styles
        [ justifyContent Css.center
        , textAlign Css.center
        ]


{-| Only pad spacing between items in a row.
-}
between : StyleBuilder { a | grid : Never, col : Never } Grid
between =
    styles [ justifyContent spaceBetween ]


{-| Pad spacing around items in a row, with space on the left and right hand sides.
-}
around : StyleBuilder { a | grid : Never, col : Never } Grid
around =
    styles [ justifyContent spaceAround ]



-- Direction


{-| Reverses the order of items in a column or row.
-}
reverse : StyleBuilder { a | grid : Never } Grid
reverse device grd =
    Builder device grd <|
        \ctx _ _ ->
            case ctx of
                Row ->
                    [ flexDirection rowReverse ]

                Column ->
                    [ flexDirection columnReverse ]

                _ ->
                    []



-- Align Items


{-| Aligns items at the top of a row.
-}
top : StyleBuilder { a | grid : Never, column : Never } Grid
top =
    styles [ alignItems flexStart ]


{-| Aligns items in the middle of a row.
-}
middle : StyleBuilder { a | grid : Never, column : Never } Grid
middle =
    styles [ alignItems Css.center ]


{-| Aligns items at the bottom of a row.
-}
bottom : StyleBuilder { a | grid : Never, column : Never } Grid
bottom =
    styles [ alignItems flexEnd ]


{-| Stretches items to fill the row height-wise.
-}
stretch : StyleBuilder { a | grid : Never, column : Never } Grid
stretch =
    styles [ alignItems Css.stretch ]


{-| Aligns items so their balines align at the top of a row.
-}
baseline : StyleBuilder { a | grid : Never, column : Never } Grid
baseline =
    styles [ alignItems Css.baseline ]



-- Ordering


{-| Orders a row or column so it comes first.
-}
first : StyleBuilder { a | grid : Never } Grid
first =
    styles [ order (num -1) ]


{-| Orders a row or column so it comes last.
-}
last : StyleBuilder { a | grid : Never } Grid
last =
    styles [ order (num 1) ]
