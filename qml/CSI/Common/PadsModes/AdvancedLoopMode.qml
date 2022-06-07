import CSI 1.0
import QtQuick 2.12

import "../../../Defines"

Module {
    id: module
    property bool active: true
    property int deckId: 1 //1-4
    property string surface: "path"

    Blinker { name: "LoopInBlinker"; cycle: 500; color: Color.Green; defaultBrightness: dimmed; blinkBrightness: bright }
    Blinker { name: "LoopInAdjustBlinker"; cycle: 250; color: Color.Green; defaultBrightness: dimmed; blinkBrightness: bright }
    Blinker { name: "LoopOutBlinker"; cycle: 500; color: Color.Green; defaultBrightness: dimmed; blinkBrightness: bright }
    Blinker { name: "LoopOutAdjustBlinker"; cycle: 250; color: Color.Green; defaultBrightness: dimmed; blinkBrightness: bright }
    Wire { from: "LoopInBlinker.trigger"; to: ExpressionAdapter { type: ExpressionAdapter.Boolean; expression: isInActiveLoop.value &&  !loopOutAdjust.value } }
    Wire { from: "LoopInAdjustBlinker.trigger"; to: ExpressionAdapter { type: ExpressionAdapter.Boolean; expression: isInActiveLoop.value && loopInAdjust.value } }
    Wire { from: "LoopOutBlinker.trigger"; to: ExpressionAdapter { type: ExpressionAdapter.Boolean; expression: isInActiveLoop.value && !loopInAdjust.value } }
    Wire { from: "LoopOutAdjustBlinker.trigger"; to: ExpressionAdapter { type: ExpressionAdapter.Boolean; expression: isInActiveLoop.value && loopOutAdjust.value } }

    property int light: 0

    WiresGroup {
        enabled: active
        //Loop In & Loop Out
        Wire { from: "%surface%.pads.2"; to: TriggerPropertyAdapter { path: "app.traktor.decks."+ deckId + ".loop.set.in"; output: false } enabled: !isInActiveLoop.value }
        Wire { from: "%surface%.pads.2"; to: TogglePropertyAdapter { path: deckPropertiesPath + ".loopInAdjust"; output: false } enabled: isInActiveLoop.value && !shift }
        Wire { from: "%surface%.pads.2.led"; to: "LoopInBlinker"; enabled: !loopInAdjust.value }
        Wire { from: "%surface%.pads.2.led"; to: "LoopInAdjustBlinker"; enabled: loopInAdjust.value }

        Wire { from: "%surface%.pads.3"; to: TriggerPropertyAdapter { path: "app.traktor.decks."+ deckId + ".loop.set.out"; output: false } enabled: !isInActiveLoop.value }
        Wire { from: "%surface%.pads.3"; to: TogglePropertyAdapter { path: deckPropertiesPath + ".loopOutAdjust"; output: false } enabled: isInActiveLoop.value && !shift }
        Wire { from: "%surface%.pads.3.led"; to: "LoopOutBlinker"; enabled: !loopOutAdjust.value }
        Wire { from: "%surface%.pads.3.led"; to: "LoopOutAdjustBlinker"; enabled: loopOutAdjust.value }

        //Half & Double Loop
        WiresGroup {
            enabled: isInActiveLoop.value && shift
            Wire { from: "%surface%.pads.2"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".move.size"; value: MoveSize.move_loop; output: false } } //This is would be the equivalent to the Double Loop Button in Pioneer
            Wire { from: "%surface%.pads.3"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".move.size"; value: MoveSize.move_loop; output: false } } //This is would be the equivalent to the Half Loop Button in Pioneer
            Wire { from: "%surface%.pads.2"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".move.mode"; value: 3; output: false } }
            Wire { from: "%surface%.pads.3"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".move.mode"; value: 3; output: false } }
            Wire { from: "%surface%.pads.2"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".move"; value: -1; output: false } }
            Wire { from: "%surface%.pads.3"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".move"; value: 1; output: false } }
        }

        //Beatjumps
        WiresGroup {
            enabled: !isInActiveLoop.value
            Wire { from: "%surface%.pads.1"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".beatjump"; value: JumpSize.bwd_loop; color: Color.Red } }
            Wire { from: "%surface%.pads.4"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".beatjump"; value: JumpSize.fwd_loop; color: Color.Red } }
            Wire { from: "%surface%.pads.5"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".beatjump"; value: JumpSize.bwd_4; color: Color.DarkOrange } }
            Wire { from: "%surface%.pads.6"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".beatjump"; value: JumpSize.bwd_1; color: Color.LightOrange } }
            Wire { from: "%surface%.pads.7"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".beatjump"; value: JumpSize.fwd_1; color: Color.LightOrange } }
            Wire { from: "%surface%.pads.8"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".beatjump"; value: JumpSize.fwd_4; color: Color.DarkOrange } }
        }

        //Loop Move
        WiresGroup {
            enabled: isInActiveLoop.value && !loopInAdjust.value && !loopOutAdjust.value
            Wire { from: "%surface%.pads.1"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".move.size"; value: MoveSize.move_loop; output: false } }
            Wire { from: "%surface%.pads.4"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".move.size"; value: MoveSize.move_loop; output: false } }
            Wire { from: "%surface%.pads.5"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".move.size"; value: MoveSize.move_4; output: false } }
            Wire { from: "%surface%.pads.6"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".move.size"; value: MoveSize.move_1; output: false } }
            Wire { from: "%surface%.pads.7"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".move.size"; value: MoveSize.move_1; output: false } }
            Wire { from: "%surface%.pads.8"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".move.size"; value: MoveSize.move_4; output: false } }

            Wire { from: "%surface%.pads.1"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".move.mode"; value: 1; output: false } }
            Wire { from: "%surface%.pads.4"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".move.mode"; value: 1; output: false } }
            Wire { from: "%surface%.pads.5"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".move.mode"; value: 1; output: false } }
            Wire { from: "%surface%.pads.6"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".move.mode"; value: 1; output: false } }
            Wire { from: "%surface%.pads.7"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".move.mode"; value: 1; output: false } }
            Wire { from: "%surface%.pads.8"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".move.mode"; value: 1; output: false } }

            Wire { from: "%surface%.pads.1"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".move"; value: -1; color: Color.Red } }
            Wire { from: "%surface%.pads.4"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".move"; value: 1; color: Color.Red } }
            Wire { from: "%surface%.pads.5"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".move"; value: -1; color: Color.DarkOrange } }
            Wire { from: "%surface%.pads.6"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".move"; value: -1; color: Color.LightOrange } }
            Wire { from: "%surface%.pads.7"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".move"; value: 1; color: Color.LightOrange } }
            Wire { from: "%surface%.pads.8"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".move"; value: 1; color: Color.DarkOrange } }
        }

        //Loop In Adjust
        WiresGroup {
            enabled: loopInAdjust.value
            //Wire { from: "%surface%.touchstrip"; to:  }

            Wire { from: "%surface%.pads.1"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".move.size"; value: MoveSize.move_loop; output: false } }
            Wire { from: "%surface%.pads.4"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".move.size"; value: MoveSize.move_loop; output: false } }
            Wire { from: "%surface%.pads.5"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".move.size"; value: MoveSize.move_4; output: false } }
            Wire { from: "%surface%.pads.6"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".move.size"; value: MoveSize.move_1; output: false } }
            Wire { from: "%surface%.pads.7"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".move.size"; value: MoveSize.move_1; output: false } }
            Wire { from: "%surface%.pads.8"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".move.size"; value: MoveSize.move_4; output: false } }

            Wire { from: "%surface%.pads.1"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".move.mode"; value: 2; output: false } }
            Wire { from: "%surface%.pads.4"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".move.mode"; value: 2; output: false } }
            Wire { from: "%surface%.pads.5"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".move.mode"; value: 2; output: false } }
            Wire { from: "%surface%.pads.6"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".move.mode"; value: 2; output: false } }
            Wire { from: "%surface%.pads.7"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".move.mode"; value: 2; output: false } }
            Wire { from: "%surface%.pads.8"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".move.mode"; value: 2; output: false } }

            Wire { from: "%surface%.pads.1"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".move"; value: 1; color: Color.Red; output: false } } //Changed -1 to 1 because otherwise it behaves strangely (opposite to what expected) on the Loop In mode with Loop Size move size
            Wire { from: "%surface%.pads.4"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".move"; value: -1; color: Color.Red; output: false } } //Changed 1 to -1 because otherwise it behaves strangely (opposite to what expected) on the Loop In mode with Loop Size move size
            Wire { from: "%surface%.pads.5"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".move"; value: -1; color: Color.DarkOrange; output: false } }
            Wire { from: "%surface%.pads.6"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".move"; value: -1; color: Color.LightOrange; output: false } }
            Wire { from: "%surface%.pads.7"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".move"; value: 1; color: Color.LightOrange; output: false } }
            Wire { from: "%surface%.pads.8"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".move"; value: 1; color: Color.DarkOrange; output: false } }

            // INFO: Added this because the HoldPropertyAdapter made the pads LEDs become crazy when adjusting the Loop Size
            Wire { from: "%surface%.pads.1"; to: ButtonScriptAdapter { brightness: light == 1; color: Color.Red; onPress: { light = 1 } onRelease: { light = 0 } } }
            Wire { from: "%surface%.pads.4"; to: ButtonScriptAdapter { brightness: light == 4; color: Color.Red; onPress: { light = 4 } onRelease: { light = 0 } } }
            Wire { from: "%surface%.pads.5"; to: ButtonScriptAdapter { brightness: light == 5; color: Color.DarkOrange; onPress: { light = 5 } onRelease: { light = 0 } } }
            Wire { from: "%surface%.pads.6"; to: ButtonScriptAdapter { brightness: light == 6; color: Color.LightOrange; onPress: { light = 6 } onRelease: { light = 0 } } }
            Wire { from: "%surface%.pads.7"; to: ButtonScriptAdapter { brightness: light == 7; color: Color.LightOrange; onPress: { light = 7 } onRelease: { light = 0 } } }
            Wire { from: "%surface%.pads.8"; to: ButtonScriptAdapter { brightness: light == 8; color: Color.DarkOrange; onPress: { light = 8 } onRelease: { light = 0 } } }
        }

        //Loop Out Adjust
        WiresGroup {
            enabled: loopOutAdjust.value
            //Wire { from: "%surface%.touchstrip"; to:  }

            Wire { from: "%surface%.pads.1"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".move.size"; value: MoveSize.move_loop; output: false } } //This would be the equivalent to the Double Loop Button in Pioneer
            Wire { from: "%surface%.pads.4"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".move.size"; value: MoveSize.move_loop; output: false } } //This would be the equivalent to the Half Loop Button in Pioneer
            Wire { from: "%surface%.pads.5"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".move.size"; value: MoveSize.move_4; output: false } }
            Wire { from: "%surface%.pads.6"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".move.size"; value: MoveSize.move_1; output: false } }
            Wire { from: "%surface%.pads.7"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".move.size"; value: MoveSize.move_1; output: false } }
            Wire { from: "%surface%.pads.8"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".move.size"; value: MoveSize.move_4; output: false } }

            Wire { from: "%surface%.pads.1"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".move.mode"; value: 3; output: false } }
            Wire { from: "%surface%.pads.4"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".move.mode"; value: 3; output: false } }
            Wire { from: "%surface%.pads.5"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".move.mode"; value: 3; output: false } }
            Wire { from: "%surface%.pads.6"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".move.mode"; value: 3; output: false } }
            Wire { from: "%surface%.pads.7"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".move.mode"; value: 3; output: false } }
            Wire { from: "%surface%.pads.8"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".move.mode"; value: 3; output: false } }

            Wire { from: "%surface%.pads.1"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".move"; value: -1; color: Color.Red; output: false } }
            Wire { from: "%surface%.pads.4"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".move"; value: 1; color: Color.Red; output: false } }
            Wire { from: "%surface%.pads.5"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".move"; value: -1; color: Color.DarkOrange; output: false } }
            Wire { from: "%surface%.pads.6"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".move"; value: -1; color: Color.LightOrange; output: false } }
            Wire { from: "%surface%.pads.7"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".move"; value: 1; color: Color.LightOrange; output: false } }
            Wire { from: "%surface%.pads.8"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".move"; value: 1; color: Color.DarkOrange; output: false } }

            // INFO: Added this because the HoldPropertyAdapter made the pads LEDs become crazy when adjusting the Loop Size
            Wire { from: "%surface%.pads.1"; to: ButtonScriptAdapter { brightness: light == 1; color: Color.Red; onPress: { light = 1 } onRelease: { light = 0 } } }
            Wire { from: "%surface%.pads.4"; to: ButtonScriptAdapter { brightness: light == 4; color: Color.Red; onPress: { light = 4 } onRelease: { light = 0 } } }
            Wire { from: "%surface%.pads.5"; to: ButtonScriptAdapter { brightness: light == 5; color: Color.DarkOrange; onPress: { light = 5 } onRelease: { light = 0 } } }
            Wire { from: "%surface%.pads.6"; to: ButtonScriptAdapter { brightness: light == 6; color: Color.LightOrange; onPress: { light = 6 } onRelease: { light = 0 } } }
            Wire { from: "%surface%.pads.7"; to: ButtonScriptAdapter { brightness: light == 7; color: Color.LightOrange; onPress: { light = 7 } onRelease: { light = 0 } } }
            Wire { from: "%surface%.pads.8"; to: ButtonScriptAdapter { brightness: light == 8; color: Color.DarkOrange; onPress: { light = 8 } onRelease: { light = 0 } } }
        }
    }
}
