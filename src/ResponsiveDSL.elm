module ResponsiveDSL exposing
    ( Compatible(..)
    , Builder(..), ContainerBuilder, DeviceBuilder, ElementBuilder, StyleBuilder
    , applyDevice, applyDevicesToBuilders
    )

{-|


# Compatability shadow type for ensuring correct DSL construction.

@docs Compatible


# Builder types.

@docs Builder, ContainerBuilder, DeviceBuilder, ElementBuilder, StyleBuilder


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
        , ResponsiveFn
        , ResponsiveStyle
        , deviceStyle
        , deviceStyles
        , rhythmPx
        )



-- Responsive style builders.


{-| Used as a shadow type to ensure correct DSL construction.
-}
type Compatible
    = Compatible


{-| A builder for a device in a DSL context.
-}
type Builder a ctx
    = ConstForDevice Device ctx (ctx -> List Css.Style)
    | ByDeviceProps ctx (ctx -> ResponsiveFn (List Css.Style))


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


{-| Applies a responsive device to a list of StyleBuilders.
-}
applyDevice : Device -> List (Device -> ctx -> Builder a ctx) -> List (ctx -> Builder a ctx)
applyDevice device builders =
    List.map (\buildFn -> buildFn device) builders


{-| Applies a set of responsive device specifications to a list of builders, in any context.
-}
applyDevicesToBuilders : List (Builder a ctx) -> ResponsiveStyle -> Css.Style
applyDevicesToBuilders buildersList responsive =
    deviceStyles responsive
        (\common device ->
            List.map
                (\builder ->
                    case builder of
                        ConstForDevice dev ctx fn ->
                            if dev == device.device then
                                fn ctx

                            else
                                []

                        ByDeviceProps ctx fn ->
                            fn ctx common device
                )
                buildersList
                |> List.concat
        )
