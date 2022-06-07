import CSI 1.0
import QtQuick 2.12

Item {
  id : phaseMeter
  property int deckId: 1

  width: 148
  height: 20
  clip: false

  AppProperty { id: masterId; path: "app.traktor.masterclock.source_id" }
  AppProperty { id: isSynched; path: "app.traktor.decks." + deckId + ".sync.enabled" }
  AppProperty { id: tempoPhase; path: "app.traktor.decks." + deckId + ".tempo.phase" }
  readonly property double phase: (tempoPhase.value*2).toFixed(4)

  MappingProperty { id: beatsxPhrase; path: "mapping.settings.beatsxPhrase" }
  MappingProperty { id: beatCounterMode; path: "mapping.settings.beatCounterMode" }

  MappingProperty { id: beatCounterX; path: deckPropertiesPath + ".beatgrid.counter.x" }
  MappingProperty { id: beatCounterY; path: deckPropertiesPath + ".beatgrid.counter.y" }
  MappingProperty { id: beatCounterZ; path: deckPropertiesPath + ".beatgrid.counter.z" }

  property color masterColor: colors.cyan
  property color syncEnabledColor: colors.greenActive
  property color syncEnabledPhaseColor: colors.redActive
  property color syncDisabledColor: colors.colorGrey232

//------------------------------------------------------------------------------------------------------------------
// Master Beats
//------------------------------------------------------------------------------------------------------------------

  Repeater {
    id: master_beats
    model: 4

    Rectangle {
        width: 34
        height: 6
        y: 0
        x: index * 38
        color: masterBeatColor(index)
    }
  }

  function masterBeatColor(index) {
    var MasterBeats = utils.getBeats(masterId.value+1);
    var MasterBeat = parseInt(Math.abs(MasterBeats) % 4);
    if (MasterBeats < 0.0) MasterBeat = 3 - MasterBeat;

    //InternalClock is Master
    if (masterId.value == -1) return masterColor;

    //CurrentDeck is Master
    if (deckId == masterId.value+1) {
        if (MasterBeat != index) return colors.darkerColor(masterColor, 0.30)
        else return masterColor
    }
    //Master is not current deck nor the InternalClock
    else {
        if (MasterBeat != index) return colors.darkerColor(syncDisabledColor, 0.30);
        else return syncDisabledColor;
    }
  }

//------------------------------------------------------------------------------------------------------------------
// Deck Beats
//------------------------------------------------------------------------------------------------------------------

  Repeater {
    id: beats
    model: 4

    Rectangle {
        width: 34
        height: 10
        y: 10
        x: index * 38
        color: deckBeatColor(index)
    }
  }

  function deckBeatColor(index) {
    var DeckBeats = utils.getBeats(deckId);
    var DeckBeat = parseInt(Math.abs(DeckBeats) % 4);
    if (DeckBeats < 0.0) DeckBeat = 3 - DeckBeat;

    var MasterBeats = utils.getBeats(masterId.value+1);
    var MasterBeat = parseInt(Math.abs(MasterBeats) % 4);
    if (MasterBeats < 0.0) MasterBeat = 3 - MasterBeat;

    //InternalClock is Master
    if (masterId.value == -1 && isSynched.value){
        if (DeckBeat != index) return colors.darkerColor(masterColor, 0.30)
        else return masterColor
    }
    //BeatPhase Synched and in the same beat as Master
    else if ((DeckBeat == MasterBeat && (phase >= -0.016 && phase <= 0.016) && isSynched.value) || deckId == masterId.value+1) {
        if (DeckBeat != index) return colors.darkerColor(syncEnabledColor, 0.30)
        else return syncEnabledColor
    }
    //Tempo Synched (out of phase)
    else if ((DeckBeat != MasterBeat || (phase < -0.016 && phase > 0.016)) && isSynched.value) {
        if (DeckBeat != index) return colors.darkerColor(syncEnabledPhaseColor, 0.30)
        else return syncEnabledPhaseColor
    }
    //Not synched
    else {
        if (DeckBeat != index) return colors.darkerColor(syncDisabledColor, 0.30)
        else return syncDisabledColor
    }
  }

//------------------------------------------------------------------------------------------------------------------
// Master Beats Value
//------------------------------------------------------------------------------------------------------------------

  Text {
    width: 58
    y: -3
    x: 152
    font.pixelSize: fonts.smallFontSize
    font.family: "Pragmatica"
    horizontalAlignment: Text.AlignRight
    color: (masterId.value == -1 || deckId == masterId.value+1) ? masterColor : syncDisabledColor
    //visible: (masterId.value > -1 && !isMaster)
    text: masterId.value == -1 ? "CLOCK" : (isMaster ? "MASTER" : utils.beatCounterString((masterId.value+1), beatCounterMode.value))
    font.capitalization: Font.AllUppercase
  }

//------------------------------------------------------------------------------------------------------------------
// Deck Beats Value
//------------------------------------------------------------------------------------------------------------------

  Text {
    width: 58
    y: 10
    x: 152
    color: deckBeatsStringColor()
    text: utils.beatCounterString(deckId, beatCounterMode.value) //beatCounterX.value + "." + beatCounterY.value + "." + beatCounterZ.value
    font.pixelSize: fonts.smallFontSize
    font.family: "Pragmatica"
    font.capitalization: Font.AllUppercase
    horizontalAlignment: Text.AlignRight
  }

  function deckBeatsStringColor() {
    var DeckBeats = utils.getBeats(deckId);
    var DeckBeat = parseInt(Math.abs(DeckBeats) % 4);
    if (DeckBeats < 0.0) DeckBeat = 3 - DeckBeat;

    var MasterBeats = utils.getBeats(masterId.value+1);
    var MasterBeat = parseInt(Math.abs(MasterBeats) % 4);
    if (MasterBeats < 0.0) MasterBeat = 3 - MasterBeat;

    //InternalClock is Master
    if (masterId.value == -1 && isSynched.value){
        return masterColor;
    }
    //BeatPhase Synched and in the same beat as Master
    else if ((DeckBeat == MasterBeat && (phase >= -0.016 && phase <= 0.016) && isSynched.value) || isMaster) {
        return syncEnabledColor;
    }
    //Tempo Synched (out of phase)
    else if ((DeckBeat != MasterBeat || (phase < -0.016 && phase > 0.016)) && isSynched.value) {
        return syncEnabledPhaseColor;
    }
    //Not synched
    else {
        return syncDisabledColor;
    }
  }
}
