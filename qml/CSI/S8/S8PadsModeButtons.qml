import CSI 1.0
import QtQuick 2.12

import "../../Defines"
import "../../Helpers/LED.js" as LED

Module {
    id: module
    property bool active: true
    property int deckId: 1 //1-4
    property string surface: "path"

    //Freeze Slice PopUp + Freeze/Effects Mode
    ButtonScriptAdapter {
        name: "FreezeButton"
        brightness: (activePadsMode.value == PadsMode.freeze && freezeButton.value == 0) || (activePadsMode.value == PadsMode.effects && freezeButton.value == 1)
        color: LED.legacy(deckId)
        onPress: {
            holdFreeze_countdown.restart()
        }
        onRelease: {
            if (holdFreeze_countdown.running) {
                if (hasDeckProperties && activePadsMode.value != PadsMode.freeze && !shift && freezeButton.value == 0) activePadsMode.value = PadsMode.freeze
                else if (hasDeckProperties && activePadsMode.value == PadsMode.freeze && !shift && freezeButton.value == 0) activePadsMode.value = deck.defaultPadsMode()
                else if (!shift && freezeButton.value == 1) activePadsMode.value = PadsMode.effects
            }
            holdFreeze_countdown.stop()
            holdFreeze.value = false
        }
    }
    Timer { id: holdFreeze_countdown; interval: holdTimer.value
        onTriggered: {
            if (hasDeckProperties) holdFreeze.value = true
        }
    }

    //Remix Capture Source + Remix/Legacy Remix Mode
    ButtonScriptAdapter {
        name: "RemixButton"
        brightness: (activePadsMode.value == PadsMode.legacyRemix && legacyRemixMode.value) || (activePadsMode.value == PadsMode.remix && !legacyRemixMode.value)
        color: LED.legacy(deckId)
        onPress: {
            holdRemix_countdown.restart()
        }
        onRelease: {
            if (holdRemix_countdown.running) {
                if ((legacyRemixMode.value && activePadsMode.value != PadsMode.legacyRemix) || (!legacyRemixMode.value && activePadsMode.value == PadsMode.remix)) activePadsMode.value = PadsMode.legacyRemix
                else if ((!legacyRemixMode.value && activePadsMode.value != PadsMode.remix ) || (legacyRemixMode.value && activePadsMode.value == PadsMode.legacyRemix)) activePadsMode.value = PadsMode.remix
            }
            holdRemix_countdown.stop()
            holdRemix.value = false
        }
    }
    Timer { id: holdRemix_countdown; interval: holdTimer.value
        onTriggered: {
            if (remixControlled && hasRemixProperties) holdRemix.value = true
        }
    }

    WiresGroup {
        enabled: !directThru.value

        //Pads Mode
        WiresGroup {
            enabled: deck.active
            //Hotcue Mode
            Wire { from: "%surface%.hotcue"; to: SetPropertyAdapter { path: activePadsMode.path; value: PadsMode.hotcues; color: LED.legacy(deckId) } enabled: !shift && hasTrackProperties }
            Wire { from: "%surface%.hotcue"; to: SetPropertyAdapter { path: activePadsMode.path; value: PadsMode.tonePlay; color: LED.legacy(deckId) } enabled: shift && hasTrackProperties }

            //Loop Modes
            Wire { from: "%surface%.loop"; to: SetPropertyAdapter { path: activePadsMode.path; value: PadsMode.loop; color: LED.legacy(deckId) } enabled: hasDeckProperties && (!shift && loopButton.value == 0) || (shift && shiftLoopButton.value == 0) }
            Wire { from: "%surface%.loop"; to: SetPropertyAdapter { path: activePadsMode.path; value: PadsMode.advancedLoop; color: LED.legacy(deckId) } enabled: hasDeckProperties && (!shift && loopButton.value == 1) || (shift && shiftLoopButton.value == 1) }
            Wire { from: "%surface%.loop"; to: SetPropertyAdapter { path: activePadsMode.path; value: PadsMode.loopRoll; color: LED.legacy(deckId) } enabled: hasDeckProperties && (!shift && loopButton.value == 2) || (shift && shiftLoopButton.value == 2) }

            //Freeze Button
            Wire { from: "%surface%.freeze"; to: "FreezeButton"; enabled: !shift && ((hasDeckProperties && padsMode.value != PadsMode.freeze && freezeButton.value == 0) || (hasDeckProperties && padsMode.value == PadsMode.freeze && freezeButton.value == 0) || freezeButton.value == 1) }
            WiresGroup {
                enabled: shift
                Wire { from: "%surface%.freeze"; to: SetPropertyAdapter { path: activePadsMode.path; value: PadsMode.freeze; output: false } enabled: hasDeckProperties && padsMode.value != PadsMode.freeze && shiftFreezeButton.value == 0 }
                Wire { from: "%surface%.freeze"; to: SetPropertyAdapter { path: activePadsMode.path; value: defaultPadsMode(); output: false } enabled: hasDeckProperties && padsMode.value == PadsMode.freeze && shiftFreezeButton.value == 0 }
                Wire { from: "%surface%.freeze"; to: ButtonScriptAdapter { brightness: activePadsMode.value == PadsMode.freeze; color: LED.legacy(deckId) } enabled: hasDeckProperties && shiftFreezeButton.value == 0 }
                Wire { from: "%surface%.freeze"; to: SetPropertyAdapter { path: activePadsMode.path; value: PadsMode.effects; color: LED.legacy(deckId) } enabled: shiftFreezeButton.value == 1 }
            }

            //Sequencer Mode
            Wire { from: "%surface%.remix"; to: SetPropertyAdapter { path: activePadsMode.path; value: PadsMode.sequencer; color: LED.legacy(deckId) } enabled: shift && hasRemixProperties }
        }
        WiresGroup {
            enabled: deck.remixControlled

            //Remix Mode (even if deck is in DirectThru and the other one is a Remix Deck, it's best to disable it and to control it from its own deck)
            Wire { from: "%surface%.remix"; to: "RemixButton"; enabled: !shift && hasRemixProperties }
        }
    }
}
