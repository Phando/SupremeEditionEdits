import CSI 1.0
import QtQuick 2.12
import QtGraphicalEffects 1.12

Item {
  id: sample
  property int deckId: 1
  property string samplePropertyPath
  property int slotId
  property int cellId
  property int cellSize
  property int cellRadius

  width: cellSize
  height: cellSize

  MappingProperty { id: legacyRemixMode; path: deckSettingsPath + ".legacyRemixMode" }
  MappingProperty { id: remixPadsControl; path: deckPropertiesPath + ".remixPadsControl" }

//--------------------------------------------------------------------------------------------------------------------
// Remix Sample Properties
//--------------------------------------------------------------------------------------------------------------------

  AppProperty { id: selected_cell_currentSlot; path: "app.traktor.decks." + deckId + ".remix.players." + slotId + ".sequencer.selected_cell" }
  property bool highlightCell: ((cellId == remixPadsControl.value*2 || cellId == remixPadsControl.value*2-1) && legacyRemixMode.value == true) || ((selected_cell_currentSlot.value + 1) == cellId &&  legacyRemixMode.value == false) ? true : false

  AppProperty { id: sampleColorId; path: samplePropertyPath + ".color_id" }
  AppProperty { id: sampleName; path: samplePropertyPath + ".name" }
  AppProperty { id: sampleState; path: samplePropertyPath + ".state" }
  AppProperty { id: samplePlayMode; path: samplePropertyPath + ".play_mode" }

  AppProperty { id: sampleAnimationColorRatio; path: samplePropertyPath + ".animation.color_ratio"; onValueChanged: calculateResultColor() }
  AppProperty { id: sampleAnimationColor1; path: samplePropertyPath + ".animation.color_id.1" }
  AppProperty { id: sampleAnimationColor2; path: samplePropertyPath + ".animation.color_id.2" }
  AppProperty { id: sampleAnimationBrightness1; path: samplePropertyPath + ".animation.brightness.1" }
  AppProperty { id: sampleAnimationBrightness2; path: samplePropertyPath + ".animation.brightness.2" }
  AppProperty { id: sampleAnimationState; path: samplePropertyPath + ".animation.display_state" }

  property color resultColor: "white"   //this is the color displayed as sample background color
  property color sampleBgColor: colors.palette(sampleAnimationBrightness1.value,  sampleAnimationColor1.value)
  property color sampleBgsampleAnimationColor2: colors.palette(sampleAnimationBrightness2.value,  sampleAnimationColor2.value)
  onSampleBgColorChanged: calculateResultColor()
  onSampleBgsampleAnimationColor2Changed: calculateResultColor()

  function calculateResultColor() {
/*
    resultColor.r = sampleBgColor.r*(1.0 - sampleAnimationColorRatio.value) + (sampleBgsampleAnimationColor2.r*(sampleAnimationColorRatio.value));
    resultColor.g = sampleBgColor.g*(1.0 - sampleAnimationColorRatio.value) + (sampleBgsampleAnimationColor2.g*(sampleAnimationColorRatio.value));
    resultColor.b = sampleBgColor.b*(1.0 - sampleAnimationColorRatio.value) + (sampleBgsampleAnimationColor2.b*(sampleAnimationColorRatio.value));
    resultColor.a = sampleBgColor.a*(1.0 - sampleAnimationColorRatio.value) + (sampleBgsampleAnimationColor2.a*(sampleAnimationColorRatio.value));
*/
    resultColor = sampleState.description == "Empty" ? "black" : colors.palette(computeBrightness(sampleState.description, sampleAnimationState.description), sampleColorId.value)
    remixSampleBg.color = resultColor;
  }

  function computeBrightness(state, displayState) {
    if (state == "Playing" && displayState == "BrightColor") return 1
    else return 0.5
  }

//--------------------------------------------------------------------------------------------------------------------
// Sample Container
//--------------------------------------------------------------------------------------------------------------------

  Rectangle {
    id: remixSampleBg

    anchors.fill: parent
    radius: cellRadius
    color: resultColor
    border.width: 2
    border.color: highlightCell ? (sampleColorId.value > 0 ? colors.palette(0.75, sampleColorId.value) : colors.colorGrey72) : resultColor
    Component.onCompleted: calculateResultColor() // refers to color palette

    // Sample Icon (Loop & OneShot)
    Image {
        id: remixSampleIcon

        //anchors.fill: parent
        anchors.centerIn: parent
        width: cellSize*0.8
        height: cellSize*0.8
        fillMode: Image.PreserveAspectFit

        visible: false
        source: ""
        state: samplePlayMode.description
        states: [
            State { name: "Looped";  PropertyChanges { target: remixSampleIcon; source: "../../Images/Remix_Sample_Icon_Loop.png" } },
            State { name: "OneShot"; PropertyChanges { target: remixSampleIcon; source: "../../Images/Remix_Sample_Icon_OneShot.png" } }
        ]
    }

    // Sample Icon - Colorize Overlay
    ColorOverlay {
        id: remixSampleIconColorOverlay

        anchors.fill: remixSampleIcon
        color: sampleAnimationColor1.value == 0 ? colors.colorGrey40 : highlightCell ? colors.palette(0.75, sampleColorId.value) : colors.palette(0.5, sampleColorId.value)
        source: remixSampleIcon
    }
  }

  state: sampleState.description
  states: [
    State {
      name: "Empty"; // = empty cell
    },
    State {
      name: "Loaded"; // = loaded cell
    },
    State {
      name: "Playing"; // = cell is playing
      PropertyChanges { target: remixSampleIconColorOverlay;  color: colors.colorBlack /*brightness: 0.0*/ }
    },
    State {
      name: "Waiting"; // = cell is waiting to be played (waiting for quantized)
    }
  ]

}
