import CSI 1.0
import QtQuick 2.12


Rectangle {
  id: loopSizeIndicator

  property int diamater: 30
  property bool fluxIndicator: false

  width: diamater
  height: diamater
  radius: diamater / 2
  color: isInActiveLoop.value ? (fluxIndicator && fluxing ? colors.darkerColor(colors.orange, 0.1) : colors.darkerColor(colors.green, 0.1)) : "transparent"
  border.width: 2
  border.color: fluxIndicator && ((loopActive.value && fluxing) || (!loopActive.value && fluxEnabled.value)) ? colors.orange : (loopActive.value ? colors.green : colors.colorGrey72)

  Behavior on opacity { NumberAnimation { duration: blinkFreq; easing.type: Easing.Linear} }

  Text {
    id: numberText
    text: loopSize.value < 5 ? "1" + loopSize.description : loopSize.description
    color: isInActiveLoop.value ? (fluxIndicator && fluxing ? colors.orange : colors.green) : colors.colorGrey72
    font.pixelSize: fonts.scale((parent.height-parent.border.width*2) * (loopSize.value < 5 ? 0.45 : loopSize.value > 8 ? 0.6 : 0.65))
    font.family: "Pragmatica MediumTT"
    anchors.fill: parent
    anchors.rightMargin: 1
    anchors.topMargin: 1
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
  }
}