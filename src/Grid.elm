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
        , rhythmPx
        )
import ResponsiveDSL
    exposing
        ( Builder(..)
        , Compatible(..)
        , ConstDeviceBuilder
        , ContainerBuilder
        , ElementBuilder
        , StyleBuilder
        , applyDevicesToBuilders
        )
import Styles exposing (lg, md, sm, xl)



{- The grid styling context. -}


type Grid
    = Grid
    | Row
    | Column



-- Grid constructors


{-| The outer builder of a responsive grid.
-}
grid : ContainerBuilder { a | grid : Compatible } Grid msg
grid builders attributes innerHtml responsive =
    let
        flatBuilders =
            List.concat builders
                |> List.map (\gridFn -> gridFn Column)
    in
    styled div
        [ marginRight Css.auto
        , marginLeft Css.auto
        , applyDevicesToBuilders flatBuilders responsive
        ]
        attributes
        (List.map (\deviceStyleFn -> deviceStyleFn responsive) innerHtml)


{-| The row builder for a responsive grid, on which row compatible properties can be defined.
-}
row : ContainerBuilder { a | row : Compatible } Grid msg
row builders attributes innerHtml responsive =
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
        , applyDevicesToBuilders flatBuilders responsive
        ]
        attributes
        (List.map (\deviceStyleFn -> deviceStyleFn responsive) innerHtml)


{-| The column builder for a responsive grid, on which column compatible properties can be defined.
-}
col : ElementBuilder { a | col : Compatible } Grid msg
col builders attributes innerHtml responsive =
    let
        flatBuilders =
            List.concat builders
                |> List.map (\gridFn -> gridFn Column)
    in
    styled div
        [ boxSizing borderBox
        , flexShrink (num 0)
        , flexGrow (num 0)
        , applyDevicesToBuilders flatBuilders responsive
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
columns n device ctx =
    case ctx of
        Column ->
            if n > 0 then
                ConstForDevice device ctx <|
                    always
                        [ flexBasis (pct (n / 12 * 100))
                        , maxWidth (pct (n / 12 * 100))
                        ]

            else
                ConstForDevice device ctx <|
                    always
                        [ flexBasis (pct (n / 12 * 100))
                        , maxWidth (pct 100)
                        , flexGrow (num 1)
                        ]

        Row ->
            ConstForDevice device ctx <| always []

        Grid ->
            ConstForDevice device ctx <| always []


{-| Defines how many column widths a column is offset from the left hand side by.
-}
offset : Float -> StyleBuilder { a | grid : Never, row : Never } Grid
offset n =
    if n > 0 then
        Styles.styles
            [ marginLeft (pct (n / 12 * 100)) ]

    else
        Styles.empty



-- Justify Content


{-| Puts the content of a row or column at the start.
-}
start : StyleBuilder { a | grid : Never } Grid
start =
    Styles.styles
        [ justifyContent flexStart
        , textAlign Css.start
        ]


{-| Puts the content of a row or column at the end.
-}
end : StyleBuilder { a | grid : Never } Grid
end =
    Styles.styles
        [ justifyContent flexEnd
        , textAlign Css.end
        ]


{-| Centers a row or column.
-}
center : StyleBuilder { a | grid : Never } Grid
center =
    Styles.styles
        [ justifyContent Css.center
        , textAlign Css.center
        ]


{-| Only pad spacing between items in a row.
-}
between : StyleBuilder { a | grid : Never, col : Never } Grid
between =
    Styles.styles [ justifyContent spaceBetween ]


{-| Pad spacing around items in a row, with space on the left and right hand sides.
-}
around : StyleBuilder { a | grid : Never, col : Never } Grid
around =
    Styles.styles [ justifyContent spaceAround ]



-- Direction


{-| Reverses the order of items in a column or row.
-}
reverse : StyleBuilder { a | grid : Never } Grid
reverse device grd =
    ConstForDevice device grd <|
        \ctx ->
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
    Styles.styles [ alignItems flexStart ]


{-| Aligns items in the middle of a row.
-}
middle : StyleBuilder { a | grid : Never, column : Never } Grid
middle =
    Styles.styles [ alignItems Css.center ]


{-| Aligns items at the bottom of a row.
-}
bottom : StyleBuilder { a | grid : Never, column : Never } Grid
bottom =
    Styles.styles [ alignItems flexEnd ]


{-| Stretches items to fill the row height-wise.
-}
stretch : StyleBuilder { a | grid : Never, column : Never } Grid
stretch =
    Styles.styles [ alignItems Css.stretch ]


{-| Aligns items so their balines align at the top of a row.
-}
baseline : StyleBuilder { a | grid : Never, column : Never } Grid
baseline =
    Styles.styles [ alignItems Css.baseline ]



-- Ordering


{-| Orders a row or column so it comes first.
-}
first : StyleBuilder { a | grid : Never } Grid
first =
    Styles.styles [ order (num -1) ]


{-| Orders a row or column so it comes last.
-}
last : StyleBuilder { a | grid : Never } Grid
last =
    Styles.styles [ order (num 1) ]
