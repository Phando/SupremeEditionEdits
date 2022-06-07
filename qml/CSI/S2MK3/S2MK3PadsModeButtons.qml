import CSI 1.0
import QtQuick 2.12

import "../../Defines"
import "../../Helpers/LED.js" as LED

Module {
    id: module
    property bool active: true
    property int deckId: 1 //1-4
    property string surface: "path"

    //Remix Capture Source + Remix/Legacy Remix Mode
    ButtonScriptAdapter {
        name: "SamplesButton"
        brightness: (activePadsMode.value == PadsMode.legacyRemix && legacyRemixMode.value) || (activePadsMode.value == PadsMode.remix && !legacyRemixMode.value)
        color: LED.custom(deckId)
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

    //property bool holdKeyLock: true

    WiresGroup {
        enabled: !directThru.value

        WiresGroup {
            enabled: active

            //Hotcue Button
            WiresGroup {
                enabled: !holdGrid.value && !holdKeyLock
                Wire { from: "%surface%.hotcues"; to: SetPropertyAdapter { path: activePadsMode.path; value: PadsMode.hotcues; color: LED.custom(deckId) } enabled: hasTrackProperties && (!shift || (shift && shiftHotcueButton.value == 0))  }
                Wire { from: "%surface%.hotcues"; to: SetPropertyAdapter { path: activePadsMode.path; value: PadsMode.loop; color: LED.custom(deckId) } enabled: hasDeckProperties && (shift && shiftHotcueButton.value == 1) }
                Wire { from: "%surface%.hotcues"; to: SetPropertyAdapter { path: activePadsMode.path; value: PadsMode.advancedLoop; color: LED.custom(deckId) } enabled: hasDeckProperties && (shift && shiftHotcueButton.value == 2) }
                Wire { from: "%surface%.hotcues"; to: SetPropertyAdapter { path: activePadsMode.path; value: PadsMode.loopRoll; color: LED.custom(deckId) } enabled: hasDeckProperties && (shift && shiftHotcueButton.value == 3) }
                Wire { from: "%surface%.hotcues"; to: SetPropertyAdapter { path: activePadsMode.path; value: PadsMode.effects; color: LED.custom(deckId) } enabled: shift && shiftHotcueButton.value == 4 }
            }
            WiresGroup {
                enabled: holdGrid.value
                Wire { from: "%surface%.hotcues"; to: SetPropertyAdapter { path: activePadsMode.path; value: PadsMode.freeze; output: false } enabled: hasDeckProperties && padsMode.value != PadsMode.freeze }
                Wire { from: "%surface%.hotcues"; to: SetPropertyAdapter { path: activePadsMode.path; value: defaultPadsMode(); output: false } enabled: hasDeckProperties && padsMode.value == PadsMode.freeze }
                Wire { from: "%surface%.hotcues"; to: ButtonScriptAdapter { brightness: activePadsMode.value == PadsMode.freeze; color: LED.custom(deckId) } enabled: hasDeckProperties }
            }
            Wire { from: "%surface%.hotcues"; to: SetPropertyAdapter { path: activePadsMode.path; value: PadsMode.tonePlay; color: LED.custom(deckId) } enabled: hasTrackProperties && holdKeyLock }

            //Samples Button
            Wire { from: "%surface%.samples"; to: SetPropertyAdapter { path: activePadsMode.path; value: PadsMode.sequencer; color: LED.custom(deckId) } enabled: hasRemixProperties && !holdGrid.value && shift }
        }
        WiresGroup {
            enabled: footerControlled && !holdGrid.value
            //Remix Mode (even if deck is in DirectThru and the other one is a Remix Deck, it's best to disable it and to control it from its own deck)
            Wire { from: "%surface%.samples"; to: "SamplesButton"; enabled: hasRemixProperties && !shift }
            Wire { from: "%surface%.samples"; to: SetPropertyAdapter { path: activePadsMode.path; value: PadsMode.stems; color: LED.custom(side.deckId) } enabled: hasStemProperties } // && ((!shift && stemsButton.value == 1) || (shift && shiftStemsButton.value == 1)) }
        }
    }
}
