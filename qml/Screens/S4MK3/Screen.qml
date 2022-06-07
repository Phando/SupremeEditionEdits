import CSI 1.0
import QtQuick 2.12
import QtGraphicalEffects 1.12
import Traktor.Gui 1.0 as Traktor

import '../../Defines'
import '../../Preferences' as Preferences
import '../Shared/Variables' as Variables

import './Views/Deck'
import './Views/Browser'
import '../Shared/Views/FXSettings'
import './Views/Settings'

import '../Shared/Overlays/'
import '../Shared/Overlays/SideOverlays'
import '../Shared/Widgets/' as Widgets

Item {
    id: screen
    property var flavor
    property bool isLeftScreen
    property string settingsPath: "mapping.settings.left"
    property string propertiesPath: "mapping.state.left"

    width: 320
    height: 240
    clip: true

    //THE FOLLOWING PROPERTIES ARE SET BY THE HARDWARE (S8_SCREEN_WRAPPER), DO NOT MODIFY ANY ALIAS
    //property alias screenStateAlias: screenView.state
    property alias browserView: browser
    property int browserPageSize: browser.pageSize //INFO: Don't delete or shift + browse won't work

    property alias browserIndexIncrement: browser.increment
    property alias enterBrowserNode: browser.enterNode
    property alias exitBrowserNode: browser.exitNode
    property alias browserSortingValue: browser.sortingKnobValue

    /*
    property alias leftOverlayState: leftOverlay.visibleState
    property alias rightOverlayState: rightOverlay.visibleState
    property alias leftOverlayContentState: leftOverlay.contentState
    property alias rightOverlayContentState: rightOverlay.contentState
    */

    /*
    property alias bottomControlState: bottomControls.contentState
    property alias bottomControlSizeState: bottomControls.sizeState
    property alias bottomControlSmallHeight: bottomControls.smallStateHeight
    */

    Preferences.Preferences { id: preferences }
    Preferences.PadFXs { id: padFXs }

    Variables.Version { id: version }
    Variables.Utils { id: utils }
    Variables.Font { id: fonts }
    Variables.Colors { id: colors }
    Variables.Durations { id: durations }
    Variables.Margins { id: margins }

//------------------------------------------------------------------------------------------------------------------
// TRAKTOR SETTINGS
//------------------------------------------------------------------------------------------------------------------

    //Settings - Touch Controls
    MappingProperty { id: showBrowserOnTouch; path: "mapping.settings.show_browser_on_touch" }
    MappingProperty { id: showTopPanelOnTouch; path: "mapping.settings.show_fx_panels_on_touch" }
    MappingProperty { id: showBottomPanelOnTouch; path: "mapping.settings.show_performance_control_on_touch" }

    //Settings - Touchstrip
    MappingProperty { id: scratchWithTouchstrip; path: "mapping.settings.scratch_with_touchstrip" }
    MappingProperty { id: bendSensitivity; path: "mapping.settings.touchstrip_bend_sensitivity" }
    MappingProperty { id: bendDirection; path: "mapping.settings.touchstrip_bend_invert" }
    MappingProperty { id: scratchSensitivity; path: "mapping.settings.touchstrip_scratch_sensitivity" }
    MappingProperty { id: scratchDirection; path: "mapping.settings.touchstrip_scratch_invert" }

    //Settings - LED Brightness
    MappingProperty { id: onBrightness; path: "mapping.settings.led_on_brightness" }
    MappingProperty { id: dimmedBrightness; path: "mapping.settings.led_dimmed_percentage" }

    //Settings - MIDI Controls
    MappingProperty { id: useMIDIControls; path: "mapping.settings.use_midi_controls" }

    //S5 Settings - Stems
    MappingProperty { id: stemSelectorModeHold; path: "mapping.settings.stem_select_hold" }
    MappingProperty { id: stemResetOnLoad; path: "mapping.settings.stem_reset_on_load" }

    //MixerFXs
    MappingProperty { id: mixerFXAssigned1; path: "mapping.settings.mixerFXAssigned1" }
    MappingProperty { id: mixerFXAssigned2; path: "mapping.settings.mixerFXAssigned2" }
    MappingProperty { id: mixerFXAssigned3; path: "mapping.settings.mixerFXAssigned3" }
    MappingProperty { id: mixerFXAssigned4; path: "mapping.settings.mixerFXAssigned4" }
    readonly property variant mxrFXLabels: ["FLTR", "RVRB", "DLDL", "NOISE", "TIMG", "FLNG", "BRPL", "DTDL", "CRSH"]
    readonly property variant mxrFXNames: ["Filter", "Reverb", "Dual Delay", "Noise", "Time Gater", "Flanger", "Barber Pole", "Dotted Delay", "Crush"]
    property variant mixerFXNames: [mxrFXNames[0], mxrFXNames[mixerFXAssigned1.value], mxrFXNames[mixerFXAssigned2.value], mxrFXNames[mixerFXAssigned3.value], mxrFXNames[mixerFXAssigned4.value] ] // do not change FLTR
    property variant mixerFXLabels: [mxrFXLabels[0], mxrFXLabels[mixerFXAssigned1.value], mxrFXLabels[mixerFXAssigned2.value], mxrFXLabels[mixerFXAssigned3.value], mxrFXLabels[mixerFXAssigned4.value] ] // do not change FLTR

//------------------------------------------------------------------------------------------------------------------
// MAPPING SETTINGS
//------------------------------------------------------------------------------------------------------------------

    //Shift
    MappingProperty { id: globalShiftEnabled; path: "mapping.settings.globalShift" }
    MappingProperty { id: globalShift; path: "mapping.state.shift" }
    MappingProperty { id: sideShift; path: propertiesPath + ".shift" }
    property bool shift: (globalShift.value && globalShiftEnabled.value) || (sideShift.value && !globalShiftEnabled.value)

    //Transport buttons
    MappingProperty { id: playButton; path: "mapping.settings.playButton" } //0: Play/Pause, 1: Vinyl Break
    MappingProperty { id: shiftPlayButton; path: "mapping.settings.shiftPlayButton" } //0: TimeCode, 1: Vinyl Break, 2: KeyLock (preserve), 3: KeyLock (reset)
    MappingProperty { id: playBlinker; path: "mapping.settings.playBlinker" }

    MappingProperty { id: cueButton; path: "mapping.settings.cueButton" } //0: Cue, 1: CUP, 2: Restart, 3: Pioneer (CUE + CUP)
    MappingProperty { id: shiftCueButton; path: "mapping.settings.shiftCueButton" } //0: Cue, 1: CUP, 2: Restart, 3: Pioneer (CUE + CUP)
    MappingProperty { id: cueBlinker; path: "mapping.settings.cueBlinker" }

    MappingProperty { id: faderStart; path: "mapping.state.faderStart" }

    //Vinyl break
    MappingProperty { id: vinylBreakInBeats; path: "mapping.settings.vinylBreakInBeats" }
    MappingProperty { id: vinylBreakDurationInBeats; path: "mapping.settings.vinylBreakDurationInBeats" }
    MappingProperty { id: vinylBreakDurationInSeconds; path: "mapping.settings.vinylBreakDurationInSeconds" }

    //Key Sync
    MappingProperty { id: fuzzyKeySync; path: "mapping.settings.fuzzyKeySync" }
    MappingProperty { id: useKeyText; path: "mapping.settings.useKeyText" }

    //Encoders
    MappingProperty { id: shiftBrowsePush; path: "mapping.settings.shiftBrowsePush" } //0: Disabled, 1: Instant Doubles, 2: Load Next Track, 3: Load Previous Track
    MappingProperty { id: browseEncoder; path: "mapping.settings.browseEncoder" } //0: BPM, 1: Tempo, 2: Controller Zoom, 3: TP3 Zoom
    MappingProperty { id: shiftBrowseEncoder; path: "mapping.settings.shiftBrowseEncoder" } //0: BPM, 1: Tempo, 2: Controller Zoom, 3: TP3 Zoom

    MappingProperty { id: stepBpm; path: "mapping.settings.stepBpm" }
    MappingProperty { id: stepShiftBpm; path: "mapping.settings.stepShiftBpm" }
    MappingProperty { id: stepTempo; path: "mapping.settings.stepTempo" }
    MappingProperty { id: stepShiftTempo; path: "mapping.settings.stepShiftTempo" }

    MappingProperty { id: loopEncoderInBrowser; path: "mapping.settings.loopEncoderInBrowser" }
    MappingProperty { id: shiftLoopEncoderInBrowser; path: "mapping.settings.shiftLoopEncoderInBrowser" }

    //Pads - Mode Selector
    MappingProperty { id: shiftHotcueButton; path: "mapping.settings.shiftHotcueButton" } //S5 Only

    MappingProperty { id: loopButton; path: "mapping.settings.loopButton" }
    MappingProperty { id: shiftLoopButton; path: "mapping.settings.shiftLoopButton" }

    MappingProperty { id: freezeButton; path: "mapping.settings.freezeButton" }
    MappingProperty { id: shiftFreezeButton; path: "mapping.settings.shiftFreezeButton" }

    //Pads - Loop Mode
    MappingProperty { id: enableFluxOnLoopMode; path: "mapping.settings.enableFluxOnLoopMode" }

    //Pads - Loop Roll Mode
    MappingProperty { id: enableFluxOnLoopRoll; path: "mapping.settings.enableFluxOnLoopRoll" }
    MappingProperty { path: "mapping.settings.pad_loop_roll_size1" }
    MappingProperty { path: "mapping.settings.pad_loop_roll_size2" }
    MappingProperty { path: "mapping.settings.pad_loop_roll_size3" }
    MappingProperty { path: "mapping.settings.pad_loop_roll_size4" }
    MappingProperty { path: "mapping.settings.pad_loop_roll_size5" }
    MappingProperty { path: "mapping.settings.pad_loop_roll_size6" }
    MappingProperty { path: "mapping.settings.pad_loop_roll_size7" }
    MappingProperty { path: "mapping.settings.pad_loop_roll_size8" }

    //Pads - Others
    MappingProperty { id: slotSelectorMode; path: "mapping.settings.slotSelectorMode" }
    MappingProperty { id: hotcuesPlayMode; path: "mapping.settings.hotcuesPlayMode" }
    MappingProperty { id: hotcueColors; path: "mapping.settings.hotcueColors" }

    //FX Select
    MappingProperty { id: fxSelectButton; path: "mapping.settings.fxSelectButton" } //0: FX Select, 1: mixerFX overlay
    MappingProperty { id: shiftFxSelectButton; path: "mapping.settings.shiftFxSelectButton" } //0: FX Select, 1: mixerFX overlay

    //Mods
    MappingProperty { id: fixBPMControl; path: "mapping.settings.fixBPMControl" }
    MappingProperty { id: fixHotcueTrigger; path: "mapping.settings.fixHotcueTrigger" }
    MappingProperty { id: beatmatchPracticeMode; path: "mapping.state.beatmatchPracticeMode" }

    //Timers
    MappingProperty { id: browserTimer; path: "mapping.settings.browserTimer" }
    MappingProperty { id: overlayTimer; path: "mapping.settings.overlayTimer" }
    MappingProperty { id: mixerFXTimer; path: "mapping.settings.mixerFXTimer" }
    MappingProperty { id: hotcueTypeTimer; path: "mapping.settings.hotcueTypeTimer" }
    MappingProperty { id: sideButtonsTimer; path: "mapping.settings.sideButtonsTimer" }

    //Other Settings
    MappingProperty { id: traktorRelatedBrowser; path: "mapping.settings.traktorRelatedBrowser" }
    MappingProperty { id: autoZoomTPwaveform; path: "mapping.settings.autoZoomTPwaveform" }
    MappingProperty { id: onlyFocusedDeck; path: "mapping.settings.onlyFocusedDeck" }

//------------------------------------------------------------------------------------------------------------------
// DISPLAY SETTINGS
//------------------------------------------------------------------------------------------------------------------

    //General
    MappingProperty { id: theme; path: "mapping.settings.theme" }
    MappingProperty { id: brightMode; path: "mapping.settings.brightMode" }
    MappingProperty { id: topLeftCorner; path: "mapping.settings.topLeftCorner" }
    //MappingProperty { id: topRightCorner; path: "mapping.settings.topRightCorner" }
    MappingProperty { id: displayCamelotKey; path: "mapping.settings.displayCamelotKey" }
    //MappingProperty { id: displayKeyText; path: "mapping.settings.displayKeyText" }
    MappingProperty { id: displayActive; path: "mapping.settings.displayActive" }

    //General - Top&Bottom Panel
    MappingProperty { id: showAssignedFXOverlays; path: "mapping.settings.show_assigned_fx_overlays" }
    MappingProperty { id: hideBottomPanel; path: "mapping.settings.hide_bottom_panel" }

    //Browser
    MappingProperty { id: browserRows; path: "mapping.settings.browserRows" }
    MappingProperty { id: browserFooterInfo; path: "mapping.settings.browserFooterInfo" }
    MappingProperty { id: showTracksPlayedDarker; path: "mapping.settings.showTracksPlayedDarker" }
    MappingProperty { id: independentScreenBrowser; path: "mapping.settings.independentScreenBrowser" }

    //Browser - Displayed info
    MappingProperty { id: browserAlbum; path: "mapping.settings.browserAlbum" }
    MappingProperty { id: browserArtist; path: "mapping.settings.browserArtist" }
    MappingProperty { id: browserBPM; path: "mapping.settings.browserBPM" }
    MappingProperty { id: browserKey; path: "mapping.settings.browserKey" }
    MappingProperty { id: browserRating; path: "mapping.settings.browserRating" }

    //Browser - BPM
    MappingProperty { id: highlightMatchRecommendations; path: "mapping.settings.highlightMatchRecommendations" }
    MappingProperty { id: perfectTempoMatchLimit; path: "mapping.settings.perfectTempoMatchLimit" }
    MappingProperty { id: regularTempoMatchLimit; path: "mapping.settings.regularTempoMatchLimit" }

    //Browser - Key
    MappingProperty { id: keyColorsInBrowser; path: "mapping.settings.keyColorsInBrowser" }
    MappingProperty { id: keyMatch2p; path: "mapping.settings.keyMatch2p" }
    MappingProperty { id: keyMatch2m; path: "mapping.settings.keyMatch2m" }
    MappingProperty { id: keyMatch5p; path: "mapping.settings.keyMatch5p" }
    MappingProperty { id: keyMatch5m; path: "mapping.settings.keyMatch5m" }
    MappingProperty { id: keyMatch6; path: "mapping.settings.keyMatch6" }

    //Deck - Widget
    MappingProperty { id: beatsxPhrase; path: "mapping.settings.beatsxPhrase" }
    MappingProperty { id: beatCounterMode; path: "mapping.settings.beatCounterMode" }
    MappingProperty { id: phaseWidget; path: "mapping.settings.phaseWidget" }

    //Deck - Waveform
    MappingProperty { id: waveformColor; path: "mapping.settings.waveformColor" }
    MappingProperty { id: waveformOffset; path: "mapping.settings.waveformOffset" }
    MappingProperty { id: dynamicWF; path: "mapping.settings.dynamicWF" }
    MappingProperty { id: showLoopSizeOverlay; path: "mapping.settings.loopSizeOverlay" }

    //Deck - Grid
    MappingProperty { id: gridMode; path: "mapping.settings.gridMode" }
    MappingProperty { id: displayGridMarkersWF; path: "mapping.settings.displayGridMarkersWF" }
    MappingProperty { id: displayBarsWF; path: "mapping.settings.displayBarsWF" }
    MappingProperty { id: displayPhrasesWF; path: "mapping.settings.displayPhrasesWF" }

    //Deck - Stripe
    MappingProperty { id: displayDarkenerPlayed; path: "mapping.settings.displayDarkenerPlayed" }
    MappingProperty { id: displayGridMarkersStripe; path: "mapping.settings.displayGridMarkersStripe" }
    MappingProperty { id: displayMinuteMarkersStripe; path: "mapping.settings.displayMinuteMarkersStripe" }
    MappingProperty { id: displayRemainingTimeStripe; path: "mapping.settings.displayRemainingTimeStripe" }
    MappingProperty { id: displayDeckLetterStripe; path: "mapping.settings.displayDeckLetterStripe" }
    MappingProperty { id: displayResultingKey; path: "mapping.settings.displayResultingKey" }

    //Deck - Performance Panel
    MappingProperty { id: panelMode; path: "mapping.settings.panelMode" }
    MappingProperty { id: displayNumbersHotcuePanel; path: "mapping.settings.displayNumbersHotcuePanel" }

    //Remix Deck
    MappingProperty { id: showVolumeFaders; path: "mapping.settings.showVolumeFaders" }
    MappingProperty { id: showFilterFaders; path: "mapping.settings.showFilterFaders" }
    MappingProperty { id: showSlotIndicators; path: "mapping.settings.showSlotIndicators" }

//------------------------------------------------------------------------------------------------------------------
// TRAKTOR APP PROPERTIES
//------------------------------------------------------------------------------------------------------------------

    //Master
    AppProperty { id: masterId; path: "app.traktor.masterclock.source_id" } //-1: MasterClock, 0: Deck A, 1: Deck B, 2: Deck C, 3: Deck D
    AppProperty { id: masterMode; path: "app.traktor.masterclock.mode" }
    AppProperty { id: clockBpm; path: "app.traktor.masterclock.tempo" }

    //Browser
    AppProperty { id: fullscreenBrowser; path:"app.traktor.browser.full_screen" }
    AppProperty { id: browserSortId; path: "app.traktor.browser.sort_id" }
    AppProperty { id: favoritesSelect; path: "app.traktor.browser.favorites.select" }

    //Preview Player
    AppProperty { id: previewPlayerIsLoaded; path: "app.traktor.browser.preview_player.is_loaded" }
    AppProperty { id: unloadPreviewPlayer; path: "app.traktor.browser.preview_player.unload" }

    //FXs
    AppProperty { id: fxMode; path: "app.traktor.fx.4fx_units" }

    //Other
    AppProperty { id: quantize; path: "app.traktor.quant" }
    AppProperty { id: snap; path: "app.traktor.snap" }

//----------------------------------------------------------------------------------------------------------------------
// MASTER DECK PROPERTIES
//----------------------------------------------------------------------------------------------------------------------

    AppProperty { id: masterDeckType; path: "app.traktor.decks." + (masterId.value+1) + ".type" }
    AppProperty { id: masterTrackBpm; path: "app.traktor.decks." + (masterId.value+1) + ".content.bpm" }

    AppProperty { id: masterKeyText; path: "app.traktor.decks." + (masterId.value+1) + ".content.legacy_key" }
    AppProperty { id: masterKeyAdjust; path: "app.traktor.decks." + (masterId.value+1) + ".track.key.adjust" }
    AppProperty { id: masterResultingKey; path: "app.traktor.decks." + (masterId.value+1) + ".track.key.resulting.precise" }
    AppProperty { id: masterResultingKeyIndex; path: "app.traktor.decks." + (masterId.value+1) + ".track.key.final_id" }
    property int masterKeyTextIndex: (masterId.value && masterKeyText.value && masterKeyAdjust.value && masterResultingKeyIndex.value) ? (masterId.value != -1 ? useKeyText.value ? Key.getKeyTextId(masterKeyText.value, masterKeyAdjust.value) : masterResultingKeyIndex.value : -1) : -1

//----------------------------------------------------------------------------------------------------------------------
// FOCUSED DECK PROPERTIES
//----------------------------------------------------------------------------------------------------------------------

    MappingProperty { id: activePadsMode; path: propertiesPath + ".pads_mode" }

    property int focusedDeckId: side.focusedDeckId
    property string focusedDeckType: side.focusedDeck().deckType
    property string focusedDeckSize: side.focusedDeck().deckSize

    AppProperty { id: directThru; path: "app.traktor.decks." + focusedDeckId + ".direct_thru" }
    AppProperty { id: gridLock; path: "app.traktor.decks." + focusedDeckId + ".track.grid.lock_bpm" }
    AppProperty { id: isTrackTick; path: "app.traktor.decks." + focusedDeckId + ".track.grid.enable_tick" }
    AppProperty { id: samplePage; path: "app.traktor.decks." + focusedDeckId + ".remix.page" }

    /*
    AppProperty { id: topDeckHeaderWarningActive; path: "app.traktor.informer.deckheader_message." + side.topDeckId + ".active"; onValueChanged: { onDeckHeaderWarningActive( side.topDeckId, topDeckHeaderWarningActive.value ) } }
    AppProperty { id: bottomDeckHeaderWarningActive; path: "app.traktor.informer.deckheader_message." + side.bottomDeckId + ".active"; onValueChanged: { onDeckHeaderWarningActive( side.bottomDeckId, bottomDeckHeaderWarningActive.value ) } }
    // Switching to split deck view if a warning occurs on an "invisible" deck / TP-8019
    function onDeckHeaderWarningActive( deckId, warningActive ) {
        if ( warningActive ) {
            var isVisible = !deckIsSingleProp.value | (focusDeckId == deckId);
            if ( !isVisible ){
                switchBackToSingleDeckViewAfterWarning = true;
                deckFocusBeforeDeckViewWarningSwitch   = deckFocusStateProp.value;
                deckIsSingleProp.value = false;
            }
        }
        else if ( switchBackToSingleDeckViewAfterWarning ){
            switchBackToSingleDeckViewAfterWarning = false;
            if ( deckFocusBeforeDeckViewWarningSwitch == deckFocusStateProp.value ) { // if somebody manually switches the deck focus during warnings we won't auto switch back
                deckIsSingleProp.value = true;
            }
        }
    }
    */

//----------------------------------------------------------------------------------------------------------------------
// SCREEN PROPERTIES
//----------------------------------------------------------------------------------------------------------------------

    MappingProperty { id: screenView; path: propertiesPath + ".screen_view" }
    MappingProperty { id: screenIsSingleDeck; path: propertiesPath + ".screenIsSingleDeck" }
    MappingProperty { id: screenOverlay; path: propertiesPath + ".overlay" }

    MappingProperty { id: deckAColor; path: "mapping.settings.1.deckColor" }
    MappingProperty { id: deckBColor; path: "mapping.settings.2.deckColor" }
    MappingProperty { id: deckCColor; path: "mapping.settings.3.deckColor" }
    MappingProperty { id: deckDColor; path: "mapping.settings.4.deckColor" }

    readonly property variant deckLetters: ["Clock", "A", "B", "C", "D"]
    readonly property variant deckColors: [colors.cyan, colors.palette(1, deckAColor.value), colors.palette(1, deckBColor.value), colors.palette(1, deckCColor.value), colors.palette(1, deckDColor.value)]
    readonly property variant darkerDeckColors: [colors.darkerColor(deckColors[0]), colors.darkerColor(deckColors[1], colors.darkerColor(deckColors[2])), colors.darkerColor(deckColors[3]), colors.darkerColor(deckColors[4])]

//--------------------------------------------------------------------------------------------------------------------
// VIEWS
//----------------------------------------------------------------------------------------------------------------------

    //Deck
    property int sideHeight: screen.height - side.anchors.bottomMargin
    Side {
        id: side
        topDeckId: isLeftScreen ? 1 : 2 //revise this with the DeckAssignement
        bottomDeckId: isLeftScreen ? 3 : 4 //revise this with the DeckAssignement

        anchors.fill: parent
        visible: screenView.value == ScreenView.deck
    }

    //Browser Overlay
    Browser {
        id: browser
        anchors.fill: parent
        //visible: screenView.value == ScreenView.browser
        state: screenView.value == ScreenView.browser ? "visible" : "down"
    }

    //FX Settings
    FXSettings {
        id: fxSelect
        anchors.fill: parent
        //visible: screenView.value == ScreenView.fxSettings
        state: screenView.value == ScreenView.fxSettings ? "visible" : "up"
    }

    //Settings
    Settings {
        id: settings
        anchors.fill: parent
        //visible: screenView.value == ScreenView.settings
        state: screenView.value == ScreenView.settings ? "visible" : "right"
    }

//--------------------------------------------------------------------------------------------------------------------
// OVERLAYS
//----------------------------------------------------------------------------------------------------------------------

    //Properties
    MappingProperty { id: topFXUnit; path: settingsPath + ".topFXUnit" }
    MappingProperty { id: bottomFXUnit; path: settingsPath + ".bottomFXUnit" }

    MappingProperty { id: topFXOverlay; path: propertiesPath + ".topFXOverlay" }
    MappingProperty { id: bottomPerformanceOverlay; path: propertiesPath + ".bottomPerformanceOverlay" }
    MappingProperty { id: showFX1; path: "mapping.state.showFX1" }
    MappingProperty { id: showFX2; path: "mapping.state.showFX2" }
    MappingProperty { id: showFX3; path: "mapping.state.showFX3" }
    MappingProperty { id: showFX4; path: "mapping.state.showFX4" }
    property bool topFXPanel: topFXOverlay.value || (showFX1.value && topFXUnit.value == 1) || (showFX2.value && topFXUnit.value == 2) || (showFX3.value && topFXUnit.value == 3) || (showFX4.value && topFXUnit.value == 4)
    property bool bottomFXPanel: bottomPerformanceOverlay.value || (showFX1.value && bottomFXUnit.value == 1) || (showFX2.value && bottomFXUnit.value == 2) || (showFX3.value && bottomFXUnit.value == 3) || (showFX4.value && bottomFXUnit.value == 4)

    MappingProperty { id: footerPage;  path: propertiesPath + ".footer_page" }
    MappingProperty { id: footerHasContent; path: propertiesPath + ".footerHasContent" }
    MappingProperty { id: footerHasContentToSwitch; path: propertiesPath + ".footerHasContentToSwitch" }

    MappingProperty { id: editMode; path: propertiesPath + ".edit_mode" }
    property bool isInEditMode: editMode.value == EditMode.full
    MappingProperty { id: sequencerMode; path: propertiesPath + "." + focusedDeckId + ".sequencerMode" }
    MappingProperty { path: propertiesPath + ".show_button_area_input" }
    property bool showButtonArea: false

    //FX Top Overlay
    TopControls {
        id: topControls
        fxUnit: shift ? bottomFXUnit.value : topFXUnit.value
        visible: screenView.value == ScreenView.deck
        visibleState: topFXPanel ? "show" : "hide"
    }

    //FX Top SoftTakeover Overlay
    MappingProperty { id: showSofttakeoverKnobs; path: propertiesPath + ".softtakeover.show_knobs" }
    SoftTakeoverKnobs {
        id: softTakeoverKnobs
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        visible: showSofttakeoverKnobs.value
    }

    //Center Overlays
    OverlayManager {
        id: overlayManager
        deckId: side.focusedDeckId
        remixId: side.remixId
    }
}
