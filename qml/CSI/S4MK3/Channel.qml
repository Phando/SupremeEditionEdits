import CSI 1.0
import QtQuick 2.12

import "../../Defines"

Module {
    id: channel
    property int deckId
    property string surface: "hw.mixer.channels.X"

    //Deck properties
    AppProperty { id: directThru; path: "app.traktor.decks." + deckId + ".direct_thru" }
    AppProperty { id: deckType; path: "app.traktor.decks." + deckId + ".type" }

    //EXT Mode
    Wire { from: "%surface%.input";
        to: ButtonScriptAdapter {
            brightness: deckType.value == DeckType.Live;
            onPress: {
                if (!shift && deckType.value == DeckType.Live) {
                    deckType.value = DeckType.Track
                }
                else deckType.value = DeckType.Live
            }
        }
    }

    //Channel strip
    Wire { from: "%surface%.volume"; to: DirectPropertyAdapter { path: "app.traktor.mixer.channels." + deckId + ".volume" } }
    Wire { from: "%surface%.gain"; to: DirectPropertyAdapter { path: "app.traktor.mixer.channels." + deckId + ".gain" } }
    Wire { from: "%surface%.eq.high"; to: DirectPropertyAdapter { path: "app.traktor.mixer.channels." + deckId + ".eq.high" } }
    Wire { from: "%surface%.eq.mid"; to: DirectPropertyAdapter { path: "app.traktor.mixer.channels." + deckId + ".eq.mid" } }
    Wire { from: "%surface%.eq.low"; to: DirectPropertyAdapter { path: "app.traktor.mixer.channels." + deckId + ".eq.low" } }
    Wire { from: "%surface%.cue"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels." + deckId + ".cue" } }
    //NOTE: Filter Adjust & Filter On/Off are in ChannelFX.qml

    //FX Assign Arrows
    SwitchTimer { name: "fx1"; resetTimeout: 1000 }
    SwitchTimer { name: "fx2"; resetTimeout: 1000 }
    SwitchTimer { name: "fx3"; resetTimeout: 1000 }
    SwitchTimer { name: "fx4"; resetTimeout: 1000 }

    WiresGroup {
        enabled: !directThru.value

        WiresGroup {
            enabled: !shift || fxMode.value == FxMode.TwoFxUnits
            Wire { from: "%surface%.deck_fx_assign.1"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels." + deckId + ".fx.assign.1" } }
            Wire { from: "%surface%.deck_fx_assign.1"; to: "fx1.input" }
            Wire { from: "fx1.output"; to: DirectPropertyAdapter { path: showFX1.path } enabled: showAssignedFXOverlays.value }

            Wire { from: "%surface%.deck_fx_assign.2"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels." + deckId + ".fx.assign.2" } }
            Wire { from: "%surface%.deck_fx_assign.2"; to: "fx2.input" }
            Wire { from: "fx2.output"; to: DirectPropertyAdapter { path: showFX2.path } enabled: showAssignedFXOverlays.value }
        }
        WiresGroup {
            enabled: shift && fxMode.value == FxMode.FourFxUnits
            Wire { from: "%surface%.deck_fx_assign.1"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels." + deckId + ".fx.assign.3" } }
            Wire { from: "%surface%.deck_fx_assign.1"; to: "fx3.input" }
            Wire { from: "fx3.output"; to: DirectPropertyAdapter { path: showFX3.path } enabled: showAssignedFXOverlays.value }

            Wire { from: "%surface%.deck_fx_assign.2"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels." + deckId + ".fx.assign.4" } }
            Wire { from: "%surface%.deck_fx_assign.2"; to: "fx4.input" }
            Wire { from: "fx4.output"; to: DirectPropertyAdapter { path: showFX4.path } enabled: showAssignedFXOverlays.value }
        }
    }

    //X-Fader assign
    Wire { from: "%surface%.xfader_assign.left"; to: DirectPropertyAdapter { path: "app.traktor.mixer.channels." + deckId + ".xfader_assign.left" } }
    Wire { from: "%surface%.xfader_assign.right"; to: DirectPropertyAdapter { path: "app.traktor.mixer.channels." + deckId + ".xfader_assign.right" } }

    //LED Level meter
    LEDLevelMeter { name: "meter"; segments: 15 }
    Wire { from: "%surface%.level_meter"; to: "meter" }
    Wire { from: "meter.level"; to: DirectPropertyAdapter { path: "app.traktor.mixer.channels." + deckId + ".level.prefader.linear.meter"; input: false } }

    //Fader Start
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
}
