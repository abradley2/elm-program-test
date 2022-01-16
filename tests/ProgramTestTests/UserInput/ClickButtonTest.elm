module ProgramTestTests.UserInput.ClickButtonTest exposing (all)

import Expect exposing (Expectation)
import Html
import Html.Attributes exposing (attribute, disabled, type_, value)
import Html.Events exposing (onClick, onSubmit)
import ProgramTest exposing (ProgramTest)
import Test exposing (..)
import Test.Expect exposing (expectAnyFailure, expectFailure)
import TestingProgram exposing (Msg(..))


all : Test
all =
    describe "clicking buttons"
        [ test "can click a button" <|
            \() ->
                TestingProgram.startView
                    (Html.button
                        [ onClick (Log "CLICK") ]
                        [ Html.text "Click Me" ]
                    )
                    |> ProgramTest.clickButton "Click Me"
                    |> ProgramTest.expectModel (Expect.equal [ "CLICK" ])
        , test "failure message when button doesn't have onClick" <|
            \() ->
                TestingProgram.startView
                    (Html.button []
                        [ Html.text "Click Me" ]
                    )
                    |> ProgramTest.clickButton "Click Me"
                    |> ProgramTest.done
                    |> expectFailure
                        [ "clickButton \"Click Me\":"
                        , "▼ Query.fromHtml"
                        , ""
                        , "    <body>"
                        , "        <button>"
                        , "            Click Me"
                        , "        </button>"
                        , "    </body>"
                        , ""
                        , ""
                        , "▼ Query.has [ text \"HTML expected by the call to: clickButton \"Click Me\"\" ]"
                        , ""
                        , "✗ has text \"HTML expected by the call to: clickButton \"Click Me\"\""
                        , ""
                        , "Expected one of the following to exist:"
                        , "- <button> (not disabled) with onClick and text \"Click Me\""
                        , "    Event.expectEvent: I found a node, but it does not listen for \"click\" events like I expected it would."
                        , "- <button> (not disabled) with onClick containing an <img> with alt=\"Click Me\""
                        , "    ✓ has tag \"button\""
                        , "    ✗ has containing [ tag \"img\", attribute \"alt\" \"Click Me\" ]"
                        , "- <button> (not disabled) with onClick and attribute aria-label=\"Click Me\""
                        , "    ✓ has tag \"button\""
                        , "    ✗ has attribute \"aria-label\" \"Click Me\""
                        , "- an element with role=\"button\" (not disabled) and onClick and text \"Click Me\""
                        , "    ✗ has attribute \"role\" \"button\""
                        , "- an element with role=\"button\" (not disabled) and onClick and aria-label=\"Click Me\""
                        , "    ✗ has attribute \"role\" \"button\""
                        , "- a <form> with onSubmit containing a <button> (not disabled, not type=button) with text \"Click Me\""
                        , "    ✗ has tag \"form\""
                        , "- a <form> with onSubmit containing an <input type=submit value=\"Click Me\"> (not disabled)"
                        , "    ✗ has tag \"form\""
                        ]
        , test "can click a button containing an image with alt text" <|
            \() ->
                TestingProgram.startView
                    (Html.button
                        [ onClick (Log "CLICK") ]
                        [ Html.img
                            [ Html.Attributes.src "googoo.png"
                            , Html.Attributes.alt "Click Me"
                            ]
                            []
                        ]
                    )
                    |> ProgramTest.clickButton "Click Me"
                    |> ProgramTest.expectModel (Expect.equal [ "CLICK" ])
        , test "can click a button with an aria-label attribute" <|
            \() ->
                TestingProgram.startView
                    (Html.button
                        [ onClick (Log "CLICK")
                        , attribute "aria-label" "Close"
                        ]
                        [ Html.text "X" ]
                    )
                    |> ProgramTest.clickButton "Close"
                    |> ProgramTest.expectModel (Expect.equal [ "CLICK" ])
        , test "can click a role=\"button\" with an aria-label attribute" <|
            \() ->
                TestingProgram.startView
                    (Html.div
                        [ onClick (Log "CLICK")
                        , attribute "role" "button"
                        , attribute "aria-label" "Close"
                        ]
                        [ Html.text "X" ]
                    )
                    |> ProgramTest.clickButton "Close"
                    |> ProgramTest.expectModel (Expect.equal [ "CLICK" ])
        , test "can click an elm-ui button" <|
            \() ->
                TestingProgram.startView
                    (Html.div
                        [ onClick (Log "CLICK")
                        , Html.Attributes.attribute "role" "button"
                        ]
                        [ Html.text "Click Me" ]
                    )
                    |> ProgramTest.clickButton "Click Me"
                    |> ProgramTest.expectModel (Expect.equal [ "CLICK" ])
        , test "can click a submit button (no type attribute) in a form to submit the form" <|
            \() ->
                TestingProgram.startView
                    (Html.form
                        [ onSubmit (Log "SUBMIT")
                        ]
                        [ Html.button [] [ Html.text "Click Me" ]
                        ]
                    )
                    |> ProgramTest.clickButton "Click Me"
                    |> ProgramTest.expectModel (Expect.equal [ "SUBMIT" ])
        , test "can click a submit button (type=submit) in a form to submit the form" <|
            \() ->
                TestingProgram.startView
                    (Html.form
                        [ onSubmit (Log "SUBMIT")
                        ]
                        [ Html.button [ type_ "submit" ] [ Html.text "Click Me" ]
                        ]
                    )
                    |> ProgramTest.clickButton "Click Me"
                    |> ProgramTest.expectModel (Expect.equal [ "SUBMIT" ])
        , test "can click a submit button (input type=submit) in a form to submit the form" <|
            \() ->
                TestingProgram.startView
                    (Html.form
                        [ onSubmit (Log "SUBMIT")
                        ]
                        [ Html.input [ type_ "submit", value "Click Me" ] []
                        ]
                    )
                    |> ProgramTest.clickButton "Click Me"
                    |> ProgramTest.expectModel (Expect.equal [ "SUBMIT" ])
        , test "clicking a <button type=button> does not submit the form" <|
            \() ->
                TestingProgram.startView
                    (Html.form
                        [ onSubmit (Log "SUBMIT")
                        ]
                        [ Html.button [ type_ "button" ] [ Html.text "Click Me" ]
                        ]
                    )
                    |> ProgramTest.clickButton "Click Me"
                    |> ProgramTest.done
                    |> expectAnyFailure
        , test "fails when clicking a disabled button" <|
            \() ->
                TestingProgram.startView
                    (Html.button
                        [ onClick (Log "CLICK")
                        , disabled True
                        ]
                        [ Html.text "Click Me" ]
                    )
                    |> ProgramTest.clickButton "Click Me"
                    |> ProgramTest.done
                    |> expectFailure
                        [ "clickButton \"Click Me\":"
                        , "▼ Query.fromHtml"
                        , ""
                        , "    <body>"
                        , "        <button disabled=true>"
                        , "            Click Me"
                        , "        </button>"
                        , "    </body>"
                        , ""
                        , ""
                        , "▼ Query.has [ text \"HTML expected by the call to: clickButton \"Click Me\"\" ]"
                        , ""
                        , "✗ has text \"HTML expected by the call to: clickButton \"Click Me\"\""
                        , ""
                        , "Expected one of the following to exist:"
                        , "- <button> (not disabled) with onClick and text \"Click Me\""
                        , "    ✓ has tag \"button\""
                        , "    ✓ has containing [ text \"Click Me\" ]"
                        , "    ✗ has attribute \"disabled\" False"
                        , "- <button> (not disabled) with onClick containing an <img> with alt=\"Click Me\""
                        , "    ✓ has tag \"button\""
                        , "    ✗ has containing [ tag \"img\", attribute \"alt\" \"Click Me\" ]"
                        , "- <button> (not disabled) with onClick and attribute aria-label=\"Click Me\""
                        , "    ✓ has tag \"button\""
                        , "    ✗ has attribute \"aria-label\" \"Click Me\""
                        , "- an element with role=\"button\" (not disabled) and onClick and text \"Click Me\""
                        , "    ✗ has attribute \"role\" \"button\""
                        , "- an element with role=\"button\" (not disabled) and onClick and aria-label=\"Click Me\""
                        , "    ✗ has attribute \"role\" \"button\""
                        , "- a <form> with onSubmit containing a <button> (not disabled, not type=button) with text \"Click Me\""
                        , "    ✗ has tag \"form\""
                        , "- a <form> with onSubmit containing an <input type=submit value=\"Click Me\"> (not disabled)"
                        , "    ✗ has tag \"form\""
                        ]
        , test "fails when clicking a disabled button in a form" <|
            \() ->
                TestingProgram.startView
                    (Html.form
                        [ onSubmit (Log "SUBMIT") ]
                        [ Html.button [ disabled True ] [ Html.text "Click Me" ]
                        ]
                    )
                    |> ProgramTest.clickButton "Click Me"
                    |> ProgramTest.done
                    |> expectAnyFailure
        , test "fails when clicking a disabled <input type=submit> in a form" <|
            \() ->
                TestingProgram.startView
                    (Html.form
                        [ onSubmit (Log "SUBMIT") ]
                        [ Html.input [ type_ "submit", disabled True, value "Click Me" ] []
                        ]
                    )
                    |> ProgramTest.clickButton "Click Me"
                    |> ProgramTest.done
                    |> expectAnyFailure
        , test "failure message with multiple matches" <|
            \() ->
                TestingProgram.startView
                    (Html.div []
                        [ Html.button
                            [ onClick (Log "CLICK") ]
                            [ Html.text "Click Me"
                            ]
                        , Html.button
                            [ onClick (Log "CLICK2")
                            , attribute "role" "button"
                            , attribute "aria-label" "Click Me"
                            ]
                            []
                        ]
                    )
                    |> ProgramTest.clickButton "Click Me"
                    |> ProgramTest.done
                    |> expectFailure
                        [ "clickButton \"Click Me\":"
                        , "▼ Query.fromHtml"
                        , ""
                        , "    <body>"
                        , "        <div>"
                        , "            <button>"
                        , "                Click Me"
                        , "            </button>"
                        , "            <button aria-label=\"Click Me\" role=\"button\">"
                        , "            </button>"
                        , "        </div>"
                        , "    </body>"
                        , ""
                        , ""
                        , "▼ Query.has [ text \"HTML expected by the call to: clickButton \"Click Me\"\" ]"
                        , ""
                        , "✗ has text \"HTML expected by the call to: clickButton \"Click Me\"\""
                        , ""
                        , "Expected one of the following to exist, but there were multiple successful matches:"
                        , "- <button> (not disabled) with onClick and text \"Click Me\""
                        , "- <button> (not disabled) with onClick and attribute aria-label=\"Click Me\""
                        , ""
                        , "If that's what you intended, use `ProgramTest.within` to focus in on a portion of"
                        , "the view that contains only one of the matches."
                        ]
        ]
