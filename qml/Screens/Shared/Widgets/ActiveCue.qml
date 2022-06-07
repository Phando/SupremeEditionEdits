import CSI 1.0
import QtQuick 2.12
import Traktor.Gui 1.0 as Traktor

//These are the triangle shaped cues at the bottom of the waveform/stripe. Two different sized triangle components can be loaded and switched using the 'isSmall' variable.
//To work, an "invisible" rectangle is placed on the WF. It then creates the triangles at the left/right of the recangle borders.

Item {
  id: activeCue 
  property int deckId: 1
  property bool isSmall: false
  property bool displayRightIndicator: true

  MappingProperty { id: theme; path: "mapping.settings.theme" }

  AppProperty { id: type; path: "app.traktor.decks." + deckId + ".track.cue.active.type"   }
  readonly property var  hotcueMarkerTypes: {0: "hotcue", 1: "fadeIn", 2: "fadeOut", 3: "load", 4: "grid", 5: "loop" }
  readonly property bool isLoop: (hotcueMarkerTypes[type.value] == "loop")

  //Active Cue Left Triangle Indicator
  Loader {
	anchors.horizontalCenter: parent.left
	//anchors.horizontalCenterOffset: 1 //to fix a small offset produced due to border width?
	anchors.bottom: parent.bottom
	height: parent.height
	active: true
	visible: theme.value != 4
	clip: false
	sourceComponent: isSmall ? smallTriangle : largeTriangle
  }

  //Active Cue Right Triangle Indicator
  Loader {
	anchors.horizontalCenter: parent.right
	anchors.bottom: parent.bottom
	height: parent.height
	active: true
	visible: theme.value != 4 && isLoop && displayRightIndicator
	clip: false
	sourceComponent: isSmall ? smallTriangle : largeTriangle
  }

  //Active Cue Left Triangle Indicator
  Loader {
	anchors.left: parent.left
	anchors.bottom: parent.bottom
	height: parent.height
	active: true
	visible: theme.value == 4
	clip: false
	sourceComponent: isSmall ? smallLeftTriangle : largeLeftTriangle
  }

  //Active Cue Right Triangle Indicator
  Loader {
	anchors.right: parent.right
	anchors.bottom: parent.bottom
	height: parent.height
	active: true
	visible: theme.value == 4 && isLoop && displayRightIndicator
	clip: false
	sourceComponent: isSmall ? smallRightTriangle : largeRightTriangle
  }


//------------------------------------------------------------------------------------------------------------------
// COMPONENTS
//------------------------------------------------------------------------------------------------------------------

  //Waveform Triangles
  Component {
	id: largeTriangle
	Traktor.Polygon {
	  id: currentCueLarge
	  anchors.bottom: parent.bottom
	  anchors.horizontalCenter: parent.horizontalCenter
	  color: theme.value < 4 ? (activeCue.isLoop ? colors.green : "white") : colors.orange
	  border.width: 1
	  border.color: colors.colorBlack50
	  antialiasing: true
	  points: [ Qt.point(12, 8)
			  , Qt.point(0 , 8)
			  , Qt.point(6 , 0)
			  ]
	}
  }

  //Stripe Triangles
  Component {
	id: smallTriangle
	Traktor.Polygon {
	  id: currentCueSmall
	  anchors.bottom: parent.bottom
	  anchors.horizontalCenter: parent.horizontalCenter
	  color: theme.value < 4 ? (activeCue.isLoop ? colors.green : "white") : colors.orange
	  border.width: 1
	  border.color: colors.colorBlack50
	  antialiasing: true
	  points: [ Qt.point(0, 7)
			  , Qt.point(10, 7)
			  , Qt.point(5, 0)
			  ]
	}
  }

  //Waveform Left Triangles
  Component {
	id: largeLeftTriangle
	Traktor.Polygon {
	  id: currentCueLarge
	  anchors.left: parent.left
	  anchors.bottom: parent.bottom
	  color: "white"
	  border.width: 1
	  border.color: colors.colorBlack50
	  antialiasing: true
	  points: [ Qt.point(6, 8)
			  , Qt.point(0, 8)
			  , Qt.point(0, 0)
			  ]
	}
  }

  //Stripe Left Triangles
  Component {
	id: smallLeftTriangle
	Traktor.Polygon {
	  id: currentCueSmall
	  anchors.left: parent.left
	  anchors.bottom: parent.bottom
	  color: "white"
	  border.width: 1
	  border.color: colors.colorBlack50
	  antialiasing: true
	  points: [ Qt.point(4, 7)
			  , Qt.point(0, 7)
			  , Qt.point(0, 0)
			  ]
	}
  }

  //Waveform Right Triangles
  Component {
	id: largeRightTriangle
	Traktor.Polygon {
	  id: currentCueLarge
	  anchors.right: parent.right
	  anchors.bottom: parent.bottom
	  color: "white"
	  border.width: 1
	  border.color: colors.colorBlack50
	  antialiasing: true
	  points: [ Qt.point(0, 8)
			  , Qt.point(6, 0)
			  , Qt.point(6, 8)
			  ]
	}
  }

  //Stripe Right Triangles
  Component {
	id: smallRightTriangle
	Traktor.Polygon {
	  id: currentCueSmall
	  anchors.right: parent.right
	  anchors.bottom: parent.bottom
	  color: "white"
	  border.width: 1
	  border.color: colors.colorBlack50
	  antialiasing: true
	  points: [ Qt.point(0, 7)
			  , Qt.point(4, 0)
			  , Qt.point(4, 7)
			  ]
	}
  }

}
