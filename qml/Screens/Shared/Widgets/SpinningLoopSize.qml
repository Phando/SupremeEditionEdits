import CSI 1.0
import QtQuick 2.12


SpinningWheel {
  id: loopSizeIndicator

  property bool spinOnActive: false
  property bool fluxIndicator: false

  diamater: 30

  spinningPrimaryColor: fluxIndicator && ((loopActive.value && fluxing) || (!loopActive.value && fluxEnabled.value)) ? colors.orange : (loopActive.value ? colors.green : colors.colorGrey72)
  backgroundColor: isInActiveLoop.value ? (fluxIndicator && fluxing ? colors.darkerColor(colors.orange, 0.1) : colors.darkerColor(colors.green, 0.1)) : "transparent"
  borderColor: fluxIndicator && ((loopActive.value && fluxing) || (!loopActive.value && fluxEnabled.value)) ? colors.orange : (loopActive.value ? colors.green : colors.colorGrey72)
  borderWidth: 2

  spinning: isInActiveLoop.value && spinOnActive
  spinningBorder: true

  Behavior on opacity { NumberAnimation { duration: blinkFreq; easing.type: Easing.Linear} }

  Text {
    id: numberText
    text: loopSize.value < 5 ? "1" + loopSize.description : loopSize.description
    color: isInActiveLoop.value ? (fluxIndicator && fluxing ? colors.orange : colors.green) : colors.colorGrey72
    font.pixelSize: fonts.scale((parent.height-borderWidth*2) * (loopSize.value < 5 ? 0.45 : loopSize.value > 8 ? 0.6 : 0.65))
    font.family: "Pragmatica MediumTT"
    anchors.fill: parent
    anchors.rightMargin: 1
    anchors.topMargin: 1
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
  }
}