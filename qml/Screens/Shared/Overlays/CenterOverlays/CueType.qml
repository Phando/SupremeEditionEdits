import CSI 1.0
import QtQuick 2.12

CenterOverlay {
  id: hotcueTypeOverlay
  property int deckId: 1

  MappingProperty { id: selectedHotcue ; path: propertiesPath + ".selectedHotcue";
    onValueChanged: {
        if (value != 0) { selectedCuePath = "app.traktor.decks." + deckId + ".track.cue.hotcues." + value }
        else { selectedCuePath = "app.traktor.decks." + deckId + ".track.cue" }
    }
  }
  property string selectedCuePath: "app.traktor.decks." + deckId + ".track.cue"
  AppProperty { id: type; path: selectedCuePath + ".type" }

  //Overlay Headline
  Text {
    anchors.top: parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.topMargin: margins.topMarginCenterOverlayHeadline
    font.pixelSize: fonts.largeFontSize
    color: colors.colorCenterOverlayHeadline
    text: "HOTCUE " + selectedHotcue.value + " TYPE"
  }

  //Content
  Text {
    anchors.top: parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.topMargin: 55
    font.pixelSize: fonts.extraLargeValueFontSize
    font.family: "Pragmatica"
    color: selectedHotcue.value != 0 ? colors.hotcueColor(selectedHotcue.value, type.value, true, hotcueColors.value) : "transparent"
    text: type.description
  }

  //Footline
  Text {
    anchors.bottom: parent.bottom
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottomMargin: 24.0
    font.pixelSize: fonts.smallFontSize
    color: colors.colorGrey72
    text: "Push BROWSE to modify the selected hotcue type"
  }

  //Footline 2
  Item {
    anchors.bottom: parent.bottom
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottomMargin: 8.0
    width: footline2hold.paintedWidth + footline2back.paintedWidth + footline2reset.paintedWidth + footline2value.paintedWidth
    visible: type.description != "Hotcue"

    Text {
        id: footline2hold
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        font.pixelSize: fonts.smallFontSize
        color: colors.colorGrey72
        text: "Press "
    }
    Text {
        id: footline2back
        anchors.bottom: parent.bottom
        anchors.left: footline2hold.right
        font.pixelSize: fonts.smallFontSize
        color: colors.orange
        text: "BACK "
    }
    Text {
        id: footline2reset
        anchors.bottom: parent.bottom
        anchors.left: footline2back.right
        font.pixelSize: fonts.smallFontSize
        color: colors.colorGrey72
        text: "to reset to "
    }
    Text {
        id: footline2value
        anchors.bottom: parent.bottom
        anchors.left: footline2reset.right
        font.pixelSize: fonts.smallFontSize
        color: colors.cyan
        text: "CUE"
    }
  }
}
