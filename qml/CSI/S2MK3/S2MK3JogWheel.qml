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

        WiresGroup {
            enabled: !loopInAdjust.value && !loopOutAdjust.value

            WiresGroup {
                enabled: !editMode.value && !holdGrid.value
                Wire { from: "%surface%.shift"; to: "turntable.shift" }
                Wire { from: "%surface%.jogwheel.rotation"; to: "turntable.rotation" }
                Wire { from: "%surface%.jogwheel.speed"; to: "turntable.speed" }
                Wire { from: "%surface%.jogwheel.touch"; to: "turntable.touch"; enabled: scratchOnTouch.value }
            }

            Wire {
                enabled: (editMode.value || holdGrid.value) && !gridLock.value
                from: "%surface%.jogwheel";
                to: EncoderScriptAdapter {
                    onTick: {
                        const minimalTickValue = 0.0035;
                        const rotationScaleFactor = 20;
                        if (value < -minimalTickValue || value > minimalTickValue) gridAdjust.value = value * rotationScaleFactor
                    }
                }
            }
        }


        Wire {
            enabled: loopInAdjust.value || loopOutAdjust.value
            from: "%surface%.jogwheel";
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
