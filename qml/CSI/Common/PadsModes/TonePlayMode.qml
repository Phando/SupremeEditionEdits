import CSI 1.0
import QtQuick 2.12

import "../../../Helpers/LED.js" as LED
import "../../../Helpers/KeyHelpers.js" as Key

Module {
    id: module
    property bool active: true
    property int deckId: 1 //1-4
    property string surface: "path"

    property string selectedCuePath: "app.traktor.decks." + deckId + ".track.cue"
    MappingPropertyDescriptor { id: tonePlayHotcue; path: deckPropertiesPath + ".tonePlayHotcue"; type: MappingPropertyDescriptor.Integer; value: 0; min: 0; max: 8;
        onValueChanged: {
            if (value != 0) { selectedCuePath = "app.traktor.decks." + deckId + ".track.cue.hotcues." + value }
            else { selectedCuePath = "app.traktor.decks." + deckId + ".track.cue" }
        }
    }
    MappingPropertyDescriptor { id: tonePlayMode; path: deckPropertiesPath + ".tonePlayMode"; type: MappingPropertyDescriptor.Integer; value: 0; min: -1; max: 1 }

    AppProperty { id: hotcueExists; path: "app.traktor.decks." + deckId + ".track.cue.hotcues." + tonePlayHotcue.value + ".exists"; onValueChanged: {if (!value) tonePlayHotcue.value = 0 } }
    AppProperty { id: hotcueType; path: selectedCuePath + ".type" }
    AppProperty { id: hotcueActive; path: selectedCuePath +  ".active" }

    AppProperty { id: hotcue1Exists; path: "app.traktor.decks." + deckId + ".track.cue.hotcues.1.exists" }
    AppProperty { id: hotcue2Exists; path: "app.traktor.decks." + deckId + ".track.cue.hotcues.2.exists" }
    AppProperty { id: hotcue3Exists; path: "app.traktor.decks." + deckId + ".track.cue.hotcues.3.exists" }
    AppProperty { id: hotcue4Exists; path: "app.traktor.decks." + deckId + ".track.cue.hotcues.4.exists" }
    AppProperty { id: hotcue5Exists; path: "app.traktor.decks." + deckId + ".track.cue.hotcues.5.exists" }
    AppProperty { id: hotcue6Exists; path: "app.traktor.decks." + deckId + ".track.cue.hotcues.6.exists" }
    AppProperty { id: hotcue7Exists; path: "app.traktor.decks." + deckId + ".track.cue.hotcues.7.exists" }
    AppProperty { id: hotcue8Exists; path: "app.traktor.decks." + deckId + ".track.cue.hotcues.8.exists" }

    WiresGroup {
        enabled: active

        //Hotcue Type Selector (Hotcue Button Acts as a 2nd Shift)
        //Wire { from: "%surface%.hotcue"; to: HoldPropertyAdapter { path: hotcueModifier.path; output: false } }

        WiresGroup {
            enabled: !shift

            WiresGroup {
                enabled: tonePlayHotcue.value != 0

/*
                //Not working...?
                Wire { from: "%surface%.pads.1"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: tonePlayHotcue.value-1; output: false } }
                Wire { from: "%surface%.pads.2"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: tonePlayHotcue.value-1; output: false } }
                Wire { from: "%surface%.pads.3"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: tonePlayHotcue.value-1; output: false } }
                Wire { from: "%surface%.pads.4"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: tonePlayHotcue.value-1; output: false } }
                Wire { from: "%surface%.pads.5"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: tonePlayHotcue.value-1; output: false } }
                Wire { from: "%surface%.pads.6"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: tonePlayHotcue.value-1; output: false } }
                Wire { from: "%surface%.pads.7"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: tonePlayHotcue.value-1; output: false } }
                Wire { from: "%surface%.pads.8"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: tonePlayHotcue.value-1; output: false } }
*/

                WiresGroup {
                    enabled: tonePlayHotcue.value == 1
                    Wire { from: "%surface%.pads.1"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 0; output: false } }
                    Wire { from: "%surface%.pads.2"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 0; output: false } }
                    Wire { from: "%surface%.pads.3"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 0; output: false } }
                    Wire { from: "%surface%.pads.4"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 0; output: false } }
                    Wire { from: "%surface%.pads.5"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 0; output: false } }
                    Wire { from: "%surface%.pads.6"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 0; output: false } }
                    Wire { from: "%surface%.pads.7"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 0; output: false } }
                    Wire { from: "%surface%.pads.8"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 0; output: false } }
                }
                WiresGroup {
                    enabled: tonePlayHotcue.value == 2
                    Wire { from: "%surface%.pads.1"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 1; output: false } }
                    Wire { from: "%surface%.pads.2"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 1; output: false } }
                    Wire { from: "%surface%.pads.3"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 1; output: false } }
                    Wire { from: "%surface%.pads.4"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 1; output: false } }
                    Wire { from: "%surface%.pads.5"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 1; output: false } }
                    Wire { from: "%surface%.pads.6"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 1; output: false } }
                    Wire { from: "%surface%.pads.7"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 1; output: false } }
                    Wire { from: "%surface%.pads.8"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 1; output: false } }
                }
                WiresGroup {
                    enabled: tonePlayHotcue.value == 3
                    Wire { from: "%surface%.pads.1"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 2; output: false } }
                    Wire { from: "%surface%.pads.2"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 2; output: false } }
                    Wire { from: "%surface%.pads.3"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 2; output: false } }
                    Wire { from: "%surface%.pads.4"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 2; output: false } }
                    Wire { from: "%surface%.pads.5"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 2; output: false } }
                    Wire { from: "%surface%.pads.6"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 2; output: false } }
                    Wire { from: "%surface%.pads.7"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 2; output: false } }
                    Wire { from: "%surface%.pads.8"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 2; output: false } }
                }
                WiresGroup {
                    enabled: tonePlayHotcue.value == 4
                    Wire { from: "%surface%.pads.1"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 3; output: false } }
                    Wire { from: "%surface%.pads.2"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 3; output: false } }
                    Wire { from: "%surface%.pads.3"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 3; output: false } }
                    Wire { from: "%surface%.pads.4"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 3; output: false } }
                    Wire { from: "%surface%.pads.5"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 3; output: false } }
                    Wire { from: "%surface%.pads.6"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 3; output: false } }
                    Wire { from: "%surface%.pads.7"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 3; output: false } }
                    Wire { from: "%surface%.pads.8"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 3; output: false } }
                }
                WiresGroup {
                    enabled: tonePlayHotcue.value == 5
                    Wire { from: "%surface%.pads.1"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 4; output: false } }
                    Wire { from: "%surface%.pads.2"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 4; output: false } }
                    Wire { from: "%surface%.pads.3"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 4; output: false } }
                    Wire { from: "%surface%.pads.4"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 4; output: false } }
                    Wire { from: "%surface%.pads.5"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 4; output: false } }
                    Wire { from: "%surface%.pads.6"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 4; output: false } }
                    Wire { from: "%surface%.pads.7"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 4; output: false } }
                    Wire { from: "%surface%.pads.8"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 4; output: false } }
                }
                WiresGroup {
                    enabled: tonePlayHotcue.value == 6
                    Wire { from: "%surface%.pads.1"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 5; output: false } }
                    Wire { from: "%surface%.pads.2"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 5; output: false } }
                    Wire { from: "%surface%.pads.3"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 5; output: false } }
                    Wire { from: "%surface%.pads.4"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 5; output: false } }
                    Wire { from: "%surface%.pads.5"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 5; output: false } }
                    Wire { from: "%surface%.pads.6"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 5; output: false } }
                    Wire { from: "%surface%.pads.7"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 5; output: false } }
                    Wire { from: "%surface%.pads.8"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 5; output: false } }
                }
                WiresGroup {
                    enabled: tonePlayHotcue.value == 7
                    Wire { from: "%surface%.pads.1"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 6; output: false } }
                    Wire { from: "%surface%.pads.2"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 6; output: false } }
                    Wire { from: "%surface%.pads.3"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 6; output: false } }
                    Wire { from: "%surface%.pads.4"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 6; output: false } }
                    Wire { from: "%surface%.pads.5"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 6; output: false } }
                    Wire { from: "%surface%.pads.6"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 6; output: false } }
                    Wire { from: "%surface%.pads.7"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 6; output: false } }
                    Wire { from: "%surface%.pads.8"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 6; output: false } }
                }
                WiresGroup {
                    enabled: tonePlayHotcue.value == 8
                    Wire { from: "%surface%.pads.1"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 7; output: false } }
                    Wire { from: "%surface%.pads.2"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 7; output: false } }
                    Wire { from: "%surface%.pads.3"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 7; output: false } }
                    Wire { from: "%surface%.pads.4"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 7; output: false } }
                    Wire { from: "%surface%.pads.5"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 7; output: false } }
                    Wire { from: "%surface%.pads.6"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 7; output: false } }
                    Wire { from: "%surface%.pads.7"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 7; output: false } }
                    Wire { from: "%surface%.pads.8"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.cue.select_or_set_hotcue"; value: 7; output: false } }
                }
            }
            WiresGroup {
                enabled: tonePlayHotcue.value == 0 && isPlaying.value
                Wire { from: "%surface%.pads.1"; to: DirectPropertyAdapter { path: "app.traktor.decks." + deckId + ".cup"; output: false } }
                Wire { from: "%surface%.pads.2"; to: DirectPropertyAdapter { path: "app.traktor.decks." + deckId + ".cup"; output: false } }
                Wire { from: "%surface%.pads.3"; to: DirectPropertyAdapter { path: "app.traktor.decks." + deckId + ".cup"; output: false } }
                Wire { from: "%surface%.pads.4"; to: DirectPropertyAdapter { path: "app.traktor.decks." + deckId + ".cup"; output: false } }
                Wire { from: "%surface%.pads.5"; to: DirectPropertyAdapter { path: "app.traktor.decks." + deckId + ".cup"; output: false } }
                Wire { from: "%surface%.pads.6"; to: DirectPropertyAdapter { path: "app.traktor.decks." + deckId + ".cup"; output: false } }
                Wire { from: "%surface%.pads.7"; to: DirectPropertyAdapter { path: "app.traktor.decks." + deckId + ".cup"; output: false } }
                Wire { from: "%surface%.pads.8"; to: DirectPropertyAdapter { path: "app.traktor.decks." + deckId + ".cup"; output: false } }
            }
            WiresGroup {
                enabled: tonePlayHotcue.value == 0 && !isPlaying.value
                Wire { from: "%surface%.pads.1"; to: DirectPropertyAdapter { path: "app.traktor.decks." + deckId + ".cue"; output: false } }
                Wire { from: "%surface%.pads.2"; to: DirectPropertyAdapter { path: "app.traktor.decks." + deckId + ".cue"; output: false } }
                Wire { from: "%surface%.pads.3"; to: DirectPropertyAdapter { path: "app.traktor.decks." + deckId + ".cue"; output: false } }
                Wire { from: "%surface%.pads.4"; to: DirectPropertyAdapter { path: "app.traktor.decks." + deckId + ".cue"; output: false } }
                Wire { from: "%surface%.pads.5"; to: DirectPropertyAdapter { path: "app.traktor.decks." + deckId + ".cue"; output: false } }
                Wire { from: "%surface%.pads.6"; to: DirectPropertyAdapter { path: "app.traktor.decks." + deckId + ".cue"; output: false } }
                Wire { from: "%surface%.pads.7"; to: DirectPropertyAdapter { path: "app.traktor.decks." + deckId + ".cue"; output: false } }
                Wire { from: "%surface%.pads.8"; to: DirectPropertyAdapter { path: "app.traktor.decks." + deckId + ".cue"; output: false } }
            }

            WiresGroup {
                enabled: (useKeyText.value && Key.getIndex(keyText.value) > 12) || (!useKeyText.value && Key.getIndex(key.value) > 12) //Minor Scale

                WiresGroup {
                    enabled: tonePlayMode.value == 0
                    Wire { from: "%surface%.pads.1"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: 0; color: Color.Purple } }
                    Wire { from: "%surface%.pads.2"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: (1/12)*2; color: Color.Magenta } }
                    Wire { from: "%surface%.pads.3"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: (1/12)*3; color: Color.Magenta } }
                    Wire { from: "%surface%.pads.4"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: (1/12)*5; color: Color.Magenta } }
                    Wire { from: "%surface%.pads.5"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: -(1/12)*7; color: Color.Red } }
                    Wire { from: "%surface%.pads.6"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: -(1/12)*5; color: Color.Red } }
                    Wire { from: "%surface%.pads.7"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: -(1/12)*3; color: Color.Red } }
                    Wire { from: "%surface%.pads.8"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: -(1/12)*2; color: Color.Red } }
                }
                WiresGroup {
                    enabled: tonePlayMode.value == -1
                    Wire { from: "%surface%.pads.4"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: 0; color: Color.Purple } }
                    Wire { from: "%surface%.pads.3"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: -(1/12)*2; color: Color.Red } }
                    Wire { from: "%surface%.pads.2"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: -(1/12)*3; color: Color.Red } }
                    Wire { from: "%surface%.pads.1"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: -(1/12)*5; color: Color.Red } }
                    Wire { from: "%surface%.pads.8"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: -(1/12)*7; color: Color.Red } }
                    Wire { from: "%surface%.pads.7"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: -(1/12)*8; color: Color.Red } }
                    Wire { from: "%surface%.pads.6"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: -(1/12)*10; color: Color.Red } }
                    Wire { from: "%surface%.pads.5"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: -(1/12)*12; color: Color.Red } }
                }
                WiresGroup {
                    enabled: tonePlayMode.value == 1
                    Wire { from: "%surface%.pads.5"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: 0; color: Color.Purple } }
                    Wire { from: "%surface%.pads.6"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: (1/12)*2; color: Color.Magenta } }
                    Wire { from: "%surface%.pads.7"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: (1/12)*3; color: Color.Magenta } }
                    Wire { from: "%surface%.pads.8"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: (1/12)*5; color: Color.Magenta } }
                    Wire { from: "%surface%.pads.1"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: (1/12)*7; color: Color.Magenta } }
                    Wire { from: "%surface%.pads.2"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: (1/12)*8; color: Color.Magenta } }
                    Wire { from: "%surface%.pads.3"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: (1/12)*10; color: Color.Magenta } }
                    Wire { from: "%surface%.pads.4"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: (1/12)*12; color: Color.Magenta } }
                }
            }

            WiresGroup {
                enabled: useKeyText.value && Key.getIndex(keyText.value) <= 12 || (!useKeyText.value && Key.getIndex(key.value) <= 12) //Major scale

                WiresGroup {
                    enabled: tonePlayMode.value == 0
                    Wire { from: "%surface%.pads.1"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: 0; color: Color.Purple } }
                    Wire { from: "%surface%.pads.2"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: (1/12)*2; color: Color.Magenta } }
                    Wire { from: "%surface%.pads.3"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: (1/12)*4; color: Color.Magenta } }
                    Wire { from: "%surface%.pads.4"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: (1/12)*5; color: Color.Magenta } }
                    Wire { from: "%surface%.pads.5"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: -(1/12)*7; color: Color.Red } }
                    Wire { from: "%surface%.pads.6"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: -(1/12)*5; color: Color.Red } }
                    Wire { from: "%surface%.pads.7"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: -(1/12)*3; color: Color.Red } }
                    Wire { from: "%surface%.pads.8"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: -(1/12)*1; color: Color.Red } }
                }
                WiresGroup {
                    enabled: tonePlayMode.value == -1
                    Wire { from: "%surface%.pads.4"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: 0; color: Color.Purple } }
                    Wire { from: "%surface%.pads.3"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: -(1/12)*1; color: Color.Red } }
                    Wire { from: "%surface%.pads.2"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: -(1/12)*3; color: Color.Red } }
                    Wire { from: "%surface%.pads.1"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: -(1/12)*5; color: Color.Red } }
                    Wire { from: "%surface%.pads.8"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: -(1/12)*7; color: Color.Red } }
                    Wire { from: "%surface%.pads.7"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: -(1/12)*8; color: Color.Red } }
                    Wire { from: "%surface%.pads.6"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: -(1/12)*10; color: Color.Red } }
                    Wire { from: "%surface%.pads.5"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: -(1/12)*12; color: Color.Red } }
                }
                WiresGroup {
                    enabled: tonePlayMode.value == 1
                    Wire { from: "%surface%.pads.5"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: 0; color: Color.Purple } }
                    Wire { from: "%surface%.pads.6"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: (1/12)*2; color: Color.Magenta } }
                    Wire { from: "%surface%.pads.7"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: (1/12)*4; color: Color.Magenta } }
                    Wire { from: "%surface%.pads.8"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: (1/12)*5; color: Color.Magenta } }
                    Wire { from: "%surface%.pads.1"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: (1/12)*7; color: Color.Magenta } }
                    Wire { from: "%surface%.pads.2"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: (1/12)*9; color: Color.Magenta } }
                    Wire { from: "%surface%.pads.3"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: (1/12)*11; color: Color.Magenta } }
                    Wire { from: "%surface%.pads.4"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: (1/12)*12; color: Color.Magenta } }
                }
            }

            WiresGroup {
                enabled: useKeyText.value && Key.getIndex(keyText.value) == null || (!useKeyText.value && Key.getIndex(key.value) == null)

                WiresGroup {
                    enabled: tonePlayMode.value == 0
                    Wire { from: "%surface%.pads.1"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: 0; color: Color.Purple } }
                    Wire { from: "%surface%.pads.2"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: (1/12)*1; color: Color.Magenta } }
                    Wire { from: "%surface%.pads.3"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: (1/12)*2; color: Color.Magenta } }
                    Wire { from: "%surface%.pads.4"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: (1/12)*3; color: Color.Magenta } }
                    Wire { from: "%surface%.pads.5"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: -(1/12)*4; color: Color.Red } }
                    Wire { from: "%surface%.pads.6"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: -(1/12)*3; color: Color.Red } }
                    Wire { from: "%surface%.pads.7"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: -(1/12)*2; color: Color.Red } }
                    Wire { from: "%surface%.pads.8"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: -(1/12)*1; color: Color.Red } }
                }
                WiresGroup {
                    enabled: tonePlayMode.value == -1
                    Wire { from: "%surface%.pads.4"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: 0; color: Color.Purple } }
                    Wire { from: "%surface%.pads.3"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: -(1/12)*1; color: Color.Red } }
                    Wire { from: "%surface%.pads.2"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: -(1/12)*2; color: Color.Red } }
                    Wire { from: "%surface%.pads.1"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: -(1/12)*3; color: Color.Red } }
                    Wire { from: "%surface%.pads.8"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: -(1/12)*4; color: Color.Red } }
                    Wire { from: "%surface%.pads.7"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: -(1/12)*5; color: Color.Red } }
                    Wire { from: "%surface%.pads.6"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: -(1/12)*6; color: Color.Red } }
                    Wire { from: "%surface%.pads.5"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: -(1/12)*7; color: Color.Red } }
                }
                WiresGroup {
                    enabled: tonePlayMode.value == 1
                    Wire { from: "%surface%.pads.5"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: 0; color: Color.Purple } }
                    Wire { from: "%surface%.pads.6"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: (1/12)*1; color: Color.Magenta } }
                    Wire { from: "%surface%.pads.7"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: (1/12)*2; color: Color.Magenta } }
                    Wire { from: "%surface%.pads.8"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: (1/12)*3; color: Color.Magenta } }
                    Wire { from: "%surface%.pads.1"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: (1/12)*4; color: Color.Magenta } }
                    Wire { from: "%surface%.pads.2"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: (1/12)*5; color: Color.Magenta } }
                    Wire { from: "%surface%.pads.3"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: (1/12)*6; color: Color.Magenta } }
                    Wire { from: "%surface%.pads.4"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.adjust"; value: (1/12)*7; color: Color.Magenta } }
                }
            }

/*
            WiresGroup { //FIX: Autodeactivate Loop Mode when triggering hotcues which are not Loops
                enabled: fixHotcueTrigger.value
                Wire { enabled: hotcueType.description != "Loop" && hotcueExists.value; from: "%surface%.pads.1"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".loop.active"; value: 0; output: false } }
                Wire { enabled: hotcueType.description != "Loop" && hotcueExists.value; from: "%surface%.pads.2"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".loop.active"; value: 0; output: false } }
                Wire { enabled: hotcueType.description != "Loop" && hotcueExists.value; from: "%surface%.pads.3"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".loop.active"; value: 0; output: false } }
                Wire { enabled: hotcueType.description != "Loop" && hotcueExists.value; from: "%surface%.pads.4"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".loop.active"; value: 0; output: false } }
                Wire { enabled: hotcueType.description != "Loop" && hotcueExists.value; from: "%surface%.pads.5"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".loop.active"; value: 0; output: false } }
                Wire { enabled: hotcueType.description != "Loop" && hotcueExists.value; from: "%surface%.pads.6"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".loop.active"; value: 0; output: false } }
                Wire { enabled: hotcueType.description != "Loop" && hotcueExists.value; from: "%surface%.pads.7"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".loop.active"; value: 0; output: false } }
                Wire { enabled: hotcueType.description != "Loop" && hotcueExists.value; from: "%surface%.pads.8"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".loop.active"; value: 0; output: false } }
            }
*/
        }

        WiresGroup {
            enabled: shift

            //If they are in the Hotcue color, there may be confusion wether if you are selecting hotcue for tone play mode or if you are deleting it
            Wire { from: "%surface%.pads.1"; to: TogglePropertyAdapter { path: deckPropertiesPath + ".tonePlayHotcue"; value: 1; defaultValue: 0; color: Color.White } enabled: hotcue1Exists.value }
            Wire { from: "%surface%.pads.2"; to: TogglePropertyAdapter { path: deckPropertiesPath + ".tonePlayHotcue"; value: 2; defaultValue: 0; color: Color.White  } enabled: hotcue2Exists.value }
            Wire { from: "%surface%.pads.3"; to: TogglePropertyAdapter { path: deckPropertiesPath + ".tonePlayHotcue"; value: 3; defaultValue: 0; color: Color.White  } enabled: hotcue3Exists.value }
            Wire { from: "%surface%.pads.4"; to: TogglePropertyAdapter { path: deckPropertiesPath + ".tonePlayHotcue"; value: 4; defaultValue: 0; color: Color.White  } enabled: hotcue4Exists.value }
            Wire { from: "%surface%.pads.5"; to: TogglePropertyAdapter { path: deckPropertiesPath + ".tonePlayHotcue"; value: 5; defaultValue: 0; color: Color.White  } enabled: hotcue5Exists.value }
            Wire { from: "%surface%.pads.6"; to: TogglePropertyAdapter { path: deckPropertiesPath + ".tonePlayHotcue"; value: 6; defaultValue: 0; color: Color.White  } enabled: hotcue6Exists.value }
            Wire { from: "%surface%.pads.7"; to: TogglePropertyAdapter { path: deckPropertiesPath + ".tonePlayHotcue"; value: 7; defaultValue: 0; color: Color.White  } enabled: hotcue7Exists.value }
            Wire { from: "%surface%.pads.8"; to: TogglePropertyAdapter { path: deckPropertiesPath + ".tonePlayHotcue"; value: 8; defaultValue: 0; color: Color.White  } enabled: hotcue8Exists.value }

        }
    }
}
