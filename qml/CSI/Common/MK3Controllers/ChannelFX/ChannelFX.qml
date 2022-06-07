import CSI 1.0

import "../../../../Defines"

Module {
    id: module
    property string surface: "path"
    property int deckId
    property int channelFxSelectorVal

    property alias selectedFx: fxSelect
    signal fxChanged()

    AppProperty { id: fxSelect; path: "app.traktor.mixer.channels." + deckId + ".fx.select" }
    AppProperty { id: fxOn; path: "app.traktor.mixer.channels." + deckId + ".fx.on" }

    readonly property variant mixerFXLEDs: [ Color.LightOrange, Color.Red, Color.Green, Color.Blue, Color.Yellow ]

    //Channel FX Knob + Enable
    Wire { from: "%surface%.channel_fx.amount"; to: DirectPropertyAdapter { path: "app.traktor.mixer.channels." + deckId + ".fx.adjust" } }
    Wire { from: "%surface%.channel_fx.on"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels." + deckId + ".fx.on"; color: mixerFXLEDs[fxSelect.value] } enabled: channelFxSelectorVal == -1 }
    Wire {
        enabled: channelFxSelectorVal != -1;
        from: "%surface%.channel_fx.on";
        to: ButtonScriptAdapter {
            brightness: fxOn.value ? 1.0 : 0.5
            color: mixerFXLEDs[fxSelect.value]
            onPress: {
                selectedFx.value = channelFxSelectorVal
                fxChanged()
            }
        }
    }
}
