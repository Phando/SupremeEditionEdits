import CSI 1.0
import QtQuick 2.12

import "../../Defines"
import "../Common"
import "../../Helpers/LED.js" as LED
import "../../Helpers/KeySync.js" as KeySync
import "../../Helpers/KeyHelpers.js" as Key

Module {
    id: module
    property bool active: true
    property int deckId: 1
    property string surface: "path"

    TransportSection {
        name: "transport"
        channel: module.deckId
        masterColor: LED.custom(deckId)
        syncColor: LED.custom(deckId)
        cueColor: LED.custom(deckId)
    }

    TempoControl {
        id: tempo_control
        name: "tempo_control";
        channel: deckId;
        color: LED.custom(deckId)
    }

    /*
    AppProperty { id: tempoAdjust; path: "app.traktor.decks." + deckId + ".tempo.adjust" }
    SoftTakeoverFader {
      id: tempo_fader
      name: "fader"
      surfaceObject: surface + ".pitch.fader"
      propertiesPath: side.propertiesPath + ".softtakeover.pitch.fader";
      appProperty: tempoAdjust
    }
    */

    //Play should BLINK When Deck is Loaded & Paused or warn when Cueing but not playing
    Blinker { name: "PlayBlinkerStopped"; cycle: 1000; color: Color.Green; defaultBrightness: dimmed; blinkBrightness: bright }
    Blinker { name: "PlayBlinkerCueing"; cycle: 250; color: Color.Green; defaultBrightness: dimmed; blinkBrightness: bright }
    Wire { from: "PlayBlinkerStopped.trigger"; to: ExpressionAdapter { type: ExpressionAdapter.Boolean; expression: playBlinker.value && !isPlaying.value && (!isCueing.value || (isCueing.value && (!isRunning.value || !isLoaded.value))) } }
    Wire { from: "PlayBlinkerCueing.trigger"; to: ExpressionAdapter { type: ExpressionAdapter.Boolean; expression: playBlinker.value && !isPlaying.value && isCueing.value && isRunning.value && isLoaded.value } }

    //Cue should BLINK when deck is Stopped and not in the Active Cue
    Blinker { name: "CueBlinker"; cycle: 500; color: Color.Blue; defaultBrightness: bright; blinkBrightness: dimmed } //CUE should BLINK when paused and out of Active Cue Position
    Wire { from: "CueBlinker.trigger"; to: ExpressionAdapter { type: ExpressionAdapter.Boolean; expression: cueBlinker.value && !isRunning.value && !activeCueWithPlayhead } }

    //Sync should BLINK when out of Phase, or when Tempo is out of Tempo Range (as an alert to prevent that you are waaay to far away from the original BPM)
    Blinker { name: "SyncBlinkerOutLimitPhase"; cycle: 500; color: !isLoaded.value ? Color.Green : Color.Red; defaultBrightness: bright; blinkBrightness: dimmed } //Sync should BLINK when out of phase OR warn if the sync is "too much"
    Wire { from: "SyncBlinkerOutLimitPhase.trigger"; to: ExpressionAdapter { type: ExpressionAdapter.Boolean; expression: isSyncEnabled.value && !syncInRange || !syncInPhase } }

    //Vinyl Break
    property int vinylBreakDuration: vinylBreakDurationInSeconds.value //vinylBreakInBeats.value ? (vinylBreakDurationInBeats.value*(2/tempoBPM.value)*60000).toFixed(0) : vinylBreakDurationInSeconds.value
    property double adjustedTempobend: stableTempo.value < 1 ? stableTempo.value : 1
    property bool previousKeyLockState: false
    ButtonScriptAdapter {
        name: "VinylBreak"
        onPress: {
            if (vinylBreak_countdown.running) {
                vinylBreak_countdown.stop()
                tempobend.value = 0
                isPlaying.value = true
                if (previousKeyLockState) {
                    keyLock.value = true
                }
            }
            else if (isPlaying.value && vinylBreakDuration > 0) {
                isPlaying.value = false
                tempobend.value = adjustedTempobend
                vinylBreak_countdown.restart()
                if (Math.abs(keyAdjust.value) <= 0.05/12 && keyLock.value) {
                    previousKeyLockState = true
                    keyLock.value = false
                }
            }
            else {
                isPlaying.value = !isPlaying.value
            }
        }
    }
    Timer { id: vinylBreak_countdown; interval: (vinylBreakDuration/adjustedTempobend)/100; repeat: true
        onTriggered: {
            if (tempobend.value < 0.005) {
                vinylBreak_countdown.stop()
                tempobend.value = 0
                if (previousKeyLockState) {
                    keyLock.value = true
                }
            }
            else tempobend.value = tempobend.value - 0.01
        }
    }

    //KeyLock button
    Blinker { name: "KeyLockBlinker"; cycle: 250; defaultBrightness: bright; blinkBrightness: dimmed }
    property bool holdKeyLock: false
    ButtonScriptAdapter {
        name: "KeyLockButton"
        brightness: (keyLock.value && !holdGrid.value) || (gridLock.value && (holdGrid.value || editMode.value))
        color: LED.custom(deckId)
        onPress: {
            holdKeyLock_countdown.restart()
        }
        onRelease: {
            if (holdKeyLock_countdown.running) {
                if (!holdGrid.value && !editMode.value) keyLock.value = !keyLock.value
                else gridLock.value = !gridLock.value
            }
            holdKeyLock_countdown.stop()
            holdKeyLock = false
        }
    }
    Timer { id: holdKeyLock_countdown; interval: holdTimer.value
        onTriggered: {
            holdKeyLock = true
        }
    }

    //Key Sync Button
    ButtonScriptAdapter {
        name: "KeySyncButton"
        brightness: dimmed //KeySync.isSynchronized(keyTextIndex, master().keyTextIndex, fuzzyKeySync.value) && keyLock.value

        onPress: {
            if (keyLock.value) {
                if (KeySync.isSynchronized(keyTextIndex, master().keyTextIndex, fuzzyKeySync.value)) keyAdjust.value = 0
                else keyAdjust.value = keyAdjust.value + KeySync.sync(keyTextIndex, master().keyTextIndex, fuzzyKeySync.value) + keyTextOffset + master().keyTextOffset
            }
            else {
                // keyLocked.value = true
                keyAdjust.value = KeySync.sync(keyTextIndex, master().keyTextIndex, fuzzyKeySync.value) + keyTextOffset + master().keyTextOffset
            }
        }
    }


    DirectPropertyAdapter { name: "tempo_fader_relative"; path: "mapping.settings.tempo_fader_relative"; input: false }
    Wire{ from: "tempo_fader_relative"; to: "tempo_control.enable_relative_mode" }

    WiresGroup {
        enabled: active

        //Play button
        WiresGroup {
            enabled: isLoaded.value
            Wire { from: "%surface%.play"; to: TogglePropertyAdapter { path: "app.traktor.decks." + deckId + ".play"; output: !playBlinker.value } enabled: (!shift && playButton.value == 0) || (shift && shiftPlayButton.value == 0) }
            Wire { from: "%surface%.play.value"; to: "VinylBreak"; enabled: (!shift && playButton.value == 1) || (shift && shiftPlayButton.value == 1) }
            //LED Blinker
            Wire { from: "%surface%.play.led"; to: "PlayBlinkerStopped"; enabled: playBlinker.value && !isPlaying.value && (!isCueing.value || (isCueing.value && (!isRunning.value || !isLoaded.value))) }
            Wire { from: "%surface%.play.led"; to: "PlayBlinkerCueing"; enabled: playBlinker.value && !isPlaying.value && isCueing.value && isRunning.value && isLoaded.value }
            Wire { from: "%surface%.play"; to: ButtonScriptAdapter { color: Color.Green; brightness: isPlaying.value ? bright : dimmed } enabled: (playBlinker.value && isPlaying.value) || (!playBlinker.value && (!shift && playButton.value == 0) || (shift && shiftPlayButton.value == 0)) }
        }
        Wire { from: "%surface%.play"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".play"; value: false; output: false } enabled: !isLoaded.value }

        //Cue button
        WiresGroup {
            enabled: isLoaded.value
            Wire { from: "%surface%.cue"; to: DirectPropertyAdapter { path: "app.traktor.decks." + deckId + ".cue"; output: !cueBlinker.value } enabled: (!shift && cueButton.value == 0) || (shift && shiftCueButton.value == 0) }
            Wire { from: "%surface%.cue"; to: DirectPropertyAdapter { path: "app.traktor.decks." + deckId + ".cup"; output: !cueBlinker.value } enabled: (!shift && cueButton.value == 1) || (shift && shiftCueButton.value == 1) }
            Wire { from: "%surface%.cue"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".seek"; value: 0 } enabled: (!shift && cueButton.value == 2) || (shift && shiftCueButton.value == 2) }
            Wire { from: "%surface%.cue.led"; to: "CueBlinker"; enabled: cueBlinker.value && !((!shift && cueButton.value == 2) || (shift && shiftCueButton.value == 2)) }
        }

        //Sync button
        WiresGroup {
            enabled: !holdKeyLock
            WiresGroup {
                enabled: !shift
                Wire { from: "%surface%.sync.value"; to: TogglePropertyAdapter { path: isSyncEnabled.path; output: false } enabled: !beatmatchPracticeMode.value }
                Wire { from: "%surface%.sync.value"; to: SetPropertyAdapter { path: isSyncEnabled.path; value: false; output: false } enabled: beatmatchPracticeMode.value }
                //Wire { from: "%surface%.sync"; to: ButtonScriptAdapter { color: syncInPhase ? Color.Green : Color.Red; brightness: isSyncEnabled.value } enabled: vinylBreak_countdown.running }
                Wire { from: "%surface%.sync"; to: ButtonScriptAdapter { brightness: isSyncEnabled.value } enabled: (!isSyncEnabled.value || (syncInPhase && syncInRange)) && !beatmatchPracticeMode.value }
                //LED Blinker
                WiresGroup {
                    enabled: !vinylBreak_countdown.running
                    //Wire { from: "%surface%.sync"; to: ButtonScriptAdapter { brightness: isSyncEnabled.value } enabled: syncInRange }
                    //Wire { from: "%surface%.sync"; to: ButtonScriptAdapter { brightness: dimmed } enabled: !syncInRange && !isSyncEnabled.value }
                    Wire { from: "%surface%.sync.led"; to: "SyncBlinkerOutLimitPhase"; enabled: isSyncEnabled.value && (!syncInPhase || !syncInRange) && !beatmatchPracticeMode.value }
                }
            }
            WiresGroup {
                enabled: shift
                Wire { from: "%surface%.sync"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".set_as_master"; output: false } } //enabled: (volume.value != 0 && isRunning.value && masterMode.value) || !masterMode.value } //enabled: (editMode.value != EditMode.armed) && (editMode.value != EditMode.used) }
                //LED Mod
                Wire { from: "%surface%.sync"; to: ButtonScriptAdapter { brightness: (masterId.value+1) == deckId ? bright : dimmed } enabled: isRunning.value && ((volume.value != 0 && masterMode.value) || !masterMode.value) } //AJF: volume != 0  only if setting "Only on-air decks can be master" is enabled //enabled: (editMode.value != EditMode.armed) && (editMode.value != EditMode.used) }
            }
        }
        WiresGroup {
            enabled: holdKeyLock

            Wire { from: "%surface%.sync"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.lock_enabled"; value: true; output: false } enabled: active && hasTrackProperties && !keyLock.value && masterId.value != -1 && (master().deckType == DeckType.Track || master().deckType == DeckType.Stem) }
            Wire { from: "%surface%.sync"; to: "KeySyncButton"; enabled: active && hasTrackProperties && masterId.value != -1 && (master().deckType == DeckType.Track || master().deckType == DeckType.Stem) }
        }

        //KeyLock button
        WiresGroup {
            enabled: hasTrackProperties
            Wire { from: "%surface%.key_lock"; to: "KeyLockButton"; enabled: !shift }
            Wire { from: "%surface%.key_lock"; to: "tempo_control.reset"; enabled: shift }
        }

        //Flux buttons
        Wire { from: "%surface%.flux"; to: "transport.flux" }
        Wire { from: "%surface%.reverse"; to: "transport.flux_reverse"; enabled: reverseCensor.value }
        WiresGroup {
            enabled: !reverseCensor.value
            Wire { from: "%surface%.reverse"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".flux.reverse" } enabled: fluxEnabled.value }
            Wire { from: "%surface%.reverse"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".reverse" } enabled: !fluxEnabled.value }
        }

        //Tempo fader
        Wire { from: "%surface%.pitch.fader"; to: "tempo_control.adjust" }
        //Wire { from: "%surface%.pitch.led"; to: "tempo_control.indicator" }

        //Wire { from: "fader.softtakeover.output"; to: DirectPropertyAdapter { path: "app.traktor.decks." + deckId + ".tempo.adjust" } }
        //Wire { from: "fader.softtakeover.output"; to: DirectPropertyAdapter { path: "app.traktor.decks." + deckId + ".tempo.adjust"; rescale: true } }
        //Wire { from: "fader.softtakeover.output"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deckId + ".tempo.adjust"; mode: RelativeMode.Default  } }
        //Wire { from: "fader.softtakeover.output_monitor"; to: DirectPropertyAdapter { path: "app.traktor.decks." + deckId + ".tempo.adjust" } }
        //Wire { from: "fader.softtakeover.output"; to: ExpressionAdapter { type: ExpressionAdapter.Float; expression: tempoAdjust.value } }
        //Wire { from: "fader.softtakeover.output"; to: DirectPropertyAdapter { path: "app.traktor.decks." + deckId + ".tempo.adjust"; rescale: true } }
    }

    /*
    property var debug: ({
        tempo: tempo.value
    })
    onDebugChanged: { console.log(JSON.stringify(tempo_fader)); console.log(JSON.stringify(tempo_control)) }
    */
}
