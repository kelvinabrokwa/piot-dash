module App (..) where

import Signal exposing (..)
import Html exposing (..)
import Html.Events exposing (onClick)
import Effects exposing (Effects, Never)
import Http
import Json.Decode as Json exposing ((:=))
import Task


-- MODEL

type alias TempModel =
  { temp : Float,
    time : String
  }

init : ( TempModel, Effects Action )
init =
  ( { temp = 0,
      time = "0:0:0"
    }
  , Effects.none
  )


--- UPDATE

type Action
  = DoNothing
  | RequestTemp
  | UpdateTemp (Maybe Float)

updateTemp : Action -> TempModel -> ( TempModel, Effects Action )
updateTemp action model =
  case action of
    DoNothing ->
      ( model, Effects.none )

    RequestTemp ->
      ( model, requestTemp )

    UpdateTemp temp ->
      ( { model | temp = (Maybe.withDefault 0.0 temp) }
      , Effects.none
      )


-- VIEW

view : Address Action -> TempModel -> Html
view address model =
  div
    []
    [ button [ onClick address RequestTemp ] [ text "Get temperature" ]
    , div [] [ text ("Temperature: " ++ (toString model.temp)) ]
    , div [] [ text ("Time: ") ]
    ]


--- Effects

requestTemp : Effects Action
requestTemp =
  Http.get ("temp" := Json.float) "http://localhost:8080/temp"
    |> Effects.none
  --Http.get (Json.object2 (,) ("temp" := Json.float) ("time" := Json.string)) "http://localhost:8080/temp"
    --|> Task.toMaybe
    --|> Task.map UpdateTemp
    --|> Effects.task
