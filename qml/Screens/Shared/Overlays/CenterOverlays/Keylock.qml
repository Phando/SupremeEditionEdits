import CSI 1.0
import QtQuick 2.12

import '../../../../Helpers/KeyHelpers.js' as Key

CenterOverlay {
  id: keylock
  property int deckId: 1

  MappingProperty { id: useKeyText; path: "mapping.settings.useKeyText" }
  MappingProperty { id: displayCamelotKey; path: "mapping.settings.displayCamelotKey" }

  AppProperty { id: isLoaded; path: "app.traktor.decks." + deckId + ".is_loaded" }
  AppProperty { id: keyLock; path: "app.traktor.decks." + deckId + ".track.key.lock_enabled" }
  AppProperty { id: musicalKey; path: "app.traktor.decks." + deckId + ".content.musical_key" }
  AppProperty { id: keyText; path: "app.traktor.decks." + deckId + ".content.legacy_key" }
  AppProperty { id: resultingKey; path: "app.traktor.decks." + deckId + ".track.key.resulting.precise" }
  AppProperty { id: resultingKeyRounded; path: "app.traktor.decks." + deckId + ".track.key.resulting.quantized" }
  AppProperty { id: keyId; path: "app.traktor.decks." + deckId + ".track.key.final_id" }
  AppProperty { id: keyAdjust; path: "app.traktor.decks." + deckId + ".track.key.adjust" }

  property real keyOffset: keyAdjust.value * 12
  //property int  offset: (keyOffset.toFixed(2) - keyOffset.toFixed(0)) * 100.0

  //Overlay Headline
  Text {
    anchors.top: parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.topMargin: margins.topMarginCenterOverlayHeadline
    font.pixelSize: fonts.largeFontSize
    color: colors.colorCenterOverlayHeadline
    text: "KEY"
  }

  //Content
  Text {
    anchors.top: parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.topMargin: 55
    font.pixelSize: fonts.extraLargeValueFontSize
    font.family: "Pragmatica"
    color: keyLock.value ? colors.colorWhite : colors.colorGrey72
    text: (keyOffset > -0.009 && keyOffset < 0.009) ? "0.00" : (((keyOffset > 0) ? "+" : "") + keyOffset.toFixed(2).toString())
  }

/*
  Text {
    id: leftparentesis
    anchors.top: parent.top
    anchors.right: modifiedkey.left
    anchors.topMargin: 67
    font.pixelSize: fonts.largeFontSize
    font.family: "Pragmatica"
    font.capitalization: Font.AllUppercase
    color: colors.colorGrey72
    text: "("
  }
*/

  Text {
    id: modifiedkey
    anchors.top: parent.top
    anchors.right: parent.right //parentesis.left
    anchors.topMargin: 67
    anchors.rightMargin: 20
    font.pixelSize: fonts.largeFontSize
    font.family: "Pragmatica"
    color: Key.getKeyId(text) > 0 ? colors.musicalKeyColors[Key.getKeyId(text)] : colors.red
    text: useKeyText.value ? (displayCamelotKey.value ? utils.convertKeyTextToResultingCamelot(keyText.value, keyAdjust.value) : utils.convertKeyTextToResultingCamelot(keyText.value, keyAdjust.value)) : (displayCamelotKey.value ? Key.toCamelot(resultingKey.value) : resultingKey.value)
    visible: isLoaded.value && keyLock.value
  }

/*
  Text {
    id: rightparentesis
    anchors.top: parent.top
    anchors.right: parent.right
    anchors.topMargin: 67
    anchors.rightMargin: 15
    font.pixelSize: fonts.largeFontSize
    font.family: "Pragmatica"
    font.capitalization: Font.AllUppercase
    color: colors.colorGrey72
    text: ")"
    visible: isLoaded.value
  }
*/

  //♪ LOCK button
  Rectangle {
    anchors.top:			  parent.top
    anchors.left:			 parent.left
    anchors.topMargin:		67
    anchors.leftMargin:	   10
    width: 50
    height: 23
    color: (keyLock.value) ? colors.cyan : colors.colorGrey72
    radius: 4

    Text {
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 1
        anchors.horizontalCenterOffset: -1
        font.pixelSize: fonts.smallFontSize
        text: "♪  LOCK"
        color: keyLock.value ? colors.colorBlack : "black"
    }
  }

  //Footline
  Text {
    anchors.bottom: parent.bottom
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottomMargin: 24.0
    font.pixelSize: fonts.smallFontSize
    color: colors.colorGrey72
    text: "Push BROWSE to activate ♪ Lock"
  }

  //Footline 2
  Item {
    anchors.bottom: parent.bottom
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottomMargin: 8.0
    width: footline2hold.paintedWidth + footline2back.paintedWidth + footline2reset.paintedWidth + footline2value.paintedWidth
    visible: keyOffset < -0.009 || keyOffset > 0.009

    Text {
        id: footline2hold
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        font.pixelSize: fonts.smallFontSize
        color: colors.colorGrey72
        text: "Hold "
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
        text: isLoaded.value ? "to reset to " : "to reset"
    }
    Text {
        id: footline2value
        anchors.bottom: parent.bottom
        anchors.left: footline2reset.right
        font.pixelSize: fonts.smallFontSize
        color: Key.getKeyId(text) > 0 ? colors.musicalKeyColors[Key.getKeyId(text)] : colors.red
        text: useKeyText.value ? (displayCamelotKey.value ? Key.toCamelot(keyText.value) : keyText.value) : (displayCamelotKey.value ? Key.toCamelot(musicalKey.value) : musicalKey.value)
        visible: isLoaded.value
    }
  }
}
