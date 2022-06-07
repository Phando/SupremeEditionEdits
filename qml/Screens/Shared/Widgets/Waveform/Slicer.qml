import QtQuick 2.12
import CSI 1.0

Item {
	id: slice_view
	property int deckId: 1
	property real zoom_factor: 0.9 // 90%

	AppProperty { id: freezeEnabled; path: "app.traktor.decks." + deckId + ".freeze.enabled" }
	AppProperty { id: freezeCount; path: "app.traktor.decks." + deckId + ".freeze.slice_count" }

	Row {
		id: slices
		property real boxWidth: width / freezeCount.value
		property real margins: parent.width * ((1.0-parent.zoom_factor)/2.0)

		anchors.fill: parent
		anchors.topMargin: -1
		anchors.leftMargin: margins - 1
		anchors.rightMargin: margins
		visible: freezeEnabled.value ? true : false //if we use .value only --> Traktor logs the unable to assign undefined to bool error

		Repeater {
			id: slice_repeater
			model: freezeCount.value
			Slice {
				slice_index: index
				first_slice: index == 0
				last_slice: index + 1 == freezeCount.value
				height: slices.height
				width: slices.boxWidth
			}
		}
	}
}
