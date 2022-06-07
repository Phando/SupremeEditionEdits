import QtQuick 2.12
import QtGraphicalEffects 1.12

Item {
	property int deckId: 1
	property string deckSize

  anchors.fill: parent
  property color  deckColor:	 "black"

  Rectangle {
	  id		   : background
	  color		: colors.background
	  anchors.fill : parent
  }

  Image {
	id: emptyTrackDeckImage
	anchors.fill:		 parent
	anchors.bottomMargin: 15
	anchors.topMargin:	15
	visible:			  false // visibility is handled by emptyTrackDeckImageColorOverlay

	source:			   "../../../../Shared/Images/EmptyDeck.png"
	fillMode:			 Image.PreserveAspectFit
  } 

  // Function Deck Color
  ColorOverlay {
	id: emptyTrackDeckImageColorOverlay
	anchors.fill: emptyTrackDeckImage
	visible:	  true
	color:		"#252525"
	source:	   emptyTrackDeckImage
  }
}

