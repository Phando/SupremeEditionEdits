import CSI 1.0
import QtQuick 2.12

import '../../../Helpers/KeySync.js' as Key

Text {
  id: header_field
  property int deckId: 1
  property string explicitName // by setting this string, we can suppres the properties below and explicit define a name
  property int textState //this property sets the state of this label (artist, album, bpm, ...)
  property int maxTextWidth

  readonly property string fontForNumber: "Pragmatica"
  readonly property string fontForString: "Pragmatica MediumTT"

  x: 0
  y: 0
  width: (maxTextWidth == 0 || text.paintedWidth > maxTextWidth) ? text.paintedWidth : maxTextWidth
  text: "" //set in state
  font.family: fontForString //set in state

//--------------------------------------------------------------------------------------------------------------------
//  MAPPING FROM TRAKTOR ENUM TO QML-STATE!
//--------------------------------------------------------------------------------------------------------------------

  readonly property variant stateMapping:  ["title", "artist", "release",
                                            "mix", "remixer", "genre",
                                            "trackLength", "comment", "comment2",
                                            "label", "catNo", "bitrate",
                                            "gain", "elapsedTime", "remainingTime",
                                            "beats", "beatsToCue", "sync",
                                            "originalBPM", "BPM", "stableBPM",
                                            "tempo", "stableTempo", "tempoRange",
                                            "originalKey", "resultingKey", "originalKeyText",
                                            "resultingKeyText", "remixBeats", "remixQuantizeIndex",
                                            "captureSource", "mixerFX", "mixerFXshort",
                                            "off"]

//--------------------------------------------------------------------------------------------------------------------
//  STATES FOR THE LABELS IN THE DECK HEADER
//--------------------------------------------------------------------------------------------------------------------

  state: (explicitName == "") ? stateMapping[textState] : "explicitName"

  states: [
    State {
        name: "explicitName";
        PropertyChanges {
            target: header_field;
            text: explicitName
            opacity: !isLoaded.value
        }
    },
//------------------------------------------------------------------------------------------------------------------
    State {
        name: "off";
        PropertyChanges {
            target: header_field;
            text: ""
        }
    },
    State {
        name: "title";
        PropertyChanges {
            target: header_field;
            font.family: fontForString;
            text: title.value
            opacity: isLoaded.value
        }
    },
    State {
        name: "artist";
        PropertyChanges {
            target: header_field;
            font.family: fontForString;
            text: artist.value
            opacity: isLoaded.value
        }
    },
    State {
        name: "release";
        PropertyChanges {
            target: header_field;
            font.family: fontForString;
            text: album.value
            opacity: isLoaded.value
        }
    },
    State {
        name: "genre";
        PropertyChanges {
            target: header_field
            font.family: fontForString
            text: genre.value
            opacity: isLoaded.value
        }
    },
    State {
        name: "comment";
        PropertyChanges {
            target: header_field;
            font.family: fontForString;
            text: comment.value
            opacity: isLoaded.value
        }
    },
    State {
        name: "comment2";
        PropertyChanges {
            target: header_field;
            font.family: fontForString;
            text: comment2.value
            opacity: isLoaded.value
        }
    },
    State {
        name: "label";
        PropertyChanges {
            target: header_field;
            font.family: fontForString;
            text: label.value
            opacity: isLoaded.value
        }
    },
    State {
        name: "mix";
        PropertyChanges {
            target: header_field;
            font.family: fontForString;
            text: mix.value;
            opacity: isLoaded.value
        }
    },
    State {
        name: "remixer";
        PropertyChanges {
            target: header_field;
            font.family: fontForString;
            text: remixer.value;
            opacity: isLoaded.value
        }
    },
    State {
        name: "catNo";
        PropertyChanges {
            target: header_field;
            font.family: fontForString;
            text: catNo.value
            opacity: isLoaded.value
        }
    },
//--------------------------------------------------------------------------------------------------------------------
    State {
        name: "trackLength";
        PropertyChanges {
            target: header_field;
            font.family: fontForNumber;
            text: utils.getTime(trackLength.value)
            opacity: isLoaded.value
        }
    },
    State {
        name: "elapsedTime";
        PropertyChanges {
            target: header_field;
            font.family: fontForNumber;
            text: utils.getTime(elapsedTime.value);
            opacity: isLoaded.value
        }
    },
    State {
        name: "remainingTime";
        PropertyChanges {
            target: header_field;
            font.family: fontForNumber;
            text: utils.getRemainingTime(trackLength.value, elapsedTime.value);
            opacity: isLoaded.value
        }
    },
//--------------------------------------------------------------------------------------------------------------------
    State {
        name: "sync";
        PropertyChanges {
            target: header_field;
            font.family: fontForNumber;
            text: isMaster ? "MASTER" : "SYNC"
            color: ( isMaster || isSyncEnabled.value ) ? colors.cyan : colors.colorGrey72
            opacity: !beatmatchPracticeMode.value
        }
    },
    State {
        name: "originalBPM";
        PropertyChanges {
            target: header_field;
            font.family: fontForNumber;
            text: baseBpm.value.toFixed(2).toString();
            opacity: !beatmatchPracticeMode.value
        }
    },
    State {
        name: "BPM";
        PropertyChanges {
            target: header_field;
            font.family: fontForNumber;
            text: bpm.toFixed(2).toString();
            opacity: !beatmatchPracticeMode.value
        }
    },
    State {
        name: "stableBPM";
        PropertyChanges {
            target: header_field;
            font.family: fontForNumber;
            text: stableBpm.value.toFixed(2).toString();
            opacity: !beatmatchPracticeMode.value
        }
    },
    State {
        name: "tempo";
        PropertyChanges {
            target: header_field;
            font.family: fontForNumber;
            text: ((tempo.value-1 < 0)?"":"+") + ((tempo.value-1)*100).toFixed(1).toString() + "%"
            color: utils.colorRangeTempo ((tempo.value - 1)*100)
            opacity: !beatmatchPracticeMode.value
        }
    },
    State {
        name: "stableTempo";
        PropertyChanges {
            target: header_field;
            font.family: fontForNumber;
            text: (((stableTempo.value - 1) < 0) ? "" : "+") + ((stableTempo.value - 1) * 100).toFixed(1).toString() + "%"
            color: utils.colorRangeTempo((stableTempo.value - 1)*100)
            opacity: !beatmatchPracticeMode.value
        }
    },
    State {
        name: "gain";
        PropertyChanges {
            target: header_field;
            font.family: fontForNumber;
            text: utils.convertToDb(trackGain.value).toFixed(1).toString() + "dB";
            opacity: isLoaded.value
        }
    },
//--------------------------------------------------------------------------------------------------------------------
    State {
        name: "originalKey";
        PropertyChanges {
            target: header_field;
            font.family: fontForNumber;
            text: displayCamelotKey.value ? Key.toCamelot(key.value) : key.value
            color: colors.musicalKeyColors[keyIndex.value]
            opacity: isLoaded.value
        }
    },
    State {
        name: "resultingKey";
        PropertyChanges {
            target: header_field;
            font.family: fontForNumber;
            text: displayCamelotKey.value ? Key.toCamelot(value.toString()) : resultingKey.value
            color: colors.musicalKeyColors[resultingKeyIndex.value]
            opacity: isLoaded.value
        }
    },
    State {
        name: "originalKeyText";
        PropertyChanges {
            target: header_field;
            font.family: fontForNumber;
            text: displayCamelotKey.value ? Key.toCamelot(keyText.value) : keyText.value
            color: colors.musicalKeyColors[Key.getKeyId(keyText.value)]
            opacity: isLoaded.value
        }
    },
    State {
        name: "resultingKeyText";
        PropertyChanges {
            target: header_field;
            font.family: fontForNumber;
            text: displayCamelotKey.value ? Key.indexToCamelot(key.getKeyTextIndex(key.value, keyAdjust.value)) : keyText.value
            color: colors.musicalKeyColors[Key.getKeyId(text)]
            opacity: isLoaded.value
        }
    },
    State {
        name: "tempoRange";
        PropertyChanges {
            target: header_field;
            font.family: fontForNumber;
            text: (parseInt(0.5 + tempoRange.value*100)).toString() + "%"; //+0.5 to round it
        }
    },
//--------------------------------------------------------------------------------------------------------------------
    State {
        name: "beats";
        PropertyChanges {
            target: header_field;
            font.family: fontForNumber;
            text: utils.beatCounterString(deckId, 2)
            opacity: !beatmatchPracticeMode.value && isLoaded.value
        }
    },
    State {
        name: "beatsToCue";
        PropertyChanges {
            target: header_field;
            font.family: fontForNumber;
            text: utils.beatCounterString(deckId, 3)
            opacity: !beatmatchPracticeMode.value && isLoaded.value
        }
    },
    State {
        name: "bitrate";
        PropertyChanges {
            target: header_field;
            font.family: fontForNumber;
            text: parseInt(bitrate.value / 1000).toString();
            opacity: isLoaded.value
        }
    },
//--------------------------------------------------------------------------------------------------------------------
    State {
        name: "remixBeats";
        PropertyChanges {
            target: header_field;
            font.family: fontForNumber;
            text: utils.beatCounterString(deckId, 2)
            opacity: !beatmatchPracticeMode.value
        }
    },
    State {
        name: "remixQuantizeIndex";
        PropertyChanges {
            target: header_field;
            font.family: fontForNumber;
            text: remixQuantizeIndex.description;
            color: remixQuantize.value ? "white" : colors.colorGrey72
        }
    },
    State {
        name: "captureSource";
        PropertyChanges {
            target: header_field;
            font.family: fontForNumber;
            text: remixCaptureSource.description;
            //color: remixCaptureSource.description == "Loop Rec" ? colors.green : (remixCaptureSource.value < 2 ? colors.colorWhite : colors.brightBlue)
        }
    },
//--------------------------------------------------------------------------------------------------------------------
    State {
        name: "mixerFX";
        PropertyChanges {
            target: header_field;
            font.family: fontForString;
            text: mixerFXNames[mixerFX.value];
            color: mixerFXOn.value ? colors.mixerFXColors[mixerFX.value] : colors.colorGrey72
        }
    },
    State {
        name: "mixerFXshort";
        PropertyChanges {
            target: header_field;
            font.family: fontForString;
            text: mixerFXLabels[mixerFX.value];
            color: mixerFXOn.value ? colors.mixerFXColors[mixerFX.value] : colors.colorGrey72
        }
    }
  ]
}
