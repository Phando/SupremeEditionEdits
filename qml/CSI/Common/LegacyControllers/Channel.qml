import CSI 1.0
import QtQuick 2.12

import "../../../Defines"

Module {
    id: module
    property int deckId: 1
    property string surface: "hw.mixer.channels.X"
    property bool faderStart: false

    AppProperty { id: directThru; path: "app.traktor.decks." + deckId + ".direct_thru" }
    AppProperty { id: mixerFX; path: "app.traktor.mixer.channels." + deckId + ".fx.select" }
    AppProperty { id: mixerFXOn; path: "app.traktor.mixer.channels." + deckId + ".fx.on" }
    AppProperty { id: fxMode; path: "app.traktor.fx.4fx_units" }

    //Fader Start
    AppProperty { id: deckType; path: "app.traktor.decks." + deckId + ".type" }
    AppProperty { id: isLoaded; path: "app.traktor.decks." + deckId + ".is_loaded" }
    AppProperty { id: isPlaying; path: "app.traktor.decks." + deckId + ".play" }
    AppProperty { id: isRunning; path: "app.traktor.decks." + deckId + ".running" }
    AppProperty { id: isCueing; path: "app.traktor.decks." + deckId + ".cue" }

    AppProperty { id: volume; path: "app.traktor.mixer.channels." + deckId + ".volume" }
    AppProperty { id: xfaderAssignLeft;   path: "app.traktor.mixer.channels." + deckId + ".xfader_assign.left" }
    AppProperty { id: xfaderAssignRight;  path: "app.traktor.mixer.channels." + deckId + ".xfader_assign.right" }
    AppProperty { id: xfaderAdjust; path: "app.traktor.mixer.xfader.adjust" }
    property bool onAir: volume.value > 0
      && ((!xfaderAssignLeft.value && !xfaderAssignRight.value)
        || (xfaderAssignLeft.value && xfaderAdjust.value < 1)
        || (xfaderAssignRight.value && xfaderAdjust.value > 0));

    onOnAirChanged: {
        if (faderStart.value && !directThru.value && (deckType.value == DeckType.Track || DeckType.Stem) && isLoaded.value) {
            if (onAir && !isPlaying.value) isPlaying.value = true;
            else if (!onAir) {
                isCueing.value = true;
                cueTimer.restart();
            }
        }
    }

    Timer { id: cueTimer; interval: 1
        onTriggered: {
            isCueing.value = false;
        }
    }

    //MixerFX / Filter button
    MappingPropertyDescriptor { id: holdMixerFX; path: "mapping.mixer." + deckId + ".filterOnHold"; type: MappingPropertyDescriptor.Boolean; value: false }
    ButtonScriptAdapter {
        name: "mixerFXOnButton"
        brightness: mixerFXOn.value
        onPress: {
            holdMixerFX_countdown.restart()
        }
        onRelease: {
            if (holdMixerFX_countdown.running) {
                //mixerFXOn.value = !mixerFXOn.value
                if (!shift) mixerFXOn.value = !mixerFXOn.value
                else mixerFX.value = (mixerFX.value+1) % 4
            }
            holdMixerFX_countdown.stop()
            holdMixerFX.value = false
        }
    }
    Timer { id: holdMixerFX_countdown; interval: 500
        onTriggered: {
            holdMixerFX.value = true
        }
    }

    //Channel strip
    Wire { from: "%surface%.volume"; to: DirectPropertyAdapter { path: "app.traktor.mixer.channels." + deckId + ".volume" } }
    Wire { from: "%surface%.gain"; to: DirectPropertyAdapter { path: "app.traktor.mixer.channels." + deckId + ".gain" } }
    Wire { from: "%surface%.eq.high"; to: DirectPropertyAdapter { path: "app.traktor.mixer.channels." + deckId + ".eq.high" } }
    Wire { from: "%surface%.eq.mid"; to: DirectPropertyAdapter { path: "app.traktor.mixer.channels." + deckId + ".eq.mid" } }
    Wire { from: "%surface%.eq.low"; to: DirectPropertyAdapter { path: "app.traktor.mixer.channels." + deckId + ".eq.low" } }
    Wire { from: "%surface%.filter"; to: DirectPropertyAdapter { path: "app.traktor.mixer.channels." + deckId + ".fx.adjust" } }
    Wire { from: "%surface%.filter_on"; to: DirectPropertyAdapter { path: "app.traktor.mixer.channels." + deckId + ".fx.on" } enabled: directFX }
    //Wire { from: "%surface%.filter_on"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels." + deckId + ".fx.on" } enabled: !directFX && !mixerFXControls }
    //Wire { from: "%surface%.filter_on"; to: "mixerFXOnButton"; enabled: !directFX && mixerFXControls }
    Wire { from: "%surface%.cue"; to: DirectPropertyAdapter { path: "app.traktor.mixer.channels." + deckId + ".cue" } enabled: directCue }
    //Wire { from: "%surface%.cue"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels." + deckId + ".cue" } enabled: !directCue }


    //FX Assign Arrows
    WiresGroup {
        enabled: !directThru.value

        WiresGroup {
            enabled: !shift || (fxMode.value == FxMode.TwoFxUnits && !mixerFXControls)
            Wire { from: "%surface%.fx.assign.1"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels." + deckId + ".fx.assign.1" } }
            Wire { from: "%surface%.fx.assign.2"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels." + deckId + ".fx.assign.2" } }
        }
        WiresGroup {
            enabled: shift && (fxMode.value == FxMode.FourFxUnits)
            Wire { from: "%surface%.fx.assign.1"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels." + deckId + ".fx.assign.3" } }
            Wire { from: "%surface%.fx.assign.2"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels." + deckId + ".fx.assign.4" } }
        }
        WiresGroup {
            enabled: shift && fxMode.value == FxMode.TwoFxUnits && mixerFXControls
            Wire { from: "%surface%.fx.assign.1"; to: ButtonScriptAdapter { onPress: { mixerFX.value == 4 ? mixerFX.value = mixerFX.value - 4 : mixerFX.value = mixerFX.value + 1 } } }
            Wire { from: "%surface%.fx.assign.2"; to: ButtonScriptAdapter { onPress: { mixerFX.value == 0 ? mixerFX.value = mixerFX.value + 4 : mixerFX.value = mixerFX.value - 1 } } }
        }

        /*
        Wire { from: "%surface%.fx.assign.1"; to: "fxOverlay.input"; enabled: (deck == 1 && !shift) || (deck == 3 && shift) } // fxMode.value == FxMode.TwoFxUnits --> disabled so that one can cicle through mixerFX pressing Shift + Assign Buttons
        Wire { from: "%surface%.fx.assign.2"; to: "fxOverlay.input"; enabled: (deck == 2 && !shift) || (deck == 4 && shift) } // fxMode.value == FxMode.TwoFxUnits --> disabled so that one can cicle through mixerFX pressing Shift + Assign Buttons
        Wire { from: "fxOverlay.output"; to: DirectPropertyAdapter { path: topPanel.path } enabled: focusedPanel == "top" }
        Wire { from: "fxOverlay.output"; to: DirectPropertyAdapter { path: bottomPanel.path } enabled: focusedPanel == "bottom" && footerPage.value == FooterPage.fx }
        */
    }


    //X-Fader assign
    Wire { from: "%surface%.xfader_assign.left"; to: DirectPropertyAdapter { path: "app.traktor.mixer.channels." + deckId + ".xfader_assign.left" } }
    Wire { from: "%surface%.xfader_assign.right"; to: DirectPropertyAdapter { path: "app.traktor.mixer.channels." + deckId + ".xfader_assign.right" } }

    //LED Level meter
    LEDLevelMeter { name: "meter"; dBThresholds: [-30,-18,-12,-9,-6,-3,0,2,4,6,8] } //[-30,-20,-10,-6,-4,-2,0,2,4,6,8]
    //LEDLevelMeter { name: "meter"; segments: 11 }
    Wire { from: "%surface%.levelmeter"; to: "meter" }
    Wire { from: "meter.level"; to: DirectPropertyAdapter { path: "app.traktor.mixer.channels." + deckId + ".level.prefader.linear.sum"; input: false } }
}
