import QtQuick 2.12


Rectangle {
  id: phaseSyncBar
  property int deckId: 0
  //This should be in the parent: AppProperty { id: tempoPhase; path: "app.traktor.decks." + deckId + ".tempo.phase" }
  width:  200
  height: 20
  radius: 4

  color: colors.colorGrey16
	
  Rectangle {
	anchors.top: parent.top
	anchors.topMargin: parent.height*0.2
	anchors.bottom: parent.bottom
	anchors.bottomMargin: parent.height*0.2
	width: tempoPhase.value < 0 ? (-tempoPhase.value*parent.width) : tempoPhase.value*parent.width
	x: (tempoPhase.value < 0) ? parent.width/2 - width : parent.width/2
	color:  colors.orangeDimmed

	Rectangle {// bright line in the phase bar
		anchors.top: parent.top
		anchors.bottom: parent.bottom
		width:  1
		color: colors.orange
		x: (tempoPhase.value < 0) ? 0 : parent.width
		visible: Math.round(parent.width) != 0
	}
  }
  Rectangle {// white line: center indicator
	anchors.top: parent.top
	anchors.topMargin: parent.height*0.05
	anchors.bottom: parent.bottom
	anchors.bottomMargin: parent.height*0.05
	width:  1
	color: "white"
	anchors.horizontalCenter: parent.horizontalCenter
  }
  Rectangle {// white line: right quater indicator
	anchors.top: parent.top
	anchors.topMargin: parent.height*0.15
	anchors.bottom: parent.bottom
	anchors.bottomMargin: parent.height*0.15
	width:  1
	color: "white"
	x: parent.width*3/4
  }
  Rectangle {// white line: left quater indicator
	anchors.top: parent.top
	anchors.topMargin: parent.height*0.15
	anchors.bottom: parent.bottom
	anchors.bottomMargin: parent.height*0.15
	width:  1
	color: "white"
	x: parent.width/4
  }

}
