import CSI 1.0
import QtQuick 2.12

import "../../Defines"
import "../../Helpers/LED.js" as LED //Dev stuff only

Module {
    id: module
    property bool active: true
    property int deckId: 1 //1-4
    property string surface: "path"

    AppProperty { id: directThru; path: "app.traktor.decks." + deckId + ".direct_thru" }

    //Remix Controlled Samples + Remix/Legacy Remix Mode
    ButtonScriptAdapter {
        name: "SamplesButton"
        brightness: (activePadsMode.value == PadsMode.legacyRemix && legacyRemixMode.value) || (activePadsMode.value == PadsMode.remix && !legacyRemixMode.value)
        color: footerDeck().deckLEDColor
        onPress: {
            holdSamples_countdown.restart()
        }
        onRelease: {
            if (holdSamples_countdown.running) {
                if ((legacyRemixMode.value && activePadsMode.value != PadsMode.legacyRemix) || (!legacyRemixMode.value && activePadsMode.value == PadsMode.remix)) activePadsMode.value = PadsMode.legacyRemix
                else if ((!legacyRemixMode.value && activePadsMode.value != PadsMode.remix ) || (legacyRemixMode.value && activePadsMode.value == PadsMode.legacyRemix)) activePadsMode.value = PadsMode.remix
            }
            holdSamples_countdown.stop()
            holdSamples.value = false
        }
    }
    Timer { id: holdSamples_countdown; interval: holdTimer.value
        onTriggered: {
            if (remixControlled && hasRemixProperties) holdSamples.value = true
        }
    }

    WiresGroup {
        enabled: !directThru.value

        //Pads Mode
        WiresGroup {
            enabled: deck.active

            //Hotcue Mode
            Wire { from: "%surface%.hotcues"; to: SetPropertyAdapter { path: activePadsMode.path; value: PadsMode.hotcues; color: deckLEDColor } enabled: hasTrackProperties && !shift }
            Wire { from: "%surface%.hotcues"; to: SetPropertyAdapter { path: activePadsMode.path; value: PadsMode.tonePlay; color: deckLEDColor } enabled: hasTrackProperties && (shift && shiftHotcueButton.value == 3) }

            //Loop Modes
            Wire { from: "%surface%.hotcues"; to: SetPropertyAdapter { path: activePadsMode.path; value: PadsMode.loop; color: deckLEDColor } enabled: hasDeckProperties && (shift && shiftHotcueButton.value == 0) }
            Wire { from: "%surface%.hotcues"; to: SetPropertyAdapter { path: activePadsMode.path; value: PadsMode.advancedLoop; color: deckLEDColor } enabled: hasDeckProperties && (shift && shiftHotcueButton.value == 1) }
            Wire { from: "%surface%.hotcues"; to: SetPropertyAdapter { path: activePadsMode.path; value: PadsMode.loopRoll; color: deckLEDColor } enabled: hasDeckProperties && (shift && shiftHotcueButton.value == 2) }

            WiresGroup {
                enabled: holdGrid.value
                Wire { from: "%surface%.samples"; to: SetPropertyAdapter { path: activePadsMode.path; value: PadsMode.freeze; output: false } enabled: hasDeckProperties && padsMode.value != PadsMode.freeze }
                Wire { from: "%surface%.samples"; to: SetPropertyAdapter { path: activePadsMode.path; value: defaultPadsMode(); output: false } enabled: hasDeckProperties && padsMode.value == PadsMode.freeze }
                Wire { from: "%surface%.samples"; to: ButtonScriptAdapter { brightness: activePadsMode.value == PadsMode.freeze; color: deckLEDColor } enabled: hasDeckProperties }
            }
            Wire { from: "%surface%.samples"; to: SetPropertyAdapter { path: activePadsMode.path; value: PadsMode.sequencer; color: deckLEDColor } enabled: shift && hasRemixProperties && !holdGrid.value }

            Wire { from: "%surface%.stems"; to: SetPropertyAdapter { path: activePadsMode.path; value: PadsMode.effects; color: deckLEDColor } enabled: (!shift && stemsButton.value == 1) || (shift && shiftStemsButton.value == 1) }

            //Dev Stuff
            Wire { from: "%surface%.hotcue"; to: SetPropertyAdapter { path: activePadsMode.path; value: PadsMode.hotcues; color: deckLEDColor } enabled: hasTrackProperties && !shift }
            WiresGroup {
                enabled: holdGrid.value
                Wire { from: "%surface%.remix"; to: SetPropertyAdapter { path: activePadsMode.path; value: PadsMode.freeze; output: false } enabled: hasDeckProperties && padsMode.value != PadsMode.freeze }
                Wire { from: "%surface%.remix"; to: SetPropertyAdapter { path: activePadsMode.path; value: defaultPadsMode(); output: false } enabled: hasDeckProperties && padsMode.value == PadsMode.freeze }
                Wire { from: "%surface%.remix"; to: ButtonScriptAdapter { brightness: activePadsMode.value == PadsMode.freeze; color: LED.legacy(deckId) } enabled: hasDeckProperties }
            }
            Wire { from: "%surface%.remix"; to: SetPropertyAdapter { path: activePadsMode.path; value: PadsMode.sequencer; color: LED.legacy(deckId) } enabled: shift && hasRemixProperties && !holdGrid.value }
            Wire { from: "%surface%.freeze"; to: SetPropertyAdapter { path: activePadsMode.path; value: PadsMode.effects; color: LED.legacy(deckId) } enabled: (!shift && stemsButton.value == 1) || (shift && shiftStemsButton.value == 1) }
        }
        WiresGroup {
            enabled: deck.footerControlled
            //Remix Mode (even if deck is in DirectThru and the other one is a Remix Deck, it's best to disable it and to control it from its own deck)
            Wire { from: "%surface%.samples"; to: "SamplesButton"; enabled: !shift && hasRemixProperties && !holdGrid.value}
            Wire { from: "%surface%.stems"; to: SetPropertyAdapter { path: activePadsMode.path; value: PadsMode.stems; color: footerDeck().deckLEDColor } enabled: hasStemProperties && ((!shift && stemsButton.value == 0) || (shift && shiftStemsButton.value == 0)) }

            //Dev Stuff
            Wire { from: "%surface%.remix"; to: "SamplesButton"; enabled: !shift && hasRemixProperties && !holdGrid.value}
            Wire { from: "%surface%.loop"; to: SetPropertyAdapter { path: activePadsMode.path; value: PadsMode.stems; color: LED.legacy(deckId) } } //enabled: hasStemProperties && ((!shift && stemsButton.value == 0) || (shift && shiftStemsButton.value == 0)) }
        }
    }
}
