import CSI 1.0
import QtQuick 2.12

import "../../../Helpers/LED.js" as LED

Module {
    id: module
    property bool active: true
    property int deckId: 1 //1-4
    property string surface: "path"

    Hotcues { name: "hotcues"; channel: deckId }

    AppProperty { id: hotcue1Exists; path: "app.traktor.decks." + deckId + ".track.cue.hotcues.1.exists" }
    AppProperty { id: hotcue2Exists; path: "app.traktor.decks." + deckId + ".track.cue.hotcues.2.exists" }
    AppProperty { id: hotcue3Exists; path: "app.traktor.decks." + deckId + ".track.cue.hotcues.3.exists" }
    AppProperty { id: hotcue4Exists; path: "app.traktor.decks." + deckId + ".track.cue.hotcues.4.exists" }
    AppProperty { id: hotcue5Exists; path: "app.traktor.decks." + deckId + ".track.cue.hotcues.5.exists" }
    AppProperty { id: hotcue6Exists; path: "app.traktor.decks." + deckId + ".track.cue.hotcues.6.exists" }
    AppProperty { id: hotcue7Exists; path: "app.traktor.decks." + deckId + ".track.cue.hotcues.7.exists" }
    AppProperty { id: hotcue8Exists; path: "app.traktor.decks." + deckId + ".track.cue.hotcues.8.exists" }

    AppProperty { id: hotcue1Type; path: "app.traktor.decks." + deckId + ".track.cue.hotcues.1.type" }
    AppProperty { id: hotcue2Type; path: "app.traktor.decks." + deckId + ".track.cue.hotcues.2.type" }
    AppProperty { id: hotcue3Type; path: "app.traktor.decks." + deckId + ".track.cue.hotcues.3.type" }
    AppProperty { id: hotcue4Type; path: "app.traktor.decks." + deckId + ".track.cue.hotcues.4.type" }
    AppProperty { id: hotcue5Type; path: "app.traktor.decks." + deckId + ".track.cue.hotcues.5.type" }
    AppProperty { id: hotcue6Type; path: "app.traktor.decks." + deckId + ".track.cue.hotcues.6.type" }
    AppProperty { id: hotcue7Type; path: "app.traktor.decks." + deckId + ".track.cue.hotcues.7.type" }
    AppProperty { id: hotcue8Type; path: "app.traktor.decks." + deckId + ".track.cue.hotcues.8.type" }

    AppProperty { id: hotcue1Active; path: "app.traktor.decks." + deckId + ".track.cue.hotcues.1.active" }
    AppProperty { id: hotcue2Active; path: "app.traktor.decks." + deckId + ".track.cue.hotcues.2.active" }
    AppProperty { id: hotcue3Active; path: "app.traktor.decks." + deckId + ".track.cue.hotcues.3.active" }
    AppProperty { id: hotcue4Active; path: "app.traktor.decks." + deckId + ".track.cue.hotcues.4.active" }
    AppProperty { id: hotcue5Active; path: "app.traktor.decks." + deckId + ".track.cue.hotcues.5.active" }
    AppProperty { id: hotcue6Active; path: "app.traktor.decks." + deckId + ".track.cue.hotcues.6.active" }
    AppProperty { id: hotcue7Active; path: "app.traktor.decks." + deckId + ".track.cue.hotcues.7.active" }
    AppProperty { id: hotcue8Active; path: "app.traktor.decks." + deckId + ".track.cue.hotcues.8.active" }

    WiresGroup {
        enabled: active

        //Hotcue Type Selector (Hotcue Button Acts as a 2nd Shift)
        //Wire { from: "%surface%.hotcue"; to: HoldPropertyAdapter { path: hotcueModifier.path; output: false } }

        WiresGroup {
            enabled: !shift && !hotcueModifier.value

            Wire { from: "%surface%.pads.1"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 0; color: LED.hotcueLED(1, hotcue1Type.value, hotcue1Exists.value, hotcueColors.value) } }
            Wire { from: "%surface%.pads.2"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 1; color: LED.hotcueLED(2, hotcue2Type.value, hotcue2Exists.value, hotcueColors.value) } }
            Wire { from: "%surface%.pads.3"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 2; color: LED.hotcueLED(3, hotcue3Type.value, hotcue3Exists.value, hotcueColors.value) } }
            Wire { from: "%surface%.pads.4"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 3; color: LED.hotcueLED(4, hotcue4Type.value, hotcue4Exists.value, hotcueColors.value) } }
            Wire { from: "%surface%.pads.5"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 4; color: LED.hotcueLED(5, hotcue5Type.value, hotcue5Exists.value, hotcueColors.value) } }
            Wire { from: "%surface%.pads.6"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 5; color: LED.hotcueLED(6, hotcue6Type.value, hotcue6Exists.value, hotcueColors.value) } }
            Wire { from: "%surface%.pads.7"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 6; color: LED.hotcueLED(7, hotcue7Type.value, hotcue7Exists.value, hotcueColors.value) } }
            Wire { from: "%surface%.pads.8"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 7; color: LED.hotcueLED(8, hotcue8Type.value, hotcue8Exists.value, hotcueColors.value) } }

            WiresGroup { //FIX: Autodeactivate Loop Mode when triggering hotcues which are not Loops
                enabled: fixHotcueTrigger.value
                Wire { enabled: hotcue1Type.description != "Loop" && hotcue1Exists.value; from: "%surface%.pads.1"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".loop.active"; value: 0; output: false } }
                Wire { enabled: hotcue2Type.description != "Loop" && hotcue2Exists.value; from: "%surface%.pads.2"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".loop.active"; value: 0; output: false } }
                Wire { enabled: hotcue3Type.description != "Loop" && hotcue3Exists.value; from: "%surface%.pads.3"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".loop.active"; value: 0; output: false } }
                Wire { enabled: hotcue4Type.description != "Loop" && hotcue4Exists.value; from: "%surface%.pads.4"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".loop.active"; value: 0; output: false } }
                Wire { enabled: hotcue5Type.description != "Loop" && hotcue5Exists.value; from: "%surface%.pads.5"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".loop.active"; value: 0; output: false } }
                Wire { enabled: hotcue6Type.description != "Loop" && hotcue6Exists.value; from: "%surface%.pads.6"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".loop.active"; value: 0; output: false } }
                Wire { enabled: hotcue7Type.description != "Loop" && hotcue7Exists.value; from: "%surface%.pads.7"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".loop.active"; value: 0; output: false } }
                Wire { enabled: hotcue8Type.description != "Loop" && hotcue8Exists.value; from: "%surface%.pads.8"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".loop.active"; value: 0; output: false } }
            }

            WiresGroup { //Hotcues Trigger Mode
                enabled: hotcuesPlayMode.value
                Wire { enabled: hotcue1Exists.value; from: "%surface%.pads.1"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".play"; value: true; output: false } }
                Wire { enabled: hotcue2Exists.value; from: "%surface%.pads.2"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".play"; value: true; output: false } }
                Wire { enabled: hotcue3Exists.value; from: "%surface%.pads.3"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".play"; value: true; output: false } }
                Wire { enabled: hotcue4Exists.value; from: "%surface%.pads.4"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".play"; value: true; output: false } }
                Wire { enabled: hotcue5Exists.value; from: "%surface%.pads.5"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".play"; value: true; output: false } }
                Wire { enabled: hotcue6Exists.value; from: "%surface%.pads.6"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".play"; value: true; output: false } }
                Wire { enabled: hotcue7Exists.value; from: "%surface%.pads.7"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".play"; value: true; output: false } }
                Wire { enabled: hotcue8Exists.value; from: "%surface%.pads.8"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".play"; value: true; output: false } }
            }


/*
            WiresGroup { //MOD TO-DO: Disable Loop
                enabled: isInActiveLoop.value
                Wire { enabled: hotcue1Type.description == "Loop" && hotcue1Active.value; from: "%surface%.pads.1"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".loop.active"; value: 0; output: false } }
                Wire { enabled: hotcue2Type.description == "Loop" && hotcue2Active.value; from: "%surface%.pads.2"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".loop.active"; value: 0; output: false } }
                Wire { enabled: hotcue3Type.description == "Loop" && hotcue3Active.value; from: "%surface%.pads.3"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".loop.active"; value: 0; output: false } }
                Wire { enabled: hotcue4Type.description == "Loop" && hotcue4Active.value; from: "%surface%.pads.4"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".loop.active"; value: 0; output: false } }
                Wire { enabled: hotcue5Type.description == "Loop" && hotcue5Active.value; from: "%surface%.pads.5"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".loop.active"; value: 0; output: false } }
                Wire { enabled: hotcue6Type.description == "Loop" && hotcue6Active.value; from: "%surface%.pads.6"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".loop.active"; value: 0; output: false } }
                Wire { enabled: hotcue7Type.description == "Loop" && hotcue7Active.value; from: "%surface%.pads.7"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".loop.active"; value: 0; output: false } }
                Wire { enabled: hotcue8Type.description == "Loop" && hotcue8Active.value; from: "%surface%.pads.8"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".loop.active"; value: 0; output: false } }
            }
*/
        }

        WiresGroup {
            enabled: shift && !hotcueModifier.value

            Wire { from: "%surface%.pads.1"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.delete_hotcue"; value: 0; color: LED.hotcueLED(1, hotcue1Type.value, hotcue1Exists.value, hotcueColors.value) } }
            Wire { from: "%surface%.pads.2"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.delete_hotcue"; value: 1; color: LED.hotcueLED(2, hotcue2Type.value, hotcue2Exists.value, hotcueColors.value) } }
            Wire { from: "%surface%.pads.3"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.delete_hotcue"; value: 2; color: LED.hotcueLED(3, hotcue3Type.value, hotcue3Exists.value, hotcueColors.value) } }
            Wire { from: "%surface%.pads.4"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.delete_hotcue"; value: 3; color: LED.hotcueLED(4, hotcue4Type.value, hotcue4Exists.value, hotcueColors.value) } }
            Wire { from: "%surface%.pads.5"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.delete_hotcue"; value: 4; color: LED.hotcueLED(5, hotcue5Type.value, hotcue5Exists.value, hotcueColors.value) } }
            Wire { from: "%surface%.pads.6"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.delete_hotcue"; value: 5; color: LED.hotcueLED(6, hotcue6Type.value, hotcue6Exists.value, hotcueColors.value) } }
            Wire { from: "%surface%.pads.7"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.delete_hotcue"; value: 6; color: LED.hotcueLED(7, hotcue7Type.value, hotcue7Exists.value, hotcueColors.value) } }
            Wire { from: "%surface%.pads.8"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.delete_hotcue"; value: 7; color: LED.hotcueLED(8, hotcue8Type.value, hotcue8Exists.value, hotcueColors.value) } }
        }

        WiresGroup {
            enabled: hotcueModifier.value && isLoaded.value

            Wire { from: "%surface%.pads.1"; to: SetPropertyAdapter { path: propertiesPath + ".selectedHotcue"; value: 1; color: LED.hotcueLED(1, hotcue1Type.value, hotcue1Exists.value, hotcueColors.value) } }
            Wire { from: "%surface%.pads.2"; to: SetPropertyAdapter { path: propertiesPath + ".selectedHotcue"; value: 2; color: LED.hotcueLED(2, hotcue2Type.value, hotcue2Exists.value, hotcueColors.value) } }
            Wire { from: "%surface%.pads.3"; to: SetPropertyAdapter { path: propertiesPath + ".selectedHotcue"; value: 3; color: LED.hotcueLED(3, hotcue3Type.value, hotcue3Exists.value, hotcueColors.value) } }
            Wire { from: "%surface%.pads.4"; to: SetPropertyAdapter { path: propertiesPath + ".selectedHotcue"; value: 4; color: LED.hotcueLED(4, hotcue4Type.value, hotcue4Exists.value, hotcueColors.value) } }
            Wire { from: "%surface%.pads.5"; to: SetPropertyAdapter { path: propertiesPath + ".selectedHotcue"; value: 5; color: LED.hotcueLED(5, hotcue5Type.value, hotcue5Exists.value, hotcueColors.value) } }
            Wire { from: "%surface%.pads.6"; to: SetPropertyAdapter { path: propertiesPath + ".selectedHotcue"; value: 6; color: LED.hotcueLED(6, hotcue6Type.value, hotcue6Exists.value, hotcueColors.value) } }
            Wire { from: "%surface%.pads.7"; to: SetPropertyAdapter { path: propertiesPath + ".selectedHotcue"; value: 7; color: LED.hotcueLED(7, hotcue7Type.value, hotcue7Exists.value, hotcueColors.value) } }
            Wire { from: "%surface%.pads.8"; to: SetPropertyAdapter { path: propertiesPath + ".selectedHotcue"; value: 8; color: LED.hotcueLED(8, hotcue8Type.value, hotcue8Exists.value, hotcueColors.value) } }
        }
    }
}
