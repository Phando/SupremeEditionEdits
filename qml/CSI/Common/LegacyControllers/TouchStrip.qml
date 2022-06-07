import CSI 1.0
import QtQuick 2.12

import "../../../Defines"
import "../../Common"

Module {
    id: module
    property bool active: true
    property int deckId: 1 //1-4
    property string surface: "path"

    Scratch { name: "scratch"; channel: deckId; ledBarSize: 25 }
    TempoBend { name: "tempo_bend"; channel: deckId; ledBarSize: 25 }
    TouchstripTrackSeek { name: "track_seek"; channel: deckId; ledBarSize: 25 }

    DirectPropertyAdapter { name: "bend_bensitivity"; path: "mapping.settings.touchstrip_bend_sensitivity"; input: false }
    DirectPropertyAdapter { name: "bend_invert"; path: "mapping.settings.touchstrip_bend_invert"; input: false }
    DirectPropertyAdapter { name: "scratch_sensitivity"; path: "mapping.settings.touchstrip_scratch_sensitivity"; input: false }
    DirectPropertyAdapter { name: "scratch_invert"; path: "mapping.settings.touchstrip_scratch_invert"; input: false }
    Wire { from: "bend_bensitivity"; to: "tempo_bend.sensitivity" }
    Wire { from: "bend_invert"; to: "tempo_bend.invert" }
    Wire { from: "scratch_sensitivity"; to: "scratch.sensitivity" }
    Wire { from: "scratch_invert"; to: "scratch.invert" }

    WiresGroup {
        enabled: active

        WiresGroup {
            enabled: !loopInAdjust.value && !loopOutAdjust.value

            //Nudge
            WiresGroup {
                enabled: !shift && isRunning.value
                Wire { from: "%surface%.touchstrip"; to: "tempo_bend" }
                Wire { from: "%surface%.touchstrip.leds"; to: "tempo_bend.leds"; enabled: !beatmatchPracticeMode.value }
            }

            //Scratch
            WiresGroup {
                enabled: (!shift && !isRunning.value) || (shift && (scratchWithTouchstrip.value || (!scratchWithTouchstrip.value && deck.deckType == DeckType.Remix)))
                Wire { from: "%surface%.touchstrip"; to: "scratch" }
                Wire { from: "%surface%.touchstrip.leds"; to: "scratch.leds" } //Replace in the future with a 3 bright LED blue indicator of the finger position, and the others blue dimmed
            }

            //Track Seek Position
            WiresGroup {
                enabled: shift && !scratchWithTouchstrip.value && deck.deckType != DeckType.Remix
                Wire { from: "%surface%.touchstrip"; to: "track_seek" }
                //Wire { from: "%surface%.touchstrip.leds"; to: "track_seek.leds" } //Replace in the future with the scratch.leds style
                Wire { from: "%surface%.touchstrip.leds"; to: "scratch.leds" } //temporary solution
            }
        }

        Wire {
            enabled: loopInAdjust.value || loopOutAdjust.value
            from: "%surface%.touchstrip";
            to: EncoderScriptAdapter {
                onIncrement: {

                    const minimalTickValue = 0.001;
                    if (value < -minimalTickValue || value > minimalTickValue) {
                        moveMode.value = loopInAdjust.value ? 2 : 3
                        moveSize.value = 0 //TODO: if speed > parameter, do fine adjustments instead of xFine
                        move.value = 1
                    }
                }
                onDecrement: {
                    const minimalTickValue = 0.001;
                    if (value < -minimalTickValue || value > minimalTickValue) {
                        moveMode.value = loopInAdjust.value ? 2 : 3
                        moveSize.value = 0 //TODO: if speed > parameter, do fine adjustments instead of xFine
                        move.value = -1
                    }
                }
            }
        }
    }
}
