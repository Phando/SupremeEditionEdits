import CSI 1.0
import QtQuick 2.12
import QtGraphicalEffects 1.12

import '../../../../Shared/Widgets' as Widgets

Item {
  anchors.fill: parent
  property int deckId: 1

  readonly property int speed: 40  // Transition speed

//--------------------------------------------------------------------------------------------------------------------
// DECK HEADER
//--------------------------------------------------------------------------------------------------------------------

  Rectangle {
    id: deck_header;
    anchors.horizontalCenter: parent.horizontalCenter
    width: parent.width
    height: 40
    color: brightMode.value == true ? colors.colorGrey128 : colors.colorFxHeaderBg
    Behavior on width { NumberAnimation { duration: 0.5*speed } }
  }

  //Artwork
  Widgets.ArtworkBox {
    id: artwork_box
    anchors.top: deck_header.top
    anchors.bottom: deck_header.bottom
    anchors.left: deck_header.left
    width: deck_header.height
  }

  //Warning Overlay
  Widgets.DeckHeaderMessage {
    id: warning_box
    anchors.top: deck_header.top
    anchors.bottom: deck_header.bottom
    anchors.left: topLeftCorner.value == 0 ? parent.left : artwork_box.right
    anchors.right: deck_header.right

    permanentMessage: true
    shortMessageHasBackground: true
  }


  //Bottom line
  Rectangle {
    id: deck_header_line;
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: deck_header.bottom
    width: parent.width
    height: 3
    color: deckColor
    Behavior on width { NumberAnimation { duration: 0.5*speed } }
  }

//--------------------------------------------------------------------------------------------------------------------
// DECK HEADER CONTENT
//--------------------------------------------------------------------------------------------------------------------

  Item {
    anchors.top: deck_header.top
    anchors.bottom: deck_header.bottom
    anchors.left: topLeftCorner.value == 0 ? parent.left : artwork_box.right
    anchors.leftMargin: 5
    anchors.right: parent.right

    visible: !warningMessage && !errorMessage

    // Deck Type
    Text {
        id: top_left_text
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 2
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
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 20
        color: brightMode.value == true ? colors.colorGrey32 : colors.colorGrey72

        text: "Audio processed in the mixer (Gain, Equalizers & Filter)"
        elide: Text.ElideRight
        font.pixelSize: fonts.smallFontSize

        Behavior on anchors.leftMargin { NumberAnimation { duration: speed } }
        Behavior on anchors.topMargin  { NumberAnimation { duration: speed } }
    }
  }

//--------------------------------------------------------------------------------------------------------------------
// EMPTY IMAGE
//--------------------------------------------------------------------------------------------------------------------

  // Image filler
  Image {
    id: emptyThruImage
    anchors.top: deck_header_line.bottom
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
    visible: !(deckSize == "small")
    color: deckColor
    source: emptyThruImage
  }

}
