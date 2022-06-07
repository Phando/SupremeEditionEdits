import CSI 1.0
import QtQuick 2.12
import QtGraphicalEffects 1.12

import '../../../../Shared/Widgets' as Widgets
import '../../../../Shared/Widgets/Remix' as Remix

Item {
  id: remixDeck
  property int deckId: 1
  readonly property int speed: 40  // Transition speed

//--------------------------------------------------------------------------------------------------------------------
// DECK HEADER
//--------------------------------------------------------------------------------------------------------------------

  Rectangle {
    id: deck_header;
    anchors.horizontalCenter: parent.horizontalCenter
    width: parent.width // (deckSize == "small") ? deck_header.width-18 : deck_header.width
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

    //Title
    Text {
        id: titleField
        anchors.top: parent.top
        anchors.topMargin: 2
        anchors.left: parent.left
        anchors.right: isLoaded.value ? step_icon.left : loop_size.left
        anchors.rightMargin: 5

        text: isLoaded.value ? title.value : ("No Samples Loaded")
        color: brightMode.value == true ? colors.colorGrey32 : colors.colorGrey232
        elide: Text.ElideRight
        font.pixelSize: fonts.middleFontSize

        Behavior on anchors.leftMargin { NumberAnimation { duration: speed } }
        Behavior on anchors.topMargin  { NumberAnimation { duration: speed } }
    }

    //Artist
    Text {
        id: artistField
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.right: isLoaded.value ? step_icon.left : loop_size.left
        anchors.rightMargin: 5

        //text: isLoaded.value ? artist.value : (showBrowserOnTouch.value ? "Touch the Browse encoder to open the Browser" : "Push the Browse encoder to open the Browser")
        text: showBrowserOnTouch.value ? "Touch the Browse encoder to open the Browser" : "Push the Browse encoder to open the Browser"
        visible: !isLoaded.value

        color: brightMode.value == true ? colors.colorGrey32 : colors.colorGrey72
        elide: Text.ElideRight
        font.pixelSize: fonts.smallFontSize

        Behavior on anchors.leftMargin { NumberAnimation { duration: speed } }
        Behavior on anchors.topMargin  { NumberAnimation { duration: speed } }
    }

    //Step Icon
    Rectangle {
        id: step_icon
        width: 35
        height: 14
        anchors.bottom: parent.verticalCenter
        anchors.right: parent.horizontalCenter
        /*
        anchors.top: parent.top
        anchors.topMargin: 22
        anchors.right: parent.horizontalCenter
        anchors.rightMargin: 5
        */

        color: "transparent"
        border.width: 1
        border.color: sequencerOn.value ? deckColor : colors.colorGrey72
        radius: 3
        visible: isLoaded.value

        Text {
            anchors.centerIn: parent
            anchors.verticalCenterOffset: 1
            text: "STEP"
            color: sequencerOn.value ? deckColor : colors.colorGrey72
            font.pixelSize: fonts.miniFontSize
        }

        Behavior on opacity { NumberAnimation { duration: speed } }
      }

    //REC Icon
    Item {
        id: rec_icon

        anchors.top: parent.verticalCenter
        anchors.bottom: parent.bottom
        anchors.right: step_icon.right
        width: 35

        visible: isLoaded.value

        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            color: sequencerRecOn.value ? colors.red : colors.colorGrey72
            width: 10
            height: width
            radius: 0.5*width
        }
        Text {
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            text: "REC"
            color: sequencerRecOn.value ? colors.colorWhite : colors.colorGrey72
            font.pixelSize: fonts.miniFontSize
        }
    }

    //Quantize
    Text {
        id: quantizeField
        anchors.bottom: parent.verticalCenter
        anchors.right: quant_circle_icon.left
        anchors.rightMargin: 5
        color: remixQuantize.value ? "white" : colors.colorGrey72
        visible: isLoaded.value

        text: remixQuantizeIndex.description
        font.pixelSize: fonts.middleFontSize
        font.family: "Pragmatica"
        horizontalAlignment: Text.AlignRight
        elide: Text.ElideRight
    }
    Rectangle {
        id: quant_circle_icon
        anchors.bottom: parent.verticalCenter
        anchors.bottomMargin: 3
        anchors.right: loop_size.left
        anchors.rightMargin: 18
        color: remixQuantize.value ? colors.cyan : colors.colorGrey72
        width: 10
        height: width
        radius: 0.5*width
        visible: isLoaded.value
    }

    //Beat Counter
    Text {
        id: beatsField
        anchors.top: parent.verticalCenter
        anchors.topMargin: 2
        anchors.right: loop_size.left
        anchors.rightMargin: 15
        color: colors.colorGrey72
        visible: isLoaded.value

        text: remixBeats.description
        font.pixelSize: fonts.smallFontSize
        font.family: "Pragmatica"
        horizontalAlignment: Text.AlignRight
        elide: Text.ElideRight
    }

    //Loop Size Indicator
    Widgets.SpinningLoopSize {
        id: loop_size
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 110
        diamater: 30

        spinOnActive: true
        fluxIndicator: true
    }

    //BPM
    Text {
        id: bpm_whole
        anchors.bottom: parent.verticalCenter
        anchors.right: bpm_decimal.left
        anchors.rightMargin:  1
        visible: !beatmatchPracticeMode.value

        text: Math.floor(stableBpm.value.toFixed(2)).toString()
        font.pixelSize: fonts.middleFontSize
        font.family: "Pragmatica"
        color: colors.colorGrey232
      }
      Text {
        id: bpm_decimal
        anchors.bottom: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 45
        visible: !beatmatchPracticeMode.value

        text: getBpmDecimalString()
        font.pixelSize: fonts.middleFontSize
        font.family: "Pragmatica"
        color: colors.colorGrey72
        function getBpmDecimalString() {
            var dec = (stableBpm.value - Math.floor(stableBpm.value.toFixed(2)))*100
            var dec = Math.round(dec.toFixed(2))
            if (dec == 0) return ".00"
            else if (dec < 10) return ".0" + dec
            else return "." + dec
        }
    }

    //Tempo Percentage
    Text {
        anchors.top: parent.verticalCenter
        anchors.topMargin: 2
        anchors.right: parent.right
        anchors.rightMargin: 45
        width: 88
        visible: !beatmatchPracticeMode.value

        color: isLoaded.value ? utils.colorRangeTempo(tempoOffset) : colors.colorGrey72
        text: ((tempoOffset <= 0) ? "" : "+") + (tempoOffset).toFixed(1).toString() + "%";
        font.pixelSize: fonts.smallFontSize+1
        font.family: "Pragmatica"
        horizontalAlignment: Text.AlignRight
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
// REMIX SLOTS
//--------------------------------------------------------------------------------------------------------------------

  Row {
    id: remixSlotsContainer
    anchors.top: deck_header_line.bottom
    anchors.topMargin: 1
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.leftMargin: 3
    anchors.right: parent.right
    anchors.rightMargin: 3

    spacing: 10

    Repeater {  // this repeater creates the four columns of the remix deck
        id: remixSlots
        model: 4

        Remix.Slot {
            deckId: remixDeck.deckId
            slotId: index+1
            height: parent.height
            width: (remixDeck.width-10*3-3*2)/4
        }
    }
  }

//--------------------------------------------------------------------------------------------------------------------
// LoopSizeOverlay
//--------------------------------------------------------------------------------------------------------------------

  Widgets.LoopSizeIndicator {
    id: loopSizeOverlay
    anchors.centerIn: parent
    visible: deckSize != "small" && showLoopSize.value
  }
}
