import CSI 1.0
import QtQuick 2.12

import "../Common"

Module {
  id: module
  property int deckId
  property string surface: "hw.mixer.channels.X"

  //Softakeover for EQs secondary functions
  /*
  FxUnit { name: "fx"; channel: deckId }
  SoftTakeoverEq {
    name: "filter"
    surfaceObject: surface + ".channel_fx.amount"
    propertiesPath: module.propertiesPath + ".softtakeover.filter";
  }
  SoftTakeoverEq {
    name: "high"
    surfaceObject: surface + ".eq.high"
    propertiesPath: module.propertiesPath + ".softtakeover.eq.high";
  }
  SoftTakeoverEq {
    name: "mid"
    surfaceObject: surface + ".eq.mid"
    propertiesPath: module.propertiesPath + ".softtakeover.eq.mid";
  }
  SoftTakeoverEq {
    name: "low"
    surfaceObject: surface + ".eq.low"
    propertiesPath: module.propertiesPath + ".softtakeover.eq.low";
  }

  WiresGroup {
    enabled: !shift
    Wire { from: "filter.softtakeover.output"; to: DirectPropertyAdapter { path: "app.traktor.mixer.channels." + deckId + ".fx.adjust" } }
    Wire { from: "high.softtakeover.output"; to: DirectPropertyAdapter { path: "app.traktor.mixer.channels." + deckId + ".eq.high" } }
    Wire { from: "mid.softtakeover.output"; to: DirectPropertyAdapter { path: "app.traktor.mixer.channels." + deckId + ".eq.mid" } }
    Wire { from: "low.softtakeover.output"; to: DirectPropertyAdapter { path: "app.traktor.mixer.channels." + deckId + ".eq.low" } }
  }
  WiresGroup {
    enabled: shift
    Wire { from: "filter.softtakeover.output_monitor"; to: DirectPropertyAdapter { path: "app.traktor.mixer.channels." + deckId + ".fx.adjust" } }
    Wire { from: "high.softtakeover.output_monitor"; to: DirectPropertyAdapter { path: "app.traktor.mixer.channels." + deckId + ".eq.high" } }
    Wire { from: "mid.softtakeover.output_monitor"; to: DirectPropertyAdapter { path: "app.traktor.mixer.channels." + deckId + ".eq.mid" } }
    Wire { from: "low.softtakeover.output_monitor"; to: DirectPropertyAdapter { path: "app.traktor.mixer.channels." + deckId + ".eq.low" } }
  }

  SoftTakeoverEq {
    name: "knob1"
    surfaceObject: surface + ".channel_fx.amount"
    propertiesPath: module.propertiesPath + ".softtakeover.knobs.1";
  }
  SoftTakeoverEq {
    name: "knob2"
    surfaceObject: surface + ".eq.high"
    propertiesPath: module.propertiesPath + ".softtakeover.knobs.2";
  }
  SoftTakeoverEq {
    name: "knob3"
    surfaceObject: surface + ".eq.mid"
    propertiesPath: module.propertiesPath + ".softtakeover.knobs.3";
  }
  SoftTakeoverEq {
    name: "knob4"
    surfaceObject: surface + ".eq.low"
    propertiesPath: module.propertiesPath + ".softtakeover.knobs.4";
  }

  WiresGroup {
    enabled: shift
    Wire { from: "knob1.softtakeover.output"; to: "fx.dry_wet" }
    Wire { from: "knob2.softtakeover.output"; to: "fx.knob1" }
    Wire { from: "knob3.softtakeover.output"; to: "fx.knob2" }
    Wire { from: "knob4.softtakeover.output"; to: "fx.knob3" }
  }
  */

  //Deck properties
  AppProperty { id: directThru; path: "app.traktor.decks." + deckId + ".direct_thru" }
  AppProperty { id: deckType; path: "app.traktor.decks." + deckId + ".type" }

  //Channel strip
  Wire { from: "%surface%.volume"; to: DirectPropertyAdapter { path: "app.traktor.mixer.channels." + deckId + ".volume" } }
  Wire { from: "%surface%.gain"; to: DirectPropertyAdapter { path: "app.traktor.mixer.channels." + deckId + ".gain" } }

  Wire { from: "%surface%.eq.high"; to: DirectPropertyAdapter { path: "app.traktor.mixer.channels." + deckId + ".eq.high" } }
  Wire { from: "%surface%.eq.mid"; to: DirectPropertyAdapter { path: "app.traktor.mixer.channels." + deckId + ".eq.mid" } }
  Wire { from: "%surface%.eq.low"; to: DirectPropertyAdapter { path: "app.traktor.mixer.channels." + deckId + ".eq.low" } }
  Wire { from: "%surface%.channel_fx.amount"; to: DirectPropertyAdapter { path: "app.traktor.mixer.channels." + deckId + ".fx.adjust" } }

  Wire { from: "%surface%.cue"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels." + deckId + ".cue" } enabled: (precueButton.value == 0 && !shift) || (shiftPrecueButton.value == 0 && shift) }
  Wire { from: "%surface%.cue"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels." + deckId + ".fx.on" } enabled: (precueButton.value == 1 && !shift) || (shiftPrecueButton.value == 1 && shift) }

  //LED Level meter
  //LEDLevelMeter { name: "meter"; dBThresholds: [-30,-24,-18,-12,-6]; hasClipLED: true } //original
  LEDLevelMeter { name: "meter"; dBThresholds: [-30,-21,-15,-9,-3]; hasClipLED: true } //AJF adjusted
  Wire { from: "%surface%.level_meter"; to: "meter" }
  Wire { from: "meter.level"; to: DirectPropertyAdapter { path: "app.traktor.mixer.channels." + deckId + ".level.prefader.linear.sum"; input: false } }
  Wire { from: "meter.clip"; to: DirectPropertyAdapter { path: "app.traktor.mixer.master.level.clip.sum"; input: false } }

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
