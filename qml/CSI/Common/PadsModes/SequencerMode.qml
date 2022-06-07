import CSI 1.0
import QtQuick 2.12

import "../../../Defines"

Module {
    id: module
    property bool active: true
    property int deckId: 1 //1-4
    property string surface: "path"

    AppProperty { id: current_step_slot1; path: "app.traktor.decks." + deckId + ".remix.players.1.sequencer.current_step" }
    AppProperty { id: current_step_slot2; path: "app.traktor.decks." + deckId + ".remix.players.2.sequencer.current_step" }
    AppProperty { id: current_step_slot3; path: "app.traktor.decks." + deckId + ".remix.players.3.sequencer.current_step" }
    AppProperty { id: current_step_slot4; path: "app.traktor.decks." + deckId + ".remix.players.4.sequencer.current_step" }

    AppProperty { id: pattern_length_slot1; path: "app.traktor.decks." + deckId + ".remix.players.1.sequencer.pattern_length" }
    AppProperty { id: pattern_length_slot2; path: "app.traktor.decks." + deckId + ".remix.players.2.sequencer.pattern_length" }
    AppProperty { id: pattern_length_slot3; path: "app.traktor.decks." + deckId + ".remix.players.3.sequencer.pattern_length" }
    AppProperty { id: pattern_length_slot4; path: "app.traktor.decks." + deckId + ".remix.players.4.sequencer.pattern_length" }

    RemixDeckStepSequencer { name: "remix_sequencer"; channel: deckId; size: RemixDeck.Small }

    DirectPropertyAdapter { name: "sequencerSlot"; path: deckPropertiesPath + ".sequencerSlot" }
    Wire { from: "sequencerSlot.read"; to: "remix_sequencer.slot.write" }
    DirectPropertyAdapter { name: "sequencerPage"; path: deckPropertiesPath + ".sequencerPage" }
    Wire { from: "sequencerPage.read"; to: "remix_sequencer.page.write" }

    WiresGroup {
        enabled: active

        WiresGroup {
            enabled: !shift

            Wire { from: "%surface%.pads.1"; to: "remix_sequencer.1_1.steps" }
            Wire { from: "%surface%.pads.2"; to: "remix_sequencer.2_1.steps" }
            Wire { from: "%surface%.pads.3"; to: "remix_sequencer.3_1.steps" }
            Wire { from: "%surface%.pads.4"; to: "remix_sequencer.4_1.steps" }
            Wire { from: "%surface%.pads.5"; to: "remix_sequencer.1_2.steps" }
            Wire { from: "%surface%.pads.6"; to: "remix_sequencer.2_2.steps" }
            Wire { from: "%surface%.pads.7"; to: "remix_sequencer.3_2.steps" }
            Wire { from: "%surface%.pads.8"; to: "remix_sequencer.4_2.steps" }

            Wire { from: "remix_sequencer.1_1"; to: "%surface%.pads.1.led" }
            Wire { from: "remix_sequencer.2_1"; to: "%surface%.pads.2.led" }
            Wire { from: "remix_sequencer.3_1"; to: "%surface%.pads.3.led" }
            Wire { from: "remix_sequencer.4_1"; to: "%surface%.pads.4.led" }
            Wire { from: "remix_sequencer.1_2"; to: "%surface%.pads.5.led" }
            Wire { from: "remix_sequencer.2_2"; to: "%surface%.pads.6.led" }
            Wire { from: "remix_sequencer.3_2"; to: "%surface%.pads.7.led" }
            Wire { from: "remix_sequencer.4_2"; to: "%surface%.pads.8.led" }
        }

        WiresGroup {
            enabled: shift

            Wire { from: "%surface%.pads.1"; to: ButtonScriptAdapter { color: Color.White; brightness: (sequencerPage.value == 1 && sequencerSlot.value == 1) ? 1 : 0; onPress: {sequencerSlot.value = 1; sequencerPage.value = 1; footerPage.value = FooterPage.slot1 } } }
            Wire { from: "%surface%.pads.2"; to: ButtonScriptAdapter { color: Color.White; brightness: (sequencerPage.value == 1 && sequencerSlot.value == 2) ? 1 : 0; onPress: {sequencerSlot.value = 2; sequencerPage.value = 1; footerPage.value = FooterPage.slot2 } } }
            Wire { from: "%surface%.pads.3"; to: ButtonScriptAdapter { color: Color.White; brightness: (sequencerPage.value == 1 && sequencerSlot.value == 3) ? 1 : 0; onPress: {sequencerSlot.value = 3; sequencerPage.value = 1; footerPage.value = FooterPage.slot3 } } }
            Wire { from: "%surface%.pads.4"; to: ButtonScriptAdapter { color: Color.White; brightness: (sequencerPage.value == 1 && sequencerSlot.value == 4) ? 1 : 0; onPress: {sequencerSlot.value = 4; sequencerPage.value = 1; footerPage.value = FooterPage.slot4 } } }
            Wire { from: "%surface%.pads.5"; to: ButtonScriptAdapter { color: Color.White; brightness: (sequencerPage.value == 2 && sequencerSlot.value == 1) ? 1 : 0; onPress: {sequencerSlot.value = 1; sequencerPage.value = 2; footerPage.value = FooterPage.slot1 } } enabled: pattern_length_slot1.value > 8 }
            Wire { from: "%surface%.pads.6"; to: ButtonScriptAdapter { color: Color.White; brightness: (sequencerPage.value == 2 && sequencerSlot.value == 2) ? 1 : 0; onPress: {sequencerSlot.value = 2; sequencerPage.value = 2; footerPage.value = FooterPage.slot2 } } enabled: pattern_length_slot2.value > 8 }
            Wire { from: "%surface%.pads.7"; to: ButtonScriptAdapter { color: Color.White; brightness: (sequencerPage.value == 2 && sequencerSlot.value == 3) ? 1 : 0; onPress: {sequencerSlot.value = 3; sequencerPage.value = 2; footerPage.value = FooterPage.slot3 } } enabled: pattern_length_slot3.value > 8 }
            Wire { from: "%surface%.pads.8"; to: ButtonScriptAdapter { color: Color.White; brightness: (sequencerPage.value == 2 && sequencerSlot.value == 4) ? 1 : 0; onPress: {sequencerSlot.value = 4; sequencerPage.value = 2; footerPage.value = FooterPage.slot4 } } enabled: pattern_length_slot4.value > 8 }
        }
    }
}
