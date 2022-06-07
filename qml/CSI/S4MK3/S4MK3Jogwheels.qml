import CSI 1.0
import QtQuick 2.12

import "../../Defines"

Module {
    id: module
    property bool active: true
    property int deckId: 1
    property string surface: "path"

    Turntable { name: "turntable"; channel: deckId }

    WiresGroup {
        enabled: active
        Wire { from: "%surface%.shift"; to: "turntable.shift" }

        //LED
        Wire { from: DirectPropertyAdapter { path: deckColor.path; input: false } to: "%surface%.jogwheel.led_color" }

        //Motor
        Wire { from: DirectPropertyAdapter { path: "app.traktor.decks." + deckId + ".play" } to: "%surface%.jogwheel.motor_on" } // motor_on is currenty also used to tell the HWS if taktor is playing in Jog Mode.
        Wire { from: "%surface%.play"; to: "%surface%.jogwheel.motor_off"; enabled: shift && isPlaying.value }

        //Settings
        Wire { from: "%surface%.jogwheel.platter_speed"; to: DirectPropertyAdapter { path: baseSpeed.path; input: false } }
        Wire { from: "%surface%.jogwheel.haptic_ticks"; to: DirectPropertyAdapter { path: ticksWhenNudging.path; input: false } enabled: (jogMode.value === JogwheelMode.Jogwheel || jogMode.value === JogwheelMode.CDJ) && !shift }
        Wire { from: "%surface%.jogwheel.mode"; to: DirectPropertyAdapter { path: jogMode.path } }
        Wire { from: "%surface%.jogwheel.mode"; to: "turntable.mode" }
        Wire { from: "%surface%.jogwheel.timeline"; to: "turntable.timeline"; enabled: hapticHotcues.value }
        Wire { from: "%surface%.jogwheel.pitch"; to: "turntable.pitch" }
        Wire { from: "%surface%.pitch.fader"; to: "%surface%.jogwheel.tempo" }

        WiresGroup {
            enabled: !loopInAdjust.value && !loopOutAdjust.value

            Wire { from: "%surface%.jogwheel"; to: "turntable"; enabled: !holdGrid.value && editMode.value == EditMode.disabled }
            Wire {
                enabled: (holdGrid.value || editMode.value == EditMode.full) && !gridLock.value && jogMode.value === JogwheelMode.Jogwheel;
                from: "%surface%.jogwheel.rotation";
                to: EncoderScriptAdapter {
                    onTick: {
                        const minimalTickValue = 0.0035;
                        const rotationScaleFactor = 20;
                        if (value < -minimalTickValue || value > minimalTickValue) {
                            gridAdjust.value = value * rotationScaleFactor;
                        }
                    }
                }
            }
        }

        Wire {
            enabled: (loopInAdjust.value || loopOutAdjust.value) && jogMode.value === JogwheelMode.Jogwheel
            from: "%surface%.jogwheel.rotation";
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
