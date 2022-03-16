import CSI 1.0
import QtQuick 2.12
import QtGraphicalEffects 1.12

import '../../../Defines'
import '../../../Preferences'

Item {
  id: performancePanel
  property int deckId: 1
  property string propertiesPath: "mapping.state.left"
  visible: false

  InstantFXs { id: effects }
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
  //readonly property variant padsFXSlot1Names: [ instantFXs.iFX1Name, instantFXs.iFX2Name, instantFXs.iFX3Name, instantFXs.iFX4Name, instantFXs.iFX5Name, instantFXs.iFX6Name, instantFXs.iFX7Name, instantFXs.iFX8Name]
  //readonly property variant padsFXSlot2Names: [ instantFXs.iFX9Name, instantFXs.iFX10Name, instantFXs.iFX11Name, instantFXs.iFX12Name, instantFXs.iFX13Name, instantFXs.iFX14Name, instantFXs.iFX15Name, instantFXs.iFX16Name]

  readonly property variant hotcueColors: [colors.hotcue.hotcue, colors.lightOrange, colors.hotcue.fade, colors.hotcue.load, colors.hotcue.grid, colors.hotcue.loop ]
  readonly property variant loopModeColors: [colors.hotcue.loop, colors.hotcue.loop, colors.hotcue.loop, colors.hotcue.loop, colors.orange, colors.orange, colors.orange, colors.orange]
  readonly property variant advancedLoopModeColors: [colors.red, colors.hotcue.loop, colors.hotcue.loop, colors.red, colors.darkOrange, colors.lightOrange, colors.lightOrange, colors.darkOrange]
  //readonly property variant padsFXSlot1Colors: [ getColor(instantFXs.iFX1Color), getColor(instantFXs.iFX2Color), getColor(instantFXs.iFX3Color), getColor(instantFXs.iFX4Color), getColor(instantFXs.iFX5Color), getColor(instantFXs.iFX6Color), getColor(instantFXs.iFX7Color), getColor(instantFXs.iFX8Color) ]
  //readonly property variant padsFXSlot2Colors: [ getColor(instantFXs.iFX9Color), getColor(instantFXs.iFX10Color), getColor(instantFXs.iFX11Color), getColor(instantFXs.iFX12Color), getColor(instantFXs.iFX13Color), getColor(instantFXs.iFX14Color), getColor(instantFXs.iFX15Color), getColor(instantFXs.iFX16Color) ]

  function getColor(iFXColor) {
		if (iFXColor == "Red") 			return colors.red
		if (iFXColor == "Dark Orange") 	return colors.darkOrange
		if (iFXColor == "Light Orange") return colors.lightOrange
		if (iFXColor == "Warm Yellow") 	return colors.warmYellow
		if (iFXColor == "Yellow") 		return colors.yellow
		if (iFXColor == "Lime") 		return colors.lime
		if (iFXColor == "Green") 		return colors.green
		if (iFXColor == "Mint") 		return colors.mint
		if (iFXColor == "Cyan") 		return colors.cyan
		if (iFXColor == "Turquoise") 	return colors.turquoise
		if (iFXColor == "Blue") 		return colors.blue
		if (iFXColor == "Plum") 		return colors.plum
		if (iFXColor == "Violet") 		return colors.violet
		if (iFXColor == "Purple") 		return colors.purple
		if (iFXColor == "Magenta") 		return colors.magenta
		if (iFXColor == "Fuchsia") 		return colors.fuchsia
		return "white"
  }

  function performancePadsDisplayNames(index, exists, name){
    if (activePadsMode.value == PadsMode.loop) { return loopModeNames[index]}
    else if (activePadsMode.value == PadsMode.advancedLoop) { return advancedLoopModeNames[index]}
    else if (activePadsMode.value == PadsMode.loopRoll) { return loopRollNames[index]}
    else if (activePadsMode.value == PadsMode.effects) {
        //if (slotPadsFX.value == 1) return pads[index].name
        //else if (slotPadsFX.value == 2) return pads[index + 7].name
        return pads[index + (7*(slotPadsFX.value-1))].name
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
        //if (slotPadsFX.value == 1) return getColor(pads[index].color)
        //else if (slotPadsFX.value == 2) return getColor(pads[index+7].color)
        return getColor(pads[index + (7*(slotPadsFX.value-1))].color);
    }
    else if (type != -1 && exists && exists > 0) { return hotcueColors[type]}
    else { return colors.colorBgEmpty}
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
            property string cellName: performancePadsDisplayNames(index, exists.value, name.value)

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

                text: cellName
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

                text: cellName
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
