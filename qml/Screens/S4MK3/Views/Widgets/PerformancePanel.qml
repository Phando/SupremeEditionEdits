import CSI 1.0
import QtQuick 2.5
import QtGraphicalEffects 1.0

import '../../../../Defines'

Item {
  id: performancePanel
  property int deckId: 1
  property string propertiesPath: "mapping.state.left"

  MappingProperty { id: activePadsMode; path: propertiesPath + ".pads_mode"}
  MappingProperty { id: slotPadsFX; path: propertiesPath + ".slotPadsFX"}
  MappingProperty { id: displayNumbersHotcuePanel; path: "mapping.settings.displayNumbersHotcuePanel" }

/*
  property string loopSize1: mapping.settings.pad_loop_size.1.value == 2 ? "Y" : "N"
  Wire { from: DirectPropertyAdapter { path:"mapping.settings.pad_loop_size.1.value.toString()"; input: false } to: loopSize1 }
*/

  //FIX Names that appear when Default Loop Mode
  readonly property variant loopModeNames: ["NW", "NW", "NW", "NW", "NW", "NW", "NW", "NW"]  
  readonly property variant advancedLoopModeNames: ["- LOOP", "IN", "OUT", "+ LOOP", "-1 BAR", "-1 BEAT", "+1 BEAT", "+1 BAR"]
  readonly property variant loopRollNames: ["1/32", "1/16", "1/8", "1/4", "1/2", "1", "2", "4"]
  readonly property variant padsFXSlot1Names: [ preferences.iFX1Name, preferences.iFX2Name, preferences.iFX3Name, preferences.iFX4Name, preferences.iFX5Name, preferences.iFX6Name, preferences.iFX7Name, preferences.iFX8Name]
  readonly property variant padsFXSlot2Names: [ preferences.iFX9Name, preferences.iFX10Name, preferences.iFX11Name, preferences.iFX12Name, preferences.iFX13Name, preferences.iFX14Name, preferences.iFX15Name, preferences.iFX16Name]

  readonly property variant hotcueColors: [colors.hotcue.hotcue, colors.color03Bright, colors.hotcue.fade, colors.hotcue.load, colors.hotcue.grid, colors.hotcue.loop ]
  readonly property variant loopModeColors: [colors.hotcue.loop, colors.hotcue.loop, colors.hotcue.loop, colors.hotcue.loop, colors.colorOrange, colors.colorOrange, colors.colorOrange, colors.colorOrange]
  readonly property variant advancedLoopModeColors: [colors.color01Bright, colors.hotcue.loop, colors.hotcue.loop, colors.color01Bright, colors.color02Bright, colors.color03Bright, colors.color03Bright, colors.color02Bright]
  readonly property variant padsFXSlot1Colors: [ preferences.iFX1Color, preferences.iFX2Color, preferences.iFX3Color, preferences.iFX4Color, preferences.iFX5Color, preferences.iFX6Color, preferences.iFX7Color, preferences.iFX8Color]
  readonly property variant padsFXSlot2Colors: [ preferences.iFX9Color, preferences.iFX10Color, preferences.iFX11Color, preferences.iFX12Color, preferences.iFX13Color, preferences.iFX14Color, preferences.iFX15Color, preferences.iFX16Color]
 
  function performancePadsDisplayNames(index, exists, name){
	if (activePadsMode.value == PadsMode.loop) { return loopModeNames[index]}
	else if (activePadsMode.value == PadsMode.advancedLoop) { return advancedLoopModeNames[index]}
	else if (activePadsMode.value == PadsMode.loopRoll) { return loopRollNames[index]}
	else if (activePadsMode.value == PadsMode.effects) {
		if (slotPadsFX.value == 1) return padsFXSlot1Names[index]
		else if (slotPadsFX.value == 2) return padsFXSlot2Names[index]
	}
	else {
		if (exists > 0 && name != "n.n.") { return name }
		else { return "" }
	}
  }
  
  function performancePadsDisplayColor(index, exists, type){
	if (activePadsMode.value == PadsMode.loop) { return loopModeColors[index]}
	else if (activePadsMode.value == PadsMode.advancedLoop) { return advancedLoopModeColors[index]}
	else if (activePadsMode.value == PadsMode.loopRoll) { return colors.hotcue.loop}
	else if (activePadsMode.value == PadsMode.effects) {
		if (slotPadsFX.value == 1) return padsFXSlot1Colors[index]
		else if (slotPadsFX.value == 2) return padsFXSlot2Colors[index]
	}
	else {  
		if (exists > 0) { return  hotcueColors[type]}
		else { return colors.colorBgEmpty}
	}
  }
 
  Grid {
	id: grid
	anchors.fill: parent
	
	rows: 2
	columns: 4
	spacing: 1

	Repeater {
		model: 8 
		Rectangle {
			width: (parent.width - 3*1)/4
			height: (parent.height-2)/2
			color: performancePadsDisplayColor(index, exists.value, type.value)

			AppProperty { id: exists;  path: "app.traktor.decks." + deckId + ".track.cue.hotcues." + (index + 1) + ".exists" }
			AppProperty { id: name;	path: "app.traktor.decks." + deckId + ".track.cue.hotcues." + (index + 1) + ".name" }
			AppProperty { id: type;	path: "app.traktor.decks." + deckId + ".track.cue.hotcues." + (index + 1) + ".type" }

			//Performance Panel (Hotcues + Index)
			Text {
				id: hotcueIndex
				anchors.top: parent.top
				anchors.bottom: parent.bottom
				anchors.left: parent.left
				anchors.leftMargin: 2
				visible: displayNumbersHotcuePanel.value && activePadsMode.value == PadsMode.hotcues

				text: (index+1) + "."
				color: exists.value > 0 ? colors.colorGrey24 : colors.colorGrey128
				font.family: "Pragmatica MediumTT"
				font.pixelSize: fonts.smallFontSize
				verticalAlignment: Text.AlignVCenter
			}			
			Text {
				anchors.top: parent.top
				anchors.bottom: parent.bottom
				anchors.left: hotcueIndex.right
				anchors.leftMargin: 2
				anchors.right: parent.right
				anchors.rightMargin: 2
				anchors.horizontalCenter: parent.horizontalCenter
				width: parent.width - 4
				visible: displayNumbersHotcuePanel.value && activePadsMode.value == PadsMode.hotcues

				text: performancePadsDisplayNames(index, exists.value, name.value)
				color: activePadsMode.value == PadsMode.hotcues ? (exists.value > 0 ? colors.colorGrey24 : colors.colorGrey128) : (colors.colorGrey24)
				font.family: "Pragmatica MediumTT"		
				font.pixelSize: fonts.smallFontSize
				//elide: Text.ElideRight
				horizontalAlignment: Text.AlignHCenter
				verticalAlignment: Text.AlignVCenter
			}
			
			//Performance Panel (without Index)
			Text {
				anchors.top: parent.top
				anchors.bottom: parent.bottom
				width: parent.width - 4
				visible: !displayNumbersHotcuePanel.value || (displayNumbersHotcuePanel.value && activePadsMode.value != PadsMode.hotcues)
				
				text: performancePadsDisplayNames(index, exists.value, name.value)
				color: activePadsMode.value == PadsMode.hotcues ? (exists.value > 0 ? colors.colorGrey24 : colors.colorGrey128) : (colors.colorGrey24)
				font.family: "Pragmatica MediumTT"		
				font.pixelSize: fonts.smallFontSize
				elide: Text.ElideRight
				horizontalAlignment: Text.AlignHCenter
				verticalAlignment: Text.AlignVCenter
			}
		}
	}
	Behavior on height { PropertyAnimation {  duration: durations.deckTransition } }
  }
}