import CSI 1.0
import QtQuick 2.12

import "../../../Defines"
import "../../../Helpers/KeySync.js" as KeySync
import "../../../Helpers/KeyHelpers.js" as Key

Module {
    id: module
    property bool active: true
    property int deckId: 1 //1-4
    property string surface: "path"

    TransportSection { name: "transport"; channel: deckId }
    CopyMasterPhase { name: "CopyMasterPhase";  channel: deckId }

    SwitchTimer { name: "CopyMasterPhase_Switch"; setTimeout: 1000 }
    Blinker { name: "CopyMasterPhase_Blinker"; cycle: 300; repetitions: 3; defaultBrightness: bright; blinkBrightness: dimmed; color: Color.Green }

    //Flux should BLINK when fluxing
    Blinker { name: "FluxBlinker"; cycle: 250; defaultBrightness: bright; blinkBrightness: dimmed } //CUE should BLINK when paused and out of Active Cue Position
    Wire { from: "FluxBlinker.trigger"; to: ExpressionAdapter { type: ExpressionAdapter.Boolean; expression: fluxState.value == 2 } }

    //Play should BLINK When Deck is Loaded & Paused or warn when Cueing but not playing
    Blinker { name: "PlayBlinkerStopped"; cycle: 1000; color: Color.Green; defaultBrightness: dimmed; blinkBrightness: bright }
    Blinker { name: "PlayBlinkerCueing"; cycle: 250; color: Color.Green; defaultBrightness: dimmed; blinkBrightness: bright }
    Wire { from: "PlayBlinkerStopped.trigger"; to: ExpressionAdapter { type: ExpressionAdapter.Boolean; expression: playBlinker.value && !isPlaying.value && (!isCueing.value || (isCueing.value && (!isRunning.value || !isLoaded.value))) } }
    Wire { from: "PlayBlinkerCueing.trigger"; to: ExpressionAdapter { type: ExpressionAdapter.Boolean; expression: playBlinker.value && !isPlaying.value && isCueing.value && isRunning.value && isLoaded.value } }

    //Cue should BLINK when deck is Stopped and not in the Active Cue
    Blinker { name: "CueBlinker"; cycle: 500; color: Color.Blue; defaultBrightness: bright; blinkBrightness: dimmed } //CUE should BLINK when paused and out of Active Cue Position
    Wire { from: "CueBlinker.trigger"; to: ExpressionAdapter { type: ExpressionAdapter.Boolean; expression: cueBlinker.value && !isRunning.value && !activeCueWithPlayhead } }

    //Sync should BLINK when out of Phase, or when Tempo is out of Tempo Range (as an alert to prevent that you are waaay to far away from the original BPM)
    Blinker { name: "SyncBlinkerOutLimit"; cycle: 500; color: Color.Green; defaultBrightness: bright; blinkBrightness: dimmed } //Sync should BLINK when out of phase OR warn if the sync is "too much"
    Blinker { name: "SyncBlinkerOutLimitPhase"; cycle: 500; color: !isLoaded.value ? Color.Green : Color.Red; defaultBrightness: bright; blinkBrightness: dimmed } //Sync should BLINK when out of phase OR warn if the sync is "too much"
    Wire { from: "SyncBlinkerOutLimit.trigger"; to: ExpressionAdapter { type: ExpressionAdapter.Boolean; expression: isSyncEnabled.value && !syncInRange && syncInPhase } }
    Wire { from: "SyncBlinkerOutLimitPhase.trigger"; to: ExpressionAdapter { type: ExpressionAdapter.Boolean; expression: isSyncEnabled.value && !syncInRange && !syncInPhase } }

    //Hold Sync
    ButtonScriptAdapter {
        name: "SyncButton"
        onPress: {
            holdSync_countdown.restart()
        }
        onRelease: {
            if (holdSync_countdown.running) {
                if (!beatmatchPracticeMode.value) isSyncEnabled.value = !isSyncEnabled.value
                else isSyncEnabled.value = false
            }
            holdSync_countdown.stop()
        }
    }
    Timer { id: holdSync_countdown; interval: holdTimer.value
        onTriggered: {
            if (hasTrackProperties && masterId.value != -1 && (master().deckType == DeckType.Track || master().deckType == DeckType.Stem)) {
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
    }

    //Vinyl Break
    property int vinylBreakDuration: vinylBreakInBeats.value ? (vinylBreakDurationInBeats.value*(2/tempoBPM.value)*60000).toFixed(0) : vinylBreakDurationInSeconds.value
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

    WiresGroup {
    enabled: active

        //Play button
        WiresGroup {
            enabled: !shift
            Wire { from: "%surface%.play"; to: TogglePropertyAdapter { path: isPlaying.path; output: !playBlinker.value } enabled: playButton.value == 0 && isLoaded.value }
            Wire { from: "%surface%.play.value"; to: "VinylBreak"; enabled: playButton.value == 1 && isLoaded.value }
            Wire { from: "%surface%.play"; to: SetPropertyAdapter { path: isPlaying.path; value: false; output: false } enabled: !isLoaded.value }
            //LED Blinker
            WiresGroup {
                enabled: isLoaded.value
                Wire { from: "%surface%.play.led"; to: "PlayBlinkerStopped"; enabled: playBlinker.value && !isPlaying.value && (!isCueing.value || (isCueing.value && (!isRunning.value || !isLoaded.value))) }
                Wire { from: "%surface%.play.led"; to: "PlayBlinkerCueing"; enabled: playBlinker.value && !isPlaying.value && isCueing.value && isRunning.value && isLoaded.value }
                Wire { from: "%surface%.play"; to: ButtonScriptAdapter { color: Color.Green; brightness: isPlaying.value ? bright : dimmed } enabled: (playBlinker.value && isPlaying.value) || (!playBlinker.value && playButton.value == 1) }
            }
        }
        WiresGroup {
            enabled: shift
            Wire { from: "%surface%.play"; to: "transport.timecode"; enabled: shiftPlayButton.value == 0 }
            WiresGroup {
                enabled: shiftPlayButton.value == 1
                Wire { from: "%surface%.play.value"; to: "VinylBreak"; enabled: isLoaded.value }
                Wire { from: "%surface%.play"; to: SetPropertyAdapter { path: isPlaying.path; value: false; output: false } enabled: !isLoaded.value }
                //LED Blinker
                WiresGroup {
                    enabled: isLoaded.value
                    Wire { from: "%surface%.play.led"; to: "PlayBlinkerStopped"; enabled: playBlinker.value && !isPlaying.value && (!isCueing.value || (isCueing.value && (!isRunning.value || !isLoaded.value))) }
                    Wire { from: "%surface%.play.led"; to: "PlayBlinkerCueing"; enabled: playBlinker.value && !isPlaying.value && isCueing.value && isRunning.value && isLoaded.value }
                    Wire { from: "%surface%.play"; to: ButtonScriptAdapter { color: Color.Green; brightness: isPlaying.value ? bright : dimmed } enabled: (playBlinker.value && isPlaying.value) || !playBlinker.value }
                }
            }
            Wire { from: "%surface%.play"; to: TogglePropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.lock_enabled_preserve_pitch" } enabled: shiftPlayButton.value == 2 && hasTrackProperties } //to preserve the key adjust when enabling keyLock
            Wire { from: "%surface%.play"; to: TogglePropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.lock_enabled" } enabled: shiftPlayButton.value == 3 && hasTrackProperties } //to reset to 0 when enabling keyLock
        }

        //Cue button
        WiresGroup {
            enabled: isLoaded.value
            Wire { from: "%surface%.cue"; to: DirectPropertyAdapter { path: isCueing.path; output: !cueBlinker.value } enabled: (!shift && cueButton.value == 0) || (shift && shiftCueButton.value == 0) }
            Wire { from: "%surface%.cue"; to: DirectPropertyAdapter { path: isCuePlaying.path; output: !cueBlinker.value } enabled: (!shift && cueButton.value == 1) || (shift && shiftCueButton.value == 1) }
            Wire { from: "%surface%.cue"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".seek"; value: 0 } enabled: (!shift && cueButton.value == 2) || (shift && shiftCueButton.value == 2) }
            Wire { from: "%surface%.cue.led"; to: "CueBlinker"; enabled: cueBlinker.value && !((!shift && cueButton.value == 2) || (shift && shiftCueButton.value == 2)) }
        }

        //Sync button
        WiresGroup {
            enabled: !shift
            Wire { from: "%surface%.sync.value"; to: "SyncButton" }
            //LED Blinker
            Wire { from: "%surface%.sync"; to: ButtonScriptAdapter { color: syncInPhase ? Color.Green : Color.Red; brightness: isSyncEnabled.value } enabled: vinylBreak_countdown.running }
            WiresGroup {
                enabled: !vinylBreak_countdown.running
                Wire { from: "%surface%.sync"; to: ButtonScriptAdapter { color: (syncInPhase || !isLoaded.value) ? Color.Green : Color.Red; brightness: isSyncEnabled.value } enabled: syncInRange }
                Wire { from: "%surface%.sync"; to: ButtonScriptAdapter { color: (syncInPhase || !isLoaded.value)  ? Color.Green : Color.Red; brightness: dimmed } enabled: !syncInRange && !isSyncEnabled.value }
                Wire { from: "%surface%.sync.led"; to: "SyncBlinkerOutLimit"; enabled: !syncInRange && isSyncEnabled.value && syncInPhase && !beatmatchPracticeMode.value }
                Wire { from: "%surface%.sync.led"; to: "SyncBlinkerOutLimitPhase"; enabled: !syncInRange && isSyncEnabled.value && !syncInPhase && !beatmatchPracticeMode.value }
            }
        }
        WiresGroup {
            enabled: shift
            Wire { from: "%surface%.sync"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".set_as_master"; output: false } } //enabled: (volume.value != 0 && isRunning.value && masterMode.value) || !masterMode.value } //enabled: (editMode.value != EditMode.armed) && (editMode.value != EditMode.used) }
            //LED Mod
            Wire { from: "%surface%.sync"; to: ButtonScriptAdapter { color: Color.Green; brightness: (masterId.value+1) == deckId ? bright : dimmed } enabled: isRunning.value && ((volume.value != 0 && masterMode.value) || !masterMode.value) } //AJF: volume != 0  only if setting "Only on-air decks can be master" is enabled //enabled: (editMode.value != EditMode.armed) && (editMode.value != EditMode.used) }
        }

        WiresGroup {
            enabled: editMode.value == EditMode.armed || editMode.value == EditMode.used
            Wire { from: "%surface%.sync.led"; to: "CopyMasterPhase_Blinker" }
            Wire { from: "%surface%.sync.value"; to: ButtonScriptAdapter { onPress: if (editMode.value == EditMode.armed) { editMode.value = EditMode.used } } }
            Wire { from: "%surface%.sync"; to: "CopyMasterPhase_Switch.input" }
            Wire { from: "CopyMasterPhase_Switch.output"; to: "CopyMasterPhase" }
            Wire { from: "CopyMasterPhase_Switch.output"; to: "CopyMasterPhase_Blinker.trigger" }
        }

        //Flux button
        Wire { from: "%surface%.flux"; to: "transport.flux"; enabled: !shift }
        WiresGroup {
            enabled: shift
            Wire { from: "%surface%.flux"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".flux.reverse" } enabled: fluxEnabled.value || reverseCensor.value }
            Wire { from: "%surface%.flux"; to: HoldPropertyAdapter { path: "app.traktor.decks." + deckId + ".reverse" } enabled: !fluxEnabled.value && !reverseCensor.value }
        }
    }
}
