import CSI 1.0
import QtQuick 2.12

Item {
  id: phaseMeter
  property int deckId: 1

  height: 20
  width: 200

  property int rectangleWidth: (phaseMeter.width-heightSpacing*3)/4
  property int rectangleHeight: phaseMeter.height*0.425
  property int heightSpacing: phaseMeter.height*0.15

  AppProperty { id: masterId; path: "app.traktor.masterclock.source_id" }
  AppProperty { id: isSynched; path: "app.traktor.decks." + deckId + ".sync.enabled" }
  AppProperty { id: tempoPhase; path: "app.traktor.decks." + deckId + ".tempo.phase" }
  readonly property double phase: (tempoPhase.value*2).toFixed(4)

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
        width: rectangleWidth
        height: rectangleHeight
        y: 0
        x: index * (rectangleWidth + heightSpacing)
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
        width: rectangleWidth
        height: rectangleHeight
        y: rectangleHeight+heightSpacing
        x: index * (rectangleWidth + heightSpacing)
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
}