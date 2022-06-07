import CSI 1.0
import QtQuick 2.12
import QtGraphicalEffects 1.12

import '../Widgets' as Widgets

Rectangle {
  id: softTakeoverFaders

  height: 81
  anchors.left: parent.left
  anchors.right: parent.right
  color: colors.colorFxHeaderBg

  MappingProperty { id: inputPosition1; path: propertiesPath + ".softtakeover.faders.1.input"  }
  MappingProperty { id: inputPosition2; path: propertiesPath + ".softtakeover.faders.2.input"  }
  MappingProperty { id: inputPosition3; path: propertiesPath + ".softtakeover.faders.3.input"  }
  MappingProperty { id: inputPosition4; path: propertiesPath + ".softtakeover.faders.4.input"  }
  MappingProperty { id: outputPosition1; path: propertiesPath + ".softtakeover.faders.1.output" }
  MappingProperty { id: outputPosition2; path: propertiesPath + ".softtakeover.faders.2.output" }
  MappingProperty { id: outputPosition3; path: propertiesPath + ".softtakeover.faders.3.output" }
  MappingProperty { id: outputPosition4; path: propertiesPath + ".softtakeover.faders.4.output" }
  MappingProperty { id: active1; path: propertiesPath + ".softtakeover.faders.1.active" }
  MappingProperty { id: active2; path: propertiesPath + ".softtakeover.faders.2.active" }
  MappingProperty { id: active3; path: propertiesPath + ".softtakeover.faders.3.active" }
  MappingProperty { id: active4; path: propertiesPath + ".softtakeover.faders.4.active" }

  property variant inputPosition: [inputPosition1.value, inputPosition2.value, inputPosition3.value, inputPosition4.value ]
  property variant outputPosition: [outputPosition1.value, outputPosition2.value, outputPosition3.value, outputPosition4.value ]
  property variant active: [active1.value, active2.value, active3.value, active4.value ]

  //Dividers
  Repeater {
    model: 3
    Rectangle {
        width: 1
        height: 75
        color: colors.colorDivider
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: (index+1) * 120
    }
  }

  //Faders
  Row {
    Repeater {
        model: 4

        Item {
            width: softTakeoverFaders.width / 4
            height: softTakeoverFaders.height

            Widgets.Fader {
                anchors.centerIn: parent
                internalValue: inputPosition[index]
                hardwareValue: outputPosition[index]
                mismatch: active[index]
            }
        }
    }
  }

  //Black border & shadow
  Rectangle {
    id: headerBlackLine
    anchors.bottom: softTakeoverFaders.top
    width: parent.width
    height: 1
    color: colors.colorBlack
  }
}
