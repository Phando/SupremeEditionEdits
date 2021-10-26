import CSI 1.0
import QtQuick 2.5
import QtGraphicalEffects 1.0

import '../../../../Defines'
import '../../../../Preferences'

Item {
  id: performancePanel
  property int deckId: 1
  property string propertiesPath: "mapping.state.left"

  InstantFXs { id: effects; name: "effects"; }
  property var pads : effects.pads

  MappingProperty { id: activePadsMode; path: propertiesPath + ".pads_mode"}
  MappingProperty { id: slotPadsFX; path: propertiesPath + ".slotPadsFX"}
  MappingProperty { id: displayNumbersHotcuePanel; path: "mapping.settings.displayNumbersHotcuePanel" }

  MappingProperty { id: loopPad1; path: "mapping.settings.pad_loop_size.1"}
  MappingProperty { id: loopPad2; path: "mapping.settings.pad_loop_size.2"}
  MappingProperty { id: loopPad3; path: "mapping.settings.pad_loop_size.3"}
  MappingProperty { id: loopPad4; path: "mapping.settings.pad_loop_size.4"}
  MappingProperty { id: jumpPad1; path: "mapping.settings.pad_jump_size.1"}
  MappingProperty { id: jumpPad2; path: "mapping.settings.pad_jump_size.2"}
  MappingProperty { id: jumpPad3; path: "mapping.settings.pad_jump_size.3"}
  MappingProperty { id: jumpPad4; path: "mapping.settings.pad_jump_size.4"}

  readonly property variant loopModeNames: [loopPad1.description, loopPad2.description, loopPad3.description, loopPad4.description, jumpPad1.description, jumpPad2.description, jumpPad3.description, jumpPad4.description]
  readonly property variant advancedLoopModeNames: ["- LOOP", "IN", "OUT", "+ LOOP", "-1 BAR", "-1 BEAT", "+1 BEAT", "+1 BAR"]
  readonly property variant loopRollNames: ["1/32", "1/16", "1/8", "1/4", "1/2", "1", "2", "4"]
  
  readonly property variant hotcueColors: [colors.hotcue.hotcue, colors.color03Bright, colors.hotcue.fade, colors.hotcue.load, colors.hotcue.grid, colors.hotcue.loop ]
  readonly property variant loopModeColors: [colors.hotcue.loop, colors.hotcue.loop, colors.hotcue.loop, colors.hotcue.loop, colors.colorOrange, colors.colorOrange, colors.colorOrange, colors.colorOrange]
  readonly property variant advancedLoopModeColors: [colors.color01Bright, colors.hotcue.loop, colors.hotcue.loop, colors.color01Bright, colors.color02Bright, colors.color03Bright, colors.color03Bright, colors.color02Bright]
  
 	
  function performancePadsDisplayNames(index, exists, name){
	if (activePadsMode.value == PadsMode.loop) { return loopModeNames[index]}
	else if (activePadsMode.value == PadsMode.advancedLoop) { return advancedLoopModeNames[index]}
	else if (activePadsMode.value == PadsMode.loopRoll) { return loopRollNames[index]}
	else if (activePadsMode.value == PadsMode.effects) {
		if (slotPadsFX.value == 1) return pads[index].name;
		else if (slotPadsFX.value == 2) return pads[index+7].name;
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
		if (slotPadsFX.value == 1) return effects.screenColor(index)
		else if (slotPadsFX.value == 2) return effects.screenColor(index+7)
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
				//anchors.horizontalCenter: parent.horizontalCenter
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