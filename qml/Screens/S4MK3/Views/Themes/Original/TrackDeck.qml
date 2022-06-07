import CSI 1.0
import QtQuick 2.12
import QtQuick.Layouts 1.12

import './ViewModels'
import './Widgets' as OriginalWidgets
import '../../Widgets' as Widgets

//----------------------------------------------------------------------------------------------------------------------
//  Track Screen View - UI of the screen for track
//----------------------------------------------------------------------------------------------------------------------

Item {
  id: display

  property int deckId: 1
  property string deckSettingsPath: settingsPath + "." + deckId
  property string deckPropertiesPath: propertiesPath + "." + deckId

  Dimensions {id: dimensions}

  // MODEL PROPERTIES //
  property real boxesRadius:	  dimensions.cornerRadius
  property real infoBoxesWidth:   dimensions.infoBoxesWidth
  property real firstRowHeight:   dimensions.firstRowHeight
  property real secondRowHeight:  dimensions.secondRowHeight
  property real spacing:		  dimensions.spacing
  property real screenTopMargin:  dimensions.screenTopMargin
  property real screenLeftMargin: dimensions.screenLeftMargin

  width  : 320
  height : 240

  function isLeftScreen(deckId)
  {
	return deckId == 1 || deckId == 3;
  }

  ////////////////////////////////////
  /////// Track info properties //////
  ////////////////////////////////////

  readonly property bool	trackEndWarning:	  propTrackEndWarning.value
  readonly property bool	shift:				propShift.value
  readonly property string  artistString:		 propArtist.value
  readonly property string  bpmString:			isLoaded ? propBPM.value.toFixed(2).toString() : "0.00"
  readonly property real	elapsedTime:		  propElapsedTime.value
  readonly property bool	hightlightLoop:	   !shift
  readonly property bool	hightlightKey:		shift
  readonly property int	 isLoaded:			 (propTrackLength.value > 0) || (deckType === DeckType.Remix)
  readonly property string  resultingKeyStr:	  propKeyForDisplay.value
  readonly property int	 resultingKeyIdx:	  propFinalKeyId.value
  readonly property bool	hasKey:			   isLoaded && resultingKeyIdx >= 0
  readonly property bool	isKeyLockOn:		  propKeyLockOn.value
  readonly property bool	loopActive:		   propLoopActive.value
  readonly property string  loopSizeString:	   loopSizeText[propLoopSizeIdx.value]
  readonly property string  primaryKey:		   propPrimaryKey.value
  readonly property string  remainingTimeString:  (!isLoaded) ? "00:00" : utils.getRemainingTime(propTrackLength.value, propElapsedTime.value)
  readonly property string  titleString:		  isLoaded ? propTitle.value : "No Track Loaded"
  readonly property int	 trackLength:		  propTrackLength.value
  readonly property real	phase:				propPhase.value
  readonly property bool	touchKey:			 false // TODO map shift encoder touch event
  readonly property bool	touchTime:			false // TODO map shift encoder touch event
  readonly property bool	touchLoop:			false // TODO map shift encoder touch event

  readonly property int	 deckType:			 propDeckType.value
  readonly property string  keyAdjustFloatText:   (keyAdjustVal < 0 ? "" : "+") + keyAdjustVal.toFixed(2).toString()
  readonly property string  keyAdjustIntText:	 (keyAdjustVal < 0 ? "" : "+") + keyAdjustVal.toFixed(0).toString()
  readonly property real	keyAdjustVal:		 propKeyAdjust.value*12
  readonly property variant loopSizeText:		 ["1/32", "1/16", "1/8", "1/4", "1/2", "1", "2", "4", "8", "16", "32"]

  AppProperty { id: propDeckType;			   path: "app.traktor.decks." + deckId + ".type" }
  AppProperty { id: propTitle;				  path: "app.traktor.decks." + deckId + ".content.title" }
  AppProperty { id: propArtist;				 path: "app.traktor.decks." + deckId + ".content.artist" }
  AppProperty { id: propKeyForDisplay;		  path: "app.traktor.decks." + deckId + ".track.key.resulting.quantized" }
  AppProperty { id: propFinalKeyId;			 path: "app.traktor.decks." + deckId + ".track.key.final_id" }
  AppProperty { id: propKeyAdjust;			  path: "app.traktor.decks." + deckId + ".track.key.adjust" }
  AppProperty { id: propKeyLockOn;			  path: "app.traktor.decks." + deckId + ".track.key.lock_enabled" }
  AppProperty { id: propBPM;					path: "app.traktor.decks." + deckId + ".tempo.true_bpm" }
  AppProperty { id: propPhase;				  path: "app.traktor.decks." + deckId + ".tempo.phase" }
  AppProperty { id: propLoopSizeIdx;			path: "app.traktor.decks." + deckId + ".loop.size" }
  AppProperty { id: propLoopActive;			 path: "app.traktor.decks." + deckId + ".loop.active" }
  AppProperty { id: propTrackLength;			path: "app.traktor.decks." + deckId + ".track.content.track_length" }
  AppProperty { id: propElapsedTime;			path: "app.traktor.decks." + deckId + ".track.player.elapsed_time" }
  AppProperty { id: propertyCover;			  path: "app.traktor.decks." + deckId + ".content.cover_md5" }
  AppProperty { id: propPrimaryKey;			 path: "app.traktor.decks." + deckId + ".track.content.entry_key" }
  AppProperty { id: propTrackEndWarning;		path: "app.traktor.decks." + deckId + ".track.track_end_warning" }

  MappingProperty { id: propShift;	 path: "mapping.state." + (isLeftScreen(deckId) ? "left" : "right") + ".shift" }

  ///////////////////////////////////////////////////
  /////// Remix Deck properties /////////////////////
  ///////////////////////////////////////////////////

  readonly property string  beatPositionString:   propBeatPosition.description
  readonly property bool	rmxQuantizeOn:		propRemixQuantOn.value
  readonly property string  rmxQuantizeIndex:	 propRemixQuantIndex.description
  readonly property bool	isSequencerRecOn:	 propSequencerRecOn.value
  readonly property int	 remixActiveSlot:	  propRemixActiveSlot.value
  readonly property bool	remixSampleBrowsing:  propRemixSampleBrowsing.value

  AppProperty { id: propBeatPosition;				path: "app.traktor.decks." + deckId + ".remix.current_beat_pos" }
  AppProperty { id: propRemixQuantOn;				path: "app.traktor.decks." + deckId + ".remix.quant" }
  AppProperty { id: propRemixQuantIndex;			 path: "app.traktor.decks." + deckId + ".remix.quant_index" }
  AppProperty { id: propSequencerRecOn;			  path: "app.traktor.decks." + deckId + ".remix.sequencer.rec.on" }

  MappingProperty { id: propRemixActiveSlot; path: "mapping.state." + (isLeftScreen(deckId) ? "left." : "right.") + deckId + ".active_slot";  }
  MappingProperty { id: propRemixSampleBrowsing; path: "mapping.state." + (isLeftScreen(deckId) ? "left." : "right.") + deckId + ".sample_browsing";  }

  property var slot1 : Slot { slotId: 1; deckId: viewModel.deckId }
  property var slot2 : Slot { slotId: 2; deckId: viewModel.deckId }
  property var slot3 : Slot { slotId: 3; deckId: viewModel.deckId }
  property var slot4 : Slot { slotId: 4; deckId: viewModel.deckId }

  property var slots : [slot1, slot2, slot3, slot4]

  function getSlot( slotId ) { return slots[ slotId-1 ]; }

  ///////////////////////////////////////////////////
  /////// Stem Deck properties //////////////////////
  ///////////////////////////////////////////////////

  MappingProperty { id: propStemActive; path: "mapping.state." + (isLeftScreen(deckId) ? "left." : "right.") + deckId + ".stems.active_stem";  }

  readonly property bool isStemsActive: propStemActive.value != 0
  readonly property int stemSelected:   isStemsActive ? propStemActive.value : 1 // default value is 1

  readonly property string  stemSelectedName:		 isStemsActive ? propStemSelectedName.value	  : ""
  readonly property real	stemSelectedVolume:	   isStemsActive ? propStemSelectedVolume.value	: 0.0
  readonly property bool	stemSelectedMuted:		isStemsActive ? propStemSelectedMuted.value	 : false
  readonly property real	stemSelectedFilterValue:  isStemsActive ? propStemSelectedFilter.value	: 0.5
  readonly property bool	stemSelectedFilterOn:	 isStemsActive ? propStemSelectedFilterOn.value  : false
  readonly property color   stemSelectedBrightColor:  isStemsActive ? colors.palette(1., propStemSelectedColorId.value) : "grey"
  readonly property color   stemSelectedMidColor:	 isStemsActive ? colors.palette(0.5, propStemSelectedColorId.value) : "black"

  AppProperty { id: propStemSelectedName;	 path: "app.traktor.decks." + deckId + ".stems." + stemSelected + ".name" }
  AppProperty { id: propStemSelectedVolume;   path: "app.traktor.decks." + deckId + ".stems." + stemSelected + ".volume" }
  AppProperty { id: propStemSelectedMuted;	path: "app.traktor.decks." + deckId + ".stems." + stemSelected + ".muted" }
  AppProperty { id: propStemSelectedFilter;   path: "app.traktor.decks." + deckId + ".stems." + stemSelected + ".filter_value" }
  AppProperty { id: propStemSelectedFilterOn; path: "app.traktor.decks." + deckId + ".stems." + stemSelected + ".filter_on" }
  AppProperty { id: propStemSelectedColorId;  path: "app.traktor.decks." + deckId + ".stems." + stemSelected + ".color_id" }

  ///////////////////////////////////////////////////
  /////// Stripe properties /////////////////////////
  ///////////////////////////////////////////////////

  readonly property alias hotcues: hotcuesModel

  HotCues { id: hotcuesModel; deckId: viewModel.deckId }

  Rectangle
  {
	id: displayBackground
	anchors.fill : parent
	color: colors.background
  }

  ColumnLayout
  {
	id: content
	spacing: display.spacing
	
	anchors.left:	   parent.left
	anchors.top:		parent.top
	anchors.topMargin:  display.screenTopMargin
	anchors.leftMargin: display.screenLeftMargin

	// DECK HEADER //
	OriginalWidgets.DeckHeader
	{
	  id: deckHeader

	  title:  deckInfo.titleString
	  height: display.firstRowHeight
	  width:  2*display.infoBoxesWidth + display.spacing
	}

	// FIRST ROW //
	RowLayout {
	  id: firstRow

	  spacing: display.spacing

	  // BPM DISPLAY //
	  Rectangle {
		id: bpmBox
		height: display.firstRowHeight
		width:  display.infoBoxesWidth

		border.width: 2
		border.color: colors.darkGrey
		color: colors.background
		radius: display.boxesRadius

		Text {
		  text: deckInfo.bpmString
		  font.pixelSize: 24
		  font.family: "Roboto"
		  font.weight: Font.Normal
		  color: "white"
		  anchors.fill: parent
		  horizontalAlignment: Text.AlignHCenter
		  verticalAlignment: Text.AlignVCenter
		}
	  }

	  // KEY DISPLAY //
	  Item {
		  id: keyDisplay

		  property var keyColor: deckInfo.hasKey ? colors.musicalKeyColors[deckInfo.resultingKeyIdx] : colors.colorBlack

		  // key box background color
		  property var bgKeyOn: deckInfo.hasKey ? colors.opacity( keyColor, 0.3 ) : colors.opacity( colors.cyan, 0.7 )
		  property var bgKeyOnShift: deckInfo.hasKey ? colors.opacity( keyColor, 0.5 ) : colors.opacity( colors.cyan, 1.0 )
		  property var bgKeyOff: colors.darkGrey
		  property var bgKeyOffShift: colors.grey
		  property var backgroundColor: deckInfo.isKeyLockOn ? ( deckInfo.shift ? bgKeyOnShift   : bgKeyOn  ) :
															   ( deckInfo.shift ? bgKeyOffShift  : bgKeyOff )

		  // key text color
		  property var textColor: deckInfo.isKeyLockOn ? keyColor : colors.colorWhite

		  // key text string
		  readonly property real keyAdjustThreshold: 0.01
		  property bool isKeyAdjusted: deckInfo.isKeyLockOn && Math.abs(deckInfo.keyAdjustVal) > keyAdjustThreshold
		  property string keyLabelStr: deckInfo.hasKey ?
										   // Has Key
										   ( deckInfo.resultingKeyStr  + ( isKeyAdjusted && deckInfo.shift ? "  " + deckInfo.keyAdjustIntText : "" ) ) :
										   // Has No Key
										   ( isKeyAdjusted ? deckInfo.keyAdjustFloatText : "No key" )

		  height: display.firstRowHeight
		  width:  display.infoBoxesWidth

		  Rectangle {
			id: keyBackground
			color: keyDisplay.backgroundColor
			radius: display.boxesRadius
			anchors.fill: parent
		  }

		  Text {
			id: keyText
			text: keyDisplay.keyLabelStr
			font.pixelSize: 24
			font.family: "Roboto"
			color: keyDisplay.textColor
			anchors.fill: parent
			horizontalAlignment: Text.AlignHCenter
			verticalAlignment: Text.AlignVCenter
		  }
	  }


	} // first row


	// SECOND ROW //
	RowLayout {
	  id: secondRow
	  spacing: display.spacing

	  // TIME DISPLAY //
	  Item {
		id: timeBox
		width : display.infoBoxesWidth
		height: display.secondRowHeight

		Rectangle {
		  anchors.fill: parent
		  color:  trackEndBlinkTimer.blink ? colors.red : colors.grey
		  radius: display.boxesRadius
		}

		Text {
		  text: deckInfo.remainingTimeString
		  font.pixelSize: 45
		  font.family: "Roboto"
		  color: trackEndBlinkTimer.blink ? "black": "white"
		  anchors.fill: parent
		  horizontalAlignment: Text.AlignHCenter
		  verticalAlignment: Text.AlignVCenter
		}

		Timer {
		  id: trackEndBlinkTimer
		  property bool  blink: false

		  interval: 500
		  repeat:   true
		  running:  deckInfo.trackEndWarning

		  onTriggered: {
			blink = !blink;
		  }

		  onRunningChanged: {
			blink = running;
		  }
		}
	  }

	  // LOOP DISPLAY //
	  Item {
		id: loopBox
		width : display.infoBoxesWidth
		height: display.secondRowHeight

		Rectangle {
		  anchors.fill: parent
		  color: deckInfo.loopActive ? (deckInfo.shift ? colors.loopActiveDimmedColor : colors.loopActiveColor) : (deckInfo.shift ? colors.darkGrey : colors.grey ) 
		  radius: display.boxesRadius
		  }

		Text {
		  text: deckInfo.loopSizeString
		  font.pixelSize: 45
		  font.family: "Roboto"
		  color: deckInfo.loopActive ? "black" : ( deckInfo.shift ? colors.grey : colors.text )
		  anchors.fill: parent
		  horizontalAlignment: Text.AlignHCenter
		  verticalAlignment: Text.AlignVCenter
		}
	  }

	  

	} // second row

	// STRIPE //
	OriginalWidgets.Stripe
	{
	  deckId:  deckInfo.deckId - 1 // stripe uses zero based indices.
	  visible: deckInfo.isLoaded

	  // we apply -3 on the height and +3 on the topMargin,
	  //because Widgets.Stripes has elements (the cues) that are
	  //not taken into the height of the Stripe. They are 3pix outside
	  //of the stripe.
	  height: display.secondRowHeight
	  width:  2*display.infoBoxesWidth + display.spacing - 6
	  anchors.left: parent.left
	  anchors.leftMargin: 6


	  hotcuesModel: deckInfo.hotcues
	  trackLength:  deckInfo.trackLength
	  elapsedTime:  deckInfo.elapsedTime
	  audioStreamKey: ["PrimaryKey", deckInfo.primaryKey]
	}

  }




}
