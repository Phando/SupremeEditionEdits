import CSI 1.0
import QtQuick 2.12

Rectangle {
  id: key_sync_box

  property color syncColor: colors.greenActive

  height: 20
  width: 68
  color: "transparent"
  radius: 1
  border.width: 1
  border.color: isKeySynchronized ? syncColor : colors.colorGrey72

  Text {
      anchors.fill: parent
      anchors.topMargin: 1
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
      text: "K.SYNC"
      font.pixelSize: fonts.smallFontSize + 1
      color: parent.border.color
   }
}