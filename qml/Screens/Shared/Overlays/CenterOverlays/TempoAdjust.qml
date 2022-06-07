import QtQuick 2.12
import CSI 1.0

CenterOverlay {
  id: tempoAdjust
  property int deckId: 1

  AppProperty { id: clockBpm; path: "app.traktor.masterclock.tempo" }
  AppProperty { id: masterClockMode; path: "app.traktor.masterclock.mode" }
  AppProperty { id: masterId; path: "app.traktor.masterclock.source_id" }

  AppProperty { id: primaryKey; path: "app.traktor.decks." + deckId + ".track.content.entry_key" } //this refers to the "number of the track in the collection"
  AppProperty { id: isLoaded; path: "app.traktor.decks." + deckId + ".is_loaded" }
  AppProperty { id: isSyncEnabled; path: "app.traktor.decks." + deckId + ".sync.enabled" }

  AppProperty { id: tempoPhase; path: "app.traktor.decks." + deckId + ".tempo.phase" }
  AppProperty { id: tempo; path: "app.traktor.decks." + deckId + ".tempo.tempo_for_display" }
  AppProperty { id: tempoAbsolute; path: "app.traktor.decks." + deckId + ".tempo.absolute" }
  AppProperty { id: stableTempo; path: "app.traktor.decks." + deckId + ".tempo.true_tempo" }
  AppProperty { id: bpm; path: "app.traktor.decks." + deckId + ".tempo.base_bpm" }
  AppProperty { id: stableBpm; path: "app.traktor.decks." + deckId + ".tempo.true_bpm" }

  property real tempoOffset: (tempo.value - 1)*100
  property int wholeBPM: Math.round(bpm.value).toFixed(2)
  property int decBPM: Math.round(bpm.value % 1)

  readonly property bool isMaster: (masterId.value+1) == deckId
  readonly property bool synchedToOtherDeck: ((masterId.value+1) != deckId) && isSyncEnabled.value
  readonly property bool synchedToMasterClock: (masterId.value == -1) && isSyncEnabled.value

  //Overlay Headline
  Text {
    anchors.top:			  parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.topMargin:		margins.topMarginCenterOverlayHeadline
    font.pixelSize:		   fonts.largeFontSize
    color:					colorForBPMheadline(masterId.value, isSyncEnabled.value)
    text: titleForBPMOverlay(masterId.value, isSyncEnabled.value)
  }

  //Content
  Text {
    readonly property real dispBpm: synchedToMasterClock ? clockBpm.value : stableBpm.value
    anchors.top:			  parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.topMargin:		55 //47
    font.pixelSize:		   fonts.extraLargeValueFontSize //fonts.superLargeValueFontSize
    font.family   :		   "Pragmatica"
    color:					colors.colorWhite
    text:					 dispBpm.toFixed(2).toString()
  }

  Text {
    id: modifiedkey
    anchors.top:			  parent.top
    //anchors.right:		  parentesis.left
    anchors.right:			parent.right
    anchors.topMargin:		67
    anchors.rightMargin:	  10
    font.pixelSize:		   fonts.largeFontSize
    font.family   :		   "Pragmatica"
    font.capitalization: 	  Font.AllUppercase
    color:					utils.colorRangeTempo(tempoOffset)//colors.colorGrey104
    visible: 				  !synchedToMasterClock && !synchedToOtherDeck && tempoOffset!=0
    text:					  ((tempoOffset <= 0) ? "" : "+") + (tempoOffset).toFixed(1).toString() + "%";
  }

  //AUTO button
  Rectangle {
    anchors.top:			  parent.top
    anchors.left:			 parent.left
    anchors.topMargin:		67
    anchors.leftMargin:	   10
    width: 50
    height: 23
    color: (masterClockMode.value ? colors.cyan : colors.colorGrey72)
    radius: 4

    Text {
      anchors.centerIn: parent
      anchors.verticalCenterOffset: 1
      anchors.horizontalCenterOffset: -1
      font.pixelSize: fonts.smallFontSize
      text: "AUTO"
      color: "black"
    }
  }

  //Footline
  Text {
    anchors.bottom: parent.bottom
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottomMargin: 24.0
    font.pixelSize: fonts.smallFontSize
    color: colors.colorGrey72
    text: "Push BROWSE to activate Auto Master"
  }

  //Footline 2
  Item {
    anchors.bottom: parent.bottom
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottomMargin: 8.0
    width: footline2hold.paintedWidth + footline2back.paintedWidth + footline2reset.paintedWidth + footline2value.paintedWidth
    visible: !synchedToMasterClock && !synchedToOtherDeck && tempoOffset!=0

    Text {
        id: footline2hold
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        font.pixelSize: fonts.smallFontSize
        color: colors.colorGrey72
        text: "Hold "
    }
    Text {
        id: footline2back
        anchors.bottom: parent.bottom
        anchors.left: footline2hold.right
        font.pixelSize: fonts.smallFontSize
        color: colors.orange
        text: "BACK "
    }
    Text {
        id: footline2reset
        anchors.bottom: parent.bottom
        anchors.left: footline2back.right
        font.pixelSize: fonts.smallFontSize
        color: colors.colorGrey72
        text: "to reset to "
    }
    Text {
        id: footline2value
        anchors.bottom: parent.bottom
        anchors.left: footline2reset.right
        font.pixelSize: fonts.smallFontSize
        color: colors.colorGrey72
        text: wholeBPM + "." + getOriginalBpmDecimal() + " BPM"
    }
  }

  Text {
    anchors.bottom: parent.bottom
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottomMargin: 8.0
    font.pixelSize: fonts.smallFontSize
    color: colors.cyan
    text: "SYNCHED to MASTER CLOCK"
    visible: synchedToMasterClock
  }

  Text {
    anchors.bottom: parent.bottom
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottomMargin: 8.0
    font.pixelSize: fonts.smallFontSize
    color: colors.greenActive //colors.green
    text: "SYNCHED to deck " + deckLetters[masterId.value]
    visible: !synchedToMasterClock && synchedToOtherDeck
  }

    function titleForBPMOverlay(masterId, sync) {
    if ((masterId == -1) && sync) {
        return "MASTER CLOCK BPM";
    }
    else if (isMaster) {
        return "MASTER BPM";
    }
    else if (sync) {
        return "SYNCHED BPM";
    }
    else {
        return "BPM";
    }
  }

  function colorForBPMheadline(masterId, sync) {
    if ((masterId == -1) && sync) {
        return colors.cyan;
    }
    else if (masterId == deckId) {
        return colors.cyan;
    }
    else if (sync) {
        return colors.mint;
    }
    else {
        return colors.colorCenterOverlayHeadline;
    }
  }

  function getOriginalBpmDecimal() {
    var dec = Math.round((bpm.value % 1) * 100);
    if (dec == 100) dec = 0;
      var decStr = dec.toString();
      if (dec < 10) decStr = "0" + decStr;
    return decStr;
  }
}
