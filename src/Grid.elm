module Grid exposing (..)

import Maybe.Extra
import Css exposing (..)
import Html.Styled exposing (styled, div, Html, Attribute)
import Responsive exposing (Device(..), DeviceSpec, DeviceStyles, BaseStyle, rhythm, deviceStyle, deviceStyles)


type alias Size =
    { device : Device
    , columns : Int
    }


sm n =
    { device = Sm
    , columns = n
    }


md n =
    { device = Md
    , columns = n
    }


lg n =
    { device = Lg
    , columns = n
    }


xl n =
    { device = Xl
    , columns = n
    }


type alias SizeSpec =
    DeviceSpec (Maybe Size)


toSizeSpec : List Size -> SizeSpec
toSizeSpec sizes =
    List.foldl
        (\size accum ->
            case size.device of
                Sm ->
                    { accum | mobile = Just size }

                Md ->
                    { accum | tablet = Just size }

                Lg ->
                    { accum | desktop = Just size }

                Xl ->
                    { accum | desktopWide = Just size }
        )
        { mobile = Nothing, tablet = Nothing, desktop = Nothing, desktopWide = Nothing }
        sizes


mapSizeSpec : (Size -> b) -> SizeSpec -> List b
mapSizeSpec fn spec =
    [ Maybe.map fn spec.mobile
    , Maybe.map fn spec.tablet
    , Maybe.map fn spec.desktop
    , Maybe.map fn spec.desktopWide
    ]
        |> Maybe.Extra.values


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


reserveRow =
    [ flexDirection rowReverse
    ]


reverseCol =
    [ flexDirection columnReverse ]


col : DeviceStyles -> List Size -> List (Attribute msg) -> List (Html msg) -> Html msg
col devices sizes =
    let
        n =
            1

        sizeSpec =
            toSizeSpec sizes

        style devices =
            deviceStyles devices <|
                \deviceProps ->
                    mapSizeSpec
                        (\size ->
                            (if deviceProps.device == size.device then
                                if size.columns == 0 then
                                    [ flexBasis (pct ((toFloat size.columns) / 12 * 100))
                                    , maxWidth (pct 100)
                                    , flexGrow (num 1)
                                    ]
                                else
                                    [ flexBasis (pct ((toFloat size.columns) / 12 * 100))
                                    , maxWidth (pct ((toFloat size.columns) / 12 * 100))
                                    ]
                             else
                                []
                            )
                                |> Css.batch
                        )
                        sizeSpec
    in
        styled div
            [ boxSizing borderBox
            , flexShrink (num 0)
            , flexGrow (num 0)
            , style devices
            ]


offset colOffset =
    [ marginLeft (pct (colOffset / 12 * 100)) ]


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


top =
    [ alignItems flexStart ]


middle =
    [ alignItems Css.center ]


bottomXs =
    [ alignItems flexEnd ]


aroundXs =
    [ justifyContent spaceAround
    ]


betweenXs =
    [ justifyContent spaceBetween ]


firstXs =
    [ order (num -1) ]


lastXs =
    [ order (num 1) ]



--
-- @media (--sm-viewport) {
--   .container {
--     width: var(--container-sm, 46rem);
--   }
--
--   .col-sm,
--   .col-sm-1,
--   .col-sm-2,
--   .col-sm-3,
--   .col-sm-4,
--   .col-sm-5,
--   .col-sm-6,
--   .col-sm-7,
--   .col-sm-8,
--   .col-sm-9,
--   .col-sm-10,
--   .col-sm-11,
--   .col-sm-12,
--   .col-sm-offset-0,
--   .col-sm-offset-1,
--   .col-sm-offset-2,
--   .col-sm-offset-3,
--   .col-sm-offset-4,
--   .col-sm-offset-5,
--   .col-sm-offset-6,
--   .col-sm-offset-7,
--   .col-sm-offset-8,
--   .col-sm-offset-9,
--   .col-sm-offset-10,
--   .col-sm-offset-11,
--   .col-sm-offset-12 {
--     box-sizing: border-box;
--     flex: 0 0 auto;
--     padding-right: var(--half-gutter-width, 0.5rem);
--     padding-left: var(--half-gutter-width, 0.5rem);
--   }
--
--   .col-sm {
--     flex-grow: 1;
--     flex-basis: 0;
--     max-width: 100%;
--   }
--
--   .col-sm-1 {
--     flex-basis: 8.33333333%;
--     max-width: 8.33333333%;
--   }
--
--   .col-sm-2 {
--     flex-basis: 16.66666667%;
--     max-width: 16.66666667%;
--   }
--
--   .col-sm-3 {
--     flex-basis: 25%;
--     max-width: 25%;
--   }
--
--   .col-sm-4 {
--     flex-basis: 33.33333333%;
--     max-width: 33.33333333%;
--   }
--
--   .col-sm-5 {
--     flex-basis: 41.66666667%;
--     max-width: 41.66666667%;
--   }
--
--   .col-sm-6 {
--     flex-basis: 50%;
--     max-width: 50%;
--   }
--
--   .col-sm-7 {
--     flex-basis: 58.33333333%;
--     max-width: 58.33333333%;
--   }
--
--   .col-sm-8 {
--     flex-basis: 66.66666667%;
--     max-width: 66.66666667%;
--   }
--
--   .col-sm-9 {
--     flex-basis: 75%;
--     max-width: 75%;
--   }
--
--   .col-sm-10 {
--     flex-basis: 83.33333333%;
--     max-width: 83.33333333%;
--   }
--
--   .col-sm-11 {
--     flex-basis: 91.66666667%;
--     max-width: 91.66666667%;
--   }
--
--   .col-sm-12 {
--     flex-basis: 100%;
--     max-width: 100%;
--   }
--
--   .col-sm-offset-0 {
--     margin-left: 0;
--   }
--
--   .col-sm-offset-1 {
--     margin-left: 8.33333333%;
--   }
--
--   .col-sm-offset-2 {
--     margin-left: 16.66666667%;
--   }
--
--   .col-sm-offset-3 {
--     margin-left: 25%;
--   }
--
--   .col-sm-offset-4 {
--     margin-left: 33.33333333%;
--   }
--
--   .col-sm-offset-5 {
--     margin-left: 41.66666667%;
--   }
--
--   .col-sm-offset-6 {
--     margin-left: 50%;
--   }
--
--   .col-sm-offset-7 {
--     margin-left: 58.33333333%;
--   }
--
--   .col-sm-offset-8 {
--     margin-left: 66.66666667%;
--   }
--
--   .col-sm-offset-9 {
--     margin-left: 75%;
--   }
--
--   .col-sm-offset-10 {
--     margin-left: 83.33333333%;
--   }
--
--   .col-sm-offset-11 {
--     margin-left: 91.66666667%;
--   }
--
--   .start-sm {
--     justify-content: flex-start;
--     text-align: start;
--   }
--
--   .center-sm {
--     justify-content: center;
--     text-align: center;
--   }
--
--   .end-sm {
--     justify-content: flex-end;
--     text-align: end;
--   }
--
--   .top-sm {
--     align-items: flex-start;
--   }
--
--   .middle-sm {
--     align-items: center;
--   }
--
--   .bottom-sm {
--     align-items: flex-end;
--   }
--
--   .around-sm {
--     justify-content: space-around;
--   }
--
--   .between-sm {
--     justify-content: space-between;
--   }
--
--   .first-sm {
--     order: -1;
--   }
--
--   .last-sm {
--     order: 1;
--   }
-- }
--
-- @media (--md-viewport) {
--   .container {
--     width: var(--container-md, 61rem);
--   }
--
--   .col-md,
--   .col-md-1,
--   .col-md-2,
--   .col-md-3,
--   .col-md-4,
--   .col-md-5,
--   .col-md-6,
--   .col-md-7,
--   .col-md-8,
--   .col-md-9,
--   .col-md-10,
--   .col-md-11,
--   .col-md-12,
--   .col-md-offset-0,
--   .col-md-offset-1,
--   .col-md-offset-2,
--   .col-md-offset-3,
--   .col-md-offset-4,
--   .col-md-offset-5,
--   .col-md-offset-6,
--   .col-md-offset-7,
--   .col-md-offset-8,
--   .col-md-offset-9,
--   .col-md-offset-10,
--   .col-md-offset-11,
--   .col-md-offset-12 {
--     box-sizing: border-box;
--     flex: 0 0 auto;
--     padding-right: var(--half-gutter-width, 0.5rem);
--     padding-left: var(--half-gutter-width, 0.5rem);
--   }
--
--   .col-md {
--     flex-grow: 1;
--     flex-basis: 0;
--     max-width: 100%;
--   }
--
--   .col-md-1 {
--     flex-basis: 8.33333333%;
--     max-width: 8.33333333%;
--   }
--
--   .col-md-2 {
--     flex-basis: 16.66666667%;
--     max-width: 16.66666667%;
--   }
--
--   .col-md-3 {
--     flex-basis: 25%;
--     max-width: 25%;
--   }
--
--   .col-md-4 {
--     flex-basis: 33.33333333%;
--     max-width: 33.33333333%;
--   }
--
--   .col-md-5 {
--     flex-basis: 41.66666667%;
--     max-width: 41.66666667%;
--   }
--
--   .col-md-6 {
--     flex-basis: 50%;
--     max-width: 50%;
--   }
--
--   .col-md-7 {
--     flex-basis: 58.33333333%;
--     max-width: 58.33333333%;
--   }
--
--   .col-md-8 {
--     flex-basis: 66.66666667%;
--     max-width: 66.66666667%;
--   }
--
--   .col-md-9 {
--     flex-basis: 75%;
--     max-width: 75%;
--   }
--
--   .col-md-10 {
--     flex-basis: 83.33333333%;
--     max-width: 83.33333333%;
--   }
--
--   .col-md-11 {
--     flex-basis: 91.66666667%;
--     max-width: 91.66666667%;
--   }
--
--   .col-md-12 {
--     flex-basis: 100%;
--     max-width: 100%;
--   }
--
--   .col-md-offset-0 {
--     margin-left: 0;
--   }
--
--   .col-md-offset-1 {
--     margin-left: 8.33333333%;
--   }
--
--   .col-md-offset-2 {
--     margin-left: 16.66666667%;
--   }
--
--   .col-md-offset-3 {
--     margin-left: 25%;
--   }
--
--   .col-md-offset-4 {
--     margin-left: 33.33333333%;
--   }
--
--   .col-md-offset-5 {
--     margin-left: 41.66666667%;
--   }
--
--   .col-md-offset-6 {
--     margin-left: 50%;
--   }
--
--   .col-md-offset-7 {
--     margin-left: 58.33333333%;
--   }
--
--   .col-md-offset-8 {
--     margin-left: 66.66666667%;
--   }
--
--   .col-md-offset-9 {
--     margin-left: 75%;
--   }
--
--   .col-md-offset-10 {
--     margin-left: 83.33333333%;
--   }
--
--   .col-md-offset-11 {
--     margin-left: 91.66666667%;
--   }
--
--   .start-md {
--     justify-content: flex-start;
--     text-align: start;
--   }
--
--   .center-md {
--     justify-content: center;
--     text-align: center;
--   }
--
--   .end-md {
--     justify-content: flex-end;
--     text-align: end;
--   }
--
--   .top-md {
--     align-items: flex-start;
--   }
--
--   .middle-md {
--     align-items: center;
--   }
--
--   .bottom-md {
--     align-items: flex-end;
--   }
--
--   .around-md {
--     justify-content: space-around;
--   }
--
--   .between-md {
--     justify-content: space-between;
--   }
--
--   .first-md {
--     order: -1;
--   }
--
--   .last-md {
--     order: 1;
--   }
-- }
--
-- @media (--lg-viewport) {
--   .container {
--     width: var(--container-lg, 71rem);
--   }
--
--   .col-lg,
--   .col-lg-1,
--   .col-lg-2,
--   .col-lg-3,
--   .col-lg-4,
--   .col-lg-5,
--   .col-lg-6,
--   .col-lg-7,
--   .col-lg-8,
--   .col-lg-9,
--   .col-lg-10,
--   .col-lg-11,
--   .col-lg-12,
--   .col-lg-offset-0,
--   .col-lg-offset-1,
--   .col-lg-offset-2,
--   .col-lg-offset-3,
--   .col-lg-offset-4,
--   .col-lg-offset-5,
--   .col-lg-offset-6,
--   .col-lg-offset-7,
--   .col-lg-offset-8,
--   .col-lg-offset-9,
--   .col-lg-offset-10,
--   .col-lg-offset-11,
--   .col-lg-offset-12 {
--     box-sizing: border-box;
--     flex: 0 0 auto;
--     padding-right: var(--half-gutter-width, 0.5rem);
--     padding-left: var(--half-gutter-width, 0.5rem);
--   }
--
--   .col-lg {
--     flex-grow: 1;
--     flex-basis: 0;
--     max-width: 100%;
--   }
--
--   .col-lg-1 {
--     flex-basis: 8.33333333%;
--     max-width: 8.33333333%;
--   }
--
--   .col-lg-2 {
--     flex-basis: 16.66666667%;
--     max-width: 16.66666667%;
--   }
--
--   .col-lg-3 {
--     flex-basis: 25%;
--     max-width: 25%;
--   }
--
--   .col-lg-4 {
--     flex-basis: 33.33333333%;
--     max-width: 33.33333333%;
--   }
--
--   .col-lg-5 {
--     flex-basis: 41.66666667%;
--     max-width: 41.66666667%;
--   }
--
--   .col-lg-6 {
--     flex-basis: 50%;
--     max-width: 50%;
--   }
--
--   .col-lg-7 {
--     flex-basis: 58.33333333%;
--     max-width: 58.33333333%;
--   }
--
--   .col-lg-8 {
--     flex-basis: 66.66666667%;
--     max-width: 66.66666667%;
--   }
--
--   .col-lg-9 {
--     flex-basis: 75%;
--     max-width: 75%;
--   }
--
--   .col-lg-10 {
--     flex-basis: 83.33333333%;
--     max-width: 83.33333333%;
--   }
--
--   .col-lg-11 {
--     flex-basis: 91.66666667%;
--     max-width: 91.66666667%;
--   }
--
--   .col-lg-12 {
--     flex-basis: 100%;
--     max-width: 100%;
--   }
--
--   .col-lg-offset-0 {
--     margin-left: 0;
--   }
--
--   .col-lg-offset-1 {
--     margin-left: 8.33333333%;
--   }
--
--   .col-lg-offset-2 {
--     margin-left: 16.66666667%;
--   }
--
--   .col-lg-offset-3 {
--     margin-left: 25%;
--   }
--
--   .col-lg-offset-4 {
--     margin-left: 33.33333333%;
--   }
--
--   .col-lg-offset-5 {
--     margin-left: 41.66666667%;
--   }
--
--   .col-lg-offset-6 {
--     margin-left: 50%;
--   }
--
--   .col-lg-offset-7 {
--     margin-left: 58.33333333%;
--   }
--
--   .col-lg-offset-8 {
--     margin-left: 66.66666667%;
--   }
--
--   .col-lg-offset-9 {
--     margin-left: 75%;
--   }
--
--   .col-lg-offset-10 {
--     margin-left: 83.33333333%;
--   }
--
--   .col-lg-offset-11 {
--     margin-left: 91.66666667%;
--   }
--
--   .start-lg {
--     justify-content: flex-start;
--     text-align: start;
--   }
--
--   .center-lg {
--     justify-content: center;
--     text-align: center;
--   }
--
--   .end-lg {
--     justify-content: flex-end;
--     text-align: end;
--   }
--
--   .top-lg {
--     align-items: flex-start;
--   }
--
--   .middle-lg {
--     align-items: center;
--   }
--
--   .bottom-lg {
--     align-items: flex-end;
--   }
--
--   .around-lg {
--     justify-content: space-around;
--   }
--
--   .between-lg {
--     justify-content: space-between;
--   }
--
--   .first-lg {
--     order: -1;
--   }
--
--   .last-lg {
--     order: 1;
--   }
-- }
