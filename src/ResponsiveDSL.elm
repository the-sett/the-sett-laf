module ResponsiveDSL exposing
    ( sm, md, lg, xl
    , styles
    , Builder(..), Compatible(..), ContainerBuilder, DeviceBuilder, ElementBuilder, StyleBuilder, applyDevice, applyDevicesToBuilders, empty
    )

{-|


# Device builders

@docs sm, md, lg, xl


# Inject any CSS styles

@docs styles

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



-- Responsive style builders.


type Compatible
    = Compatible


type Builder a ctx
    = Builder Device ctx (ctx -> List Css.Style)


type alias ContainerBuilder a ctx msg =
    List (List (ctx -> Builder a ctx))
    -> List (Attribute msg)
    -> List (DeviceStyles -> Html msg)
    -> DeviceStyles
    -> Html msg


type alias ElementBuilder a ctx msg =
    List (List (ctx -> Builder a ctx))
    -> List (Attribute msg)
    -> List (Html msg)
    -> DeviceStyles
    -> Html msg


type alias DeviceBuilder a ctx =
    List (Device -> ctx -> Builder a ctx) -> List (ctx -> Builder a ctx)


type alias StyleBuilder a ctx =
    Device -> ctx -> Builder a ctx


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


empty : StyleBuilder a ctx
empty =
    \device ctx -> Builder device ctx (always [])


{-| Small device grid property builder.
-}
sm : DeviceBuilder a ctx
sm builders =
    applyDevice Sm builders


{-| Medium device grid property builder.
-}
md : DeviceBuilder a ctx
md builders =
    applyDevice Md builders


{-| Large device grid property builder.
-}
lg : DeviceBuilder a ctx
lg builders =
    applyDevice Lg builders


{-| Extra large device grid property builder.
-}
xl : DeviceBuilder a ctx
xl builders =
    applyDevice Xl builders
