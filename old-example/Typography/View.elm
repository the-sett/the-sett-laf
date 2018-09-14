module Typography.View exposing (root)

import Html exposing (..)
import Html.Attributes exposing (title, class)
import Typography.Types exposing (..)


root : Model -> Html Msg
root model =
    div [ class "layout-fixed-width" ]
        [ h2 []
            [ text "Typography" ]
        , h1 []
            [ text "Heading 1" ]
        , h2 []
            [ text "Heading 2" ]
        , h3 []
            [ text "Heading 3" ]
        , h4 []
            [ text "Heading 4" ]
        , p []
            [ text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam bibendum, purus vitae porttitor molestie, libero ante laoreet sem, et mattis libero dolor at tortor. Pellentesque et ligula ut ipsum egestas mollis. Fusce nisl lorem, auctor non fringilla          eu, varius vitae leo. Sed congue elit vel mauris vestibulum efficitur. Fusce facilisis risus ac pharetra fringilla. Nam et urna ac ipsum sagittis tempus. Cras et molestie nibh, et lobortis orci. Donec ac metus in nulla vulputate mollis in a arcu. Lorem            ipsum dolor sit amet, consectetur adipiscing elit. Etiam enim leo, dignissim et volutpat ut, pretium ac metus. Proin rhoncus tempus risus, id tristique est tempor quis. Ut dictum varius orci, in venenatis nisi suscipit at." ]
        , p []
            [ text "Donec at purus nulla. Morbi dictum mauris a tortor facilisis iaculis. Aenean purus purus, viverra vitae convallis faucibus, porttitor sed lorem. Phasellus varius, mi sed dignissim consectetur, enim ipsum fringilla mi, nec fringilla odio mauris ut metus.           Sed et sodales magna. Phasellus magna augue, feugiat at erat ut, sollicitudin convallis augue. Nunc at consequat ex. Praesent a leo risus. In sodales, risus vel dignissim cursus, felis orci elementum sapien, eget cursus purus ligula a odio. Etiam tincidunt,           nulla sit amet cursus tempus, nisl quam imperdiet augue, vel finibus odio nibh in arcu. Aenean libero risus, sagittis sit amet luctus id, lobortis nec nunc.        " ]
        , p []
            [ text "Aliquam at lorem gravida, euismod sem a, elementum diam. Vestibulum arcu ante, tincidunt in porta interdum, vehicula vel nisl. Cras semper felis id eros iaculis, quis egestas sem aliquet. Donec venenatis ipsum nec odio lacinia, in placerat mi condimentum.         Praesent elit turpis, iaculis sit amet imperdiet quis, suscipit quis risus. Cras a malesuada nibh. Phasellus eget sapien consequat, rhoncus odio eget, molestie mauris. Duis ut tincidunt dolor. Etiam id egestas sem, id commodo eros. Nunc suscipit nec           velit ac efficitur. Curabitur sed massa lorem. Nulla tincidunt enim ac elit luctus blandit." ]
        , ul []
            [ li []
                [ text "Bullet 1" ]
            , li []
                [ text "Bullet 2" ]
            , li []
                [ text "Bullet 3" ]
            , li []
                [ text "Bullet 4" ]
            ]
        , ol []
            [ li []
                [ text "List 1" ]
            , li []
                [ text "List 2" ]
            , li []
                [ text "List 3" ]
            , li []
                [ text "List 4" ]
            ]
        ]
