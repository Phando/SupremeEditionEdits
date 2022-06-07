import QtQuick 2.12
import QtGraphicalEffects 1.12

Item {
  property int diamater: 30
  width: diamater
  height: diamater

  property bool spinning: false
  property bool spinningInterior: false
  property bool spinningBorder: false
  property int interval: 500

  property color spinningPrimaryColor: colors.darkerColor(colors.green, 0.25)
  property color spinningSecondaryColor: "transparent"
  property color backgroundColor: "transparent"
  property color borderColor: colors.colorGrey72
  property int borderWidth: 2 //INFO: Set to 0 in order not to show any.

  Rectangle {
      id: interior
      anchors.fill: parent
      anchors.margins: borderWidth
      radius: width
      visible: !spinning || (spinning && !spinningInterior)
      color: backgroundColor
  }

  /*
  Rectangle {
      id: interiorAndBorder
      anchors.fill: parent
      radius: width
      visible: false //spinning && spinningInterior && spinningBorder
  }
  */

  ConicalGradient {
    anchors.fill: parent
    //anchors.margins: borderWidth

    angle: 0.0
    visible: spinning
    gradient: Gradient {
        GradientStop { position: 1.0; color: spinningPrimaryColor }
        GradientStop { position: 0.0; color: spinningSecondaryColor }
    }
    RotationAnimation on rotation {
        loops: Animation.Infinite
        from: 0
        to:	360
        duration: interval
    }
    layer.enabled: true
    layer.effect: OpacityMask {
        //maskSource: spinningBorder ? spinningInterior ? interiorAndBorder : border : interior
        maskSource: spinningBorder && !spinningInterior ? border : interior
    }
  }

  Rectangle {
      id: border
      anchors.fill: parent
      radius: width
      visible: !spinning || (spinning && !spinningBorder)
      color: "transparent"
      border.width: borderWidth
      border.color: borderColor
  }
}
