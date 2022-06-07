import QtQuick 2.12
import CSI 1.0
import Traktor.Gui 1.0 as Traktor

import '../../../../Defines'

//QBeatgrid deckIdChanged  editEnabledChanged samplesPerBeatChanged isAnalyzingChanged trackLengthChanged gridMarkersChanged beatMarkersChanged trackId deckId editEnabled samplesPerBeat isAnalyzing trackLength gridMarkers QList<int> beatMarkers
Traktor.Beatgrid {
  id: view
  //property string deckPropertiesPath: propertiesPath + "." + deckId
  property var waveformPosition
  property int sampleWidth

  property var gridList: gridMarkers
  property var completePhraseMarkers
  property var completeDownbeatMarkers
  property var beatList: beatMarkers

  //Preferences Properties
  MappingProperty { id: displayGridMarkersWF; path: "mapping.settings.displayGridMarkersWF"; onValueChanged: recalculateBeatMarkers() }
  MappingProperty { id: displayBarsWF; path: "mapping.settings.displayBarsWF"; onValueChanged: recalculateBeatMarkers() }
  MappingProperty { id: displayPhrasesWF; path: "mapping.settings.displayPhrasesWF"; onValueChanged: recalculateBeatMarkers() }
  MappingProperty { id: beatsxPhrase; path: "mapping.settings.beatsxPhrase"; onValueChanged: recalculateBeatMarkers() }

/*
//--------------------------------------------------------------------------------------------------------------------
// FIXED BEAT COUNTER FUNCTION
//--------------------------------------------------------------------------------------------------------------------

  MappingProperty { id: beatCounterX; path: deckPropertiesPath + ".beatgrid.counter.x" }
  MappingProperty { id: beatCounterY; path: deckPropertiesPath + ".beatgrid.counter.y" }
  MappingProperty { id: beatCounterZ; path: deckPropertiesPath + ".beatgrid.counter.z" }

  //onWaveformPositionChanged: countBeats(waveformPosition)
  AppProperty { id: elapsedTime; path: "app.traktor.decks." + trackDeck.deckId + ".track.player.elapsed_time" }
  AppProperty { id: trackLength; path: "app.traktor.decks." + trackDeck.deckId + ".track.content.track_length" }
  AppProperty { id: bpm; path: "app.traktor.decks." + trackDeck.deckId + ".tempo.base_bpm" }
  AppProperty { id: gridOffset; path: "app.traktor.decks." + trackDeck.deckId + ".content.grid_offset" }
  AppProperty { id: sampleRate; path: "app.traktor.decks." + trackDeck.deckId + ".track.content.sample_rate" }
  property int beats: parseInt((elapsedTime.value*1000-gridOffset.value)*bpm.value/60000) //ms*(1bpm/1min)*(1min/60.000ms) = current beats
  property int beatWidth: parseInt(waveform.width/(trackLength.value*1000*bpm.value/60000)) //samples/(ms*(1bpm/1min)*(1min/60.000ms) = samples/beat
  onBeatsChanged: {countBeats(beats*beatWidth)} current beats* samples/beats = samples (pos in waveform)
//  return (gridMarkers[index]/sampleRate.value)/trackLength.value * stripe.width //122880

  function countBeats(waveformPosition) { //for the beat counter
    var x = 1
    var y = 1
    var z = 1
    var relevantPhrase = 0
    var relevantBar = 0
    var relevantBeat = 0

    for (var i=0; i<completePhraseMarkers.length; ++i){
        if ( waveformPosition >= completePhraseMarkers[i] && completePhraseMarkers[i] >= relevantPhrase ) {
            relevantPhrase = completePhraseMarkers[i];
            x = i + 1
            y = 1
            z = 1
            break
        }
        else {
            for (var j=0; j<completeDownbeatMarkers.length; ++j){
                if (completeDownbeatMarkers[j] <= waveformPosition && completeDownbeatMarkers[j] > relevantBar ) {
                    relevantBar = completeDownbeatMarkers[j];
                    y = j + 1
                    z = 1
                    break
                }
                else {
                    for (var k=0; k<beatMarkers.length; ++k){
                        if (beatMarkers[k] <= waveformPosition && beatMarkers[k] > relevantBeat ) {
                            relevantBeat = beatMarkers[k];
                            z = k + 1
                            break
                        }
                        else { z=3}
                    }
                }
            }
        }
    }
    beatCounterX.value = x
    beatCounterY.value = y
    beatCounterZ.value = z
  }
*/

//--------------------------------------------------------------------------------------------------------------------
// Beat, Downbeat, Phrase & Grid Markers finder function
//--------------------------------------------------------------------------------------------------------------------

  property var phraseMarkers
  property var downbeatMarkers
  property var updatedBeatMarkers

  function recalculateBeatMarkers() {
    var phraseList = new Array (0);
    var barsList = new Array (0);
    var beatList = new Array (0);
    var completePhraseList = new Array (0);
    var completeBarsList = new Array (0);
    var gridCount = 0;
    var gridOffset = 0;
    var beatCount = 0;
    for (var i = 0; i < beatMarkers.length; ++i) {
        //Need to check beatMarker exists in array (sometimes they are blank!!!)
        if (beatMarkers[i]) {
            //Found a new grid marker? Restart calculation of where the phrase starts
            if (beatMarkers[i] >= gridMarkers[gridCount]) { //current beatmarker is after "next" gridmarker?
                //aquest >= podria ser la cause de lo de que  avegades no conta bé quan poses un segon gridmarker
                gridOffset = gridMarkers[gridCount]
                gridCount = gridCount + 1
                beatCount = 0
                if (!displayGridMarkersWF.value) {
                    if (displayPhrasesWF.value) phraseList.push(beatMarkers[i])
                    else {
                        if (displayBarsWF.value) barsList.push(beatMarkers[i])
                        else beatList.push(beatMarkers[i])
                    }
                }
                completePhraseList.push(beatMarkers[i])
                completeBarsList.push(beatMarkers[i])
            }
            else {
                //After first GridMarker
                if (gridOffset > 0 && (beatMarkers[i] >= (gridOffset + samplesPerBeat/32))) { //the second condition is necesssary to fix the bug that sometimes was caused when setting more than one GridMarker, which caused the bar after the GridMarker to only have 3 beats instead of 4, and displayed the whole grid incorrectly as a result
                    beatCount = beatCount + 1
                    //Every beatsxPhrase beats from grid marker we want a phrase
                    if (beatCount % beatsxPhrase.value == 0) {
                        if (displayPhrasesWF.value) phraseList.push(beatMarkers[i])
                        else {
                            if (displayBarsWF.value) barsList.push(beatMarkers[i])
                            else beatList.push(beatMarkers[i])
                        }
                        beatCount = 0
                        completePhraseList.push(beatMarkers[i])
                        completeBarsList.push(beatMarkers[i])
                    }
                    //Every 4 beats from grid marker we want a downbeat
                    else if (beatCount % 4 == 0) {
                        if (displayBarsWF.value) barsList.push(beatMarkers[i])
                        else beatList.push(beatMarkers[i])
                        completeBarsList.push(beatMarkers[i])
                    }
                    //Add normal beat marker
                    else {
                        beatList.push(beatMarkers[i])
                    }
                }
                //Prior to first GridMarker
                else if (gridOffset == 0) {
                    beatCount = parseInt((gridMarkers[0] - beatMarkers[i])/samplesPerBeat)+1
                    //Every beatsxPhrase beats until grid marker we want a phrase
                    if (beatCount % beatsxPhrase.value == (beatsxPhrase.value%4)) {
                        if (displayPhrasesWF.value) phraseList.push(beatMarkers[i])
                        else {
                            if (displayBarsWF.value) barsList.push(beatMarkers[i])
                            else beatList.push(beatMarkers[i])
                        }
                        beatCount = 0
                        completePhraseList.push(beatMarkers[i])
                        completeBarsList.push(beatMarkers[i])
                    }
                    //Every 4 beats from until marker we want a downbeat
                    else if (beatCount % 4 == (beatsxPhrase.value%4)) {
                        if (displayBarsWF.value) barsList.push(beatMarkers[i])
                        else beatList.push(beatMarkers[i])
                        completeBarsList.push(beatMarkers[i])
                    }
                    //Add normal beat marker
                    else {
                        beatList.push(beatMarkers[i])
                    }
                }
            }
        }
    }
    phraseMarkers = phraseList
    downbeatMarkers = barsList
    updatedBeatMarkers = beatList
    completePhraseMarkers = completePhraseList
    completeDownbeatMarkers = completeBarsList
  }

//--------------------------------------------------------------------------------------------------------------------
// Beat Markers
//--------------------------------------------------------------------------------------------------------------------

  Traktor.WaveformTranslator {
    id: beatGridlines
    x: 0
    y: 0
    height: gridMode.value == 2 ? 5 : view.height
    followTarget: waveformPosition
    visible: (editMode.value == EditMode.disabled && beatMarkers.length > 0) && gridMode.value != 3
    pos: 0
    useScaling: true

    Traktor.BeatgridLines {
        anchors.fill: parent
        beatMarkerList: updatedBeatMarkers //beatMarkers
        color: gridMode.value == 0 ? (brightMode.value == true ? colors.colorGrey40 : colors.colorWhite25) : (gridMode.value == 2 ? (brightMode.value == true ? colors.colorGrey40 : colors.colorWhite50) : (brightMode.value == true ? colors.colorGrey40 : colors.colorWhite09))
    }
  }

  //Bottom Lines
  Traktor.WaveformTranslator {
    id: tickbottombeatGridlines
    x: 0
    y: 0
    height: view.height
    followTarget:  waveformPosition
    visible: (editMode.value == EditMode.disabled && beatMarkers.length > 0) && gridMode.value == 2
    pos: 0
    useScaling: true

    Traktor.BeatgridLines {
        anchors.bottom:	parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 5

        beatMarkerList: updatedBeatMarkers //beatMarkers
        color: colors.colorWhite50
    }
  }

//--------------------------------------------------------------------------------------------------------------------
// Downbeat Markers
//--------------------------------------------------------------------------------------------------------------------

  Traktor.WaveformTranslator {
    id: downbeatGridlines
    x: 0
    y: 0
    height: gridMode.value == 2 ? (theme.value > 5 ? 5 : 10) : view.height
    followTarget:  waveformPosition
    visible: (editMode.value == EditMode.disabled && beatMarkers.length > 0) && gridMode.value != 3 && displayBarsWF.value
    pos: 0
    useScaling: true

    Traktor.BeatgridLines {
        anchors.fill: parent
        beatMarkerList: downbeatMarkers
        color: gridMode.value == 0 ? (brightMode.value == true ? "black" : "white") : (gridMode.value == 1 ? (brightMode.value == true ? colors.colorGrey72 : colors.colorWhite50) : (theme.value >= 4 ? colors.red : (brightMode.value == true ? "black" : "white")))
    }
  }

  //Bottom Lines
  Traktor.WaveformTranslator {
    id: tickbottomdownbeatGridlines
    x: 0
    y: 0
    height: view.height
    followTarget:  waveformPosition
    visible: (editMode.value == EditMode.disabled && beatMarkers.length > 0) && gridMode.value == 2 && displayBarsWF.value
    pos: 0
    useScaling: true

    Traktor.BeatgridLines {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: theme.value > 5 ? 5 : 10
        beatMarkerList: downbeatMarkers
        color: theme.value >= 4 ? colors.red : (brightMode.value == true ? "black" : "white")
    }
  }

//--------------------------------------------------------------------------------------------------------------------
// Phrase Markers
//--------------------------------------------------------------------------------------------------------------------

  Traktor.WaveformTranslator {
    x: 0
    y: 0
    height: view.height //gridMode.value == 2 ? 10 : view.height
    followTarget:  waveformPosition
    visible: (editMode.value == EditMode.disabled && beatMarkers.length > 0) && gridMode.value != 3 && displayPhrasesWF.value
    pos: 0
    useScaling: true

    Traktor.BeatgridLines {
        anchors.fill: parent
        beatMarkerList: phraseMarkers
        color: gridMode.value == 0 ? colors.orange : (gridMode.value == 1 ? colors.orange : (theme.value >= 4 ? colors.red : (brightMode.value == true ? "black" : "white"))) //colors.orange
    }
  }

//--------------------------------------------------------------------------------------------------------------------
// EDIT MODE PROPERTIES
//--------------------------------------------------------------------------------------------------------------------

  //Receive Knob Values for scrolling in the waveform while in GridEdit Mode
  MappingProperty { id: editMode; path: propertiesPath + ".edit_mode" }
  MappingProperty { id: editPosition; path: propertiesPath + ".beatgrid.position" }
  MappingProperty { id: zoomedView; path: propertiesPath + ".beatgrid.zoomed_view" }
  MappingProperty { id: scanBeatsOffset; path: propertiesPath + ".beatgrid.scan_beats_offset" }
  MappingProperty { id: scanDirection; path: propertiesPath + ".beatgrid.scan_direction" }
  MappingProperty { id: scanUpdater; path: propertiesPath + ".beatgrid.scan_updater"; onValueChanged: {	scan() } }

  //Properties of Traktor.Beatgrid (see QBeatgrid.h)
  property int delta: 0
  readonly property int posOnEdit: editPosition.value - Math.floor(widthOnEdit/10)
  readonly property int widthOnEdit: samplesPerBeat * visibleNumberOfBeats
  readonly property int focusedNumberOfBeats: zoomedView.value ? 1 : 4
  readonly property int visibleNumberOfBeats: 1.25 * focusedNumberOfBeats
  readonly property int beatWidth: Math.floor(view.width/visibleNumberOfBeats)
  readonly property int overlayWidth: Math.floor(view.width/10)

//--------------------------------------------------------------------------------------------------------------------
// EDIT MODE VIEW
// The position of the beatmarkers is fix in this mode. Just the waveform beneath should change. Therefore, it is important to keep this view independent of the "bpm" resp. "samplesPerBeat". By doing this, we avoid jittering of the beatmarkers, when changing the BPM fast.
// Use a seperate GUI, indipendent from Traktor.WaveformTranslator for the Beatgrid in EditMode. This Waveform-Overlays we can avoid jitter of the markers while editing (offset/bpm).
//--------------------------------------------------------------------------------------------------------------------
  property bool updateView: isInEditMode && deckSize != "small"
  onUpdateViewChanged: { loadEditView(); scanDirection.value = 0; scanBeatsOffset.value = 0 }
  onBeatMarkersChanged: { updateEditView(); recalculateBeatMarkers() }

  //Grid
  Repeater {
    model: focusedNumberOfBeats+1

    Item {
        anchors.bottom: view.bottom
        anchors.top: view.top
        width: 1
        visible: editMode.value == EditMode.full && !isAnalyzing
        x: overlayWidth + index*(beatWidth+1)

        //Beat Grid
        Rectangle {
            x: 0
            y: 0
            width: 1
            height: view.height - 2
            color:  colors.colorWhite25
        }

        //Beat Marker Flags
        Rectangle {
            color: colors.colorGrey40 // if downbeat should be highlighted in future:  ((index%4) != 0) ? colors.colorGrey40 : colors.colorWhite
            x: 4
            y: 0
            width: 21
            height: 15
            radius: 1
            Text {
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment:   Text.AlignVCenter
                text: index == 4 ? 1 : (index + 1) //index + 1
                font.pixelSize: fonts.smallFontSize
                color: colors.colorGrey192
                style: Text.Outline
                styleColor: colors.colorGrey24
            }
        }
    }
  }

 //Black Left/Right Waveform-Overlays
  Repeater {
    model: 2
    Rectangle {
        anchors.bottom: parent.bottom
        anchors.top: parent.top
        color: colors.colorBlack75

        visible: editMode.value == EditMode.full && !isAnalyzing
        width: overlayWidth
        x: index == 0 ? 0 : view.width - overlayWidth + 1
    }
  }

  //Ghost Marker (Playmarker for Edit Mode)
  Traktor.WaveformTranslator {
    id: ghostMarker
    followTarget: waveformPosition
    width: 1
    anchors.bottom: view.bottom
    anchors.top: view.top
    pos: ghostMarkerPos(waveformPosition.playheadPos)
    visible: (editMode.value == EditMode.full && !isAnalyzing && !isPosInsideEditBeats(waveformPosition.playheadPos))

    Rectangle {
        anchors.fill: ghostMarker
        color:		colors.colorWhite
    }
  }

  function ghostMarkerPos(playPos) {
    var offset   = 0.5*samplesPerBeat + waveformPosition.waveformPos;
    var ghostPos = ((playPos - offset) % (4*samplesPerBeat) );

    ghostPos = (playPos < offset) ? (4*samplesPerBeat + ghostPos) : ghostPos;
    return ghostPos + offset;
  }

  function isPosInsideEditBeats(pos) {
    return (pos < Math.floor(waveformPosition.waveformPos+4.5*samplesPerBeat) && pos > Math.floor(waveformPosition.waveformPos+0.5*samplesPerBeat));
  }

  //Load correct Grid (the corresponding to the Playhead Position) when enabling BeatgridEdit Mode
  function loadEditView() {
    if (editMode.value == EditMode.full && !view.isAnalyzing) {
        var gridIndex = getRelevantGridIndexForSamplePos(waveformPosition.playheadPos)
        editPosition.value = gridMarkers[gridIndex]
    }
  }

  //Update Waveform Position when modifying BeatgridEdit Mode
  function updateEditView() {
    if (editMode.value == EditMode.full && !view.isAnalyzing) {
        var gridIndex = getRelevantGridIndexForSamplePos(editPosition.value)
        //scanBeatsOffset.value = parseInt(((startPos-gridMarkers[gridIndex])/samplesPerBeat)/4)*4
        editPosition.value = gridMarkers[gridIndex]+scanBeatsOffset.value*samplesPerBeat
    }
  }

  //Scan Waveform in BeatgridEdit Mode
  function scan() {
    if (editMode.value == EditMode.full && !view.isAnalyzing) {
        var startPos = editPosition.value
        var beatsOffset = scanBeatsOffset.value + scanDirection.value
        var prevGridIndex = getRelevantGridIndexForSamplePos(startPos)
        var newGridIndex = getRelevantGridIndexForSamplePos(gridMarkers[prevGridIndex] + beatsOffset*samplesPerBeat)
        if (prevGridIndex == newGridIndex) {
            if ((gridMarkers[prevGridIndex] + beatsOffset*samplesPerBeat < trackLength) && (gridMarkers[prevGridIndex] + beatsOffset*samplesPerBeat >= -4*samplesPerBeat)) {
                scanBeatsOffset.value = beatsOffset
                editPosition.value = gridMarkers[prevGridIndex] + scanBeatsOffset.value*samplesPerBeat
            }
        }
        else {
            if (prevGridIndex < newGridIndex) {
                scanBeatsOffset.value = 0
                editPosition.value = gridMarkers[prevGridIndex+1]
            }
            else {
                scanBeatsOffset.value = parseInt(((gridMarkers[prevGridIndex]-gridMarkers[prevGridIndex-1])/samplesPerBeat)/4)*4
                editPosition.value = gridMarkers[prevGridIndex-1]+scanBeatsOffset.value*samplesPerBeat
            }
        }
    }
  }

  function getRelevantGridMarkerForSamplePos(smplPos) {
    var numMarkers = gridMarkers.length;
    var gridPos	= (numMarkers > 0) ? gridMarkers[0] : 0;
    for (var i=0; i<numMarkers; ++i){
        if (gridMarkers[i] <= smplPos && gridMarkers[i] > gridPos ) {
            gridPos = gridMarkers[i];
        }
    }
    return gridPos;
  }

  function getRelevantGridIndexForSamplePos(smplPos) {
    var numMarkers = gridMarkers.length;
    var gridPos	= (numMarkers > 0) ? gridMarkers[0] : 0;
    var gridIndex = 0
    for (var i=0; i<numMarkers; ++i){
        if (gridMarkers[i] <= smplPos && gridMarkers[i] > gridPos ) {
            gridPos = gridMarkers[i];
            gridIndex = i
        }
    }
    return gridIndex;
  }
}
