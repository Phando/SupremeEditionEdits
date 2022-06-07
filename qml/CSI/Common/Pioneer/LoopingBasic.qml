import CSI 1.0
import QtQuick 2.12

import "../../../Defines"

Module {
    id: module
    property bool active: true
    property int deckId: 1

    XDJLoop { name: "loop"; channel: deckId; }

    AppProperty { id: activeCueLength; path: "app.traktor.decks." + deckId + ".track.cue.active.length" }

    Blinker { name: "Reloop"; cycle: 500; defaultBrightness: bright }
    Blinker { name: "LoopInBlinker"; cycle: 500; defaultBrightness: bright; blinkBrightness: dimmed }
    Blinker { name: "LoopInAdjustBlinker"; cycle: 250; defaultBrightness: bright; blinkBrightness: dimmed }
    Blinker { name: "LoopOutBlinker"; cycle: 500; defaultBrightness: bright; blinkBrightness: dimmed }
    Blinker { name: "LoopOutAdjustBlinker"; cycle: 250; defaultBrightness: bright; blinkBrightness: dimmed }
    Wire { from: "LoopInBlinker.trigger"; to: ExpressionAdapter { type: ExpressionAdapter.Boolean; expression: isInActiveLoop.value && !loopOutAdjust.value } }
    Wire { from: "LoopInAdjustBlinker.trigger"; to: ExpressionAdapter { type: ExpressionAdapter.Boolean; expression: isInActiveLoop.value && loopInAdjust.value } }
    Wire { from: "LoopOutBlinker.trigger"; to: ExpressionAdapter { type: ExpressionAdapter.Boolean; expression: isInActiveLoop.value && !loopInAdjust.value } }
    Wire { from: "LoopOutAdjustBlinker.trigger"; to: ExpressionAdapter { type: ExpressionAdapter.Boolean; expression: isInActiveLoop.value && loopOutAdjust.value } }

    WiresGroup {
        enabled: active
        Wire { from: "surface.loop_in"; to: "loop.loop_in"; enabled: !isInActiveLoop.value }
        Wire { from: "surface.loop_out"; to: "loop.loop_out"; enabled: !isInActiveLoop.value }
        WiresGroup {
            enabled: isInActiveLoop.value

            Wire { from: "surface.loop_in"; to: TogglePropertyAdapter { path: loopInAdjust.path; output: false } }
            Wire { from: "surface.loop_in.led"; to: "LoopInBlinker"; enabled: !loopInAdjust.value && !loopOutAdjust.value }
            Wire { from: "surface.loop_in.led"; to: "LoopInAdjustBlinker"; enabled: loopInAdjust.value }

            Wire { from: "surface.loop_out"; to: TogglePropertyAdapter { path: loopOutAdjust.path; output: false } }
            Wire { from: "surface.loop_out.led"; to: "LoopOutBlinker"; enabled: !loopInAdjust.value && !loopOutAdjust.value }
            Wire { from: "surface.loop_out.led"; to: "LoopOutAdjustBlinker"; enabled: loopOutAdjust.value }
        }

        Wire { from: "surface.reloop"; to: TogglePropertyAdapter { path: "app.traktor.decks." + deckId + ".loop.active" } enabled: !reloopMode.value }
        WiresGroup {
            enabled: reloopMode.value

            Wire { from: "surface.reloop"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".loop.active"; value: false; output:false } enabled: isInActiveLoop.value }
            Wire { from: "surface.reloop"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".loop.active"; value: true; output:false } enabled: !isInActiveLoop.value && activeCueLength.value > 0 }
            Wire { from: "surface.reloop"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".cup"; output: false } enabled: !isInActiveLoop.value && activeCueLength.value > 0 }
            Wire { from: "surface.reloop.led"; to: "Reloop"; enabled: activeCueLength.value > 0 }
        }

        Wire { from: "surface.loop_info"; to: "loop.loop_info" }
    }
}
