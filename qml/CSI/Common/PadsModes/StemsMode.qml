import CSI 1.0
import QtQuick 2.12

import "../../../Helpers/LED.js" as LED

Module {
    id: module
    property bool active: true
    property int deckId: 1 //1-4
    property string surface: "path"

    StemDeckStreams { name: "stems"; channel: deckId }

    //Slot Selector Timer
    property bool slotSelectorBlinkState: false
    Timer {
        id: slotSelectorTimer
        interval: 500
        running: true
        repeat: true
        onTriggered: {
            slotSelectorBlinkState = !slotSelectorBlinkState;
        }
    }
    function restartSlotSelectorTimer(enable) {
        if (enable) {
            slotSelectorBlinkState = true;
            slotSelectorTimer.restart();
        }
    }

    //Slot Selector 1
    property bool slot1AlreadySelected: false
    ButtonScriptAdapter {
        name: "SlotSelector1"
        brightness: slot1Selected.value && slotSelectorBlinkState
        color: LED.legacy(deckId)
        onPress: {
            restartSlotSelectorTimer(slot1Selected.value)
            slot1Selector_countdown.restart()
            if (slot1Selected.value != true) { //slot wasn't enabled when pressed
                slot1Selected.value = true
                slot1AlreadySelected = false
            }
            else {
                slot1AlreadySelected = true
            }
        }
        onRelease: {
            if (slot1Selector_countdown.running) {	//action triggered when pressed
                if (slot1AlreadySelected) {
                    slot1Selected.value = false
                }
            }
            else { //action when button held & released
                slot1Selected.value = false
            }
            slot1Selector_countdown.stop()
        }
    }
    Timer { id: slot1Selector_countdown; interval: holdTimer.value }

    //Slot Selector 2
    property bool slot2AlreadySelected: false
    ButtonScriptAdapter {
        name: "SlotSelector2"
        brightness: slot2Selected.value && slotSelectorBlinkState
        color: LED.legacy(deckId)
        onPress: {
            restartSlotSelectorTimer(slot2Selected.value)
            slot2Selector_countdown.restart()
            if (slot2Selected.value != true) { //slot wasn't enabled when pressed
                slot2Selected.value = true
                slot2AlreadySelected = false
            }
            else {
                slot2AlreadySelected = true
            }
        }
        onRelease: {
            if (slot2Selector_countdown.running) {	//action triggered when pressed
                if (slot2AlreadySelected) {
                    slot2Selected.value = false
                }
            }
            else { //action when button held & released
                slot2Selected.value = false
            }
            slot2Selector_countdown.stop()
        }
    }
    Timer { id: slot2Selector_countdown; interval: holdTimer.value }

    //Slot Selector 3
    property bool slot3AlreadySelected: false
    ButtonScriptAdapter {
        name: "SlotSelector3"
        brightness: slot3Selected.value && slotSelectorBlinkState
        color: LED.legacy(deckId)
        onPress: {
            restartSlotSelectorTimer(slot3Selected.value)
            slot3Selector_countdown.restart()
            if (slot3Selected.value != true) { //slot wasn't enabled when pressed
                slot3Selected.value = true
                slot3AlreadySelected = false
            }
            else {
                slot3AlreadySelected = true
            }
        }
        onRelease: {
            if (slot3Selector_countdown.running) {	//action triggered when pressed
                if (slot3AlreadySelected) {
                    slot3Selected.value = false
                }
            }
            else { //action when button held & released
                slot3Selected.value = false
            }
            slot3Selector_countdown.stop()
        }
    }
    Timer { id: slot3Selector_countdown; interval: holdTimer.value }

    //Slot Selector 4
    property bool slot4AlreadySelected: false
    ButtonScriptAdapter {
        name: "SlotSelector4"
        brightness: slot4Selected.value && slotSelectorBlinkState
        color: LED.legacy(deckId)
        onPress: {
            restartSlotSelectorTimer(slot4Selected.value)
            slot4Selector_countdown.restart()
            if (slot4Selected.value != true) { //slot wasn't enabled when pressed
                slot4Selected.value = true
                slot4AlreadySelected = false
            }
            else {
                slot4AlreadySelected = true
            }
        }
        onRelease: {
            if (slot4Selector_countdown.running) {	//action triggered when pressed
                if (slot4AlreadySelected) {
                    slot4Selected.value = false
                }
            }
            else { //action when button held & released
                slot4Selected.value = false
            }
            slot4Selector_countdown.stop()
        }
    }
    Timer { id: slot4Selector_countdown; interval: holdTimer.value }

    WiresGroup {
        enabled: active

        WiresGroup {
            enabled: !shift
            Wire { from: "%surface%.pads.1"; to: "stems.1.muted" }
            Wire { from: "%surface%.pads.2"; to: "stems.2.muted" }
            Wire { from: "%surface%.pads.3"; to: "stems.3.muted" }
            Wire { from: "%surface%.pads.4"; to: "stems.4.muted" }

            //Slot Selector
            Wire { from: "%surface%.pads.5"; to: HoldPropertyAdapter { path: deckPropertiesPath + ".slot_selector_mode.1"; value: true; output: false } enabled: slotSelectorMode.value == 0 }
            Wire { from: "%surface%.pads.5"; to: TogglePropertyAdapter { path: deckPropertiesPath + ".slot_selector_mode.1"; value: true; output: false } enabled: slotSelectorMode.value == 1 }
            Wire { from: "%surface%.pads.5"; to: "SlotSelector1"; enabled: slotSelectorMode.value == 2 }
            Wire { from: "%surface%.pads.5"; to: ButtonScriptAdapter { brightness: slot1Selected.value && slotSelectorBlinkState; color: LED.legacy(deckId); onPress: { restartSlotSelectorTimer(slot1Selected.value) } } }

            Wire { from: "%surface%.pads.6"; to: HoldPropertyAdapter { path: deckPropertiesPath + ".slot_selector_mode.2"; value: true; output: false } enabled: slotSelectorMode.value == 0 }
            Wire { from: "%surface%.pads.6"; to: TogglePropertyAdapter { path: deckPropertiesPath + ".slot_selector_mode.2"; value: true; output: false } enabled: slotSelectorMode.value == 1 }
            Wire { from: "%surface%.pads.6"; to: "SlotSelector2"; enabled: slotSelectorMode.value == 2 }
            Wire { from: "%surface%.pads.6"; to: ButtonScriptAdapter { brightness: slot2Selected.value && slotSelectorBlinkState; color: LED.legacy(deckId); onPress: { restartSlotSelectorTimer(slot2Selected.value) } } }

            Wire { from: "%surface%.pads.7"; to: HoldPropertyAdapter { path: deckPropertiesPath + ".slot_selector_mode.3"; value: true; output: false } enabled: slotSelectorMode.value == 0 }
            Wire { from: "%surface%.pads.7"; to: TogglePropertyAdapter { path: deckPropertiesPath + ".slot_selector_mode.3"; value: true; output: false } enabled: slotSelectorMode.value == 1 }
            Wire { from: "%surface%.pads.7"; to: "SlotSelector3"; enabled: slotSelectorMode.value == 2 }
            Wire { from: "%surface%.pads.7"; to: ButtonScriptAdapter { brightness: slot3Selected.value && slotSelectorBlinkState; color: LED.legacy(deckId); onPress: { restartSlotSelectorTimer(slot3Selected.value) } } }

            Wire { from: "%surface%.pads.8"; to: HoldPropertyAdapter { path: deckPropertiesPath + ".slot_selector_mode.4"; value: true; output: false } enabled: slotSelectorMode.value == 0 }
            Wire { from: "%surface%.pads.8"; to: TogglePropertyAdapter { path: deckPropertiesPath + ".slot_selector_mode.4"; value: true; output: false } enabled: slotSelectorMode.value == 1 }
            Wire { from: "%surface%.pads.8"; to: "SlotSelector4"; enabled: slotSelectorMode.value == 2 }
            Wire { from: "%surface%.pads.8"; to: ButtonScriptAdapter { brightness: slot4Selected.value && slotSelectorBlinkState; color: LED.legacy(deckId); onPress: { restartSlotSelectorTimer(slot4Selected.value) } } }
        }

        WiresGroup {
            enabled: shift
            Wire { from: "%surface%.pads.1"; to: "stems.1.fx_send_on" }
            Wire { from: "%surface%.pads.2"; to: "stems.2.fx_send_on" }
            Wire { from: "%surface%.pads.3"; to: "stems.3.fx_send_on" }
            Wire { from: "%surface%.pads.4"; to: "stems.4.fx_send_on" }

            //Reset Parameters (TO-DO)... meanwhile... slot selector with shift too
            Wire { from: "%surface%.pads.5"; to: HoldPropertyAdapter { path: deckPropertiesPath + ".slot_selector_mode.1"; value: true; output: false } enabled: slotSelectorMode.value == 0 }
            Wire { from: "%surface%.pads.5"; to: TogglePropertyAdapter { path: deckPropertiesPath + ".slot_selector_mode.1"; value: true; output: false } enabled: slotSelectorMode.value == 1 }
            Wire { from: "%surface%.pads.5"; to: "SlotSelector1"; enabled: slotSelectorMode.value == 2 }
            Wire { from: "%surface%.pads.5"; to: ButtonScriptAdapter { brightness: slot1Selected.value && slotSelectorBlinkState; color: LED.legacy(deckId); onPress: { restartSlotSelectorTimer(slot1Selected.value) } } }

            Wire { from: "%surface%.pads.6"; to: HoldPropertyAdapter { path: deckPropertiesPath + ".slot_selector_mode.2"; value: true; output: false } enabled: slotSelectorMode.value == 0 }
            Wire { from: "%surface%.pads.6"; to: TogglePropertyAdapter { path: deckPropertiesPath + ".slot_selector_mode.2"; value: true; output: false } enabled: slotSelectorMode.value == 1 }
            Wire { from: "%surface%.pads.6"; to: "SlotSelector2"; enabled: slotSelectorMode.value == 2 }
            Wire { from: "%surface%.pads.6"; to: ButtonScriptAdapter { brightness: slot2Selected.value && slotSelectorBlinkState; color: LED.legacy(deckId); onPress: { restartSlotSelectorTimer(slot2Selected.value) } } }

            Wire { from: "%surface%.pads.7"; to: HoldPropertyAdapter { path: deckPropertiesPath + ".slot_selector_mode.3"; value: true; output: false } enabled: slotSelectorMode.value == 0 }
            Wire { from: "%surface%.pads.7"; to: TogglePropertyAdapter { path: deckPropertiesPath + ".slot_selector_mode.3"; value: true; output: false } enabled: slotSelectorMode.value == 1 }
            Wire { from: "%surface%.pads.7"; to: "SlotSelector3"; enabled: slotSelectorMode.value == 2 }
            Wire { from: "%surface%.pads.7"; to: ButtonScriptAdapter { brightness: slot3Selected.value && slotSelectorBlinkState; color: LED.legacy(deckId); onPress: { restartSlotSelectorTimer(slot3Selected.value) } } }

            Wire { from: "%surface%.pads.8"; to: HoldPropertyAdapter { path: deckPropertiesPath + ".slot_selector_mode.4"; value: true; output: false } enabled: slotSelectorMode.value == 0 }
            Wire { from: "%surface%.pads.8"; to: TogglePropertyAdapter { path: deckPropertiesPath + ".slot_selector_mode.4"; value: true; output: false } enabled: slotSelectorMode.value == 1 }
            Wire { from: "%surface%.pads.8"; to: "SlotSelector4"; enabled: slotSelectorMode.value == 2 }
            Wire { from: "%surface%.pads.8"; to: ButtonScriptAdapter { brightness: slot4Selected.value && slotSelectorBlinkState; color: LED.legacy(deckId); onPress: { restartSlotSelectorTimer(slot4Selected.value) } } }
        }
    }
}
