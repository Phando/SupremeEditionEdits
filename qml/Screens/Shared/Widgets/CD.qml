import CSI 1.0
import QtQuick 2.12
import Traktor.Gui 1.0 as Traktor

Rectangle {
    id: cd

    property color cdColor: colors.darkGrey
    property color centerColor: colors.colorGrey08
    property color backgroundColor: "transparent"

    color: backgroundColor

    Rectangle {
      id: outerCircle
      height: parent.height*0.8
      width: height
      radius: height * 0.5
      anchors.centerIn: parent
      color: cdColor
    }
    Rectangle {
      id: innerCircle
      height: parent.height*0.1
      width: height
      radius: height * 0.5
      anchors.centerIn: parent
      color: centerColor
    }
}