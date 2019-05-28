module TestContextTests.UserInput.SelectOptionTest exposing (all)

import Expect exposing (Expectation)
import Html exposing (Html)
import Html.Attributes exposing (for, id, value)
import Html.Events exposing (on)
import Test exposing (..)
import Test.Runner
import TestContext exposing (TestContext)


testContext : TestContext String String ()
testContext =
    TestContext.createSandbox
        { init = "<INIT>"
        , update = \msg model -> model ++ ";" ++ msg
        , view = testView
        }
        |> TestContext.start ()


testView : String -> Html String
testView model =
    Html.div []
        [ Html.label [ for "pet-select" ] [ Html.text "Choose a pet" ]
        , Html.select
            [ id "pet-select"
            , on "change" Html.Events.targetValue
            ]
            [ Html.option [ value "dog-value" ] [ Html.text "Dog" ]
            , Html.option [ value "cat-value" ] [ Html.text "Cat" ]
            , Html.option [ value "hamster-value" ] [ Html.text "Hamster" ]
            , Html.option [] [ Html.text "Tegu" ]
            ]
        , Html.label [ for "name-select" ] [ Html.text "Choose a name" ]
        , Html.select
            [ id "name-select"
            ]
            [ Html.option [ value "hamster-value" ] [ Html.text "Hamster" ]
            , Html.option [ value "george-value" ] [ Html.text "George" ]
            ]
        ]


all : Test
all =
    describe "TestContext.selectionOption"
        [ test "can select an option" <|
            \() ->
                testContext
                    |> TestContext.selectOption "pet-select" "Choose a pet" "hamster-value" "Hamster"
                    |> TestContext.expectModel (Expect.equal "<INIT>;hamster-value")
        , test "fails if there is no onChange handler" <|
            \() ->
                testContext
                    |> TestContext.selectOption "name-select" "Choose a name" "george-value" "George"
                    |> TestContext.done
                    |> Test.Runner.getFailureReason
                    |> Maybe.map .description
                    |> Maybe.withDefault "<Expected selectOption to fail, but it succeeded>"
                    |> Expect.all
                        [ expectContains "selectOption"
                        , expectContains "The event change does not exist on the found node."
                        ]
        ]


expectContains : String -> String -> Expectation
expectContains expectedString actualString =
    if String.contains expectedString actualString then
        Expect.pass

    else
        Expect.fail
            ("Expected string containing: "
                ++ expectedString
                ++ "\nBut got: "
                ++ actualString
            )
