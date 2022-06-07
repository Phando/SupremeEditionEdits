import CSI 1.0
import QtQuick 2.12
import QtGraphicalEffects 1.12

import '../../../../../Defines'
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
    width: parent.width // (deckSize == "small") ? deck_header.width-18 : deck_header.width
    height: 50
    color: brightMode.value == true ? "white" : "black"
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

        text: "Live Input"
        elide: Text.ElideRight
        font.pixelSize: fonts.middleFontSize

        Behavior on anchors.leftMargin { NumberAnimation { duration: speed } }
        Behavior on anchors.topMargin  { NumberAnimation { duration: speed } }
    }

    // Description
    Text {
        id: mid_left_text
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 20
        color: brightMode.value == true ? colors.colorGrey32 : colors.colorGrey72

        text: "Audio processed in Traktor (Gain, Equalizers & Effects)"
        elide: Text.ElideRight
        font.pixelSize: fonts.smallFontSize

        Behavior on anchors.leftMargin { NumberAnimation { duration: speed } }
        Behavior on anchors.topMargin  { NumberAnimation { duration: speed } }
    }

    //Clock BPM
    Text {
        id: top_right_text
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: 2
        anchors.rightMargin: 50
        color: colors.cyan

        text: clockBpm.value.toFixed(2)
        font.pixelSize: fonts.middleFontSize

        Behavior on anchors.rightMargin { NumberAnimation { duration: speed } }
        Behavior on anchors.topMargin  { NumberAnimation { duration: speed } }
    }

    //Clock
    Text {
        id: mid_right_text
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: 18
        anchors.rightMargin: 50
        color: colors.cyan

        text: "Clock"
        font.pixelSize: fonts.smallFontSize + 1

        Behavior on anchors.rightMargin { NumberAnimation { duration: speed } }
        Behavior on anchors.topMargin  { NumberAnimation { duration: speed } }
    }

    //FXs Indicators
    Widgets.FXsBox {
        anchors.top: parent.top
        anchors.topMargin: 5
        anchors.right: parent.right
        anchors.rightMargin: 5

        onlyTwo: false
        showMixerFX: true
    }
  }

//--------------------------------------------------------------------------------------------------------------------
// Bottom Performance Panel
//--------------------------------------------------------------------------------------------------------------------

  Widgets.PerformancePanel {
    id: performancePanel
    deckId: parent.deckId
    propertiesPath: screen.propertiesPath
    visible: deckSize != "small" && padsMode.value == PadsMode.effects

    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: 30
  }

//--------------------------------------------------------------------------------------------------------------------
// EMPTY IMAGE
//--------------------------------------------------------------------------------------------------------------------

  // Image filler
  Image {
    id: emptyLiveImage
    anchors.top: deck_header.bottom
    anchors.topMargin: 15
    anchors.bottom: performancePanel.top //parent.bottom
    anchors.bottomMargin: 15
    anchors.horizontalCenter: parent.horizontalCenter
    visible: false // visibility is handled by emptyTrackDeckImageColorOverlay
    source: "../../../../Shared/Images/Microphone.png"
    fillMode: Image.PreserveAspectFit
  }
  ColorOverlay {
    id: emptyLiveImageColorOverlay
    anchors.fill: emptyLiveImage
    visible: !(deckSize == "small")
    color: colors.grey
    source: emptyLiveImage
  }
}
