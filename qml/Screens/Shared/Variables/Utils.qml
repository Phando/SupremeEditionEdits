import CSI 1.0
import QtQuick 2.12

Module {
  id: utils

//--------------------------------------------------------------------------------------------------------------------
// Math functions
//--------------------------------------------------------------------------------------------------------------------

  function log10(num) {
    return Math.log(num) / Math.LN10
  }

  function clamp(value, min, max) { //clamp returns the index if it is in the min-max interval. If the ind is minor than the min, it will return the min. If major than the max, it will return the major.
    return Math.max(min, Math.min(value, max))
  }

//--------------------------------------------------------------------------------------------------------------------
// App Properties
//--------------------------------------------------------------------------------------------------------------------

  AppProperty { id: masterId; path: "app.traktor.masterclock.source_id" }
  AppProperty { id: masterBPM; path: "app.traktor.masterclock.tempo" }
  AppProperty { id: masterKey; path: "app.traktor.decks." + (masterId.value+1) + ".track.key.resulting.precise" }
  AppProperty { id: masterKeyRounded; path: "app.traktor.decks." + (masterId.value+1) + ".track.key.resulting.quantized" }
  AppProperty { id: masterKeyText; path: "app.traktor.decks." + (masterId.value+1) + ".content.legacy_key" }
  AppProperty { id: masterKeyAdjust; path: "app.traktor.decks." + (masterId.value+1) + ".track.key.adjust" }

  AppProperty { id: deckAType; path: "app.traktor.decks.1.type" }
  AppProperty { id: deckBType; path: "app.traktor.decks.2.type" }
  AppProperty { id: deckCType; path: "app.traktor.decks.3.type" }
  AppProperty { id: deckDType; path: "app.traktor.decks.4.type" }

  AppProperty { id: deckAMixerBpm; path: "app.traktor.decks.1.tempo.base_bpm" }
  AppProperty { id: deckBMixerBpm; path: "app.traktor.decks.2.tempo.base_bpm" }
  AppProperty { id: deckCMixerBpm; path: "app.traktor.decks.3.tempo.base_bpm" }
  AppProperty { id: deckDMixerBpm; path: "app.traktor.decks.4.tempo.base_bpm" }

  AppProperty { id: deckAGridOffset; path: "app.traktor.decks.1.content.grid_offset" }
  AppProperty { id: deckBGridOffset; path: "app.traktor.decks.2.content.grid_offset" }
  AppProperty { id: deckCGridOffset; path: "app.traktor.decks.3.content.grid_offset" }
  AppProperty { id: deckDGridOffset; path: "app.traktor.decks.4.content.grid_offset" }

  AppProperty { id: deckATrackLength; path: "app.traktor.decks.1.track.content.track_length" }
  AppProperty { id: deckBTrackLength; path: "app.traktor.decks.2.track.content.track_length" }
  AppProperty { id: deckCTrackLength; path: "app.traktor.decks.3.track.content.track_length" }
  AppProperty { id: deckDTrackLength; path: "app.traktor.decks.4.track.content.track_length" }

  AppProperty { id: deckAElapsedTime; path: "app.traktor.decks.1.track.player.elapsed_time" }
  AppProperty { id: deckBElapsedTime; path: "app.traktor.decks.2.track.player.elapsed_time" }
  AppProperty { id: deckCElapsedTime; path: "app.traktor.decks.3.track.player.elapsed_time" }
  AppProperty { id: deckDElapsedTime; path: "app.traktor.decks.4.track.player.elapsed_time" }

  AppProperty { id: deckANextCuePoint; path: "app.traktor.decks.1.track.player.next_cue_point" }
  AppProperty { id: deckBNextCuePoint; path: "app.traktor.decks.2.track.player.next_cue_point" }
  AppProperty { id: deckCNextCuePoint; path: "app.traktor.decks.3.track.player.next_cue_point" }
  AppProperty { id: deckDNextCuePoint; path: "app.traktor.decks.4.track.player.next_cue_point" }

  AppProperty { id: remixABeatPos; path: "app.traktor.decks.1.remix.current_beat_pos" }
  AppProperty { id: remixBBeatPos; path: "app.traktor.decks.2.remix.current_beat_pos" }
  AppProperty { id: remixCBeatPos; path: "app.traktor.decks.3.remix.current_beat_pos" }
  AppProperty { id: remixDBeatPos; path: "app.traktor.decks.4.remix.current_beat_pos" }

//--------------------------------------------------------------------------------------------------------------------
// Mapping Properties
//--------------------------------------------------------------------------------------------------------------------

  MappingProperty { id: beatsxPhrase; path: "mapping.settings.beatsxPhrase" }
  MappingProperty { id: perfectTempoMatchLimit; path: "mapping.settings.perfectTempoMatchLimit" }
  MappingProperty { id: regularTempoMatchLimit; path: "mapping.settings.regularTempoMatchLimit" }

//--------------------------------------------------------------------------------------------------------------------
// Beat Counter Helpers
//--------------------------------------------------------------------------------------------------------------------

  function getBeats(deckId) {
    switch (deckId) {
        case 1: return deckAType.value != 1 ? (((deckAElapsedTime.value * 1000 - deckAGridOffset.value) * deckAMixerBpm.value) / 60000.0) : parseInt(remixABeatPos.value)
        case 2: return deckBType.value != 1 ? (((deckBElapsedTime.value * 1000 - deckBGridOffset.value) * deckBMixerBpm.value) / 60000.0) : parseInt(remixBBeatPos.value)
        case 3: return deckCType.value != 1 ? (((deckCElapsedTime.value * 1000 - deckCGridOffset.value) * deckCMixerBpm.value) / 60000.0) : parseInt(remixCBeatPos.value)
        case 4: return deckDType.value != 1 ? (((deckDElapsedTime.value * 1000 - deckDGridOffset.value) * deckDMixerBpm.value) / 60000.0) : parseInt(remixDBeatPos.value);
    }
  }

  function getBeatsToCue(deckId) {
    switch (deckId) {
        case 1:
            var cuePos = deckANextCuePoint.value
            if (cuePos < 0.0) cuePos = deckATrackLength.value * 1000
            return ((deckAElapsedTime.value * 1000 - cuePos) * deckAMixerBpm.value) / 60000.0
        case 2:
            var cuePos = deckBNextCuePoint.value
            if (cuePos < 0.0) cuePos = deckBTrackLength.value * 1000
            return ((deckBElapsedTime.value * 1000 - cuePos) * deckBMixerBpm.value) / 60000.0
        case 3:
            var cuePos = deckCNextCuePoint.value
            if (cuePos < 0.0) cuePos = deckCTrackLength.value * 1000
            return ((deckCElapsedTime.value * 1000 - cuePos) * deckCMixerBpm.value) / 60000.0
        case 4:
            var cuePos = deckDNextCuePoint.value
            if (cuePos < 0.0) cuePos = deckDTrackLength.value * 1000
            return ((deckDElapsedTime.value * 1000 - cuePos) * deckDMixerBpm.value) / 60000.0;
    }
  }

  function getBeatsFromCue(deckId) {
    switch (deckId) {
        case 1:
            var cuePos = deckAPrevCuePoint.value
            return ((deckAElapsedTime.value * 1000 - cuePos) * deckAMixerBpm.value) / 60000.0
        case 2:
            var cuePos = deckBPrevCuePoint.value
            return ((deckBElapsedTime.value * 1000 - cuePos) * deckBMixerBpm.value) / 60000.0
        case 3:
            var cuePos = deckCPrevCuePoint.value
            return ((deckCElapsedTime.value * 1000 - cuePos) * deckCMixerBpm.value) / 60000.0
        case 4:
            var cuePos = deckDPrevCuePoint.value
            return ((deckDElapsedTime.value * 1000 - cuePos) * deckDMixerBpm.value) / 60000.0;
    }
  }

  function beatCounterString(deckId, beatCounterMode) {
    var currentBeat = (beatCounterMode == 4) ? Math.abs(getBeatsFromCue(deckId)) : ((beatCounterMode == 3) ? Math.abs(getBeatsToCue(deckId)) : Math.abs(getBeats(deckId)));
    var totalbars = parseInt(currentBeat / 4) + 1;

    //TO DO: if deck is Remix Deck --> use 16 (or even remixQuantIndex.value*4) instead of beatsxPhrase.value
    var beats = parseInt((currentBeat%beatsxPhrase.value) % 4)+1;
    var bars = parseInt((currentBeat/4) % (beatsxPhrase.value/4)  + 1);
    var phrases = parseInt((currentBeat/beatsxPhrase.value) + 1)

    switch (beatCounterMode) {
        case 0: return (getBeats(deckId) < 0 ? "- " : "") + totalbars.toString() + " Bars"
        case 1: return (getBeats(deckId) < 0 ? "- " : "") + totalbars.toString() + "." + beats.toString() + " Bars"
        case 2: return (getBeats(deckId) < 0 ? "- " : "") + phrases.toString() + "." + bars.toString() + "." + beats.toString()
        case 3: return (getBeatsToCue(deckId) < 0 ? "- " : "") + phrases.toString() + "." + bars.toString() + "." + beats.toString()
        case 4: return (getBeatsFromCue(deckId) < 0 ? "- " : "") + phrases.toString() + "." + bars.toString() + "." + beats.toString();
    }
  }

  function fixedBeatCounterString(deckid, beatCounterMode) {
    var currentBeat = Math.abs(view.getCorrectBeats(deckId))

    var beats = parseInt((currentBeat % (beatsxPhrase.value)) % 4 )+1;
    var bars = parseInt((currentBeat / 4) % (beatsxPhrase.value/4)  + 1);
    //var phrases = view.getAcumulatedPhrases(deckId) + parseInt((currentBeat / beatsxPhrase.value) + 1);
    var phrases = 1

    switch (beatCounterMode) {
        case 0: return (getBeats(deckId) < 0 ? "- " : "") + totalbars.toString() + " Bars"
        case 1: return (getBeats(deckId) < 0 ? "- " : "") + totalbars.toString() + "." + beats.toString() + " Bars"
        case 2: return (getBeats(deckId) < 0 ? "- " : "") + phrases.toString() + "." + bars.toString() + "." + beats.toString()
        case 3: return (getBeatsToCue(deckId) < 0 ? "- " : "") + phrases.toString() + "." + bars.toString() + "." + beats.toString()
        case 4: return (getBeatsFromCue(deckId) < 0 ? "- " : "") + phrases.toString() + "." + bars.toString() + "." + beats.toString();
    }
  }

//--------------------------------------------------------------------------------------------------------------------
// Time Conversion Helpers
//--------------------------------------------------------------------------------------------------------------------

  function getTime(time){ //Time in seconds
    var neg = time < 0
    var roundedSec = Math.floor(time);

    if (neg) {
        roundedSec = -roundedSec;
    }

    var sec = roundedSec % 60;
    var min = (roundedSec - sec) / 60

    var secStr = sec.toString();
    if (sec < 10) secStr = "0" + secStr

    var minStr = min.toString();
    if (min < 10) minStr = "0" + minStr;

    return (neg ? "-" : "") + minStr + ":" + secStr;
  }

  function getRemainingTime(length, elapsed){
    return (elapsed > length) ? getTime(0) : getTime(Math.floor(elapsed) - Math.floor(length))
  }

//--------------------------------------------------------------------------------------------------------------------
// Other Helpers
//--------------------------------------------------------------------------------------------------------------------

  function convertToDb(gain) {
    var level0dB = 1.0;
    var norm = gain / level0dB;
    if (norm <= 0.0)
      return -0.0000000001;

    return 20.0*log10(norm);
  }

  //TO-DO: Move to colors
  function colorRangeTempo(tempoOffset) {
    if (-perfectTempoMatchLimit.value < tempoOffset && tempoOffset <= perfectTempoMatchLimit.value){
        return colors.greenActive; //colors.colorGrey72;
    }
    else if ((perfectTempoMatchLimit.value < tempoOffset && tempoOffset <= regularTempoMatchLimit.value) || (-perfectTempoMatchLimit.value > tempoOffset && tempoOffset >= -regularTempoMatchLimit.value)){
        return colors.orange;
    }
    else {
        return colors.red;
    }
  }
}
