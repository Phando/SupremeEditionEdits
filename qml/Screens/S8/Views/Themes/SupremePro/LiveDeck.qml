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
        id: bpm_whole
        anchors.bottom: parent.verticalCenter
        anchors.bottomMargin: 1
        anchors.right: bpm_decimal.left
        anchors.rightMargin: 2

        text: Math.floor(clockBpm.value.toFixed(2)).toString()
        font.pixelSize: fonts.smallFontSize+1
        font.family: "Pragmatica"
        color: colors.brightBlue
    }
    Text {
        id: bpm_decimal
        anchors.verticalCenter: bpm_whole.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 45

        text: getBpmDecimalString()
        font.pixelSize: fonts.smallFontSize+1
        font.family: "Pragmatica"
        color: colors.darkBlue
        function getBpmDecimalString() {
            var dec = (clockBpm.value - Math.floor(clockBpm.value.toFixed(2)))*100;
            var dec = Math.round(dec.toFixed(2));
            if (dec == 0) return ".00";
            else if (dec < 10) return ".0" + dec;
            else return "." + dec
        }
    }

    //Clock
    Text {
        id: clockString
        anchors.top: parent.verticalCenter
        anchors.topMargin: 2
        anchors.right: parent.right
        anchors.rightMargin: 45

        text: "CLOCK"
        font.pixelSize: fonts.smallFontSize+1
        font.family: "Pragmatica"
        color: colors.brightBlue
    }

    //FXs Indicators
    Widgets.FXsBox {
          anchors.top: parent.top
          anchors.topMargin: 5
          anchors.right: parent.right
          anchors.rightMargin: 5

          onlyTwo: false
          showMixerFX: false
    }
  }

//--------------------------------------------------------------------------------------------------------------------
// Mixer FX Rectangle Indicator
//--------------------------------------------------------------------------------------------------------------------

  Text {
    id: mixerfx_indicator
    anchors.top: deck_header_line.bottom
    anchors.topMargin: 2
    anchors.right: parent.right
    anchors.rightMargin: 5
    color: mixerFXOn.value ? colors.mixerFXColors[mixerFX.value] : colors.colorGrey72
    visible: deckSize != "small"

    text: mixerFXLabels[mixerFX.value]
    font.family: "Pragmatica MediumTT"
    font.pixelSize: fonts.smallFontSize + 1
    horizontalAlignment: Text.AlignRight
    verticalAlignment: Text.AlignVCenter

    Behavior on visible { NumberAnimation { duration: speed } }
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
    anchors.top: deck_header_line.bottom
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
    color: deckColor
    source: emptyLiveImage
  }
}
