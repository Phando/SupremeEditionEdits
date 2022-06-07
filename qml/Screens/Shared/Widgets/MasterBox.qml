import CSI 1.0
import QtQuick 2.12
import Traktor.Gui 1.0 as Traktor

Rectangle {
  id: master_box

  property bool clockIndicator: false

  property color textColor: "black"
  property color backgroundColor: colors.colorGrey72

  property color clockColor: colors.cyan
  property color masterColor: colors.greenActive
  color: isMaster ? masterColor : backgroundColor
  //color: isMaster ? masterColor : (clockIndicator && masterId.value == -1 ? clockColor : backgroundColor)

  Text {
    anchors.fill: parent
    anchors.topMargin: 1
    text: clockIndicator && masterId.value == -1 ? "Clock" : "Master"
    //color: isMaster ? "black" : textColor
    color: isMaster ? "black" : (clockIndicator && masterId.value == -1 ? clockColor : textColor)
    font.pixelSize: fonts.smallFontSize
    font.capitalization: Font.AllUppercase
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
  }
}