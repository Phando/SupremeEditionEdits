import CSI 1.0
import QtQuick 2.12

import '../../../Defines'
import '../../../../Helpers/KeySync.js' as Key

Text {
  id: header_text
  property int deckId: 1
  property string explicitName // by setting this string, we can suppres the properties below and explicit define a name
  property int textState //this property sets the state of this label (artist, album, bpm, ...)
  property int maxTextWidth
  property double syncLabelOpacity

  readonly property string fontForNumber: "Pragmatica"
  readonly property string fontForString: "Pragmatica MediumTT"

  x: 0
  y: 0
  width: (maxTextWidth == 0 || text.paintedWidth > maxTextWidth) ? text.paintedWidth : maxTextWidth
  text: "" //set in state
  font.family: fontForString

  //Deck Properties
  AppProperty { id: primaryKey;	 	path: "app.traktor.decks." + deckId + ".track.content.entry_key" } //this refers to the "number of the track in the collection"
  AppProperty { id: isLoaded; 			path: "app.traktor.decks." + deckId + ".is_loaded" }
  AppProperty { id: masterId;   		path: "app.traktor.masterclock.source_id" }
  AppProperty { id: isSyncEnabled; 		path: "app.traktor.decks." + deckId + ".sync.enabled" }
  AppProperty { id: deckType;	   	path: "app.traktor.decks." + deckId + ".type" }
  AppProperty { id: mixerTotalGain;   	path: "app.traktor.decks." + deckId + ".content.total_gain" }

  AppProperty { id: title;		  	path: "app.traktor.decks." + deckId + ".content.title" }
  AppProperty { id: artist;				path: "app.traktor.decks." + deckId + ".content.artist" }
  AppProperty { id: album;		  	path: "app.traktor.decks." + deckId + ".content.album" }
  AppProperty { id: genre;		  	path: "app.traktor.decks." + deckId + ".content.genre" }
  AppProperty { id: comment;			path: "app.traktor.decks." + deckId + ".content.comment" }
  AppProperty { id: comment2;	   	path: "app.traktor.decks." + deckId + ".content.comment2" }
  AppProperty { id: label;		  	path: "app.traktor.decks." + deckId + ".content.label" }
  AppProperty { id: mix;				path: "app.traktor.decks." + deckId + ".content.mix" }
  AppProperty { id: remixer;			path: "app.traktor.decks." + deckId + ".content.remixer" }
  AppProperty { id: catNo;		  	path: "app.traktor.decks." + deckId + ".content.catalog_number" }
  AppProperty { id: gridOffset; 		path: "app.traktor.decks." + deckId + ".content.grid_offset" }
  AppProperty { id: bitrate;			path: "app.traktor.decks." + deckId + ".content.bitrate" }

  AppProperty { id: trackLength;		path: "app.traktor.decks." + deckId + ".track.content.track_length" }
  AppProperty { id: elapsedTime;		path: "app.traktor.decks." + deckId + ".track.player.elapsed_time" }
  AppProperty { id: nextCuePoint;   	path: "app.traktor.decks." + deckId + ".track.player.next_cue_point" }

  AppProperty { id: keyText;			path: "app.traktor.decks." + deckId + ".content.legacy_key" }
  AppProperty { id: musicalKey;	 	path: "app.traktor.decks." + deckId + ".content.musical_key" }
  AppProperty { id: keyAdjust;		  path: "app.traktor.decks." + deckId + ".track.key.adjust" }
  AppProperty { id: keyDisplay;	 	path: "app.traktor.decks." + deckId + ".track.key.resulting.quantized" }
  AppProperty { id: keyDisplayPrecise;  path: "app.traktor.decks." + deckId + ".track.key.resulting.precise" }

  AppProperty { id: pitchRange;	 	path: "app.traktor.decks." + deckId + ".tempo.range_value" }
  AppProperty { id: tempo;				path: "app.traktor.decks." + deckId + ".tempo.tempo_for_display" }
  AppProperty { id: tempoAbsolute;		path: "app.traktor.decks." + deckId + ".tempo.absolute" }
  AppProperty { id: mixerStableTempo;	path: "app.traktor.decks." + deckId + ".tempo.true_tempo" }
  AppProperty { id: trackBPM;			path: "app.traktor.decks." + deckId + ".content.bpm" }
  AppProperty { id: mixerBpm;	   	path: "app.traktor.decks." + deckId + ".tempo.base_bpm" }
  AppProperty { id: mixerStableBpm; 	path: "app.traktor.decks." + deckId + ".tempo.true_bpm" }

  //Special Remix Deck Properties
  AppProperty { id: remixCaptureSource; path: "app.traktor.decks." + deckId + ".capture_source" }
  AppProperty { id: remixBeatPos;	  	path: "app.traktor.decks." + deckId + ".remix.current_beat_pos" }
  AppProperty { id: remixQuantizeIndex;	path: "app.traktor.decks." + deckId + ".remix.quant_index" }
  AppProperty { id: remixQuantize;		path: "app.traktor.decks." + deckId + ".remix.quant" }

  AppProperty { id: mixerFXSelect;		path: "app.traktor.mixer.channels." + deckId + ".fx.select" }
  AppProperty { id: mixerFXOn;	 		path: "app.traktor.mixer.channels." + deckId + ".fx.on" }

  readonly property bool isMaster: (masterId.value+1) == deckId
  readonly property double cuePos: nextCuePoint.value >= 0 ? nextCuePoint.value : trackLength.value*1000

  MappingProperty { id: displayCamelotKey; path: "mapping.settings.displayCamelotKey" }

  MappingProperty { id: mixerFX1; path: "mapping.settings.mixerFX1" }
  MappingProperty { id: mixerFX2; path: "mapping.settings.mixerFX2" }
  MappingProperty { id: mixerFX3; path: "mapping.settings.mixerFX3" }
  MappingProperty { id: mixerFX4; path: "mapping.settings.mixerFX4" }

  MappingProperty { id: beatmatchPracticeMode; path: "mapping.state.beatmatchPracticeMode" }

  readonly property variant mxrFXLabels: ["FLTR", "RVRB", "DLDL", "NOISE", "TIMG", "FLNG", "BRPL", "DTDL", "CRSH"]
  readonly property variant mxrFXNames: ["Filter", "Reverb", "Dual Delay", "Noise", "Time Gater", "Flanger", "Barber Pole", "Dotted Delay", "Crush"]
  property variant mixerFXNames: [mxrFXNames[0], mxrFXNames[mixerFX1.value], mxrFXNames[mixerFX2.value], mxrFXNames[mixerFX3.value], mxrFXNames[mixerFX4.value] ] // do not change FLTR
  property variant mixerFXLabels: [mxrFXLabels[0], mxrFXLabels[mixerFX1.value], mxrFXLabels[mixerFX2.value], mxrFXLabels[mixerFX3.value], mxrFXLabels[mixerFX4.value] ] // do not change FLTR

//--------------------------------------------------------------------------------------------------------------------
//  MAPPING FROM TRAKTOR ENUM TO QML-STATE!
//--------------------------------------------------------------------------------------------------------------------

  readonly property variant stateMapping:  ["title", "artist", "release", "mix", "remixer", "genre", "trackLength",
											"comment", "comment2", "label", "catNo", "bitrate", "gain",
											"elapsedTime", "remainingTime", "beats", "beatsToCue", "sync",
											"originalBpm", "bpm", "bpmStable", "tempo", "tempoStable", "pitchRange",
											"originalKey", "resultingKey", "originalKeyText", "resultingKeyText",
											"remixBeats", "remixQuantizeIndex", "captureSource", "mixerFX", "mixerFXshort", "off"]

//--------------------------------------------------------------------------------------------------------------------
//  STATES FOR THE LABELS IN THE DECK HEADER
//--------------------------------------------------------------------------------------------------------------------

  state: (explicitName == "") ? stateMapping[textState] : "explicitName"

  states: [
	State {
		name: "explicitName";
		PropertyChanges {
			target: header_text;
			text: explicitName
			opacity: !isLoaded.value
		}
	},
//------------------------------------------------------------------------------------------------------------------
	State {
		name: "off";
		PropertyChanges {
			target: header_text;
			text: ""
		}
	},
	State {
		name: "title";
		PropertyChanges {
			target: header_text;
			font.family: fontForString;
			text: title.value
			opacity: isLoaded.value
		}
	},
	State {
		name: "artist";
		PropertyChanges {
			target: header_text;
			font.family: fontForString;
			text: artist.value
			opacity: isLoaded.value
		}
	},
	State {
		name: "release";
		PropertyChanges {
			target: header_text;
			font.family: fontForString;
			text: album.value
			opacity: isLoaded.value
		}
	},
	State {
		name: "genre";
		PropertyChanges {
			target: header_text
			font.family: fontForString
			text: genre.value
			opacity: isLoaded.value
		}
	},
	State {
		name: "comment";
		PropertyChanges {
			target: header_text;
			font.family: fontForString;
			text: comment.value
			opacity: isLoaded.value
		}
	},
	State {
		name: "comment2";
		PropertyChanges {
			target: header_text;
			font.family: fontForString;
			text: comment2.value
			opacity: isLoaded.value
		}
	},
	State {
		name: "label";
		PropertyChanges {
			target: header_text;
			font.family: fontForString;
			text: label.value
			opacity: isLoaded.value
		}
	},
	State {
		name: "mix";
		PropertyChanges {
			target: header_text;
			font.family: fontForString;
			text: mix.value;
			opacity: isLoaded.value
		}
	},
	State {
		name: "remixer";
		PropertyChanges {
			target: header_text;
			font.family: fontForString;
			text: remixer.value;
			opacity: isLoaded.value
		}
	},
	State {
		name: "catNo";
		PropertyChanges {
			target: header_text;
			font.family: fontForString;
			text: catNo.value
			opacity: isLoaded.value
		}
	},
//--------------------------------------------------------------------------------------------------------------------
	State {
		name: "trackLength";
		PropertyChanges {
			target: header_text;
			font.family: fontForNumber;
			text: utils.getTime(trackLength.value)
			opacity: isLoaded.value
		}
	},
	State {
		name: "elapsedTime";
		PropertyChanges {
			target: header_text;
			font.family: fontForNumber;
			text: utils.getTime(elapsedTime.value);
			opacity: isLoaded.value
		}
	},
	State {
		name: "remainingTime";
		PropertyChanges {
			target: header_text;
			font.family: fontForNumber;
			text: utils.getRemainingTime(trackLength.value, elapsedTime.value);
			opacity: isLoaded.value
		}
	},
//--------------------------------------------------------------------------------------------------------------------
	State {
		name: "sync";
		PropertyChanges {
			target: header_text;
			font.family: fontForNumber;
			text: isMaster ? "MASTER" : "SYNC"
			color: ( isMaster || isSyncEnabled.value ) ? colors.cyan : colors.colorGrey72
			opacity: !beatmatchPracticeMode.value
		}
	},
	State {
		name: "originalBpm";
		PropertyChanges {
			target: header_text;
			font.family: fontForNumber;
			text: trackBPM.value.toFixed(2).toString();
			opacity: !beatmatchPracticeMode.value && isLoaded.value
		}
	},
	State {
		name: "bpm";
		PropertyChanges {
			target: header_text;
			font.family: fontForNumber;
			text: mixerBpm.value.toFixed(2).toString();
			opacity: !beatmatchPracticeMode.value
		}
	},
	State {
		name: "bpmStable";
		PropertyChanges {
			target: header_text;
			font.family: fontForNumber;
			text: mixerStableBpm.value.toFixed(2).toString();
			opacity: !beatmatchPracticeMode.value
		}
	},
	State {
		name: "tempo";
		PropertyChanges {
			target: header_text;
			font.family: fontForNumber;
			text: ((tempo.value-1 < 0)?"":"+") + ((tempo.value-1)*100).toFixed(1).toString() + "%";
			color: utils.colorRangeTempo ((tempo.value - 1)*100)
			opacity: !beatmatchPracticeMode.value
		}
	},
	State {
		name: "tempoStable";
		PropertyChanges {
			target: header_text;
			font.family: fontForNumber;
			text: (((mixerStableTempo.value - 1) < 0) ? "" : "+") + ((mixerStableTempo.value - 1) * 100).toFixed(1).toString() + "%"
			color: utils.colorRangeTempo((mixerStableTempo.value - 1)*100)
			opacity: !beatmatchPracticeMode.value
		}
	},
	State {
		name: "gain";
		PropertyChanges {
			target: header_text;
			font.family: fontForNumber;
			text: utils.convertToDb(mixerTotalGain.value).toFixed(1).toString() + "dB";
			opacity: isLoaded.value
		}
	},
//--------------------------------------------------------------------------------------------------------------------
	State {
		name: "originalKey";
		PropertyChanges {
			target: header_text;
			font.family: fontForNumber;
			text: displayCamelotKey.value ? Key.toCamelot(musicalKey.value.toString()) : musicalKey.value.toString()
			color: colors.musicalKeyColors[utils.returnKeyIndex(musicalKey.value)]
			opacity: isLoaded.value
		}
	},
	State {
		name: "resultingKey";
		PropertyChanges {
			target: header_text;
			font.family: fontForNumber;
			text: displayCamelotKey.value ? Key.toCamelot(keyDisplay.value.toString()) : keyDisplay.value.toString()
			color: colors.musicalKeyColors[utils.returnKeyIndex(deckKeyDisplay.value)]
			opacity: isLoaded.value
		}
	},
	State {
		name: "originalKeyText";
		PropertyChanges {
			target: header_text;
			font.family: fontForNumber;
			text: displayCamelotKey.value ? Key.toCamelot(keyText.value.toString()) : keyText.value.toString()
			color: colors.musicalKeyColors[utils.returnKeyIndex(keyText.value.toString())]
			opacity: isLoaded.value
		}
	},
	State {
		name: "resultingKeyText";
		PropertyChanges {
			target: header_text;
			font.family: fontForNumber;
			text: displayCamelotKey.value ? Key.indexToCamelot(key.getKeyTextIndex(musicalKey.value, keyAdjust.value)) : keyText.value.toString()
			color: colors.musicalKeyColors[utils.returnKeyIndex(keyText.value.toString())]
			opacity: isLoaded.value
		}
	},
	State {
		name: "pitchRange";
		PropertyChanges {
			target: header_text;
			font.family: fontForNumber;
			text: (parseInt(0.5 + pitchRange.value*100)).toString() + "%"; //+0.5 to round it
		}
	},
//--------------------------------------------------------------------------------------------------------------------
	State {
		name: "beats";
		PropertyChanges {
			target: header_text;
			font.family: fontForNumber;
			text: utils.beatCounterString(deckId, 2)
			opacity: !beatmatchPracticeMode.value && isLoaded.value
		}
	},
	State {
		name: "beatsToCue";
		PropertyChanges {
			target: header_text;
			font.family: fontForNumber;
			text: utils.beatCounterString(deckId, 3)
			opacity: !beatmatchPracticeMode.value && isLoaded.value
		}
	},
	State {
		name: "bitrate";
		PropertyChanges {
			target: header_text;
			font.family: fontForNumber;
			text: parseInt(bitrate.value / 1000).toString();
			opacity: isLoaded.value
		}
	},
//--------------------------------------------------------------------------------------------------------------------
	State {
		name: "remixBeats";
		PropertyChanges {
			target: header_text;
			font.family: fontForNumber;
			text: utils.beatCounterString(deckId, 2)
			opacity: !beatmatchPracticeMode.value
		}
	},
	State {
		name: "remixQuantizeIndex";
		PropertyChanges {
			target: header_text;
			font.family: fontForNumber;
			text: remixQuantizeIndex.description;
			color: remixQuantize.value ? "white" : colors.colorGrey72
		}
	},
	State {
		name: "captureSource";
		PropertyChanges {
			target: header_text;
			font.family: fontForNumber;
			text: remixCaptureSource.description;
			//color: remixCaptureSource.description == "Loop Rec" ? colors.green : (remixCaptureSource.value < 2 ? colors.colorWhite : colors.brightBlue)
		}
	},
//--------------------------------------------------------------------------------------------------------------------
	State {
		name: "mixerFX";
		PropertyChanges {
			target: header_text;
			font.family: fontForString;
			text: mixerFXNames[mixerFXSelect.value];
			color: mixerFXOn.value ? colors.mixerFXColors[mixerFXSelect.value] : colors.colorGrey72
		}
	},
	State {
		name: "mixerFXshort";
		PropertyChanges {
			target: header_text;
			font.family: fontForString;
			text: mixerFXLabels[mixerFXSelect.value];
			color: mixerFXOn.value ? colors.mixerFXColors[mixerFXSelect.value] : colors.colorGrey72
		}
	}
  ]
}
