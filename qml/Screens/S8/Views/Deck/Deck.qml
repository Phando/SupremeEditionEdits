import CSI 1.0
import QtQuick 2.12

import '../../../../Defines'
import '../../../../Helpers/KeyHelpers.js' as Key
import '../../../../Helpers/KeySync.js' as KeySync

import '../Themes/Traktor' as Traktor
import '../Themes/Supreme' as Supreme
import '../Themes/SupremePro' as SupremePro
import '../Themes/Prime' as Prime
import '../Themes/CDJ2000NXS2' as CDJ2000NXS2
import '../Themes/CDJ3000' as CDJ3000

Item {
    id: deck
    property int deckId: 1
    property string deckSize //set in state in Side.qml

    property alias deckType: deckType.value

//------------------------------------------------------------------------------------------------------------------
// APP PROPERTIES
//------------------------------------------------------------------------------------------------------------------

    //State properties
    AppProperty { id: directThru; path: "app.traktor.decks." + deckId + ".direct_thru" }
    AppProperty { path: "app.traktor.decks." + deckId + ".is_loaded_signal" }
    AppProperty { id: deckType; path: "app.traktor.decks." + deckId + ".type" }
    AppProperty { id: isLoaded; path: "app.traktor.decks." + deckId + ".is_loaded" }
    AppProperty { id: volume; path: "app.traktor.mixer.channels." + deckId + ".volume" }

    //Transport
    AppProperty { id: isRunning; path: "app.traktor.decks." + deckId + ".running" }
    AppProperty { id: isPlaying; path: "app.traktor.decks." + deckId + ".play" }
    AppProperty { id: isCueing; path: "app.traktor.decks." + deckId + ".cue" }
    AppProperty { id: isCuePlaying; path: "app.traktor.decks." + deckId + ".cup" }
    AppProperty { id: cuePosition; path: "app.traktor.decks." + deckId + ".track.cue.active.start_pos" }
    AppProperty { id: playheadPosition; path: "app.traktor.decks."  + deckId + ".track.player.playhead_position" }
    readonly property real timeTolerance: 0.001 // seconds
    property bool activeCueWithPlayhead: Math.abs(cuePosition.value - playheadPosition.value) < timeTolerance

    //Loop
    AppProperty { id: loopActive; path: "app.traktor.decks."+ deckId + ".loop.active" }
    AppProperty { id: isInActiveLoop; path: "app.traktor.decks."+ deckId + ".loop.is_in_active_loop" }
    AppProperty { id: loopSize; path: "app.traktor.decks." + deckId + ".loop.size" }

    //Move
    AppProperty { id: move; path: "app.traktor.decks." + deckId + ".move" }
    AppProperty { id: moveMode; path: "app.traktor.decks." + deckId + ".move.mode" }
    AppProperty { id: moveSize; path: "app.traktor.decks." + deckId + ".move.size" }

    //Flux
    AppProperty { id: fluxEnabled; path: "app.traktor.decks." + deckId + ".flux.enabled" }
    AppProperty { id: fluxState; path: "app.traktor.decks." + deckId + ".flux.state" }
    AppProperty { id: fluxPosition; path: "app.traktor.decks."  + deckId + ".track.player.flux_position" }
    property bool fluxing: fluxState.value == 2

    //Tempo & Sync
    AppProperty { id: tempobend; path: "app.traktor.decks." + deckId + ".tempobend.stepless" }

    AppProperty { id: stableTempo; path: "app.traktor.decks." + deckId + ".tempo.true_tempo" }
    AppProperty { id: tempo; path: "app.traktor.decks." + deckId + ".tempo.tempo_for_display" }
    AppProperty { id: tempoAbsolute; path: "app.traktor.decks." + deckId + ".tempo.absolute" }
    AppProperty { id: tempoRange; path: "app.traktor.decks." + deckId + ".tempo.range_value" }
    AppProperty { id: tempoPhase; path: "app.traktor.decks." + deckId + ".tempo.phase" }
    readonly property double phase: (tempoPhase.value*2).toFixed(4)
    readonly property real tempoOffset: (stableTempo.value - 1)*100;

    AppProperty { id: isSyncEnabled; path: "app.traktor.decks." + deckId + ".sync.enabled" }
    readonly property bool syncInPhase: phase >= -0.0315 && phase <= 0.0315
    readonly property bool syncInRange: Math.abs(stableTempo.value-1).toFixed(4) <= tempoRange.value.toFixed(4)

    //BPM
    AppProperty { id: trackBpm; path: "app.traktor.decks." + deckId + ".content.bpm" } //INFO: Same as baseBPM
    AppProperty { id: baseBpm; path: "app.traktor.decks." + deckId + ".tempo.base_bpm" }
    AppProperty { id: stableBpm; path: "app.traktor.decks." + deckId + ".tempo.true_bpm" }
    property double bpm: (baseBpm.value*tempo.value).toFixed(3)

    //Key
    AppProperty { id: key; path: "app.traktor.decks." + deckId + ".content.musical_key" }
    AppProperty { id: keyText; path: "app.traktor.decks." + deckId + ".content.legacy_key" }
    AppProperty { id: keyIndex; path: "app.traktor.decks." + deckId + ".content.key_index" }
    AppProperty { id: keyLock; path: "app.traktor.decks." + deckId + ".track.key.lock_enabled" }
    AppProperty { id: keyAdjust; path: "app.traktor.decks." + deckId + ".track.key.adjust" }
    AppProperty { id: resultingKey; path: "app.traktor.decks." + deckId + ".track.key.resulting.quantized" }
    AppProperty { id: resultingKeyPrecise; path: "app.traktor.decks." + deckId + ".track.key.resulting.precise" }
    AppProperty { id: resultingKeyIndex; path: "app.traktor.decks." + deckId + ".track.key.final_id" }
    property string originalKey: useKeyText.value ? keyText.value : (displayCamelotKey.value ? Key.keyIdToCamelot(keyIndex.value) : key.value)
    property string resultingKeyText: displayCamelotKey.value ? Key.keyIdToCamelot(keyTextIndex) : useKeyText.value ? resultingKey.value : resultingKey.value //TO-DO: if use key text is enabled
    property int keyTextIndex: useKeyText.value ? Key.getKeyTextId(keyText.value, keyAdjust.value) : resultingKeyIndex.value
    property double keyTextOffset: useKeyText.value ? KeySync.sync(resultingKeyIndex.value, Key.getKeyTextId(keyText.value, keyAdjust.value), false) : 0

    property bool isKeySynchronized: KeySync.isSynchronized(keyTextIndex, masterKeyTextIndex, fuzzyKeySync.value)
    property bool isKeyAdjusted: keyLock.value && (Math.abs(keyAdjust.value*12)).toFixed(2) > 0.05
    property bool isKeyInRange: (Math.abs(((keyAdjust.value*12).toFixed(2) - (keyAdjust.value*12).toFixed(0)))).toFixed(2) <= 0.05 || (Math.abs(((keyAdjust.value*12).toFixed(2) - (keyAdjust.value*12).toFixed(0)))).toFixed(2) >= 0.95
    property color keyColor: isLoaded.value && keyTextIndex != -1 && isKeyInRange && displayResultingKey.value ? colors.musicalKeyColors[keyTextIndex] : colors.colorBlack

    //Track metadata
    AppProperty { id: primaryKey; path: "app.traktor.decks." + deckId + ".track.content.entry_key" } //this refers to the "number of the track in the collection"
    AppProperty { id: title; path: "app.traktor.decks." + deckId + ".content.title" }
    AppProperty { id: artist; path: "app.traktor.decks." + deckId + ".content.artist" }
    AppProperty { id: mix; path: "app.traktor.decks." + deckId + ".content.mix" }
    AppProperty { id: remixer; path: "app.traktor.decks." + deckId + ".content.remixer" }
    AppProperty { id: album; path: "app.traktor.decks." + deckId + ".content.album" }
    AppProperty { id: albumCoverDirectory; path: "app.traktor.decks." + deckId + ".content.cover_md5" }
    AppProperty { id: genre; path: "app.traktor.decks." + deckId + ".content.genre" }
    AppProperty { id: comment; path: "app.traktor.decks." + deckId + ".content.comment" }
    AppProperty { id: comment2; path: "app.traktor.decks." + deckId + ".content.comment2" }
    AppProperty { id: label; path: "app.traktor.decks." + deckId + ".content.label" }
    AppProperty { id: catNo; path: "app.traktor.decks." + deckId + ".content.catalog_number" }
    AppProperty { id: bitrate; path: "app.traktor.decks." + deckId + ".content.bitrate" }
    AppProperty { id: gridOffset; path: "app.traktor.decks." + deckId + ".content.grid_offset" }
    AppProperty { id: trackGain; path: "app.traktor.decks." + deckId + ".content.total_gain" }

    //Freeze Properties
    AppProperty { id: sliceCount; path: "app.traktor.decks." + deckId + ".freeze.slice_count" }
    AppProperty { id: freezeEnabled; path: "app.traktor.decks." + deckId + ".freeze.enabled" }
    AppProperty { id: freezeStart; path: "app.traktor.decks." + deckId + ".freeze.slice_start_in_sec" }
    AppProperty { id: freezeWidth; path: "app.traktor.decks." + deckId + ".freeze.slice_width_in_sec" }

    //Track Properties
    AppProperty { id: sampleRate; path: "app.traktor.decks."  + deckId + ".track.content.sample_rate" }
    AppProperty { id: trackLength; path: "app.traktor.decks." + deckId + ".track.content.track_length" }
    AppProperty { id: elapsedTime; path: "app.traktor.decks." + deckId + ".track.player.elapsed_time" }
    AppProperty { id: nextCuePoint; path: "app.traktor.decks." + deckId + ".track.player.next_cue_point" }
    //readonly property double nextCuePos: nextCuePoint.value >= 0 ? nextCuePoint.value : trackLength.value*1000

    AppProperty { id: waveformZoom; path: "app.traktor.decks." + deckId + ".track.waveform_zoom" }
    AppProperty { id: gridLock; path: "app.traktor.decks." + deckId + ".track.grid.lock_bpm" }
    AppProperty { id: gridAdjust; path: "app.traktor.decks." + deckId + ".track.gridmarker.move" }
    AppProperty { id: trackEndWarning; path: "app.traktor.decks." + deckId + ".track.track_end_warning" }

    //Remix Properties
    AppProperty { id: remixQuantize; path: "app.traktor.decks." + deckId + ".remix.quant" }
    AppProperty { id: remixQuantizeIndex;	path: "app.traktor.decks." + deckId + ".remix.quant_index" }
    AppProperty { id: remixBeats; path: "app.traktor.decks." + deckId + ".remix.current_beat_pos" }
    AppProperty { id: remixCaptureSource; path: "app.traktor.decks." + deckId + ".capture_source" }
    AppProperty { id: remixPage; path: "app.traktor.decks." + deckId + ".remix.page" }
    AppProperty { id: activeCell_slot1; path: "app.traktor.decks." + deckId + ".remix.players.1.active_cell_row" }
    AppProperty { id: activeCell_slot2; path: "app.traktor.decks." + deckId + ".remix.players.2.active_cell_row" }
    AppProperty { id: activeCell_slot3; path: "app.traktor.decks." + deckId + ".remix.players.3.active_cell_row" }
    AppProperty { id: activeCell_slot4; path: "app.traktor.decks." + deckId + ".remix.players.4.active_cell_row" }

    //Sequencer Properties
    AppProperty { id: sequencerOn; path: "app.traktor.decks." + deckId + ".remix.sequencer.on" }
    AppProperty { id: sequencerRecOn; path: "app.traktor.decks." + deckId + ".remix.sequencer.rec.on" }
    AppProperty { id: selectedCell_slot1; path: "app.traktor.decks." + deckId + ".remix.players.1.sequencer.selected_cell" }
    AppProperty { id: selectedCell_slot2; path: "app.traktor.decks." + deckId + ".remix.players.2.sequencer.selected_cell" }
    AppProperty { id: selectedCell_slot3; path: "app.traktor.decks." + deckId + ".remix.players.3.sequencer.selected_cell" }
    AppProperty { id: selectedCell_slot4; path: "app.traktor.decks." + deckId + ".remix.players.4.sequencer.selected_cell" }

    //Traktor Pro Advanced Panel
    AppProperty { id: advancedPanel; path: "app.traktor.decks." + deckId + ".view.select_advanced_panel" } //0: Hotcues, 1: Loop, 2: Grid

    //FXs
    AppProperty { id: mixerFX; path: "app.traktor.mixer.channels." + deckId + ".fx.select" }
    AppProperty { id: mixerFXOn; path: "app.traktor.mixer.channels." + deckId + ".fx.on" }
    AppProperty { id: fx1Enabled; path: "app.traktor.mixer.channels." + deckId + ".fx.assign.1" }
    AppProperty { id: fx2Enabled; path: "app.traktor.mixer.channels." + deckId + ".fx.assign.2" }
    AppProperty { id: fx3Enabled; path: "app.traktor.mixer.channels." + deckId + ".fx.assign.3" }
    AppProperty { id: fx4Enabled; path: "app.traktor.mixer.channels." + deckId + ".fx.assign.4" }

    //Messages
    AppProperty { id: deckHeaderMessageActive; path: "app.traktor.informer.deckheader_message." + deckId + ".active" }
    AppProperty { id: deckHeaderMessageType; path: "app.traktor.informer.deckheader_message." + deckId + ".type" } //0: None, 1: Warning, 2: Error
    AppProperty { id: deckHeaderMessageMessage; path: "app.traktor.informer.deckheader_message." + deckId + ".long" }
    AppProperty { id: deckHeaderMessageShortMessage; path: "app.traktor.informer.deckheader_message." + deckId + ".short" }
    property bool warningMessage: deckHeaderMessageType.value == Message.warning
    property bool errorMessage: deckHeaderMessageType.value == Message.error

//------------------------------------------------------------------------------------------------------------------
// MAPPING PROPERTIES
//------------------------------------------------------------------------------------------------------------------

    MappingProperty { id: padsMode; path: deckPropertiesPath + ".pads_mode" }
    MappingProperty { id: performanceEncoderControls; path: deckPropertiesPath + ".performanceEncoderControls" } //property necessary for the S5... if not present on the S8, error due to being present in the ScreenButtons shared module.
    MappingProperty { id: showLoopSize; path: deckPropertiesPath + ".show_loop_size" }

    //Hold button State
    MappingProperty { id: holdCapture; path: propertiesPath + ".holdCapture" }
    MappingProperty { id: holdFreeze; path: propertiesPath + ".holdFreeze" }
    MappingProperty { id: holdRemix; path: propertiesPath + ".holdRemix" }

    //Loop Adjust State
    MappingProperty { id: loopInAdjust; path: deckPropertiesPath + ".loopInAdjust" }
    MappingProperty { id: loopOutAdjust; path: deckPropertiesPath + ".loopOutAdjust" }

    //Slot Selectors State
    MappingProperty { id: slot1Selected; path: deckPropertiesPath + ".slot_selector_mode.1" }
    MappingProperty { id: slot2Selected; path: deckPropertiesPath + ".slot_selector_mode.2" }
    MappingProperty { id: slot3Selected; path: deckPropertiesPath + ".slot_selector_mode.3" }
    MappingProperty { id: slot4Selected; path: deckPropertiesPath + ".slot_selector_mode.4" }
    MappingProperty { id: slotState; path: deckPropertiesPath + ".slot_selector_mode.any" }

    //TrackDeck Properties
    MappingProperty { id: controllerZoom; path: deckSettingsPath + ".waveform_zoom" }

    //StemDeck Properties
    MappingProperty { id: stemView; path: deckPropertiesPath + ".stem_deck_style" }

    //RemixDeck Properties
    MappingProperty { id: legacyRemixMode; path: deckSettingsPath + ".legacyRemixMode" }
    MappingProperty { id: remixPadsFocus; path: deckPropertiesPath + ".remixPadsFocus" }
    MappingProperty { id: remixPadsControl; path: deckPropertiesPath + ".remixPadsControl" }

    //Sequencer Properties
    MappingProperty { id: sequencerMode; path: deckPropertiesPath + ".sequencerMode" }
    MappingProperty { id: sequencerSlot; path: deckPropertiesPath + ".sequencerSlot" }
    MappingProperty { id: sequencerPage; path: deckPropertiesPath + ".sequencerPage" }
    MappingProperty { id: sequencerSampleLockSlot1; path: deckPropertiesPath + ".sequencerSampleLockSlot1" }
    MappingProperty { id: sequencerSampleLockSlot2; path: deckPropertiesPath + ".sequencerSampleLockSlot2" }
    MappingProperty { id: sequencerSampleLockSlot3; path: deckPropertiesPath + ".sequencerSampleLockSlot3" }
    MappingProperty { id: sequencerSampleLockSlot4; path: deckPropertiesPath + ".sequencerSampleLockSlot4" }

//------------------------------------------------------------------------------------------------------------------
// HELPER PROPERTIES
//------------------------------------------------------------------------------------------------------------------

    property string deckLetter: deckLetters[deckId]
    property string deckColor: deckColors[deckId]
    property string darkerDeckColor: darkerDeckColors[deckId] //colors.darkerColor(deckColor)

    property string deckSettingsPath: settingsPath + "." + deckId
    property string deckPropertiesPath: propertiesPath + "." + deckId
    property string remixDeckPropertyPath: "app.traktor.decks." + deckId + ".remix"

    property bool footerControlled: footerId == deckId
    property bool remixControlled: remixId == deckId
    readonly property bool isMaster: deckId == masterId.value+1

    property bool hasDeckProperties: (deckType.value == DeckType.Track || deckType.value == DeckType.Stem || deckType.value == DeckType.Remix) && !directThru.value
    property bool hasTrackProperties: (deckType.value == DeckType.Track || deckType.value == DeckType.Stem) && !directThru.value
    property bool hasRemixProperties: deckType.value == DeckType.Remix && !directThru.value
    property bool hasStemProperties: deckType.value == DeckType.Stem && !directThru.value

    property bool hasBottomControls: hasRemixProperties || hasStemProperties
    property bool hasRMXControls: hasRemixProperties && !sequencerMode.value
    property bool hasSQCRControls: hasRemixProperties && sequencerMode.value
    property bool hasEditMode: hasTrackProperties && isLoaded.value
    property bool hasEffects: !directThru.value

    Flipable {
        id: flipable

        anchors.fill: parent

        Behavior on anchors.topMargin { NumberAnimation { duration: durations.deckTransition } }

        //Top Content
        front:
            Item {
            id: frontSide
            anchors.fill: parent
            Loader {
                id: loader1
                anchors.fill: parent
                sourceComponent: trackDeckComponent //set in state
                active: true
                visible: true
            }
        }

        //Bottom Content
        back:
            Item {
            id: backSide
            anchors.fill: parent
            Loader {
                id: loader2
                anchors.fill: parent
                sourceComponent: remixDeckComponent //set in state
                active: true
                visible: true
            }
        }

        //Switch from top to bottom
        transform:
            Rotation {
            id: rotation
            origin.x: 0.5*flipable.width
            origin.y: 0.5*flipable.height
            axis.x: 1; axis.y: 0; axis.z: 0	 // set axis.x to 1 to rotate around x-axis
            angle: 0
            Behavior on angle { NumberAnimation { duration: 1000 } }
        }

        //TrackDeck Loader
        Component {
            id: trackDeckComponent;
            Item {
                anchors.fill: parent
                Loader {
                    id: themeLoader
                    anchors.fill: parent
                    sourceComponent: theme.value == 1 ? traktorDeck : (theme.value == 2 ? supremeDeck : (theme.value == 3 ? supremeProDeck : (theme.value == 4 ? primeDeck : (theme.value == 5 ? cdj2000Deck : cdj3000Deck))))
                }
                Component {
                    id: traktorDeck
                    Traktor.TrackDeck  {
                        id: trackDeck
                        deckId: deck.deckId
                    }
                }
                Component {
                    id: supremeDeck
                    Supreme.TrackDeck  {
                        id: trackDeck
                        deckId: deck.deckId
                    }
                }
                Component {
                    id: supremeProDeck
                    SupremePro.TrackDeck  {
                        id: trackDeck
                        deckId: deck.deckId
                    }
                }
                Component {
                    id: primeDeck
                    Prime.TrackDeck  {
                        id: trackDeck
                        deckId: deck.deckId
                    }
                }
                Component {
                    id: cdj2000Deck
                    CDJ2000NXS2.TrackDeck  {
                        id: trackDeck
                        deckId: deck.deckId
                    }
                }
                Component {
                    id: cdj3000Deck
                    CDJ3000.TrackDeck  {
                        id: trackDeck
                        deckId: deck.deckId
                    }
                }
            }
        }

        //RemixDeck Loader
        Component {
            id: remixDeckComponent
            Item {
                anchors.fill: parent
                Loader {
                    id: themeLoader
                    anchors.fill: parent
                    sourceComponent: theme.value == 1 ? traktorDeck : (theme.value == 2 ? supremeDeck : (theme.value == 3 || theme.value == 4 ? supremeProDeck : (theme.value == 5 ? cdj2000Deck : cdj3000Deck)))
                }
                Component {
                    id: traktorDeck
                    Traktor.RemixDeck {
                        id: remixDeck
                        deckId: deck.deckId
                    }
                }
                Component {
                    id: supremeDeck
                    Supreme.RemixDeck {
                        id: remixDeck
                        deckId: deck.deckId
                    }
                }
                Component {
                    id: supremeProDeck
                    SupremePro.RemixDeck {
                        id: remixDeck
                        deckId: deck.deckId
                    }
                }
                Component {
                    id: cdj2000Deck
                    CDJ2000NXS2.RemixDeck {
                        id: remixDeck
                        deckId: deck.deckId
                    }
                }
                Component {
                    id: cdj3000Deck
                    CDJ3000.RemixDeck {
                        id: remixDeck
                        deckId: deck.deckId
                    }
                }
            }
        }

        //LiveDeck Loader
        Component {
            id: liveDeckComponent;
            Item {
                anchors.fill: parent
                Loader {
                    id: themeLoader
                    anchors.fill: parent
                    sourceComponent: theme.value == 1 ? traktorDeck : (theme.value == 2 ? supremeDeck : supremeProDeck) //(theme.value == 3 ? supremeProDeck : (theme.value == 4 ? primeDeck : (theme.value == 5 ? cdj2000Deck : cdj3000Deck))))
                }
                Component {
                    id: traktorDeck
                    Traktor.LiveDeck {
                        id: liveDeck;
                        deckId: deck.deckId
                    }
                }
                Component {
                    id: supremeDeck
                    Supreme.LiveDeck {
                        id: liveDeck;
                        deckId: deck.deckId
                    }
                }
                Component {
                    id: supremeProDeck
                    SupremePro.LiveDeck {
                        id: liveDeck;
                        deckId: deck.deckId
                    }
                }
            }
        }

        //ThruDeck Loader
        Component {
            id: thruDeckComponent;
            Item {
                anchors.fill: parent
                Loader {
                    id: themeLoader
                    anchors.fill: parent
                    sourceComponent: theme.value == 1 ? traktorDeck : supremeProDeck
                }
                Component {
                    id: traktorDeck
                    Traktor.ThruDeck {
                        id: thruDeck
                        deckId: deck.deckId
                    }
                }
                Component {
                    id: supremeProDeck
                    SupremePro.ThruDeck {
                        id: thruDeck
                        deckId: deck.deckId
                    }
                }
            }
        }

//--------------------------------------------------------------------------------------------------------------------
// DECK TYPE STATES
//--------------------------------------------------------------------------------------------------------------------

        Item {
            id: content
            property bool flipped: false
            state: directThru.value ? "Direct Thru" : deckType.description
            states: [
                State { name: "Track Deck" },
                State { name: "Stem Deck" },
                State { name: "Remix Deck" },
                State { name: "Live Input" },
                State { name: "Direct Thru" }
            ]

            transitions: [
                //INFO: The sequntial animations are necessary to load the deck correctly before flipping sides.
                Transition {
                    to: "Track Deck"
                    SequentialAnimation {
                        PropertyAction  { target: content.flipped ? loader1 : loader2; property: "sourceComponent"; value: trackDeckComponent }
                        PropertyAction  { target: content.flipped ? loader1 : loader2; property: "active"; value: true }
                        NumberAnimation { target: rotation; property: "angle"; to: content.flipped ? 0 : 180; duration: 100 }
                        PropertyAction  { target: content.flipped ? loader2 : loader1; property: "active"; value: false }
                        PropertyAction  { target: content; property: "flipped"; value: !content.flipped }
                    }
                },
                Transition {
                    to: "Remix Deck"
                    SequentialAnimation {
                        PropertyAction  { target: content.flipped ? loader1 : loader2; property: "sourceComponent"; value: remixDeckComponent }
                        PropertyAction  { target: content.flipped ? loader1 : loader2; property: "active"; value: true }
                        NumberAnimation { target: rotation; property: "angle"; to: content.flipped ? 0 : 180; duration: 100 }
                        PropertyAction  { target: content.flipped ? loader2 : loader1; property: "active"; value: false }
                        PropertyAction  { target: content; property: "flipped"; value: !content.flipped }
                    }
                },
                Transition {
                    to: "Stem Deck"
                    SequentialAnimation {
                        PropertyAction  { target: content.flipped ? loader1 : loader2; property: "sourceComponent"; value: trackDeckComponent } //the screen for the TrackDeck/StemDeck is exactly the same
                        PropertyAction  { target: content.flipped ? loader1 : loader2; property: "active"; value: true }
                        NumberAnimation { target: rotation; property: "angle"; to: content.flipped ? 0 : 180; duration: 100 }
                        PropertyAction  { target: content.flipped ? loader2 : loader1; property: "active"; value: false }
                        PropertyAction  { target: content; property: "flipped"; value: !content.flipped }
                    }
                },
                Transition {
                    to: "Live Input"
                    SequentialAnimation {
                        PropertyAction  { target: content.flipped ? loader1 : loader2; property: "sourceComponent"; value: liveDeckComponent }
                        PropertyAction  { target: content.flipped ? loader1 : loader2; property: "active"; value: true }
                        NumberAnimation { target: rotation; property: "angle"; to: content.flipped ? 0 : 180; duration: 100 }
                        PropertyAction  { target: content.flipped ? loader2 : loader1; property: "active"; value: false }
                        PropertyAction  { target: content; property: "flipped"; value: !content.flipped }
                    }
                },
                Transition {
                    to: "Direct Thru"
                    SequentialAnimation {
                        PropertyAction  { target: content.flipped ? loader1 : loader2; property: "sourceComponent"; value: thruDeckComponent }
                        PropertyAction  { target: content.flipped ? loader1 : loader2; property: "active"; value: true }
                        NumberAnimation { target: rotation; property: "angle"; to: content.flipped ? 0 : 180; duration: 100 }
                        PropertyAction  { target: content.flipped ? loader2 : loader1; property: "active"; value: false }
                        PropertyAction  { target: content; property: "flipped"; value: !content.flipped }
                    }
                }
            ]
        }
    }

}
