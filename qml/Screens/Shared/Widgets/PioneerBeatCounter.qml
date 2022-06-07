import CSI 1.0
import QtQuick 2.12

Item {
  id : phaseMeter
  property int deckId: 1

  width: 240
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
  
  property color masterColor: colors.orange
  property color deckColor: colors.cyan

//------------------------------------------------------------------------------------------------------------------
// Master Indicator
//------------------------------------------------------------------------------------------------------------------

  Text {
	anchors.right: masterIndicator.left
	anchors.rightMargin: 5
	anchors.top: parent.top
	font.pixelSize: fonts.smallFontSize
	font.family: "Pragmatica"
	horizontalAlignment: Text.AlignRight
	color: colors.orange
	//visible: (masterId.value > -1 && !isMaster)
	text: "MASTER"
  }

  Text {
	anchors.right: masterIndicator.left
	anchors.rightMargin: 5
	anchors.top: parent.top
	anchors.topMargin: 12
	font.pixelSize: fonts.smallFontSize
	font.family: "Pragmatica"
	horizontalAlignment: Text.AlignRight
	color: colors.orange
	text: masterId.value > -1 ? "PLAYER" : "CLOCK"
  }
  
  Rectangle {
	id: masterIndicator
	width: 10
	height: 10
	anchors.right: masterBeats.left
	anchors.rightMargin: 5
	anchors.top: parent.top
	color: colors.orange
	visible: masterId.value > -1

	Text {
		anchors.fill: parent
		horizontalAlignment: Text.AlignHCenter
		verticalAlignment: Text.AlignVCenter
		color: "black"
		text: masterId.value + 1
		font.pixelSize: fonts.scale(8)
		font.family: "Pragmatica"
	}
  }
  
//------------------------------------------------------------------------------------------------------------------
// Master Beats
//------------------------------------------------------------------------------------------------------------------


  Row {
	id: masterBeats
	anchors.horizontalCenter: parent.horizontalCenter
	anchors.top: parent.top
	spacing: 4
	Repeater {
		model: 4
		Rectangle {
			width: 34
			height: 10
			color: colors.darkerColor(masterBeatColor(index), 0.5)
			border.width: 1
			border.color: masterColor
			radius: 2
		}		
	}
  }

  function masterBeatColor(index) {
	var MasterBeats = utils.getBeats(masterId.value+1);
	var MasterBeat = parseInt(Math.abs(MasterBeats) % 4);
	if (MasterBeats < 0.0) MasterBeat = 3 - MasterBeat;

	//CurrentDeck is Master
    //if (deckId == masterId.value+1 && MasterBeat == index && isSynched.value) return masterColor
    if (MasterBeat == index && isSynched.value) return masterColor
	else return "transparent"
  }

//------------------------------------------------------------------------------------------------------------------
// Deck Beats
//------------------------------------------------------------------------------------------------------------------

  Row {
	id: deckBeats
	anchors.horizontalCenter: parent.horizontalCenter
	anchors.top: masterBeats.bottom
	anchors.topMargin: spacing
	spacing: 4
	Repeater {
		model: 4
		Rectangle {
			width: 34
			height: 10
			color: colors.darkerColor(deckBeatColor(index), 0.5)
			border.width: 1
			border.color: (isSynched.value && parseInt(Math.abs(utils.getBeats(deckId)) % 4) == index && index == 0) ? colors.red : deckColor
			radius: 2
		}		
	}
  }

  function deckBeatColor(index) {
	var DeckBeats = utils.getBeats(deckId);
	var DeckBeat = parseInt(Math.abs(DeckBeats) % 4);
	if (DeckBeats < 0.0) DeckBeat = 3 - DeckBeat;
			
	if (isSynched.value && DeckBeat == index) {
		if (index == 0) return colors.red
		else return deckColor
	}
	else return "transparent"
  }

//------------------------------------------------------------------------------------------------------------------
// Master Beats Value
//------------------------------------------------------------------------------------------------------------------

  Text {
	anchors.top: parent.top
	anchors.left: masterBeats.right
	anchors.leftMargin: 5
	width: 50
	font.pixelSize: fonts.smallFontSize
	font.family: "Pragmatica"
	horizontalAlignment: Text.AlignRight
	color: masterColor
	text: masterId.value > -1 ? utils.beatCounterString((masterId.value+1), beatCounterMode.value) : "CLOCK" //: "--.-"
	visible: isSynched.value
  }

//------------------------------------------------------------------------------------------------------------------
// Deck Beats Value
//------------------------------------------------------------------------------------------------------------------

  Text {
	anchors.top: parent.top
	anchors.topMargin: 12
	anchors.left: masterBeats.right
	anchors.leftMargin: 5
	width: 50
	color: deckColor
	text: utils.beatCounterString(deckId, beatCounterMode.value) //: "--.-"
	font.pixelSize: fonts.smallFontSize
	font.family: "Pragmatica"
	horizontalAlignment: Text.AlignRight
	visible: isSynched.value
  }
}
