import CSI 1.0
import QtQuick 2.12

import "../../Defines"

Module {
    id: module
    property int deckId
    property string surface: "hw.mixer.channels.X"

    //Deck properties
    AppProperty { id: directThru; path: "app.traktor.decks." + deckId + ".direct_thru" }
    AppProperty { id: deckType; path: "app.traktor.decks." + deckId + ".type" }

    //Channel strip
    Wire { from: "%surface%.volume"; to: DirectPropertyAdapter { path: "app.traktor.mixer.channels." + deckId + ".volume" } }
    Wire { from: "%surface%.gain"; to: DirectPropertyAdapter { path: "app.traktor.mixer.channels." + deckId + ".gain" } }
    Wire { from: "%surface%.eq.high"; to: DirectPropertyAdapter { path: "app.traktor.mixer.channels." + deckId + ".eq.high" } }
    Wire { from: "%surface%.eq.mid"; to: DirectPropertyAdapter { path: "app.traktor.mixer.channels." + deckId + ".eq.mid" } }
    Wire { from: "%surface%.eq.low"; to: DirectPropertyAdapter { path: "app.traktor.mixer.channels." + deckId + ".eq.low" } }
    Wire { from: "%surface%.cue"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels." + deckId + ".cue" } }
    //NOTE: Filter Adjust & Filter On/Off are in ChannelFX.qml

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