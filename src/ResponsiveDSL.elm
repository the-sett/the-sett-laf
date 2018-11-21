module ResponsiveDSL exposing
    ( Compatible(..)
    , Builder(..), ByDeviceBuilder, ContainerBuilder, ConstDeviceBuilder
    , ElementBuilder, StyleBuilder, OuterBuilder, SimpleElementBuilder
    , applyDevicesToBuilders
    )

{-|


# Compatability shadow type for ensuring correct DSL construction.

@docs Compatible


# Builder types.

@docs Builder, ByDeviceBuilder, ContainerBuilder, ConstDeviceBuilder
@docs ElementBuilder, StyleBuilder, OuterBuilder, SimpleElementBuilder


# For applying responsive devices.

@docs applyDevicesToBuilders

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


{-| Builds an outer container of Containers or Elements.
-}
type alias OuterBuilder a ctx msg =
    List (List (ctx -> Builder a ctx))
    -> List (Attribute msg)
    -> List (ctx -> ResponsiveStyle -> Html msg)
    -> ResponsiveStyle
    -> Html msg


{-| Builds a container of Elements.
-}
type alias ContainerBuilder a ctx msg =
    List (List (ctx -> Builder a ctx))
    -> List (Attribute msg)
    -> List (ctx -> ResponsiveStyle -> Html msg)
    -> ctx
    -> ResponsiveStyle
    -> Html msg


{-| Builds an Element with a parent context.
-}
type alias ElementBuilder a ctx msg =
    List (List (ctx -> Builder a ctx))
    -> List (Attribute msg)
    -> List (Html msg)
    -> ctx
    -> ResponsiveStyle
    -> Html msg


{-| Builds an Element without a parent context.
-}
type alias SimpleElementBuilder a ctx msg =
    List (List (ctx -> Builder a ctx))
    -> List (Attribute msg)
    -> List (Html msg)
    -> ResponsiveStyle
    -> Html msg


{-| Builds constant styles explicitly for a responsive Device.
-}
type alias ConstDeviceBuilder a ctx =
    List (Device -> ctx -> Builder a ctx) -> List (ctx -> Builder a ctx)


{-| Build responsive styles by device properties.
-}
type alias ByDeviceBuilder a ctx =
    List (ctx -> Builder a ctx)


{-| Builds a style within a Context.
-}
type alias StyleBuilder a ctx =
    Device -> ctx -> Builder a ctx


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
