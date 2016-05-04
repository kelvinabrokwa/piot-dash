module Main (..) where

import StartApp
import Task
import Effects exposing (Effects, Never)
import Html exposing (Html)
import App exposing (init, updateTemp, view, TempModel)


--- SETUP

app : StartApp.App TempModel
app =
  StartApp.start
    { init = init
    , view = view
    , update = updateTemp
    , inputs = []
    }


main : Signal Html
main =
  app.html


--- PORTS

port tasks : Signal (Task.Task Never ())
port tasks =
  app.tasks
