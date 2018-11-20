module ResponsiveDSL exposing
    ( Compatible(..)
    , Builder(..), ContainerBuilder, DeviceBuilder, ElementBuilder, StyleBuilder
    , styles, empty
    , applyDevice, applyDevicesToBuilders
    )

{-|


# Compatability shadow type for ensuring correct DSL construction.

@docs Compatible


# Builder types.

@docs Builder, ContainerBuilder, DeviceBuilder, ElementBuilder, StyleBuilder


# Injecting CSS styles

@docs styles, empty


# For applying responsive devices.

@docs applyDevice, applyDevicesToBuilders

-}

import Css
import Html.Styled exposing (Attribute, Html, div, styled, text)
import Responsive
    exposing
        ( CommonStyle
        , Device(..)
        , DeviceSpec
        , DeviceStyle
        , ResponsiveStyle
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
    = Builder Device ctx (ctx -> CommonStyle -> DeviceStyle -> List Css.Style)


{-| Builds a container of Elements. This can be styled per device.
-}
type alias ContainerBuilder a ctx msg =
    List (List (ctx -> Builder a ctx))
    -> List (Attribute msg)
    -> List (ResponsiveStyle -> Html msg)
    -> ResponsiveStyle
    -> Html msg


{-| Builds an Element. This can be styled per device.
-}
type alias ElementBuilder a ctx msg =
    List (List (ctx -> Builder a ctx))
    -> List (Attribute msg)
    -> List (Html msg)
    -> ResponsiveStyle
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
    Builder device ctx (always3 styleList)


{-| Applies a responsive device to a list of StyleBuilders.
-}
applyDevice : Device -> List (Device -> ctx -> Builder a ctx) -> List (ctx -> Builder a ctx)
applyDevice device builders =
    List.map (\buildFn -> buildFn device) builders


{-| Applies a set of responsive device specifications to a list of builders, in any context.
-}
applyDevicesToBuilders : List (Builder a ctx) -> ResponsiveStyle -> Css.Style
applyDevicesToBuilders buildersList devices =
    deviceStyles devices
        (\device ->
            List.map
                (\(Builder dev ctx fn) ->
                    if dev == device.device then
                        fn ctx devices.commonStyle device

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
    \device ctx -> Builder device ctx (always3 [])


always3 =
    always >> always >> always
