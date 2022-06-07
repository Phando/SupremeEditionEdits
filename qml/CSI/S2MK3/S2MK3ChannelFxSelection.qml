import CSI 1.0
import QtQuick 2.12

Module {
    id: module
    property bool leftShift: false
    property bool rightShift: false

    AppProperty { id: fxSelectA; path: "app.traktor.mixer.channels.1.fx.select" }
    AppProperty { id: fxSelectB; path: "app.traktor.mixer.channels.2.fx.select" }
    AppProperty { id: fxOnA; path: "app.traktor.mixer.channels.1.fx.on" }
    AppProperty { id: fxOnB; path: "app.traktor.mixer.channels.2.fx.on" }

    Blinker { name: "MixerFX1"; cycle: 500; defaultBrightness: bright; blinkBrightness: dimmed }
    Blinker { name: "MixerFX2"; cycle: 500; defaultBrightness: bright; blinkBrightness: dimmed }
    Blinker { name: "MixerFX3"; cycle: 500; defaultBrightness: bright; blinkBrightness: dimmed }
    Blinker { name: "MixerFX4"; cycle: 500; defaultBrightness: bright; blinkBrightness: dimmed }
    Wire { from: "MixerFX1.trigger"; to: ExpressionAdapter { type: ExpressionAdapter.Boolean; expression: (fxSelectA.value == 1 && (leftShift || !rightShift)) || (fxSelectB.value == 1 && (!leftShift || rightShift)) } }
    Wire { from: "MixerFX2.trigger"; to: ExpressionAdapter { type: ExpressionAdapter.Boolean; expression: (fxSelectA.value == 2 && (leftShift || !rightShift)) || (fxSelectB.value == 2 && (!leftShift || rightShift)) } }
    Wire { from: "MixerFX3.trigger"; to: ExpressionAdapter { type: ExpressionAdapter.Boolean; expression: (fxSelectA.value == 3 && (leftShift || !rightShift)) || (fxSelectB.value == 3 && (!leftShift || rightShift)) } }
    Wire { from: "MixerFX4.trigger"; to: ExpressionAdapter { type: ExpressionAdapter.Boolean; expression: (fxSelectA.value == 4 && (leftShift || !rightShift)) || (fxSelectB.value == 4 && (!leftShift || rightShift)) } }

    MappingPropertyDescriptor {
        id: channelFxSelection;
        path: "mapping.state.channelFxSelection";
        type: MappingPropertyDescriptor.Integer;
        value: 0;
        onValueChanged: {
            //Filter (MixerFX 1) + 3 MixerFXs
            if (!filterFX.value) {
                if (channelFxSelection.value == 0 && precueButton.value != 1 && shiftPrecueButton.value != 1) {
                    fxOnA.value = false;
                    fxOnB.value = false;
                }
                else {
                    fxOnA.value = true;
                    fxOnB.value = true;
                    if (!individualFXs.value) {
                        fxSelectA.value = channelFxSelection.value
                        fxSelectB.value = channelFxSelection.value;
                    }
                }
            }

            //Filter + 4 MixerFXs
            else {
                if (precueButton.value != 1 && shiftPrecueButton.value != 1) {
                    fxOnA.value = true;
                    fxOnB.value = true;
                }
                if (!individualFXs.value) {
                    fxSelectA.value = channelFxSelection.value
                    fxSelectB.value = channelFxSelection.value;
                }
            }
        }
    }

    WiresGroup {
        enabled: !individualFXs.value
        Wire { from: "s2mk3.mixer.channel_fx.fx1"; to: TogglePropertyAdapter { path: "mapping.state.channelFxSelection"; value: 1; defaultValue: 0 } }
        Wire { from: "s2mk3.mixer.channel_fx.fx2"; to: TogglePropertyAdapter { path: "mapping.state.channelFxSelection"; value: 2; defaultValue: 0 } }
        Wire { from: "s2mk3.mixer.channel_fx.fx3"; to: TogglePropertyAdapter { path: "mapping.state.channelFxSelection"; value: 3; defaultValue: 0 } }
        Wire { from: "s2mk3.mixer.channel_fx.fx4"; to: TogglePropertyAdapter { path: "mapping.state.channelFxSelection"; value: 4; defaultValue: 0 } }
    }

    WiresGroup {
        enabled: individualFXs.value && filterFX.value

        Wire { from: "s2mk3.mixer.channel_fx.fx1"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.1.fx.select"; value: 1; defaultValue: 0; output: false } enabled: leftShift || (!rightShift && ((fxSelectA.value == 1 && fxSelectB.value == 1) || fxSelectA.value != 1)) }
        Wire { from: "s2mk3.mixer.channel_fx.fx1"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.2.fx.select"; value: 1; defaultValue: 0; output: false } enabled: rightShift || (!leftShift && ((fxSelectA.value == 1 && fxSelectB.value == 1) || fxSelectB.value != 1)) }

        Wire { from: "s2mk3.mixer.channel_fx.fx2"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.1.fx.select"; value: 2; defaultValue: 0; output: false } enabled: leftShift || (!rightShift && ((fxSelectA.value == 2 && fxSelectB.value == 2) || fxSelectA.value != 2)) }
        Wire { from: "s2mk3.mixer.channel_fx.fx2"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.2.fx.select"; value: 2; defaultValue: 0; output: false } enabled: rightShift || (!leftShift && ((fxSelectA.value == 2 && fxSelectB.value == 2) || fxSelectB.value != 2)) }

        Wire { from: "s2mk3.mixer.channel_fx.fx3"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.1.fx.select"; value: 3; defaultValue: 0; output: false } enabled: leftShift || (!rightShift && ((fxSelectA.value == 3 && fxSelectB.value == 3) || fxSelectA.value != 3)) }
        Wire { from: "s2mk3.mixer.channel_fx.fx3"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.2.fx.select"; value: 3; defaultValue: 0; output: false } enabled: rightShift || (!leftShift && ((fxSelectA.value == 3 && fxSelectB.value == 3) || fxSelectB.value != 3)) }

        Wire { from: "s2mk3.mixer.channel_fx.fx4"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.1.fx.select"; value: 4; defaultValue: 0; output: false } enabled: leftShift || (!rightShift && ((fxSelectA.value == 4 && fxSelectB.value == 4) || fxSelectA.value != 4)) }
        Wire { from: "s2mk3.mixer.channel_fx.fx4"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.2.fx.select"; value: 4; defaultValue: 0; output: false } enabled: rightShift || (!leftShift && ((fxSelectA.value == 4 && fxSelectB.value == 4) || fxSelectB.value != 4)) }

        //LEDs
        WiresGroup {
            enabled: !mixerFXsBlinkers.value

            Wire { from: "s2mk3.mixer.channel_fx.fx1"; to: ButtonScriptAdapter { brightness: (fxSelectA.value == 1 && (leftShift || !rightShift)) || (fxSelectB.value == 1 && (!leftShift || rightShift)) } }
            Wire { from: "s2mk3.mixer.channel_fx.fx2"; to: ButtonScriptAdapter { brightness: (fxSelectA.value == 2 && (leftShift || !rightShift)) || (fxSelectB.value == 2 && (!leftShift || rightShift)) } }
            Wire { from: "s2mk3.mixer.channel_fx.fx3"; to: ButtonScriptAdapter { brightness: (fxSelectA.value == 3 && (leftShift || !rightShift)) || (fxSelectB.value == 3 && (!leftShift || rightShift)) } }
            Wire { from: "s2mk3.mixer.channel_fx.fx4"; to: ButtonScriptAdapter { brightness: (fxSelectA.value == 4 && (leftShift || !rightShift)) || (fxSelectB.value == 4 && (!leftShift || rightShift)) } }
        }

        //Blinkers
        WiresGroup {
            enabled: mixerFXsBlinkers.value

            Wire { from: "s2mk3.mixer.channel_fx.fx1.led"; to: "MixerFX1" }
            Wire { from: "s2mk3.mixer.channel_fx.fx2.led"; to: "MixerFX2" }
            Wire { from: "s2mk3.mixer.channel_fx.fx3.led"; to: "MixerFX3" }
            Wire { from: "s2mk3.mixer.channel_fx.fx4.led"; to: "MixerFX4" }
        }
    }

    WiresGroup {
        enabled: individualFXs.value && !filterFX.value

        Wire { from: "s2mk3.mixer.channel_fx.fx1"; to: SetPropertyAdapter { path: "app.traktor.mixer.channels.1.fx.select"; value: 1; output: false } enabled: leftShift || (!rightShift && ((fxSelectA.value == 1 && fxSelectB.value == 1) || fxSelectA.value != 1)) }
        Wire { from: "s2mk3.mixer.channel_fx.fx1"; to: SetPropertyAdapter { path: "app.traktor.mixer.channels.2.fx.select"; value: 1; output: false } enabled: rightShift || (!leftShift && ((fxSelectA.value == 1 && fxSelectB.value == 1) || fxSelectB.value != 1)) }

        Wire { from: "s2mk3.mixer.channel_fx.fx2"; to: SetPropertyAdapter { path: "app.traktor.mixer.channels.1.fx.select"; value: 2; output: false } enabled: leftShift || (!rightShift && ((fxSelectA.value == 2 && fxSelectB.value == 2) || fxSelectA.value != 2)) }
        Wire { from: "s2mk3.mixer.channel_fx.fx2"; to: SetPropertyAdapter { path: "app.traktor.mixer.channels.2.fx.select"; value: 2; output: false } enabled: rightShift || (!leftShift && ((fxSelectA.value == 2 && fxSelectB.value == 2) || fxSelectB.value != 2)) }

        Wire { from: "s2mk3.mixer.channel_fx.fx3"; to: SetPropertyAdapter { path: "app.traktor.mixer.channels.1.fx.select"; value: 3; output: false } enabled: leftShift || (!rightShift && ((fxSelectA.value == 3 && fxSelectB.value == 3) || fxSelectA.value != 3)) }
        Wire { from: "s2mk3.mixer.channel_fx.fx3"; to: SetPropertyAdapter { path: "app.traktor.mixer.channels.2.fx.select"; value: 3; output: false } enabled: rightShift || (!leftShift && ((fxSelectA.value == 3 && fxSelectB.value == 3) || fxSelectB.value != 3)) }

        Wire { from: "s2mk3.mixer.channel_fx.fx4"; to: SetPropertyAdapter { path: "app.traktor.mixer.channels.1.fx.select"; value: 4; output: false } enabled: leftShift || (!rightShift && ((fxSelectA.value == 4 && fxSelectB.value == 4) || fxSelectA.value != 4)) }
        Wire { from: "s2mk3.mixer.channel_fx.fx4"; to: SetPropertyAdapter { path: "app.traktor.mixer.channels.2.fx.select"; value: 4; output: false } enabled: rightShift || (!leftShift && ((fxSelectA.value == 4 && fxSelectB.value == 4) || fxSelectB.value != 4)) }

        //Autoenable MixerFX
        WiresGroup {
            enabled: precueButton.value == 0 && shiftPrecueButton.value == 0

            Wire { from: "s2mk3.mixer.channel_fx.fx1"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.1.fx.on"; value: true; defaultValue: false; output: false } enabled: (fxSelectA.value != 1 && !fxOnA.value) || ((leftShift && fxSelectA.value == 1) || (!rightShift && ((fxSelectA.value == 1 && fxSelectB.value == 1)))) }
            Wire { from: "s2mk3.mixer.channel_fx.fx1"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.2.fx.on"; value: true; defaultValue: false; output: false } enabled: (fxSelectB.value != 1  && !fxOnB.value) || ((rightShift && fxSelectB.value == 1) || (!leftShift && ((fxSelectA.value == 1 && fxSelectB.value == 1)))) }

            Wire { from: "s2mk3.mixer.channel_fx.fx2"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.1.fx.on"; value: true; defaultValue: false; output: false } enabled: (fxSelectA.value != 2 && !fxOnA.value) || ((leftShift && fxSelectA.value == 2) || (!rightShift && ((fxSelectA.value == 2 && fxSelectB.value == 2)))) }
            Wire { from: "s2mk3.mixer.channel_fx.fx2"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.2.fx.on"; value: true; defaultValue: false; output: false } enabled: (fxSelectB.value != 2 && !fxOnB.value) || ((rightShift && fxSelectB.value == 2) || (!leftShift && ((fxSelectA.value == 2 && fxSelectB.value == 2)))) }

            Wire { from: "s2mk3.mixer.channel_fx.fx3"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.1.fx.on"; value: true; defaultValue: false; output: false } enabled: (fxSelectA.value != 3 && !fxOnA.value) || ((leftShift && fxSelectA.value == 3) || (!rightShift && ((fxSelectA.value == 3 && fxSelectB.value == 3)))) }
            Wire { from: "s2mk3.mixer.channel_fx.fx3"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.2.fx.on"; value: true; defaultValue: false; output: false } enabled: (fxSelectB.value != 3 && !fxOnB.value) || ((rightShift && fxSelectB.value == 3) || (!leftShift && ((fxSelectA.value == 3 && fxSelectB.value == 3)))) }

            Wire { from: "s2mk3.mixer.channel_fx.fx4"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.1.fx.on"; value: true; defaultValue: false; output: false } enabled: (fxSelectA.value != 4 && !fxOnA.value) || ((leftShift && fxSelectA.value == 4) || (!rightShift && ((fxSelectA.value == 4 && fxSelectB.value == 4)))) }
            Wire { from: "s2mk3.mixer.channel_fx.fx4"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.2.fx.on"; value: true; defaultValue: false; output: false } enabled: (fxSelectB.value != 4 && !fxOnB.value) || ((rightShift && fxSelectB.value == 4) || (!leftShift && ((fxSelectA.value == 4 && fxSelectB.value == 4)))) }
        }

        //LEDs
        WiresGroup {
            enabled: !mixerFXsBlinkers.value

            Wire { from: "s2mk3.mixer.channel_fx.fx1"; to: ButtonScriptAdapter { brightness: (fxOnA.value && fxSelectA.value == 1 && (leftShift || !rightShift)) || (fxOnB.value && fxSelectB.value == 1 && (!leftShift || rightShift)) } }
            Wire { from: "s2mk3.mixer.channel_fx.fx2"; to: ButtonScriptAdapter { brightness: (fxOnA.value && fxSelectA.value == 2 && (leftShift || !rightShift)) || (fxOnB.value && fxSelectB.value == 2 && (!leftShift || rightShift)) } }
            Wire { from: "s2mk3.mixer.channel_fx.fx3"; to: ButtonScriptAdapter { brightness: (fxOnA.value && fxSelectA.value == 3 && (leftShift || !rightShift)) || (fxOnB.value && fxSelectB.value == 3 && (!leftShift || rightShift)) } }
            Wire { from: "s2mk3.mixer.channel_fx.fx4"; to: ButtonScriptAdapter { brightness: (fxOnA.value && fxSelectA.value == 4 && (leftShift || !rightShift)) || (fxOnB.value && fxSelectB.value == 4 && (!leftShift || rightShift)) } }
        }

        //Blinkers
        WiresGroup {
            enabled: mixerFXsBlinkers.value

            Wire { from: "s2mk3.mixer.channel_fx.fx1.led"; to: "MixerFX1" }
            Wire { from: "s2mk3.mixer.channel_fx.fx2.led"; to: "MixerFX2" }
            Wire { from: "s2mk3.mixer.channel_fx.fx3.led"; to: "MixerFX3" }
            Wire { from: "s2mk3.mixer.channel_fx.fx4.led"; to: "MixerFX4" }
        }

    }
}
