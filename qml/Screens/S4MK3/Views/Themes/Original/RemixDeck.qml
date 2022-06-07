import CSI 1.0
import QtQuick 2.12
import QtQuick.Layouts 1.12

import './ViewModels'
import './Widgets' as OriginalWidgets
import '../../Widgets' as Widgets

//----------------------------------------------------------------------------------------------------------------------
//  Remix Deck View - UI of the screen for remix decks
//----------------------------------------------------------------------------------------------------------------------


Item {
  id: display

  property int deckId: 1
  property string deckSettingsPath: settingsPath + "." + deckId
  property string deckPropertiesPath: propertiesPath + "." + deckId
  property string remixDeckPropertyPath
  property string deckSize

  Colors {id: colors}
  Dimensions {id: dimensions}

  ViewModels.DeckInfo {
	id: deckInfoModel
	deckId: deckscreen.deckId
  }
  
  // MODEL PROPERTIES //
  property var deckInfo: ({})

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

  // LAYOUT + DESIGN //
  property color timeColor  : colors.text

  property real infoBoxesWidth:   dimensions.infoBoxesWidth
  property real firstRowHeight:   dimensions.firstRowHeight
  property real secondRowHeight:  dimensions.secondRowHeight
  property real remixCellWidth:   dimensions.thirdRowHeight
  property real screenTopMargin:  dimensions.screenTopMargin
  property real screenLeftMargin: dimensions.screenLeftMargin

  property real boxesRadius:  5
  property real cellSpacing:  dimensions.spacing
  property real textMargin:   13

  property variant lightGray: colors.grey
  property variant darkGray:  colors.darkGrey

  Rectangle {
	  id		   : background
	  color		: colors.background
	  anchors.fill : parent
  }


  ColumnLayout 
  {
	spacing: display.cellSpacing
	anchors.top: parent.top
	anchors.topMargin: display.screenTopMargin
	anchors.left: parent.left
	anchors.leftMargin: display.screenLeftMargin

	// DECK HEADER //
	OriginalWidgets.DeckHeader
	{
	  id: deckHeader

	  height: display.firstRowHeight
	  width:  2*display.infoBoxesWidth + display.cellSpacing
	  title:  deckInfo.titleString 

	  backgroundColor: deckInfo.isSequencerRecOn ? colors.red : colors.background
	}

	RowLayout
	{
	  spacing: display.cellSpacing

	  // BPM DISPLAY //
	  Rectangle {
		id: bpmBox

		height: display.firstRowHeight
		width:  display.infoBoxesWidth

		border.width: 1
		border.color: display.darkGray
		color: "black"
		radius: display.boxesRadius

		Text {
		  text: deckInfo.bpmString
		  font.pixelSize: 24
		  font.family: "Roboto"
		  font.weight: Font.Normal
		  color: "white"
		  anchors.fill: parent
		  anchors.leftMargin: display.textMargin
		  anchors.rightMargin: display.textMargin
		  horizontalAlignment: Text.AlignHCenter
		  verticalAlignment: Text.AlignVCenter
		}
	  }

	  // Quant*** DISPLAY //
	  Rectangle {
		id: quant
		
		height: display.firstRowHeight
		width:  display.infoBoxesWidth

		color: deckInfo.shift ? display.lightGray : display.darkGray
		radius: display.boxesRadius

		Text {
		  id: quantText
		  text: deckInfo.rmxQuantizeIndex
		  font.pixelSize: 24
		  font.family: "Roboto"
		  font.weight: Font.Normal
		  color: colors.colorWhite
		  anchors.verticalCenter: parent.verticalCenter
		  anchors.horizontalCenter: parent.horizontalCenter
		  
		  horizontalAlignment: Text.AlignHCenter
		  verticalAlignment: Text.AlignVCenter
		}

		//quantization of/off display (circle)
		Text {
		  visible: deckInfo.rmxQuantizeOn
		  text: "\u25CF"
		  font.pixelSize: 24
		  font.family: "Roboto"
		  font.weight: Font.Normal
		  color: colors.cyan
		  anchors.left: quantText.right
		  anchors.leftMargin: 3
		  anchors.verticalCenter: parent.verticalCenter
		}
	  }
	}

	RowLayout
	{
	  spacing: display.cellSpacing
	  
	  // BEAT POSITION DISPLAY //
	  Item {
		id: beatPosition
		width : display.infoBoxesWidth
		height: display.secondRowHeight

		Rectangle {
		  anchors.fill: parent
		  color:  colors.grayBackground
		  radius: display.boxesRadius
		}

		Text {
		  text: deckInfo.beatPositionString
		  font.pixelSize: 45
		  font.family: "Roboto"
		  color: "white"
		  anchors.fill: parent
		  anchors.leftMargin: display.textMargin
		  anchors.rightMargin: display.textMargin
		  fontSizeMode: Text.HorizontalFit
		  horizontalAlignment: Text.AlignHCenter
		  verticalAlignment: Text.AlignVCenter
		}
	  }

	  // LOOP DISPLAY //
	  Item {
		id: loopBox
		width : display.infoBoxesWidth
		height: display.secondRowHeight

		Rectangle {
		  anchors.fill: parent
		  color: deckInfo.loopActive ? (deckInfo.shift ? colors.loopActiveDimmedColor : colors.loopActiveColor ) : (deckInfo.shift ? display.darkGray : display.lightGray)
		  radius: display.boxesRadius
		}

		Text {
		  text: deckInfo.loopSizeString
		  font.pixelSize: 45
		  font.family: "Roboto"
		  color: deckInfo.loopActive ? "black" : colors.text
		  anchors.fill: parent
		  anchors.leftMargin:   display.textMargin
		  anchors.rightMargin: display.textMargin
		  horizontalAlignment: Text.AlignHCenter
		  verticalAlignment: Text.AlignVCenter
		}
	  }
	}

	// LOOP DISPLAY //
	Row
	{
	  spacing: display.cellSpacing

	  Repeater {
		model: deckInfo.slots
		OriginalWidgets.RemixCell
		{
			//store activeCell locally so that we don't have to
			//fetch it every time
			property var activeCell: modelData.getActiveCell();

			cellColor				   : activeCell.color
			isLoop					  : activeCell.isLooped
			cellRadius				  : display.boxesRadius
			cellSize					: display.remixCellWidth
			withIcon					: !activeCell.isEmpty
		}
	  }
	}

  }

  OriginalWidgets.RemixOverlay {
	id: remixOverlay
	deckInfo: display.deckInfo
	anchors.top:  parent.top
	anchors.left: parent.left
	slotId:  deckInfo.remixActiveSlot > 0 ? deckInfo.remixActiveSlot : 1
	visible: deckInfo.remixActiveSlot > 0 && !deckInfo.remixSampleBrowsing
  }

  OriginalWidgets.RemixBrowsingOverlay{
	id: remixBrowsingOverlay
	deckInfo: display.deckInfo
	anchors.top: parent.top
	anchors.left: parent.left
	slotId: deckInfo.remixActiveSlot > 0 ? deckInfo.remixActiveSlot : 1
	visible: deckInfo.remixActiveSlot > 0 && deckInfo.remixSampleBrowsing
  }
}
