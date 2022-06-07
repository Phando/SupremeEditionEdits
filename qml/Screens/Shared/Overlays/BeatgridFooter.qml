import QtQuick 2.12
import CSI 1.0

Rectangle {
  id: footer
  property int deckId: 1
  property bool isAnalyzing //averiguar d'on surt això

  color:  colors.colorBgEmpty 
  
  AppProperty { id: bpm; path: "app.traktor.decks." + deckId + ".track.grid.adjust_bpm" }
  AppProperty { id: isGridLocked; path: "app.traktor.decks." + deckId + ".track.grid.lock_bpm" }
  
  //MappingPropertyDescriptor { id: zoomedEditView; path: propertiesPath + ".beatgrid.zoomed_view"; type: MappingPropertyDescriptor.Boolean; value: false }
  MappingProperty { id: zoomedEditView; path: propertiesPath + ".beatgrid.zoomed_view" }
  MappingProperty { id: encoderScanMode; path: propertiesPath + ".encoderScanMode" }

  readonly property bool isTraktorS5: (screen.flavor == ScreenFlavor.S5)

  //Dividers
  Rectangle { id: line1; visible: !isAnalyzing; width: 1; height: footer.height; color: colors.colorDivider; x: 119 }
  Rectangle { id: line2; visible: !isAnalyzing; width: 1; height: footer.height; color: colors.colorDivider; x: 359 }

  //BPM value
  Text {
	text: (isAnalyzing) ? "analyzing..." : bpm.value.toFixed(3).toString()
	color: colors.colorWhite
	font.pixelSize: fonts.largeValueFontSize
	anchors.horizontalCenter: parent.horizontalCenter
	anchors.verticalCenter: parent.verticalCenter
	anchors.verticalCenterOffset: 1
  }

  Text {
	id: halfbpm
	anchors.verticalCenter: parent.verticalCenter
	anchors.left: parent.left
	anchors.leftMargin: 3
	color: isGridLocked.value ? colors.colorGrey32 : colors.colorGrey72
	visible: !isAnalyzing;

	text: "/2"
	font.pixelSize: fonts.smallFontSize
  }

  Text {
	id: offset
	anchors.verticalCenter: parent.verticalCenter
	anchors.left: parent.left
	anchors.leftMargin: 30
	color: isGridLocked.value ? colors.colorGrey32 : colors.colorGrey72
	visible: !isAnalyzing;

	text: isTraktorS5 ? (zoomedEditView.value ? (screen.shift ? "0.001 BPM" : "0.05 BPM") : (screen.shift ? "0.05 BPM" : "1 BPM")) : (zoomedEditView.value ? (screen.shift ? "UF. OFFSET" : "FINE OFFSET") : (screen.shift ? "FINE OFFSET" : "OFFSET"))
	font.pixelSize: fonts.smallFontSize
  }
  
  Text {
	id: bpmtext
	anchors.verticalCenter: parent.verticalCenter
	anchors.left: parent.left
	anchors.leftMargin: 125
	color: isGridLocked.value ? colors.colorGrey32 : colors.colorGrey72
	visible: !isAnalyzing;

	text: isTraktorS5 ? (screen.shift ? "ZOOM" : "TAP") : (zoomedEditView.value ? (screen.shift ? "0.001 BPM" : "0.05 BPM") : (screen.shift ? "0.05 BPM" : "1 BPM"))
	font.pixelSize: fonts.smallFontSize
  }
  
  Text {
	id: scan
	anchors.verticalCenter: parent.verticalCenter
	anchors.right: parent.right
	anchors.rightMargin: 125
	color: isTraktorS5 ? (encoderScanMode.value ? colors.colorGrey72 : colors.colorGrey32) : colors.colorGrey72
	visible: !isAnalyzing;

	text: "SCAN"
	font.pixelSize: fonts.smallFontSize
	horizontalAlignment: Text.AlignRight
  }
  
  Text {
	id: tap
	anchors.verticalCenter: parent.verticalCenter
	anchors.right: parent.right
	anchors.rightMargin: 30
	color: isTraktorS5 ? (encoderScanMode.value ? colors.colorGrey32 : colors.colorGrey72) : (isGridLocked.value ? colors.colorGrey32 : colors.colorGrey72)
	visible: !isAnalyzing;

	text: isTraktorS5 ? (zoomedEditView.value ? (screen.shift ? "UF. OFFSET" : "FINE OFFSET") : (screen.shift ? "FINE OFFSET" : "OFFSET")) : "TAP"
	font.pixelSize: fonts.smallFontSize
	horizontalAlignment: Text.AlignRight
  }
  
  Text {
	id: doublebpm
	anchors.verticalCenter: parent.verticalCenter
	anchors.right: parent.right
	anchors.rightMargin: 3
	color: isGridLocked.value ? colors.colorGrey32 : colors.colorGrey72
	visible: !isAnalyzing;

	text: "x2"
	font.pixelSize: fonts.smallFontSize
  }
}
