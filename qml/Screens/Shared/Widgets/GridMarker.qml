import QtQuick 2.12
import Traktor.Gui 1.0 as Traktor
import QtGraphicalEffects 1.12
import CSI 1.0

Item {
  id: gridMarker

  property bool showHead
  property bool smallHead
  
  property int topMargin: 6
  property color  hotcueColor:  colors.hotcue.grid
  readonly property double borderWidth:	   2
  readonly property bool   useAntialiasing:   true
  readonly property int	smallCueHeight:	gridMarker.height + 3
  readonly property int	smallCueTopMargin: 0 //-4 
  readonly property int	largeCueHeight:	gridMarker.height + 3
  
  height: parent.height
  clip: false

  Item {
	anchors.top: parent.top
	anchors.horizontalCenter: parent.horizontalCenter
	height: smallHead ? 32 : parent.height
	width: 40
	clip: false
	visible: gridMarker.showHead
	Loader { 
		id: gridLoader 
		anchors.fill: parent
		active: true
		visible: true
		clip: false
		sourceComponent: smallHead ? gridComponentSmall : gridComponentLarge
	}
  }

  Component {
	id: gridComponentSmall
	Traktor.Polygon {
		anchors.top: gridLoader.top
		anchors.left: gridLoader.horizontalCenter
		anchors.topMargin: gridMarker.smallCueTopMargin
		anchors.leftMargin: -8

		antialiasing: useAntialiasing

		color: gridMarker.hotcueColor
		border.width: borderWidth
		border.color: colors.colorBlack50

		points: [ Qt.point(0 , 0)
			, Qt.point(13, 0) 
			, Qt.point(7 , 14)
			, Qt.point(7 , gridMarker.smallCueHeight-4)
			, Qt.point(6 , gridMarker.smallCueHeight-4)
			, Qt.point(6 , 14)
		]
	}
  }

  Component {
	id: gridComponentLarge
	Traktor.Polygon {
		anchors.top: gridLoader.top
		anchors.left: gridLoader.horizontalCenter
		anchors.leftMargin: -10 
		anchors.topMargin: -1
		antialiasing: useAntialiasing

		color: gridMarker.hotcueColor
		border.width: borderWidth
		border.color: colors.colorBlack50
		points: [ Qt.point(0 , 0)
			, Qt.point(15, 0) 
			, Qt.point(8 , 17)
			, Qt.point(8 , gridMarker.largeCueHeight-4)
			, Qt.point(7 , gridMarker.largeCueHeight-4)
			, Qt.point(7 , 17)
		]
	}
  }	
}