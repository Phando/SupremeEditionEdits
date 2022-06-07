import CSI 1.0
import QtQuick 2.12
import QtGraphicalEffects 1.12

Item {
  id: sample
  property int deckId: 1
  property string deckSettingsPath: settingsPath + "." + deckId
  property string deckPropertiesPath: propertiesPath + "." + deckId
  property string samplePropertyPath
  property int slotId
  property int cellId
  
  width: 111
  height: 47
 
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

  property color resultColor: "white"   //this is the color displayed as sample background color
  property color sampleBgColor: colors.palette(sampleAnimationBrightness1.value,  sampleAnimationColor1.value)
  property color sampleBgsampleAnimationColor2: colors.palette(sampleAnimationBrightness2.value,  sampleAnimationColor2.value)
  onSampleBgColorChanged: calculateResultColor()
  onSampleBgsampleAnimationColor2Changed: calculateResultColor()
  
  function calculateResultColor() {
	resultColor.r = sampleBgColor.r*(1.0 - sampleAnimationColorRatio.value) + (sampleBgsampleAnimationColor2.r*(sampleAnimationColorRatio.value));
	resultColor.g = sampleBgColor.g*(1.0 - sampleAnimationColorRatio.value) + (sampleBgsampleAnimationColor2.g*(sampleAnimationColorRatio.value));
	resultColor.b = sampleBgColor.b*(1.0 - sampleAnimationColorRatio.value) + (sampleBgsampleAnimationColor2.b*(sampleAnimationColorRatio.value));
	resultColor.a = sampleBgColor.a*(1.0 - sampleAnimationColorRatio.value) + (sampleBgsampleAnimationColor2.a*(sampleAnimationColorRatio.value));
	remixSampleBg.color = resultColor;
  }

//--------------------------------------------------------------------------------------------------------------------
// Sample Container
//--------------------------------------------------------------------------------------------------------------------

  Rectangle {
	id: remixSampleBg

	anchors.fill: parent
	radius: 1
	color: resultColor
	border.width: 2
	border.color: highlightCell ? (sampleColorId.value > 0 ? colors.palette(0.75, sampleColorId.value) : colors.colorGrey72) : resultColor
	Component.onCompleted: calculateResultColor() // refers to color palette

	// Sample Icon (Loop & OneShot)
	Image {
		id: remixSampleIcon
		anchors.left: parent.left
		anchors.leftMargin: 3
		anchors.verticalCenter: parent.verticalCenter

		visible: false
		source: "../../../Shared/Images/Remix_Sample_Icon_Loop.png"
		state: samplePlayMode.description 
		states: [
			State { name: "Looped";  PropertyChanges { target: remixSampleIcon; source: "../../../Shared/Images/Remix_Sample_Icon_Loop.png"	} },
			State { name: "OneShot"; PropertyChanges { target: remixSampleIcon; source: "../../../Shared/Images/Remix_Sample_Icon_OneShot.png" } } 
		]
	}

	// Sample Icon - Colorize Overlay
	ColorOverlay {
		id: remixSampleIconColorOverlay

		anchors.fill: remixSampleIcon
		color: sampleAnimationColor1.value == 0 ? colors.colorGrey40 : highlightCell ? colors.palette(0.75, sampleColorId.value) : colors.palette(0.5, sampleColorId.value)
		source: remixSampleIcon
	}

	// Sample Name
	Text {
		id: remixSampleName

		anchors.fill: parent
		anchors.leftMargin: 22 
		anchors.rightMargin: 1 
		horizontalAlignment: Text.AlignLeft
		verticalAlignment: Text.AlignVCenter 

		text: sampleName.value 
		font.pixelSize: fonts.middleFontSize
		elide: Text.ElideRight
		color: highlightCell ? colors.palette(0.75, sampleColorId.value) : colors.palette(0.5, sampleColorId.value)
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
	  PropertyChanges { target: remixSampleName;			  color: colors.colorBlack /*brightness: 0.0*/ } 
	},
	State {
	  name: "Waiting"; // = cell is waiting to be played (waiting for quantized)
	}
  ]

}
