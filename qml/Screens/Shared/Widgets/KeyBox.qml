import CSI 1.0
import QtQuick 2.12

Rectangle {
  id: key_box

  property bool keyUnderliner: false
  property bool originalKeyWhenDisabled: false
  property bool showRoundedWhenNotInRange: false

  property color adjustColor: keyColor
  property int keyFontSize: 17
  property int resultingKeyFontSize: 12
  property int keyAdjustFontSize: 10

  width: 40
  color: keyLock.value ? ((isLoaded.value && keyTextIndex != -1 && (isKeyInRange || showRoundedWhenNotInRange) && displayResultingKey.value) ? colors.darkerColor(keyColor, 0.15 ) : colors.cyan) : colors.colorBgEmpty

  Text {
    id: keyField
    anchors.fill: parent
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    text: resultingKeyText //(keyLock.value && keyTextIndex != -1 && isKeyInRange && displayResultingKey.value) ? resultingKeyText : (!keyLock.value && originalKeyWhenDisabled ? resultingKeyText : "♪")
    font.pixelSize: keyFontSize
    color: keyLock.value ? keyColor : colors.colorGrey128
    visible: !keyLock.value || !isKeyAdjusted || (!isKeyInRange && !showRoundedWhenNotInRange) || !displayResultingKey.value
  }

  Rectangle {
    id: key_underliner
    anchors.top: keyField.verticalCenter
    anchors.topMargin: (keyField.paintedHeight / 2) - 5
    anchors.horizontalCenter: keyField.horizontalCenter
    width: isLoaded.value ? keyField.paintedWidth : keyField.paintedWidth + 4
    height: 2
    color: keyField.color
    visible: keyUnderliner && !isKeyAdjusted
    Behavior on width { NumberAnimation { duration: 0.5*speed } }
  }

  Text {
    anchors.top: parent.top
    anchors.topMargin: 5
    anchors.bottom: parent.verticalCenter
    anchors.horizontalCenter: parent.horizontalCenter
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter

    text: resultingKeyText //TODO: Fix this when !isKeyInRange (doesn't display any key)
    font.pixelSize: resultingKeyFontSize
    color: keyColor
    visible: keyLock.value && isKeyAdjusted && (isKeyInRange || showRoundedWhenNotInRange) && displayResultingKey.value
  }

  Text {
    anchors.top: parent.verticalCenter
    anchors.topMargin: 1
    anchors.bottom: parent.bottom
    anchors.horizontalCenter: parent.horizontalCenter
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter

    text: (keyAdjust.value*12 < 0 ? "" : "+") + (keyAdjust.value*12).toFixed(0).toString()
    font.pixelSize: keyAdjustFontSize
    color: adjustColor
    visible: keyLock.value && isKeyAdjusted && (isKeyInRange || showRoundedWhenNotInRange) && displayResultingKey.value
  }

}