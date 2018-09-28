module Grid
    exposing
        ( -- Media sizes
          sm
        , md
        , lg
        , xl
          -- Grid constructors
        , grid
        , row
        , col
          -- Grid attributes
        , styles
        , columns
        , auto
        , offset
        , start
        , end
        , center
        , around
        , between
        , reverse
        , top
        , middle
        , bottom
        , first
        , last
        )

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
import Html.Styled exposing (styled, div, Html, Attribute, text)
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


type Compatible
    = Compatible


type Grid
    = Grid
    | Row
    | Column


type Builder a
    = Builder Device Grid (Grid -> List Css.Style)


applyDevice : Device -> List (Device -> Grid -> Builder a) -> List (Grid -> Builder a)
applyDevice device builders =
    List.map (\buildFn -> buildFn device) builders



--sm : List (Grid a -> List Css.Style) -> Builder a
-- where Builder a = Builder Device (Grid a -> List Css.stlye)


sm : List (Device -> Grid -> Builder a) -> List (Grid -> Builder a)
sm builders =
    applyDevice Sm builders


md : List (Device -> Grid -> Builder a) -> List (Grid -> Builder a)
md builders =
    applyDevice Md builders


lg : List (Device -> Grid -> Builder a) -> List (Grid -> Builder a)
lg builders =
    applyDevice Lg builders


xl : List (Device -> Grid -> Builder a) -> List (Grid -> Builder a)
xl builders =
    applyDevice Xl builders


applyDevicesToBuilders buildersList devices =
    deviceStyles devices
        (\base ->
            List.map
                (\(Builder device grid fn) ->
                    if device == base.device then
                        fn grid
                    else
                        []
                )
                buildersList
                |> List.concat
        )


type alias GridT a msg =
    List (List (Grid -> Builder { a | grid : Compatible })) -> List (Attribute msg) -> List (DeviceStyles -> Html msg) -> DeviceStyles -> Html msg


grid : GridT a msg
grid builders attributes innerHtml devices =
    let
        flatBuilders =
            List.concat builders
                |> List.map (\gridFn -> gridFn Column)
    in
        (styled div)
            [ marginRight Css.auto
            , marginLeft Css.auto
            , applyDevicesToBuilders flatBuilders devices
            ]
            []
            (List.map (\deviceStyleFn -> deviceStyleFn devices) innerHtml)


type alias RowT a msg =
    List (List (Grid -> Builder { a | row : Compatible })) -> List (Attribute msg) -> List (DeviceStyles -> Html msg) -> DeviceStyles -> Html msg


row : RowT a msg
row builders attributes innerHtml devices =
    let
        flatBuilders =
            List.concat builders
                |> List.map (\gridFn -> gridFn Column)
    in
        (styled div)
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


col : ColT a msg
col builders attributes innerHtml devices =
    let
        flatBuilders : List (Builder { a | col : Compatible })
        flatBuilders =
            List.concat builders
                |> List.map (\gridFn -> gridFn Column)
    in
        (styled div)
            [ boxSizing borderBox
            , flexShrink (num 0)
            , flexGrow (num 0)
            , applyDevicesToBuilders flatBuilders devices
            ]
            []
            innerHtml


empty : Device -> Grid -> Builder a
empty =
    (\device grid -> Builder device grid (always []))


styles : List Css.Style -> Device -> Grid -> Builder a
styles styles device grid =
    Builder device grid (always styles)



-- Should work differently on column and grid.
-- On grid, sets the number of columns, on column sets width to fraction of columns.


auto =
    columns 0


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


offset : Float -> Device -> Grid -> Builder { a | grid : Never, row : Never }
offset n =
    if n > 0 then
        styles
            [ marginLeft (pct (n / 12 * 100)) ]
    else
        empty


start : Device -> Grid -> Builder { a | grid : Never }
start =
    styles
        [ justifyContent flexStart
        , textAlign Css.start
        ]


end : Device -> Grid -> Builder { a | grid : Never }
end =
    styles
        [ justifyContent flexEnd
        , textAlign Css.end
        ]


center : Device -> Grid -> Builder { a | grid : Never }
center =
    styles
        [ justifyContent Css.center
        , textAlign Css.center
        ]


around : Device -> Grid -> Builder { a | grid : Never, col : Never }
around =
    styles [ justifyContent spaceAround ]


between : Device -> Grid -> Builder { a | grid : Never, col : Never }
between =
    styles [ justifyContent spaceBetween ]


reverse : Device -> Grid -> Builder { a | grid : Never }
reverse device grid =
    Builder device grid <|
        \grid ->
            case grid of
                Row ->
                    [ flexDirection rowReverse ]

                Column ->
                    [ flexDirection columnReverse ]

                _ ->
                    []


top : Device -> Grid -> Builder { a | grid : Never, row : Never }
top =
    styles [ alignItems flexStart ]


middle : Device -> Grid -> Builder { a | grid : Never, row : Never }
middle =
    styles [ alignItems Css.center ]


bottom : Device -> Grid -> Builder { a | grid : Never, row : Never }
bottom =
    styles [ alignItems flexEnd ]


first : Device -> Grid -> Builder { a | grid : Never }
first =
    styles [ order (num -1) ]


last : Device -> Grid -> Builder { a | grid : Never }
last =
    styles [ order (num 1) ]
