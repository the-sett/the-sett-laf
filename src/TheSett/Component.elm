module TheSett.Component exposing
    ( Index
    , Indexed
    , Msg(..)
    , generalise
    , indexAsId
    , indexed
    , react
    , react1
    , render
    , render1
    , subs
    )

import Dict exposing (Dict)


type Msg textfield
    = TextfieldMsg Index textfield


type alias Index =
    List Int


indexAsId index =
    List.map String.fromInt index
        |> String.join "-"


type alias Indexed x =
    Dict Index x


indexed :
    (store -> Indexed model)
    -> (Indexed model -> store -> store)
    -> model
    -> ( Index -> store -> model, Index -> store -> model -> store )
indexed get_model set_model model0 =
    let
        get_ idx store =
            get_model store
                |> Dict.get idx
                |> Maybe.withDefault model0

        set_ idx store model =
            set_model (Dict.insert idx model (get_model store)) store
    in
    ( get_, set_ )


render1 :
    (store -> model)
    -> ((msg -> m) -> model -> x)
    -> (msg -> mdlmsg)
    -> (mdlmsg -> m)
    -> store
    -> x
render1 get_model view ctor =
    \lift store ->
        view (ctor >> lift) (get_model store)


render :
    (Index -> store -> model)
    -> ((msg -> m) -> model -> x)
    -> (Index -> msg -> mdlmsg)
    -> (mdlmsg -> m)
    -> Index
    -> store
    -> x
render get_model view ctor =
    \lift idx store ->
        view (ctor idx >> lift) (get_model idx store)


type alias Update msg m model =
    (msg -> m) -> msg -> model -> ( Maybe model, Cmd m )


react1 :
    (store -> model)
    -> (store -> model -> store)
    -> (msg -> mdlmsg)
    -> Update msg m model
    -> (mdlmsg -> m)
    -> msg
    -> store
    -> ( Maybe store, Cmd m )
react1 get set ctor update lift msg store =
    update (ctor >> lift) msg (get store)
        |> Tuple.mapFirst (Maybe.map (set store))


react :
    (Index -> store -> model)
    -> (Index -> store -> model -> store)
    -> (Index -> msg -> mdlmsg)
    -> Update msg m model
    -> (mdlmsg -> m)
    -> msg
    -> Index
    -> store
    -> ( Maybe store, Cmd m )
react get set ctor update lift msg idx store =
    update (ctor idx >> lift) msg (get idx store)
        |> Tuple.mapFirst (Maybe.map (set idx store))


generalise :
    (msg -> model -> ( model, Cmd msg ))
    -> Update msg m model
generalise update lift msg model =
    update msg model
        |> Tuple.mapFirst Just
        |> Tuple.mapSecond (Cmd.map lift)


subs :
    (Index -> msg -> mdlmsg)
    -> (store -> Indexed model)
    -> (model -> Sub msg)
    -> (mdlmsg -> m)
    -> store
    -> Sub m
subs ctor get subscriptions lift model =
    model
        |> get
        |> Dict.foldl
            (\idx innerModel ss ->
                Sub.map (ctor idx >> lift) (subscriptions innerModel) :: ss
            )
            []
        |> Sub.batch
