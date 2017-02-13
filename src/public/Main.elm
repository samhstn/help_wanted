module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode
import String

main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }

type alias Model = {
  repos : List Entry
}

type alias Entry = String

init : ( Model, Cmd Msg )
init =
    ( { repos = []
      }
    , Cmd.none
    )

type Msg
    = HandleRepos
    | GetRepos (Result Http.Error String)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
      HandleRepos ->
        (model, getRepos)
      GetRepos (Ok repos) ->
          (Model model.repos, Cmd.none)
      GetRepos (Err _) ->
          (model, Cmd.none)

view : Model -> Html Msg
view model =
    div []
        [ p [] [ text (toString model.repos) ]
        , button [ onClick HandleRepos ] [ text "Welcome" ]
        ]

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

getRepos : Cmd Msg
getRepos =
  let
    url =
      "/repos/dwyl"
  in
    Http.send GetRepos (Http.get url decodeRepoUrl)

decodeRepoUrl : Decode.Decoder String
decodeRepoUrl =
  Decode.at [ "response" ] Decode.string

