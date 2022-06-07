import CSI 1.0
import QtQuick 2.12
import QtGraphicalEffects 1.12

Item {
  anchors.fill: parent
  property int deckId: 1

  //Preferences Properties
  MappingProperty { id: brightMode; path: "mapping.settings.brightMode" }
  MappingProperty { id: topLeftCorner; path: "mapping.settings.topLeftCorner" }

  MappingProperty { id: padsFXMode;	path: "mapping.settings.preferences_padsFXMode" }


  property color  deckColor: colors.colorBgEmpty
  readonly property variant textColors: [colors.brightBlue, colors.brightBlue, colors.colorGrey232, colors.colorGrey232]
  readonly property int speed: 40  // Transition speed

//--------------------------------------------------------------------------------------------------------------------
// DECK HEADER CONTAINER
//--------------------------------------------------------------------------------------------------------------------

  Rectangle {
	id: deck_header;
	anchors.horizontalCenter: parent.horizontalCenter
	width: parent.width
	height: 50
	color: brightMode.value == true ? "white" : "black"
	Behavior on width { NumberAnimation { duration: 0.5*speed } }
  }
  
//--------------------------------------------------------------------------------------------------------------------
// Deck Letter (A, B, C or D)
//--------------------------------------------------------------------------------------------------------------------

  Image {
	id: deck_letter_large
	anchors.top: deck_header.top
	anchors.left: parent.left
	anchors.topMargin: 2
	anchors.leftMargin: 5
	width: 36
	height: 46
	visible: false //to set the visibility of the Deck Letter, modify the visibility of the Color Overlay
	clip: true
	fillMode: Image.Stretch
	source: "../../../../images/Deck_" + deckLetter + ".png"
	Behavior on height { NumberAnimation { duration: speed } }
	Behavior on opacity { NumberAnimation { duration: speed } }
  }

  ColorOverlay {
	id: deck_letter_color_overlay
	color: deckColor
	visible: topLeftCorner.value == 2
	anchors.fill: deck_letter_large
	source: deck_letter_large
  } 
  
//--------------------------------------------------------------------------------------------------------------------
// DECK HEADER TEXT
//--------------------------------------------------------------------------------------------------------------------

  // Deck Type
  Text {
	id: top_left_text
	anchors.top: deck_header.top
	anchors.left: topLeftCorner.value == 2 ? deck_letter_large.right : parent.left
	anchors.topMargin: 2
	anchors.leftMargin: 5 
	color: brightMode.value == true ? colors.colorGrey32 : colors.colorGrey232
	
	text: "Direct Thru"
	elide: Text.ElideRight
	font.pixelSize: fonts.middleFontSize

	Behavior on anchors.leftMargin { NumberAnimation { duration: speed } }
	Behavior on anchors.topMargin  { NumberAnimation { duration: speed } }
  }
  
  // Description
  Text {
	id: middle_left_text
	anchors.top: deck_header.top
	anchors.left: topLeftCorner.value == 2 ? deck_letter_large.right : parent.left
	anchors.topMargin: 20
	anchors.leftMargin: 5
	color: brightMode.value == true ? colors.colorGrey32 : colors.colorGrey72
	
	text: "Audio processed in the mixer (Gain, Equalizers & Filter)"
	elide: Text.ElideRight
	font.pixelSize: fonts.smallFontSize

	Behavior on anchors.leftMargin { NumberAnimation { duration: speed } }
	Behavior on anchors.topMargin  { NumberAnimation { duration: speed } }
  }

//--------------------------------------------------------------------------------------------------------------------
// EMPTY IMAGE
//--------------------------------------------------------------------------------------------------------------------

  // Image filler  
  Image {
	id: emptyThruImage
	anchors.top: deck_header.bottom
	anchors.topMargin: 15
	anchors.bottom: parent.bottom
	anchors.bottomMargin: 15
	anchors.horizontalCenter: parent.horizontalCenter
	visible: false // visibility is handled by emptyTrackDeckImageColorOverlay
	source: "../../../../Shared/Images/Turntable.png"
	fillMode: Image.PreserveAspectFit
  } 
  ColorOverlay {
	id: emptyThruImageColorOverlay
	anchors.fill: emptyThruImage
	color: deckColor
	source: emptyThruImage
  }

}
