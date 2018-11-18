module ResponsiveDSL exposing
    ( Compatible(..)
    , Builder(..), ContainerBuilder, DeviceBuilder, ElementBuilder, StyleBuilder
    , sm, md, lg, xl
    , styles, empty
    , applyDevice, applyDevicesToBuilders
    )

{-|


# Compatability shadow type for ensuring correct DSL construction.

@docs Compatible


# Builder types.

@docs Builder, ContainerBuilder, DeviceBuilder, ElementBuilder, StyleBuilder


# Device builders

@docs sm, md, lg, xl


# Injecting CSS styles

@docs styles, empty


# For applying responsive devices.

@docs applyDevice, applyDevicesToBuilders

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


{-| Used as a shadow type to ensure correct DSL construction.
-}
type Compatible
    = Compatible


{-| A builder for a device in a DSL context.
-}
type Builder a ctx
    = Builder Device ctx (ctx -> BaseStyle -> List Css.Style)


{-| Builds a container of Elements. This can be styled per device.
-}
type alias ContainerBuilder a ctx msg =
    List (List (ctx -> Builder a ctx))
    -> List (Attribute msg)
    -> List (DeviceStyles -> Html msg)
    -> DeviceStyles
    -> Html msg


{-| Builds an Element. This can be styled per device.
-}
type alias ElementBuilder a ctx msg =
    List (List (ctx -> Builder a ctx))
    -> List (Attribute msg)
    -> List (Html msg)
    -> DeviceStyles
    -> Html msg


{-| Builds styles per responsive Device.
-}
type alias DeviceBuilder a ctx =
    List (Device -> ctx -> Builder a ctx) -> List (ctx -> Builder a ctx)


{-| Builds a style within a Context.
-}
type alias StyleBuilder a ctx =
    Device -> ctx -> Builder a ctx


{-| Adds any CSS style you like to a grid element.
-}
styles : List Css.Style -> Device -> ctx -> Builder a ctx
styles styleList device ctx =
    Builder device ctx (always2 styleList)


{-| Applies a responsive device to a list of StyleBuilders.
-}
applyDevice : Device -> List (Device -> ctx -> Builder a ctx) -> List (ctx -> Builder a ctx)
applyDevice device builders =
    List.map (\buildFn -> buildFn device) builders


{-| Applies a set of responsive device specifications to a list of builders, in any context.
-}
applyDevicesToBuilders : List (Builder a ctx) -> DeviceStyles -> Css.Style
applyDevicesToBuilders buildersList devices =
    deviceStyles devices
        (\baseStyle ->
            List.map
                (\(Builder device grd fn) ->
                    if device == baseStyle.device then
                        fn grd baseStyle

                    else
                        []
                )
                buildersList
                |> List.concat
        )


{-| An empty style, for convenience when sketching out DSLs.
-}
empty : StyleBuilder a ctx
empty =
    \device ctx -> Builder device ctx (always2 [])


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


always2 =
    always >> always
