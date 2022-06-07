import CSI 1.0
import QtQuick 2.12

import "../../../Defines"
import "../../../Helpers/LED.js" as LED

Module {
    id: module
    property bool active: true
    property int deckId: 1 //1-4
    property string surface: "path"
    property bool browsing: false

    RemixTrigger { name: "triggering"; channel: deckId; target: RemixTrigger.StepSequencer }

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

    //RMX Deck Player Properties
    AppProperty { id: activeCell_slot1; path: "app.traktor.decks." + deckId + ".remix.players.1.active_cell_row" }
    AppProperty { id: activeCell_slot2; path: "app.traktor.decks." + deckId + ".remix.players.2.active_cell_row" }
    AppProperty { id: activeCell_slot3; path: "app.traktor.decks." + deckId + ".remix.players.3.active_cell_row" }
    AppProperty { id: activeCell_slot4; path: "app.traktor.decks." + deckId + ".remix.players.4.active_cell_row" }
    AppProperty { id: selectedCell_slot1; path: "app.traktor.decks." + deckId + ".remix.players.1.sequencer.selected_cell" }
    AppProperty { id: selectedCell_slot2; path: "app.traktor.decks." + deckId + ".remix.players.2.sequencer.selected_cell" }
    AppProperty { id: selectedCell_slot3; path: "app.traktor.decks." + deckId + ".remix.players.3.sequencer.selected_cell" }
    AppProperty { id: selectedCell_slot4; path: "app.traktor.decks." + deckId + ".remix.players.4.sequencer.selected_cell" }
    AppProperty { id: play_position_slot1; path: "app.traktor.decks." + deckId + ".remix.players.1.sequencer.play_position" }
    AppProperty { id: play_position_slot2; path: "app.traktor.decks." + deckId + ".remix.players.2.sequencer.play_position" }
    AppProperty { id: play_position_slot3; path: "app.traktor.decks." + deckId + ".remix.players.3.sequencer.play_position" }
    AppProperty { id: play_position_slot4; path: "app.traktor.decks." + deckId + ".remix.players.4.sequencer.play_position" }

    //Active Cell Properties
    AppProperty { id: selectedCell_slot1_color; path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows." + (selectedCell_slot1.value+1) + ".color_id" }
    AppProperty { id: selectedCell_slot2_color; path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows." + (selectedCell_slot2.value+1) + ".color_id" }
    AppProperty { id: selectedCell_slot3_color; path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows." + (selectedCell_slot3.value+1) + ".color_id" }
    AppProperty { id: selectedCell_slot4_color; path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows." + (selectedCell_slot4.value+1) + ".color_id" }

    AppProperty { id: selectedCell_slot1_playMode; path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows." + (selectedCell_slot1.value+1) + ".play_mode" }
    AppProperty { id: selectedCell_slot2_playMode; path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows." + (selectedCell_slot2.value+1) + ".state" }
    AppProperty { id: selectedCell_slot3_playMode; path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows." + (selectedCell_slot3.value+1) + ".state" }
    AppProperty { id: selectedCell_slot4_playMode; path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows." + (selectedCell_slot4.value+1) + ".state" }

    AppProperty { id: selectedCell_slot1_state; path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows." + (selectedCell_slot1.value+1) + ".state" }
    AppProperty { id: selectedCell_slot2_state; path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows." + (selectedCell_slot2.value+1) + ".state" }
    AppProperty { id: selectedCell_slot3_state; path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows." + (selectedCell_slot3.value+1) + ".state" }
    AppProperty { id: selectedCell_slot4_state; path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows." + (selectedCell_slot4.value+1) + ".state" }
    //0: Empty, 1: Loaded, 2: Playing, 3: Waiting

    AppProperty { id: selectedCell_slot1_color_ratio; path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows." + (selectedCell_slot1.value+1) + ".animation.color_ratio" }
    AppProperty { id: selectedCell_slot2_color_ratio; path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows." + (selectedCell_slot2.value+1) + ".animation.color_ratio" }
    AppProperty { id: selectedCell_slot3_color_ratio; path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows." + (selectedCell_slot3.value+1) + ".animation.color_ratio" }
    AppProperty { id: selectedCell_slot4_color_ratio; path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows." + (selectedCell_slot4.value+1) + ".animation.color_ratio" }

    //RMX Deck Properties - Step Sequencer + Recorder
    AppProperty { id: sequencerOn; path: "app.traktor.decks." + deckId + ".remix.sequencer.on" }
    AppProperty { id: sequencerRecOn; path: "app.traktor.decks." + deckId + ".remix.sequencer.rec.on" }

    AppProperty { id: current_step_slot1; path: "app.traktor.decks." + deckId + ".remix.players.1.sequencer.current_step" }
    AppProperty { id: current_step_slot2; path: "app.traktor.decks." + deckId + ".remix.players.2.sequencer.current_step" }
    AppProperty { id: current_step_slot3; path: "app.traktor.decks." + deckId + ".remix.players.3.sequencer.current_step" }
    AppProperty { id: current_step_slot4; path: "app.traktor.decks." + deckId + ".remix.players.4.sequencer.current_step" }

    AppProperty { id: pattern_length_slot1; path: "app.traktor.decks." + deckId + ".remix.players.1.sequencer.pattern_length" }
    AppProperty { id: pattern_length_slot2; path: "app.traktor.decks." + deckId + ".remix.players.2.sequencer.pattern_length" }
    AppProperty { id: pattern_length_slot3; path: "app.traktor.decks." + deckId + ".remix.players.3.sequencer.pattern_length" }
    AppProperty { id: pattern_length_slot4; path: "app.traktor.decks." + deckId + ".remix.players.4.sequencer.pattern_length" }

    AppProperty { id: step1slot1Enabled; path: "app.traktor.decks." + deckId + ".remix.players.1.sequencer.steps.1" }
    AppProperty { id: step2slot1Enabled; path: "app.traktor.decks." + deckId + ".remix.players.1.sequencer.steps.2" }
    AppProperty { id: step3slot1Enabled; path: "app.traktor.decks." + deckId + ".remix.players.1.sequencer.steps.3" }
    AppProperty { id: step4slot1Enabled; path: "app.traktor.decks." + deckId + ".remix.players.1.sequencer.steps.4" }
    AppProperty { id: step5slot1Enabled; path: "app.traktor.decks." + deckId + ".remix.players.1.sequencer.steps.5" }
    AppProperty { id: step6slot1Enabled; path: "app.traktor.decks." + deckId + ".remix.players.1.sequencer.steps.6" }
    AppProperty { id: step7slot1Enabled; path: "app.traktor.decks." + deckId + ".remix.players.1.sequencer.steps.7" }
    AppProperty { id: step8slot1Enabled; path: "app.traktor.decks." + deckId + ".remix.players.1.sequencer.steps.8" }
    AppProperty { id: step9slot1Enabled; path: "app.traktor.decks." + deckId + ".remix.players.1.sequencer.steps.9" }
    AppProperty { id: step10slot1Enabled; path: "app.traktor.decks." + deckId + ".remix.players.1.sequencer.steps.10" }
    AppProperty { id: step11slot1Enabled; path: "app.traktor.decks." + deckId + ".remix.players.1.sequencer.steps.11" }
    AppProperty { id: step12slot1Enabled; path: "app.traktor.decks." + deckId + ".remix.players.1.sequencer.steps.12" }
    AppProperty { id: step13slot1Enabled; path: "app.traktor.decks." + deckId + ".remix.players.1.sequencer.steps.13" }
    AppProperty { id: step14slot1Enabled; path: "app.traktor.decks." + deckId + ".remix.players.1.sequencer.steps.14" }
    AppProperty { id: step15slot1Enabled; path: "app.traktor.decks." + deckId + ".remix.players.1.sequencer.steps.15" }
    AppProperty { id: step16slot1Enabled; path: "app.traktor.decks." + deckId + ".remix.players.1.sequencer.steps.16" }

    AppProperty { id: step1slot2Enabled; path: "app.traktor.decks." + deckId + ".remix.players.2.sequencer.steps.1" }
    AppProperty { id: step2slot2Enabled; path: "app.traktor.decks." + deckId + ".remix.players.2.sequencer.steps.2" }
    AppProperty { id: step3slot2Enabled; path: "app.traktor.decks." + deckId + ".remix.players.2.sequencer.steps.3" }
    AppProperty { id: step4slot2Enabled; path: "app.traktor.decks." + deckId + ".remix.players.2.sequencer.steps.4" }
    AppProperty { id: step5slot2Enabled; path: "app.traktor.decks." + deckId + ".remix.players.2.sequencer.steps.5" }
    AppProperty { id: step6slot2Enabled; path: "app.traktor.decks." + deckId + ".remix.players.2.sequencer.steps.6" }
    AppProperty { id: step7slot2Enabled; path: "app.traktor.decks." + deckId + ".remix.players.2.sequencer.steps.7" }
    AppProperty { id: step8slot2Enabled; path: "app.traktor.decks." + deckId + ".remix.players.2.sequencer.steps.8" }
    AppProperty { id: step9slot2Enabled; path: "app.traktor.decks." + deckId + ".remix.players.2.sequencer.steps.9" }
    AppProperty { id: step10slot2Enabled; path: "app.traktor.decks." + deckId + ".remix.players.2.sequencer.steps.10" }
    AppProperty { id: step11slot2Enabled; path: "app.traktor.decks." + deckId + ".remix.players.2.sequencer.steps.11" }
    AppProperty { id: step12slot2Enabled; path: "app.traktor.decks." + deckId + ".remix.players.2.sequencer.steps.12" }
    AppProperty { id: step13slot2Enabled; path: "app.traktor.decks." + deckId + ".remix.players.2.sequencer.steps.13" }
    AppProperty { id: step14slot2Enabled; path: "app.traktor.decks." + deckId + ".remix.players.2.sequencer.steps.14" }
    AppProperty { id: step15slot2Enabled; path: "app.traktor.decks." + deckId + ".remix.players.2.sequencer.steps.15" }
    AppProperty { id: step16slot2Enabled; path: "app.traktor.decks." + deckId + ".remix.players.2.sequencer.steps.16" }

    AppProperty { id: step1slot3Enabled; path: "app.traktor.decks." + deckId + ".remix.players.3.sequencer.steps.1" }
    AppProperty { id: step2slot3Enabled; path: "app.traktor.decks." + deckId + ".remix.players.3.sequencer.steps.2" }
    AppProperty { id: step3slot3Enabled; path: "app.traktor.decks." + deckId + ".remix.players.3.sequencer.steps.3" }
    AppProperty { id: step4slot3Enabled; path: "app.traktor.decks." + deckId + ".remix.players.3.sequencer.steps.4" }
    AppProperty { id: step5slot3Enabled; path: "app.traktor.decks." + deckId + ".remix.players.3.sequencer.steps.5" }
    AppProperty { id: step6slot3Enabled; path: "app.traktor.decks." + deckId + ".remix.players.3.sequencer.steps.6" }
    AppProperty { id: step7slot3Enabled; path: "app.traktor.decks." + deckId + ".remix.players.3.sequencer.steps.7" }
    AppProperty { id: step8slot3Enabled; path: "app.traktor.decks." + deckId + ".remix.players.3.sequencer.steps.8" }
    AppProperty { id: step9slot3Enabled; path: "app.traktor.decks." + deckId + ".remix.players.3.sequencer.steps.9" }
    AppProperty { id: step10slot3Enabled; path: "app.traktor.decks." + deckId + ".remix.players.3.sequencer.steps.10" }
    AppProperty { id: step11slot3Enabled; path: "app.traktor.decks." + deckId + ".remix.players.3.sequencer.steps.11" }
    AppProperty { id: step12slot3Enabled; path: "app.traktor.decks." + deckId + ".remix.players.3.sequencer.steps.12" }
    AppProperty { id: step13slot3Enabled; path: "app.traktor.decks." + deckId + ".remix.players.3.sequencer.steps.13" }
    AppProperty { id: step14slot3Enabled; path: "app.traktor.decks." + deckId + ".remix.players.3.sequencer.steps.14" }
    AppProperty { id: step15slot3Enabled; path: "app.traktor.decks." + deckId + ".remix.players.3.sequencer.steps.15" }
    AppProperty { id: step16slot3Enabled; path: "app.traktor.decks." + deckId + ".remix.players.3.sequencer.steps.16" }

    AppProperty { id: step1slot4Enabled; path: "app.traktor.decks." + deckId + ".remix.players.4.sequencer.steps.1" }
    AppProperty { id: step2slot4Enabled; path: "app.traktor.decks." + deckId + ".remix.players.4.sequencer.steps.2" }
    AppProperty { id: step3slot4Enabled; path: "app.traktor.decks." + deckId + ".remix.players.4.sequencer.steps.3" }
    AppProperty { id: step4slot4Enabled; path: "app.traktor.decks." + deckId + ".remix.players.4.sequencer.steps.4" }
    AppProperty { id: step5slot4Enabled; path: "app.traktor.decks." + deckId + ".remix.players.4.sequencer.steps.5" }
    AppProperty { id: step6slot4Enabled; path: "app.traktor.decks." + deckId + ".remix.players.4.sequencer.steps.6" }
    AppProperty { id: step7slot4Enabled; path: "app.traktor.decks." + deckId + ".remix.players.4.sequencer.steps.7" }
    AppProperty { id: step8slot4Enabled; path: "app.traktor.decks." + deckId + ".remix.players.4.sequencer.steps.8" }
    AppProperty { id: step9slot4Enabled; path: "app.traktor.decks." + deckId + ".remix.players.4.sequencer.steps.9" }
    AppProperty { id: step10slot4Enabled; path: "app.traktor.decks." + deckId + ".remix.players.4.sequencer.steps.10" }
    AppProperty { id: step11slot4Enabled; path: "app.traktor.decks." + deckId + ".remix.players.4.sequencer.steps.11" }
    AppProperty { id: step12slot4Enabled; path: "app.traktor.decks." + deckId + ".remix.players.4.sequencer.steps.12" }
    AppProperty { id: step13slot4Enabled; path: "app.traktor.decks." + deckId + ".remix.players.4.sequencer.steps.13" }
    AppProperty { id: step14slot4Enabled; path: "app.traktor.decks." + deckId + ".remix.players.4.sequencer.steps.14" }
    AppProperty { id: step15slot4Enabled; path: "app.traktor.decks." + deckId + ".remix.players.4.sequencer.steps.15" }
    AppProperty { id: step16slot4Enabled; path: "app.traktor.decks." + deckId + ".remix.players.4.sequencer.steps.16" }

    property bool recordedPatternSlot1: step1slot1Enabled.value || step2slot1Enabled.value || step3slot1Enabled.value || step4slot1Enabled.value || step5slot1Enabled.value || step6slot1Enabled.value || step7slot1Enabled.value || step8slot1Enabled.value || step9slot1Enabled.value || step10slot1Enabled.value || step11slot1Enabled.value || step12slot1Enabled.value || step13slot1Enabled.value || step14slot1Enabled.value || step15slot1Enabled.value || step16slot1Enabled.value
    property bool recordedPatternSlot2: step1slot2Enabled.value || step2slot2Enabled.value || step3slot2Enabled.value || step4slot2Enabled.value || step5slot2Enabled.value || step6slot2Enabled.value || step7slot2Enabled.value || step8slot2Enabled.value || step9slot2Enabled.value || step10slot2Enabled.value || step11slot2Enabled.value || step12slot2Enabled.value || step13slot2Enabled.value || step14slot2Enabled.value || step15slot2Enabled.value || step16slot2Enabled.value
    property bool recordedPatternSlot3: step1slot3Enabled.value || step2slot3Enabled.value || step3slot3Enabled.value || step4slot3Enabled.value || step5slot3Enabled.value || step6slot3Enabled.value || step7slot3Enabled.value || step8slot3Enabled.value || step9slot3Enabled.value || step10slot3Enabled.value || step11slot3Enabled.value || step12slot3Enabled.value || step13slot3Enabled.value || step14slot3Enabled.value || step15slot3Enabled.value || step16slot3Enabled.value
    property bool recordedPatternSlot4: step1slot4Enabled.value || step2slot4Enabled.value || step3slot4Enabled.value || step4slot4Enabled.value || step5slot4Enabled.value || step6slot4Enabled.value || step7slot4Enabled.value || step8slot4Enabled.value || step9slot4Enabled.value || step10slot4Enabled.value || step11slot4Enabled.value || step12slot4Enabled.value || step13slot4Enabled.value || step14slot4Enabled.value || step15slot4Enabled.value || step16slot4Enabled.value

    WiresGroup {
        enabled: active

        //Wire { from: "remix.capture_mode.input";  to: DirectPropertyAdapter { path: holdCapture.path; input: false } }

        WiresGroup {
            enabled: !shift

            //LEDS
            //Wire { from: "%surface%.pads.1";  to: ButtonScriptAdapter  { brightness: (selectedCell_slot1_color_ratio.value != 1 && selectedCell_slot1_state.description == "Playing") || selectedCell_slot1_state.description == "Waiting" ? bright : dimmed; color: selectedCell_slot1_state.description == "Empty" ? Color.Black : (selectedCell_slot1_state.description == "Waiting" ? Color.White : padLED(selectedCell_slot1_color.value)); } enabled: !sequencerRecOn.value }
            //Wire { from: "%surface%.pads.2";  to: ButtonScriptAdapter  { brightness: (selectedCell_slot2_color_ratio.value != 1 && selectedCell_slot2_state.description == "Playing") || selectedCell_slot2_state.description == "Waiting" ? bright : dimmed; color: selectedCell_slot2_state.description == "Empty" ? Color.Black : (selectedCell_slot2_state.description == "Waiting" ? Color.White : padLED(selectedCell_slot2_color.value)); } enabled: !sequencerRecOn.value }
            //Wire { from: "%surface%.pads.3";  to: ButtonScriptAdapter  { brightness: (selectedCell_slot3_color_ratio.value != 1 && selectedCell_slot3_state.description == "Playing") || selectedCell_slot3_state.description == "Waiting" ? bright : dimmed; color: selectedCell_slot3_state.description == "Empty" ? Color.Black : (selectedCell_slot3_state.description == "Waiting" ? Color.White : padLED(selectedCell_slot3_color.value)); } enabled: !sequencerRecOn.value }
            //Wire { from: "%surface%.pads.4";  to: ButtonScriptAdapter  { brightness: (selectedCell_slot4_color_ratio.value != 1 && selectedCell_slot4_state.description == "Playing") || selectedCell_slot4_state.description == "Waiting" ? bright : dimmed; color: selectedCell_slot4_state.description == "Empty" ? Color.Black : (selectedCell_slot4_state.description == "Waiting" ? Color.White : padLED(selectedCell_slot4_color.value)); } enabled: !sequencerRecOn.value }

            //Trigger Slots
            Wire { from: "%surface%.pads.1"; to: "triggering.1.trigger"; enabled: selectedCell_slot1_state.description != "Empty" }
            Wire { from: "%surface%.pads.2"; to: "triggering.2.trigger"; enabled: selectedCell_slot2_state.description != "Empty" }
            Wire { from: "%surface%.pads.3"; to: "triggering.3.trigger"; enabled: selectedCell_slot3_state.description != "Empty" }
            Wire { from: "%surface%.pads.4"; to: "triggering.4.trigger"; enabled: selectedCell_slot4_state.description != "Empty" }

            WiresGroup {
                enabled: !browsing

                //Capture Slot 1
                WiresGroup {
                    enabled: selectedCell_slot1_state.description == "Empty"
                    Wire { from: "%surface%.pads.1"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows.1.capture"; output: false} enabled: selectedCell_slot1.value == 0}
                    Wire { from: "%surface%.pads.1"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows.2.capture"; output: false} enabled: selectedCell_slot1.value == 1}
                    Wire { from: "%surface%.pads.1"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows.3.capture"; output: false} enabled: selectedCell_slot1.value == 2}
                    Wire { from: "%surface%.pads.1"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows.4.capture"; output: false} enabled: selectedCell_slot1.value == 3}
                    Wire { from: "%surface%.pads.1"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows.5.capture"; output: false} enabled: selectedCell_slot1.value == 4}
                    Wire { from: "%surface%.pads.1"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows.6.capture"; output: false} enabled: selectedCell_slot1.value == 5}
                    Wire { from: "%surface%.pads.1"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows.7.capture"; output: false} enabled: selectedCell_slot1.value == 6}
                    Wire { from: "%surface%.pads.1"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows.8.capture"; output: false} enabled: selectedCell_slot1.value == 7}
                    Wire { from: "%surface%.pads.1"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows.9.capture"; output: false} enabled: selectedCell_slot1.value == 8}
                    Wire { from: "%surface%.pads.1"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows.10.capture"; output: false} enabled: selectedCell_slot1.value == 9}
                    Wire { from: "%surface%.pads.1"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows.11.capture"; output: false} enabled: selectedCell_slot1.value == 10}
                    Wire { from: "%surface%.pads.1"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows.12.capture"; output: false} enabled: selectedCell_slot1.value == 11}
                    Wire { from: "%surface%.pads.1"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows.13.capture"; output: false} enabled: selectedCell_slot1.value == 12}
                    Wire { from: "%surface%.pads.1"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows.14.capture"; output: false} enabled: selectedCell_slot1.value == 13}
                    Wire { from: "%surface%.pads.1"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows.15.capture"; output: false} enabled: selectedCell_slot1.value == 14}
                    Wire { from: "%surface%.pads.1"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows.16.capture"; output: false} enabled: selectedCell_slot1.value == 15}
                }

                //Capture Slot 2
                WiresGroup {
                    enabled: selectedCell_slot2_state.description == "Empty"
                    Wire { from: "%surface%.pads.2"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows.1.capture"; output: false} enabled: selectedCell_slot2.value == 0}
                    Wire { from: "%surface%.pads.2"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows.2.capture"; output: false} enabled: selectedCell_slot2.value == 1}
                    Wire { from: "%surface%.pads.2"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows.3.capture"; output: false} enabled: selectedCell_slot2.value == 2}
                    Wire { from: "%surface%.pads.2"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows.4.capture"; output: false} enabled: selectedCell_slot2.value == 3}
                    Wire { from: "%surface%.pads.2"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows.5.capture"; output: false} enabled: selectedCell_slot2.value == 4}
                    Wire { from: "%surface%.pads.2"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows.6.capture"; output: false} enabled: selectedCell_slot2.value == 5}
                    Wire { from: "%surface%.pads.2"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows.7.capture"; output: false} enabled: selectedCell_slot2.value == 6}
                    Wire { from: "%surface%.pads.2"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows.8.capture"; output: false} enabled: selectedCell_slot2.value == 7}
                    Wire { from: "%surface%.pads.2"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows.9.capture"; output: false} enabled: selectedCell_slot2.value == 8}
                    Wire { from: "%surface%.pads.2"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows.10.capture"; output: false} enabled: selectedCell_slot2.value == 9}
                    Wire { from: "%surface%.pads.2"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows.11.capture"; output: false} enabled: selectedCell_slot2.value == 10}
                    Wire { from: "%surface%.pads.2"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows.12.capture"; output: false} enabled: selectedCell_slot2.value == 11}
                    Wire { from: "%surface%.pads.2"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows.13.capture"; output: false} enabled: selectedCell_slot2.value == 12}
                    Wire { from: "%surface%.pads.2"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows.14.capture"; output: false} enabled: selectedCell_slot2.value == 13}
                    Wire { from: "%surface%.pads.2"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows.15.capture"; output: false} enabled: selectedCell_slot2.value == 14}
                    Wire { from: "%surface%.pads.2"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows.16.capture"; output: false} enabled: selectedCell_slot2.value == 15}
                }

                //Capture Slot 3
                WiresGroup {
                    enabled: selectedCell_slot3_state.description == "Empty"
                    Wire { from: "%surface%.pads.3"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows.1.capture"; output: false} enabled: selectedCell_slot3.value == 0}
                    Wire { from: "%surface%.pads.3"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows.2.capture"; output: false} enabled: selectedCell_slot3.value == 1}
                    Wire { from: "%surface%.pads.3"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows.3.capture"; output: false} enabled: selectedCell_slot3.value == 2}
                    Wire { from: "%surface%.pads.3"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows.4.capture"; output: false} enabled: selectedCell_slot3.value == 3}
                    Wire { from: "%surface%.pads.3"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows.5.capture"; output: false} enabled: selectedCell_slot3.value == 4}
                    Wire { from: "%surface%.pads.3"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows.6.capture"; output: false} enabled: selectedCell_slot3.value == 5}
                    Wire { from: "%surface%.pads.3"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows.7.capture"; output: false} enabled: selectedCell_slot3.value == 6}
                    Wire { from: "%surface%.pads.3"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows.8.capture"; output: false} enabled: selectedCell_slot3.value == 7}
                    Wire { from: "%surface%.pads.3"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows.9.capture"; output: false} enabled: selectedCell_slot3.value == 8}
                    Wire { from: "%surface%.pads.3"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows.10.capture"; output: false} enabled: selectedCell_slot3.value == 9}
                    Wire { from: "%surface%.pads.3"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows.11.capture"; output: false} enabled: selectedCell_slot3.value == 10}
                    Wire { from: "%surface%.pads.3"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows.12.capture"; output: false} enabled: selectedCell_slot3.value == 11}
                    Wire { from: "%surface%.pads.3"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows.13.capture"; output: false} enabled: selectedCell_slot3.value == 12}
                    Wire { from: "%surface%.pads.3"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows.14.capture"; output: false} enabled: selectedCell_slot3.value == 13}
                    Wire { from: "%surface%.pads.3"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows.15.capture"; output: false} enabled: selectedCell_slot3.value == 14}
                    Wire { from: "%surface%.pads.3"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows.16.capture"; output: false} enabled: selectedCell_slot3.value == 15}
                }

                //Capture Slot 4
                WiresGroup {
                    enabled: selectedCell_slot4_state.description == "Empty"
                    Wire { from: "%surface%.pads.4"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows.1.capture"; output: false} enabled: selectedCell_slot4.value == 0}
                    Wire { from: "%surface%.pads.4"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows.2.capture"; output: false} enabled: selectedCell_slot4.value == 1}
                    Wire { from: "%surface%.pads.4"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows.3.capture"; output: false} enabled: selectedCell_slot4.value == 2}
                    Wire { from: "%surface%.pads.4"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows.4.capture"; output: false} enabled: selectedCell_slot4.value == 3}
                    Wire { from: "%surface%.pads.4"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows.5.capture"; output: false} enabled: selectedCell_slot4.value == 4}
                    Wire { from: "%surface%.pads.4"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows.6.capture"; output: false} enabled: selectedCell_slot4.value == 5}
                    Wire { from: "%surface%.pads.4"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows.7.capture"; output: false} enabled: selectedCell_slot4.value == 6}
                    Wire { from: "%surface%.pads.4"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows.8.capture"; output: false} enabled: selectedCell_slot4.value == 7}
                    Wire { from: "%surface%.pads.4"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows.9.capture"; output: false} enabled: selectedCell_slot4.value == 8}
                    Wire { from: "%surface%.pads.4"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows.10.capture"; output: false} enabled: selectedCell_slot4.value == 9}
                    Wire { from: "%surface%.pads.4"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows.11.capture"; output: false} enabled: selectedCell_slot4.value == 10}
                    Wire { from: "%surface%.pads.4"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows.12.capture"; output: false} enabled: selectedCell_slot4.value == 11}
                    Wire { from: "%surface%.pads.4"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows.13.capture"; output: false} enabled: selectedCell_slot4.value == 12}
                    Wire { from: "%surface%.pads.4"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows.14.capture"; output: false} enabled: selectedCell_slot4.value == 13}
                    Wire { from: "%surface%.pads.4"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows.15.capture"; output: false} enabled: selectedCell_slot4.value == 14}
                    Wire { from: "%surface%.pads.4"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows.16.capture"; output: false} enabled: selectedCell_slot4.value == 15}
                }
            }

            WiresGroup {
                enabled: browsing

                //Load Slot 1
                WiresGroup {
                    enabled: selectedCell_slot1_state.description == "Empty"
                    Wire { from: "%surface%.pads.1"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows.1.load"; output: false} enabled: selectedCell_slot1.value == 0}
                    Wire { from: "%surface%.pads.1"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows.2.load"; output: false} enabled: selectedCell_slot1.value == 1}
                    Wire { from: "%surface%.pads.1"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows.3.load"; output: false} enabled: selectedCell_slot1.value == 2}
                    Wire { from: "%surface%.pads.1"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows.4.load"; output: false} enabled: selectedCell_slot1.value == 3}
                    Wire { from: "%surface%.pads.1"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows.5.load"; output: false} enabled: selectedCell_slot1.value == 4}
                    Wire { from: "%surface%.pads.1"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows.6.load"; output: false} enabled: selectedCell_slot1.value == 5}
                    Wire { from: "%surface%.pads.1"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows.7.load"; output: false} enabled: selectedCell_slot1.value == 6}
                    Wire { from: "%surface%.pads.1"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows.8.load"; output: false} enabled: selectedCell_slot1.value == 7}
                    Wire { from: "%surface%.pads.1"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows.9.load"; output: false} enabled: selectedCell_slot1.value == 8}
                    Wire { from: "%surface%.pads.1"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows.10.load"; output: false} enabled: selectedCell_slot1.value == 9}
                    Wire { from: "%surface%.pads.1"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows.11.load"; output: false} enabled: selectedCell_slot1.value == 10}
                    Wire { from: "%surface%.pads.1"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows.12.load"; output: false} enabled: selectedCell_slot1.value == 11}
                    Wire { from: "%surface%.pads.1"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows.13.load"; output: false} enabled: selectedCell_slot1.value == 12}
                    Wire { from: "%surface%.pads.1"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows.14.load"; output: false} enabled: selectedCell_slot1.value == 13}
                    Wire { from: "%surface%.pads.1"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows.15.load"; output: false} enabled: selectedCell_slot1.value == 14}
                    Wire { from: "%surface%.pads.1"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows.16.load"; output: false} enabled: selectedCell_slot1.value == 15}
                }

                //Load Slot 2
                WiresGroup {
                    enabled: selectedCell_slot2_state.description == "Empty"
                    Wire { from: "%surface%.pads.2"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows.1.load"; output: false} enabled: selectedCell_slot2.value == 0}
                    Wire { from: "%surface%.pads.2"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows.2.load"; output: false} enabled: selectedCell_slot2.value == 1}
                    Wire { from: "%surface%.pads.2"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows.3.load"; output: false} enabled: selectedCell_slot2.value == 2}
                    Wire { from: "%surface%.pads.2"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows.4.load"; output: false} enabled: selectedCell_slot2.value == 3}
                    Wire { from: "%surface%.pads.2"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows.5.load"; output: false} enabled: selectedCell_slot2.value == 4}
                    Wire { from: "%surface%.pads.2"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows.6.load"; output: false} enabled: selectedCell_slot2.value == 5}
                    Wire { from: "%surface%.pads.2"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows.7.load"; output: false} enabled: selectedCell_slot2.value == 6}
                    Wire { from: "%surface%.pads.2"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows.8.load"; output: false} enabled: selectedCell_slot2.value == 7}
                    Wire { from: "%surface%.pads.2"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows.9.load"; output: false} enabled: selectedCell_slot2.value == 8}
                    Wire { from: "%surface%.pads.2"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows.10.load"; output: false} enabled: selectedCell_slot2.value == 9}
                    Wire { from: "%surface%.pads.2"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows.11.load"; output: false} enabled: selectedCell_slot2.value == 10}
                    Wire { from: "%surface%.pads.2"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows.12.load"; output: false} enabled: selectedCell_slot2.value == 11}
                    Wire { from: "%surface%.pads.2"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows.13.load"; output: false} enabled: selectedCell_slot2.value == 12}
                    Wire { from: "%surface%.pads.2"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows.14.load"; output: false} enabled: selectedCell_slot2.value == 13}
                    Wire { from: "%surface%.pads.2"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows.15.load"; output: false} enabled: selectedCell_slot2.value == 14}
                    Wire { from: "%surface%.pads.2"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows.16.load"; output: false} enabled: selectedCell_slot2.value == 15}
                }

                //Load Slot 3
                WiresGroup {
                    enabled: selectedCell_slot3_state.description == "Empty"
                    Wire { from: "%surface%.pads.3"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows.1.load"; output: false} enabled: selectedCell_slot3.value == 0}
                    Wire { from: "%surface%.pads.3"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows.2.load"; output: false} enabled: selectedCell_slot3.value == 1}
                    Wire { from: "%surface%.pads.3"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows.3.load"; output: false} enabled: selectedCell_slot3.value == 2}
                    Wire { from: "%surface%.pads.3"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows.4.load"; output: false} enabled: selectedCell_slot3.value == 3}
                    Wire { from: "%surface%.pads.3"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows.5.load"; output: false} enabled: selectedCell_slot3.value == 4}
                    Wire { from: "%surface%.pads.3"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows.6.load"; output: false} enabled: selectedCell_slot3.value == 5}
                    Wire { from: "%surface%.pads.3"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows.7.load"; output: false} enabled: selectedCell_slot3.value == 6}
                    Wire { from: "%surface%.pads.3"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows.8.load"; output: false} enabled: selectedCell_slot3.value == 7}
                    Wire { from: "%surface%.pads.3"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows.9.load"; output: false} enabled: selectedCell_slot3.value == 8}
                    Wire { from: "%surface%.pads.3"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows.10.load"; output: false} enabled: selectedCell_slot3.value == 9}
                    Wire { from: "%surface%.pads.3"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows.11.load"; output: false} enabled: selectedCell_slot3.value == 10}
                    Wire { from: "%surface%.pads.3"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows.12.load"; output: false} enabled: selectedCell_slot3.value == 11}
                    Wire { from: "%surface%.pads.3"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows.13.load"; output: false} enabled: selectedCell_slot3.value == 12}
                    Wire { from: "%surface%.pads.3"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows.14.load"; output: false} enabled: selectedCell_slot3.value == 13}
                    Wire { from: "%surface%.pads.3"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows.15.load"; output: false} enabled: selectedCell_slot3.value == 14}
                    Wire { from: "%surface%.pads.3"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows.16.load"; output: false} enabled: selectedCell_slot3.value == 15}
                }

                //Load Slot 4
                WiresGroup {
                    enabled: selectedCell_slot4_state.description == "Empty"
                    Wire { from: "%surface%.pads.4"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows.1.load"; output: false} enabled: selectedCell_slot4.value == 0}
                    Wire { from: "%surface%.pads.4"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows.2.load"; output: false} enabled: selectedCell_slot4.value == 1}
                    Wire { from: "%surface%.pads.4"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows.3.load"; output: false} enabled: selectedCell_slot4.value == 2}
                    Wire { from: "%surface%.pads.4"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows.4.load"; output: false} enabled: selectedCell_slot4.value == 3}
                    Wire { from: "%surface%.pads.4"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows.5.load"; output: false} enabled: selectedCell_slot4.value == 4}
                    Wire { from: "%surface%.pads.4"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows.6.load"; output: false} enabled: selectedCell_slot4.value == 5}
                    Wire { from: "%surface%.pads.4"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows.7.load"; output: false} enabled: selectedCell_slot4.value == 6}
                    Wire { from: "%surface%.pads.4"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows.8.load"; output: false} enabled: selectedCell_slot4.value == 7}
                    Wire { from: "%surface%.pads.4"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows.9.load"; output: false} enabled: selectedCell_slot4.value == 8}
                    Wire { from: "%surface%.pads.4"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows.10.load"; output: false} enabled: selectedCell_slot4.value == 9}
                    Wire { from: "%surface%.pads.4"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows.11.load"; output: false} enabled: selectedCell_slot4.value == 10}
                    Wire { from: "%surface%.pads.4"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows.12.load"; output: false} enabled: selectedCell_slot4.value == 11}
                    Wire { from: "%surface%.pads.4"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows.13.load"; output: false} enabled: selectedCell_slot4.value == 12}
                    Wire { from: "%surface%.pads.4"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows.14.load"; output: false} enabled: selectedCell_slot4.value == 13}
                    Wire { from: "%surface%.pads.4"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows.15.load"; output: false} enabled: selectedCell_slot4.value == 14}
                    Wire { from: "%surface%.pads.4"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows.16.load"; output: false} enabled: selectedCell_slot4.value == 15}
                }
            }

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

            //LEDs
            Wire { from: "%surface%.pads.1";  to: ButtonScriptAdapter { brightness: recordedPatternSlot1 || (selectedCell_slot1_state.description == "Playing" && (selectedCell_slot1_playMode.description == "Looped" || (selectedCell_slot1_playMode.description == "OneShot" && selectedCell_slot1_color_ratio.value != 1))) ? bright : dimmed; color: selectedCell_slot1_state.description == "Empty" ? Color.Black : padLED(selectedCell_slot1_color.value) } }
            Wire { from: "%surface%.pads.2";  to: ButtonScriptAdapter { brightness: recordedPatternSlot2 || (selectedCell_slot2_state.description == "Playing" && (selectedCell_slot2_playMode.description == "Looped" || (selectedCell_slot2_playMode.description == "OneShot" && selectedCell_slot2_color_ratio.value != 1))) ? bright : dimmed; color: selectedCell_slot2_state.description == "Empty" ? Color.Black : padLED(selectedCell_slot2_color.value) } }
            Wire { from: "%surface%.pads.3";  to: ButtonScriptAdapter { brightness: recordedPatternSlot3 || (selectedCell_slot3_state.description == "Playing" && (selectedCell_slot3_playMode.description == "Looped" || (selectedCell_slot3_playMode.description == "OneShot" && selectedCell_slot3_color_ratio.value != 1))) ? bright : dimmed; color: selectedCell_slot3_state.description == "Empty" ? Color.Black : padLED(selectedCell_slot3_color.value) } }
            Wire { from: "%surface%.pads.4";  to: ButtonScriptAdapter { brightness: recordedPatternSlot4 || (selectedCell_slot4_state.description == "Playing" && (selectedCell_slot4_playMode.description == "Looped" || (selectedCell_slot4_playMode.description == "OneShot" && selectedCell_slot4_color_ratio.value != 1))) ? bright : dimmed; color: selectedCell_slot4_state.description == "Empty" ? Color.Black : padLED(selectedCell_slot4_color.value) } }

            //Delete Recorded Pattern
            Wire { from: "%surface%.pads.1"; to: InvokeActionAdapter { path: "app.traktor.decks." + deckId + ".remix.players.1.sequencer.delete_pattern"; output: false } }
            Wire { from: "%surface%.pads.2"; to: InvokeActionAdapter { path: "app.traktor.decks." + deckId + ".remix.players.2.sequencer.delete_pattern"; output: false } }
            Wire { from: "%surface%.pads.3"; to: InvokeActionAdapter { path: "app.traktor.decks." + deckId + ".remix.players.3.sequencer.delete_pattern"; output: false } }
            Wire { from: "%surface%.pads.4"; to: InvokeActionAdapter { path: "app.traktor.decks." + deckId + ".remix.players.4.sequencer.delete_pattern"; output: false } }

            //Stop Slot 1
            WiresGroup {
                enabled: selectedCell_slot1_state.description == "Playing" || selectedCell_slot1_state.description == "Waiting"
                Wire { from: "%surface%.pads.1"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows.1.stop"; output: false} enabled: selectedCell_slot1.value == 0}
                Wire { from: "%surface%.pads.1"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows.2.stop"; output: false} enabled: selectedCell_slot1.value == 1}
                Wire { from: "%surface%.pads.1"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows.3.stop"; output: false} enabled: selectedCell_slot1.value == 2}
                Wire { from: "%surface%.pads.1"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows.4.stop"; output: false} enabled: selectedCell_slot1.value == 3}
                Wire { from: "%surface%.pads.1"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows.5.stop"; output: false} enabled: selectedCell_slot1.value == 4}
                Wire { from: "%surface%.pads.1"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows.6.stop"; output: false} enabled: selectedCell_slot1.value == 5}
                Wire { from: "%surface%.pads.1"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows.7.stop"; output: false} enabled: selectedCell_slot1.value == 6}
                Wire { from: "%surface%.pads.1"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows.8.stop"; output: false} enabled: selectedCell_slot1.value == 7}
                Wire { from: "%surface%.pads.1"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows.9.stop"; output: false} enabled: selectedCell_slot1.value == 8}
                Wire { from: "%surface%.pads.1"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows.10.stop"; output: false} enabled: selectedCell_slot1.value == 9}
                Wire { from: "%surface%.pads.1"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows.11.stop"; output: false} enabled: selectedCell_slot1.value == 10}
                Wire { from: "%surface%.pads.1"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows.12.stop"; output: false} enabled: selectedCell_slot1.value == 11}
                Wire { from: "%surface%.pads.1"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows.13.stop"; output: false} enabled: selectedCell_slot1.value == 12}
                Wire { from: "%surface%.pads.1"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows.14.stop"; output: false} enabled: selectedCell_slot1.value == 13}
                Wire { from: "%surface%.pads.1"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows.15.stop"; output: false} enabled: selectedCell_slot1.value == 14}
                Wire { from: "%surface%.pads.1"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows.16.stop"; output: false} enabled: selectedCell_slot1.value == 15}
            }

            //Stop Slot 2
            WiresGroup {
                enabled: selectedCell_slot2_state.description == "Playing" || selectedCell_slot2_state.description == "Waiting"
                Wire { from: "%surface%.pads.2"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows.1.stop"; output: false} enabled: selectedCell_slot2.value == 0}
                Wire { from: "%surface%.pads.2"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows.2.stop"; output: false} enabled: selectedCell_slot2.value == 1}
                Wire { from: "%surface%.pads.2"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows.3.stop"; output: false} enabled: selectedCell_slot2.value == 2}
                Wire { from: "%surface%.pads.2"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows.4.stop"; output: false} enabled: selectedCell_slot2.value == 3}
                Wire { from: "%surface%.pads.2"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows.5.stop"; output: false} enabled: selectedCell_slot2.value == 4}
                Wire { from: "%surface%.pads.2"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows.6.stop"; output: false} enabled: selectedCell_slot2.value == 5}
                Wire { from: "%surface%.pads.2"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows.7.stop"; output: false} enabled: selectedCell_slot2.value == 6}
                Wire { from: "%surface%.pads.2"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows.8.stop"; output: false} enabled: selectedCell_slot2.value == 7}
                Wire { from: "%surface%.pads.2"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows.9.stop"; output: false} enabled: selectedCell_slot2.value == 8}
                Wire { from: "%surface%.pads.2"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows.10.stop"; output: false} enabled: selectedCell_slot2.value == 9}
                Wire { from: "%surface%.pads.2"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows.11.stop"; output: false} enabled: selectedCell_slot2.value == 10}
                Wire { from: "%surface%.pads.2"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows.12.stop"; output: false} enabled: selectedCell_slot2.value == 11}
                Wire { from: "%surface%.pads.2"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows.13.stop"; output: false} enabled: selectedCell_slot2.value == 12}
                Wire { from: "%surface%.pads.2"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows.14.stop"; output: false} enabled: selectedCell_slot2.value == 13}
                Wire { from: "%surface%.pads.2"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows.15.stop"; output: false} enabled: selectedCell_slot2.value == 14}
                Wire { from: "%surface%.pads.2"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows.16.stop"; output: false} enabled: selectedCell_slot2.value == 15}
            }

            //Stop Slot 3
            WiresGroup {
                enabled: selectedCell_slot3_state.description == "Playing" || selectedCell_slot3_state.description == "Waiting"
                Wire { from: "%surface%.pads.3"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows.1.stop"; output: false} enabled: selectedCell_slot3.value == 0}
                Wire { from: "%surface%.pads.3"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows.2.stop"; output: false} enabled: selectedCell_slot3.value == 1}
                Wire { from: "%surface%.pads.3"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows.3.stop"; output: false} enabled: selectedCell_slot3.value == 2}
                Wire { from: "%surface%.pads.3"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows.4.stop"; output: false} enabled: selectedCell_slot3.value == 3}
                Wire { from: "%surface%.pads.3"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows.5.stop"; output: false} enabled: selectedCell_slot3.value == 4}
                Wire { from: "%surface%.pads.3"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows.6.stop"; output: false} enabled: selectedCell_slot3.value == 5}
                Wire { from: "%surface%.pads.3"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows.7.stop"; output: false} enabled: selectedCell_slot3.value == 6}
                Wire { from: "%surface%.pads.3"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows.8.stop"; output: false} enabled: selectedCell_slot3.value == 7}
                Wire { from: "%surface%.pads.3"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows.9.stop"; output: false} enabled: selectedCell_slot3.value == 8}
                Wire { from: "%surface%.pads.3"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows.10.stop"; output: false} enabled: selectedCell_slot3.value == 9}
                Wire { from: "%surface%.pads.3"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows.11.stop"; output: false} enabled: selectedCell_slot3.value == 10}
                Wire { from: "%surface%.pads.3"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows.12.stop"; output: false} enabled: selectedCell_slot3.value == 11}
                Wire { from: "%surface%.pads.3"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows.13.stop"; output: false} enabled: selectedCell_slot3.value == 12}
                Wire { from: "%surface%.pads.3"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows.14.stop"; output: false} enabled: selectedCell_slot3.value == 13}
                Wire { from: "%surface%.pads.3"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows.15.stop"; output: false} enabled: selectedCell_slot3.value == 14}
                Wire { from: "%surface%.pads.3"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows.16.stop"; output: false} enabled: selectedCell_slot3.value == 15}
            }

            //Stop Slot 4
            WiresGroup {
                enabled: selectedCell_slot4_state.description == "Playing" || selectedCell_slot4_state.description == "Waiting"
                Wire { from: "%surface%.pads.4"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows.1.stop"; output: false} enabled: selectedCell_slot4.value == 0}
                Wire { from: "%surface%.pads.4"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows.2.stop"; output: false} enabled: selectedCell_slot4.value == 1}
                Wire { from: "%surface%.pads.4"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows.3.stop"; output: false} enabled: selectedCell_slot4.value == 2}
                Wire { from: "%surface%.pads.4"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows.4.stop"; output: false} enabled: selectedCell_slot4.value == 3}
                Wire { from: "%surface%.pads.4"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows.5.stop"; output: false} enabled: selectedCell_slot4.value == 4}
                Wire { from: "%surface%.pads.4"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows.6.stop"; output: false} enabled: selectedCell_slot4.value == 5}
                Wire { from: "%surface%.pads.4"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows.7.stop"; output: false} enabled: selectedCell_slot4.value == 6}
                Wire { from: "%surface%.pads.4"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows.8.stop"; output: false} enabled: selectedCell_slot4.value == 7}
                Wire { from: "%surface%.pads.4"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows.9.stop"; output: false} enabled: selectedCell_slot4.value == 8}
                Wire { from: "%surface%.pads.4"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows.10.stop"; output: false} enabled: selectedCell_slot4.value == 9}
                Wire { from: "%surface%.pads.4"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows.11.stop"; output: false} enabled: selectedCell_slot4.value == 10}
                Wire { from: "%surface%.pads.4"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows.12.stop"; output: false} enabled: selectedCell_slot4.value == 11}
                Wire { from: "%surface%.pads.4"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows.13.stop"; output: false} enabled: selectedCell_slot4.value == 12}
                Wire { from: "%surface%.pads.4"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows.14.stop"; output: false} enabled: selectedCell_slot4.value == 13}
                Wire { from: "%surface%.pads.4"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows.15.stop"; output: false} enabled: selectedCell_slot4.value == 14}
                Wire { from: "%surface%.pads.4"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows.16.stop"; output: false} enabled: selectedCell_slot4.value == 15}
            }

            //Delete Slot 1
            WiresGroup {
                enabled: selectedCell_slot1_state.description == "Loaded" || (selectedCell_slot1_state.description == "Playing" && selectedCell_slot1_playMode.description == "OneShot" && selectedCell_slot1_color_ratio.value == 1 && !recordedPatternSlot1)
                Wire { from: "%surface%.pads.1"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows.1.delete"; output: false} enabled: selectedCell_slot1.value == 0}
                Wire { from: "%surface%.pads.1"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows.2.delete"; output: false} enabled: selectedCell_slot1.value == 1}
                Wire { from: "%surface%.pads.1"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows.3.delete"; output: false} enabled: selectedCell_slot1.value == 2}
                Wire { from: "%surface%.pads.1"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows.4.delete"; output: false} enabled: selectedCell_slot1.value == 3}
                Wire { from: "%surface%.pads.1"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows.5.delete"; output: false} enabled: selectedCell_slot1.value == 4}
                Wire { from: "%surface%.pads.1"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows.6.delete"; output: false} enabled: selectedCell_slot1.value == 5}
                Wire { from: "%surface%.pads.1"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows.7.delete"; output: false} enabled: selectedCell_slot1.value == 6}
                Wire { from: "%surface%.pads.1"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows.8.delete"; output: false} enabled: selectedCell_slot1.value == 7}
                Wire { from: "%surface%.pads.1"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows.9.delete"; output: false} enabled: selectedCell_slot1.value == 8}
                Wire { from: "%surface%.pads.1"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows.10.delete"; output: false} enabled: selectedCell_slot1.value == 9}
                Wire { from: "%surface%.pads.1"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows.11.delete"; output: false} enabled: selectedCell_slot1.value == 10}
                Wire { from: "%surface%.pads.1"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows.12.delete"; output: false} enabled: selectedCell_slot1.value == 11}
                Wire { from: "%surface%.pads.1"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows.13.delete"; output: false} enabled: selectedCell_slot1.value == 12}
                Wire { from: "%surface%.pads.1"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows.14.delete"; output: false} enabled: selectedCell_slot1.value == 13}
                Wire { from: "%surface%.pads.1"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows.15.delete"; output: false} enabled: selectedCell_slot1.value == 14}
                Wire { from: "%surface%.pads.1"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.1.rows.16.delete"; output: false} enabled: selectedCell_slot1.value == 15}
            }

            //Delete Slot 2
            WiresGroup {
                enabled: selectedCell_slot2_state.description == "Loaded" || (selectedCell_slot2_state.description == "Playing" && selectedCell_slot2_playMode.description == "OneShot" && selectedCell_slot2_color_ratio.value == 1 && !recordedPatternSlot2)
                Wire { from: "%surface%.pads.2"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows.1.delete"; output: false} enabled: selectedCell_slot2.value == 0}
                Wire { from: "%surface%.pads.2"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows.2.delete"; output: false} enabled: selectedCell_slot2.value == 1}
                Wire { from: "%surface%.pads.2"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows.3.delete"; output: false} enabled: selectedCell_slot2.value == 2}
                Wire { from: "%surface%.pads.2"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows.4.delete"; output: false} enabled: selectedCell_slot2.value == 3}
                Wire { from: "%surface%.pads.2"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows.5.delete"; output: false} enabled: selectedCell_slot2.value == 4}
                Wire { from: "%surface%.pads.2"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows.6.delete"; output: false} enabled: selectedCell_slot2.value == 5}
                Wire { from: "%surface%.pads.2"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows.7.delete"; output: false} enabled: selectedCell_slot2.value == 6}
                Wire { from: "%surface%.pads.2"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows.8.delete"; output: false} enabled: selectedCell_slot2.value == 7}
                Wire { from: "%surface%.pads.2"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows.9.delete"; output: false} enabled: selectedCell_slot2.value == 8}
                Wire { from: "%surface%.pads.2"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows.10.delete"; output: false} enabled: selectedCell_slot2.value == 9}
                Wire { from: "%surface%.pads.2"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows.11.delete"; output: false} enabled: selectedCell_slot2.value == 10}
                Wire { from: "%surface%.pads.2"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows.12.delete"; output: false} enabled: selectedCell_slot2.value == 11}
                Wire { from: "%surface%.pads.2"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows.13.delete"; output: false} enabled: selectedCell_slot2.value == 12}
                Wire { from: "%surface%.pads.2"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows.14.delete"; output: false} enabled: selectedCell_slot2.value == 13}
                Wire { from: "%surface%.pads.2"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows.15.delete"; output: false} enabled: selectedCell_slot2.value == 14}
                Wire { from: "%surface%.pads.2"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.2.rows.16.delete"; output: false} enabled: selectedCell_slot2.value == 15}
            }
            //Delete Slot 3
            WiresGroup {
                enabled: selectedCell_slot3_state.description == "Loaded" || (selectedCell_slot3_state.description == "Playing" && selectedCell_slot3_playMode.description == "OneShot" && selectedCell_slot3_color_ratio.value == 1 && !recordedPatternSlot3)
                Wire { from: "%surface%.pads.3"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows.1.delete"; output: false} enabled: selectedCell_slot3.value == 0}
                Wire { from: "%surface%.pads.3"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows.2.delete"; output: false} enabled: selectedCell_slot3.value == 1}
                Wire { from: "%surface%.pads.3"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows.3.delete"; output: false} enabled: selectedCell_slot3.value == 2}
                Wire { from: "%surface%.pads.3"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows.4.delete"; output: false} enabled: selectedCell_slot3.value == 3}
                Wire { from: "%surface%.pads.3"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows.5.delete"; output: false} enabled: selectedCell_slot3.value == 4}
                Wire { from: "%surface%.pads.3"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows.6.delete"; output: false} enabled: selectedCell_slot3.value == 5}
                Wire { from: "%surface%.pads.3"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows.7.delete"; output: false} enabled: selectedCell_slot3.value == 6}
                Wire { from: "%surface%.pads.3"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows.8.delete"; output: false} enabled: selectedCell_slot3.value == 7}
                Wire { from: "%surface%.pads.3"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows.9.delete"; output: false} enabled: selectedCell_slot3.value == 8}
                Wire { from: "%surface%.pads.3"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows.10.delete"; output: false} enabled: selectedCell_slot3.value == 9}
                Wire { from: "%surface%.pads.3"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows.11.delete"; output: false} enabled: selectedCell_slot3.value == 10}
                Wire { from: "%surface%.pads.3"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows.12.delete"; output: false} enabled: selectedCell_slot3.value == 11}
                Wire { from: "%surface%.pads.3"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows.13.delete"; output: false} enabled: selectedCell_slot3.value == 12}
                Wire { from: "%surface%.pads.3"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows.14.delete"; output: false} enabled: selectedCell_slot3.value == 13}
                Wire { from: "%surface%.pads.3"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows.15.delete"; output: false} enabled: selectedCell_slot3.value == 14}
                Wire { from: "%surface%.pads.3"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.3.rows.16.delete"; output: false} enabled: selectedCell_slot3.value == 15}
            }

            //Delete Slot 4
            WiresGroup {
                enabled: selectedCell_slot4_state.description == "Loaded" || (selectedCell_slot4_state.description == "Playing" && selectedCell_slot4_playMode.description == "OneShot" && selectedCell_slot4_color_ratio.value == 1 && !recordedPatternSlot4)
                Wire { from: "%surface%.pads.4"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows.1.delete"; output: false} enabled: selectedCell_slot4.value == 0}
                Wire { from: "%surface%.pads.4"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows.2.delete"; output: false} enabled: selectedCell_slot4.value == 1}
                Wire { from: "%surface%.pads.4"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows.3.delete"; output: false} enabled: selectedCell_slot4.value == 2}
                Wire { from: "%surface%.pads.4"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows.4.delete"; output: false} enabled: selectedCell_slot4.value == 3}
                Wire { from: "%surface%.pads.4"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows.5.delete"; output: false} enabled: selectedCell_slot4.value == 4}
                Wire { from: "%surface%.pads.4"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows.6.delete"; output: false} enabled: selectedCell_slot4.value == 5}
                Wire { from: "%surface%.pads.4"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows.7.delete"; output: false} enabled: selectedCell_slot4.value == 6}
                Wire { from: "%surface%.pads.4"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows.8.delete"; output: false} enabled: selectedCell_slot4.value == 7}
                Wire { from: "%surface%.pads.4"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows.9.delete"; output: false} enabled: selectedCell_slot4.value == 8}
                Wire { from: "%surface%.pads.4"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows.10.delete"; output: false} enabled: selectedCell_slot4.value == 9}
                Wire { from: "%surface%.pads.4"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows.11.delete"; output: false} enabled: selectedCell_slot4.value == 10}
                Wire { from: "%surface%.pads.4"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows.12.delete"; output: false} enabled: selectedCell_slot4.value == 11}
                Wire { from: "%surface%.pads.4"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows.13.delete"; output: false} enabled: selectedCell_slot4.value == 12}
                Wire { from: "%surface%.pads.4"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows.14.delete"; output: false} enabled: selectedCell_slot4.value == 13}
                Wire { from: "%surface%.pads.4"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows.15.delete"; output: false} enabled: selectedCell_slot4.value == 14}
                Wire { from: "%surface%.pads.4"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.cell.columns.4.rows.16.delete"; output: false} enabled: selectedCell_slot4.value == 15}
            }

            //Mute Slots
            Wire { from: "%surface%.pads.1";  to: TogglePropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.players.1.muted"; value: false; defaultValue: true; color: selectedCell_slot1_state.description == "Empty" ? Color.Black : padLED(selectedCell_slot1_color.value) } }
            Wire { from: "%surface%.pads.2";  to: TogglePropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.players.2.muted"; value: false; defaultValue: true; color: selectedCell_slot2_state.description == "Empty" ? Color.Black : padLED(selectedCell_slot2_color.value) } }
            Wire { from: "%surface%.pads.3";  to: TogglePropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.players.3.muted"; value: false; defaultValue: true; color: selectedCell_slot3_state.description == "Empty" ? Color.Black : padLED(selectedCell_slot3_color.value) } }
            Wire { from: "%surface%.pads.4";  to: TogglePropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.players.4.muted"; value: false; defaultValue: true; color: selectedCell_slot4_state.description == "Empty" ? Color.Black : padLED(selectedCell_slot4_color.value) } }
        }
    }

    function padLED(colorId) {
        if (colorId == 1) return Color.Red
        else if (colorId == 2) return Color.DarkOrange
        else if (colorId == 3) return Color.LightOrange
        else if (colorId == 4) return Color.WarmYellow
        else if (colorId == 5) return Color.Yellow
        else if (colorId == 6) return Color.Lime
        else if (colorId == 7) return Color.Green
        else if (colorId == 8) return Color.Mint
        else if (colorId == 9) return Color.Cyan
        else if (colorId == 10) return Color.Turquoise
        else if (colorId == 11) return Color.Blue
        else if (colorId == 12) return Color.Plum
        else if (colorId == 13) return Color.Violet
        else if (colorId == 14) return Color.Purple
        else if (colorId == 15) return Color.Magenta
        else if (colorId == 16) return Color.Fuchsia
        else return Color.Black
    }
}
