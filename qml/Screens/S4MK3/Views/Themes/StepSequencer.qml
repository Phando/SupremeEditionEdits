import CSI 1.0
import QtQuick 2.12

import '../Widgets' as Widgets

Item {
  id: stepSequencer
  property bool active: true
  property int deckId: 1
  property var remixDeckPropertyPath
  property var playerPropertyPath
  property var activeCellPath

  property int numberOfEditableSteps: 8

  AppProperty { id: sequencerOn; path: remixDeckPropertyPath + ".sequencer.on" }
  AppProperty { id: current_step; path: playerPropertyPath + ".sequencer.current_step" }
  AppProperty { id: pattern_length; path: playerPropertyPath + ".sequencer.pattern_length" }
  AppProperty { id: activeCellColorId; path: activeCellPath + ".color_id" }
  MappingProperty { id: sequencerPage; path: deckPropertiesPath + ".sequencerPage";  }
  
  Grid {
	anchors.left: parent.left
	anchors.leftMargin: 6
	anchors.top: parent.top
	anchors.topMargin: 1
	columns: 4
	spacing: 4
	Repeater {
		model: pattern_length.value
		Rectangle {
			AppProperty   { id: step; path: playerPropertyPath + ".sequencer.steps." + (index + 1) }
			id: stepSquare
			radius: 2
			width: 22
			height: 22
			color: current_step.value === index ? colors.colorWhite : (step.value ? colors.palette(1.0, activeCellColorId.value) : colors.colorGrey24)
			border.width: 1
			border.color: current_step.value === index ? colors.colorWhite : (step.value ? colors.palette(1.0, activeCellColorId.value) : ((active && index >= (sequencerPage.value-1)*numberOfEditableSteps && index < sequencerPage.value*numberOfEditableSteps) ? colors.palette(1.0, activeCellColorId.value) : colors.colorGrey24))
		}
	}
  }
}