import CSI 1.0
import QtQuick 2.12

import "../../Defines"
import "../Common/Settings"

Mapping {

//------------------------------------------------------------------------------------------------------------------
// TRAKTOR SETTINGS
//------------------------------------------------------------------------------------------------------------------

    //Settings - Touch Controls
    MappingPropertyDescriptor { id: showBrowserOnTouch; path: "mapping.settings.show_browser_on_touch"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: showTopPanelOnTouch; path: "mapping.settings.show_fx_panels_on_touch"; type: MappingPropertyDescriptor.Boolean; value: true }
    MappingPropertyDescriptor { id: showBottomPanelOnTouch; path: "mapping.settings.show_performance_control_on_touch"; type: MappingPropertyDescriptor.Boolean; value: true }

    //Settings - Touchstrip
    MappingPropertyDescriptor { id: scratchWithTouchstrip; path: "mapping.settings.scratch_with_touchstrip"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: bendSensitivity; path: "mapping.settings.touchstrip_bend_sensitivity"; type: MappingPropertyDescriptor.Float; value: 50.0; min: 0.0; max: 100.0 }
    MappingPropertyDescriptor { id: bendDirection; path: "mapping.settings.touchstrip_bend_invert"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: scratchSensitivity; path: "mapping.settings.touchstrip_scratch_sensitivity"; type: MappingPropertyDescriptor.Float; value: 50.0; min: 0.0; max: 100.0 }
    MappingPropertyDescriptor { id: scratchDirection; path: "mapping.settings.touchstrip_scratch_invert"; type: MappingPropertyDescriptor.Boolean; value: true }

    // Settings - Stems Behaviour
    MappingPropertyDescriptor { id: stemSelectorModeHold; path: "mapping.settings.stem_select_hold"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: stemResetOnLoad; path: "mapping.settings.stem_reset_on_load"; type: MappingPropertyDescriptor.Boolean; value: true }

    //Settings - LED Brightness
    MappingPropertyDescriptor { path: "mapping.settings.led_on_brightness"; type: MappingPropertyDescriptor.Integer; value: 100; min: 50; max: 100 }
    MappingPropertyDescriptor { path: "mapping.settings.led_dimmed_percentage"; type: MappingPropertyDescriptor.Integer; value: 25; min: 0; max: 50  }
    DirectPropertyAdapter { name: "LEDBrightnessOn"; path: "mapping.settings.led_on_brightness"; input: false }
    DirectPropertyAdapter { name: "LEDDimmedPercentage"; path: "mapping.settings.led_dimmed_percentage"; input: false }
    Wire { from: "s5.led_on_brightness.write"; to: "LEDBrightnessOn.read" }
    Wire { from: "s5.led_dimmed_brightness.write"; to: "LEDDimmedPercentage.read" }
    readonly property real bright: 1.0
    readonly property real dimmed: 0.0

    //Settings - MIDI Controls //keep this as a dummy to avoid having qml warnings in the screen (MIDI Only for the D2 & S8)
    MappingPropertyDescriptor { id: useMIDIControls; path: "mapping.settings.use_midi_controls"; type: MappingPropertyDescriptor.Boolean; value: false }

//------------------------------------------------------------------------------------------------------------------
// MAPPING SETTINGS
//------------------------------------------------------------------------------------------------------------------

    //Shift
    MappingPropertyDescriptor { id: globalShiftEnabled; path: "mapping.settings.globalShift"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: globalShift; path: "mapping.state.shift"; type: MappingPropertyDescriptor.Boolean; value: globalShiftEnabled.value && (leftShift.value || rightShift.value) }

    MappingPropertyDescriptor { id: leftShift; path: "mapping.state.left.shift"; type: MappingPropertyDescriptor.Boolean; value: false }
    Wire { from: "s5.left.shift"; to: DirectPropertyAdapter { path: leftShift.path } }

    MappingPropertyDescriptor { id: rightShift; path: "mapping.state.right.shift"; type: MappingPropertyDescriptor.Boolean; value: false }
    Wire { from: "s5.right.shift"; to: DirectPropertyAdapter { path: rightShift.path } }

    //Transport buttons
    MappingPropertyDescriptor { id: playButton; path: "mapping.settings.playButton"; type: MappingPropertyDescriptor.Integer; value: 0; min: 0; max: 1 } //0: Play, 1: Vinyl Break
    MappingPropertyDescriptor { id: shiftPlayButton; path: "mapping.settings.shiftPlayButton"; type: MappingPropertyDescriptor.Integer; value: 0; min: 0; max: 3 } //0: TimeCode, 1: Vinyl Break, 2: KeyLock (preserve), 3: KeyLock (reset)
    MappingPropertyDescriptor { id: playBlinker; path: "mapping.settings.playBlinker"; type: MappingPropertyDescriptor.Boolean; value: false }

    MappingPropertyDescriptor { id: cueButton; path: "mapping.settings.cueButton"; type: MappingPropertyDescriptor.Integer; value: 0; min: 0; max: 3 } //0: Cue, 1: CUP, 2: Restart, 3: Smart CUE + CUP
    MappingPropertyDescriptor { id: shiftCueButton; path: "mapping.settings.shiftCueButton"; type: MappingPropertyDescriptor.Integer; value: 2; min: 0; max: 3 } //0: CUE 1: CUP, 2: Restart, 3: Smart CUE + CUP
    MappingPropertyDescriptor { id: cueBlinker; path: "mapping.settings.cueBlinker"; type: MappingPropertyDescriptor.Boolean; value: false }

    MappingPropertyDescriptor { id: faderStart; path: "mapping.state.faderStart"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: reverseCensor; path: "mapping.settings.reverseCensor"; type: MappingPropertyDescriptor.Boolean; value: false }

    //Vinyl break
    MappingPropertyDescriptor { id: vinylBreakInBeats; path: "mapping.settings.vinylBreakInBeats"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: vinylBreakDurationInBeats; path: "mapping.settings.vinylBreakDurationInBeats"; type: MappingPropertyDescriptor.Integer; value: 1; min: 0; max: 64 }
    MappingPropertyDescriptor { id: vinylBreakDurationInSeconds; path: "mapping.settings.vinylBreakDurationInSeconds"; type: MappingPropertyDescriptor.Integer; value: 1000; min: 0; max: 30000 }

    //Key Sync
    MappingPropertyDescriptor { id: fuzzyKeySync; path: "mapping.settings.fuzzyKeySync"; type: MappingPropertyDescriptor.Boolean; value: true }
    MappingPropertyDescriptor { id: useKeyText; path: "mapping.settings.useKeyText"; type: MappingPropertyDescriptor.Boolean; value: false }

    //Encoders
    MappingPropertyDescriptor { id: browseEncoder; path: "mapping.settings.browseEncoder"; type: MappingPropertyDescriptor.Integer; value: 0; min: 0; max: 5 } //0: BPM, 1: Tempo, 2: Controller Zoom, 3: TP3 Zoom, 4: Move, 5: Move 1 beat
    MappingPropertyDescriptor { id: shiftBrowsePush; path: "mapping.settings.shiftBrowsePush"; type: MappingPropertyDescriptor.Integer; value: 0; min: 0; max: 3 } //0: Disabled, 1: Instant Doubles, 2: Load Next Track, 3: Load Previous Track
    MappingPropertyDescriptor { id: shiftBrowseEncoder; path: "mapping.settings.shiftBrowseEncoder"; type: MappingPropertyDescriptor.Integer; value: 1; min: 0; max: 5 } //0: BPM, 1: Tempo, 2: Controller Zoom, 3: TP3 Zoom, 4: Move, 5: Move 1 beat

    MappingPropertyDescriptor { id: stepBpm; path: "mapping.settings.stepBpm"; type: MappingPropertyDescriptor.Float; value: 1.00; min: 0.01; max: 5.00 }
    MappingPropertyDescriptor { id: stepShiftBpm; path: "mapping.settings.stepShiftBpm"; type: MappingPropertyDescriptor.Float; value: 0.01; min: 0.01; max: 5.00 }
    MappingPropertyDescriptor { id: stepTempo; path: "mapping.settings.stepTempo"; type: MappingPropertyDescriptor.Float; value: 0.01; min: 0.0005; max: 0.1 }
    MappingPropertyDescriptor { id: stepShiftTempo; path: "mapping.settings.stepShiftTempo"; type: MappingPropertyDescriptor.Float; value: 0.001; min: 0.0005; max: 0.1 }

    MappingPropertyDescriptor { id: loopEncoderInBrowser; path: "mapping.settings.loopEncoderInBrowser"; type: MappingPropertyDescriptor.Integer; value: 0; min: 0; max: 1 }
    MappingPropertyDescriptor { id: shiftLoopEncoderInBrowser; path: "mapping.settings.shiftLoopEncoderInBrowser"; type: MappingPropertyDescriptor.Integer; value: 1; min: 0; max: 1 }

    //Pads - Mode Selector
    MappingPropertyDescriptor { id: shiftHotcueButton; path: "mapping.settings.shiftHotcueButton"; type: MappingPropertyDescriptor.Integer; value: 0; min: 0; max: 3 }

    MappingPropertyDescriptor { id: freezeButton; path: "mapping.settings.freezeButton"; type: MappingPropertyDescriptor.Integer; value: 1; min: 0; max: 1 }
    MappingPropertyDescriptor { id: shiftFreezeButton; path: "mapping.settings.shiftFreezeButton"; type: MappingPropertyDescriptor.Integer; value: 0; min: 0; max: 1 }

    //Pads - Loop Mode
    MappingPropertyDescriptor { id: enableFluxOnLoopMode; path: "mapping.settings.enableFluxOnLoopMode"; type: MappingPropertyDescriptor.Boolean; value: false }
    LoopSizes { name: "loop_sizes_1"; path: "mapping.settings.pad_loop_size.1"; value: LoopSize.loop_1_8 }
    LoopSizes { name: "loop_sizes_2"; path: "mapping.settings.pad_loop_size.2"; value: LoopSize.loop_1_4 }
    LoopSizes { name: "loop_sizes_3"; path: "mapping.settings.pad_loop_size.3"; value: LoopSize.loop_1_2 }
    LoopSizes { name: "loop_sizes_4"; path: "mapping.settings.pad_loop_size.4"; value: LoopSize.loop_1 }
    JumpSizes { name: "jump_sizes_1"; path: "mapping.settings.pad_jump_size.1"; value: JumpSize.bwd_loop }
    JumpSizes { name: "jump_sizes_2"; path: "mapping.settings.pad_jump_size.2"; value: JumpSize.bwd_1 }
    JumpSizes { name: "jump_sizes_3"; path: "mapping.settings.pad_jump_size.3"; value: JumpSize.fwd_1 }
    JumpSizes { name: "jump_sizes_4"; path: "mapping.settings.pad_jump_size.4"; value: JumpSize.fwd_loop }

    //Pads - Loop Roll Mode
    MappingPropertyDescriptor { id: enableFluxOnLoopRoll; path: "mapping.settings.enableFluxOnLoopRoll"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { path: "mapping.settings.pad_loop_roll_size1"; type: MappingPropertyDescriptor.Integer; value: LoopSize.loop_1_32 }
    MappingPropertyDescriptor { path: "mapping.settings.pad_loop_roll_size2"; type: MappingPropertyDescriptor.Integer; value: LoopSize.loop_1_16 }
    MappingPropertyDescriptor { path: "mapping.settings.pad_loop_roll_size3"; type: MappingPropertyDescriptor.Integer; value: LoopSize.loop_1_8 }
    MappingPropertyDescriptor { path: "mapping.settings.pad_loop_roll_size4"; type: MappingPropertyDescriptor.Integer; value: LoopSize.loop_1_4 }
    MappingPropertyDescriptor { path: "mapping.settings.pad_loop_roll_size5"; type: MappingPropertyDescriptor.Integer; value: LoopSize.loop_1_2 }
    MappingPropertyDescriptor { path: "mapping.settings.pad_loop_roll_size6"; type: MappingPropertyDescriptor.Integer; value: LoopSize.loop_1 }
    MappingPropertyDescriptor { path: "mapping.settings.pad_loop_roll_size7"; type: MappingPropertyDescriptor.Integer; value: LoopSize.loop_2 }
    MappingPropertyDescriptor { path: "mapping.settings.pad_loop_roll_size8"; type: MappingPropertyDescriptor.Integer; value: LoopSize.loop_4 }

    //Pads - Others
    MappingPropertyDescriptor { id: slotSelectorMode; path: "mapping.settings.slotSelectorMode"; type: MappingPropertyDescriptor.Integer; value: 2; min: 0; max: 2 }
    MappingPropertyDescriptor { id: hotcuesPlayMode; path: "mapping.settings.hotcuesPlayMode"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: hotcueColors; path: "mapping.settings.hotcueColors"; type: MappingPropertyDescriptor.Integer; value: 0 }

    //FX Select
    MappingPropertyDescriptor { id: fxSelectButton; path: "mapping.settings.fxSelectButton"; type: MappingPropertyDescriptor.Integer; value: 1; min: 0; max: 1 } //0: FX Select, 1: mixerFX overlay
    MappingPropertyDescriptor { id: shiftFxSelectButton; path: "mapping.settings.shiftFxSelectButton"; type: MappingPropertyDescriptor.Integer; value: 0; min: 0; max: 1 } //0: FX Select, 1: mixerFX overlay

    //Mods
    MappingPropertyDescriptor { id: fixBPMControl; path: "mapping.settings.fixBPMControl"; type: MappingPropertyDescriptor.Boolean; value: true }
    MappingPropertyDescriptor { id: fixHotcueTrigger; path: "mapping.settings.fixHotcueTrigger"; type: MappingPropertyDescriptor.Boolean; value: true }
    MappingPropertyDescriptor { id: beatmatchPracticeMode; path: "mapping.state.beatmatchPracticeMode"; type: MappingPropertyDescriptor.Boolean; value: false }

    //Timers
    MappingPropertyDescriptor { id: holdTimer; path: "mapping.settings.holdTimer"; type: MappingPropertyDescriptor.Integer; value: 250; min: 50; max: 3000 }
    MappingPropertyDescriptor { id: browserTimer; path: "mapping.settings.browserTimer"; type: MappingPropertyDescriptor.Integer; value: 1000; min: 100; max: 10000 }
    MappingPropertyDescriptor { id: overlayTimer; path: "mapping.settings.overlayTimer"; type: MappingPropertyDescriptor.Integer; value: 4000; min: 100; max: 10000 }
    MappingPropertyDescriptor { id: mixerFXTimer; path: "mapping.settings.mixerFXTimer"; type: MappingPropertyDescriptor.Integer; value: 2000; min: 100; max: 10000 }
    MappingPropertyDescriptor { id: hotcueTypeTimer; path: "mapping.settings.hotcueTypeTimer"; type: MappingPropertyDescriptor.Integer; value: 3000; min: 100; max:10000 }
    MappingPropertyDescriptor { id: sideButtonsTimer; path: "mapping.settings.sideButtonsTimer"; type: MappingPropertyDescriptor.Integer; value: 1000; min: 100; max: 10000 }

    //Other Settings
    MappingPropertyDescriptor { id: traktorRelatedBrowser; path: "mapping.settings.traktorRelatedBrowser"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: autoZoomTPwaveform; path: "mapping.settings.autoZoomTPwaveform"; type: MappingPropertyDescriptor.Boolean; value: true }
    MappingPropertyDescriptor { id: onlyFocusedDeck; path: "mapping.settings.onlyFocusedDeck"; type: MappingPropertyDescriptor.Boolean; value: false }

//------------------------------------------------------------------------------------------------------------------
// DISPLAY SETTINGS
//------------------------------------------------------------------------------------------------------------------

    //General
    MappingPropertyDescriptor { id: theme; path: "mapping.settings.theme"; type: MappingPropertyDescriptor.Integer; value: 1; min: 1; max: 6 }
    MappingPropertyDescriptor { id: brightMode; path: "mapping.settings.brightMode"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: topLeftCorner; path: "mapping.settings.topLeftCorner"; type: MappingPropertyDescriptor.Integer; value: 1; min: 0; max: 3 }
    //MappingPropertyDescriptor { id: topRightCorner; path: "mapping.settings.topRightCorner"; type: MappingPropertyDescriptor.Integer; value: 0 }

    MappingPropertyDescriptor { id: displayCamelotKey; path: "mapping.settings.displayCamelotKey"; type: MappingPropertyDescriptor.Boolean; value: false }
    //MappingPropertyDescriptor { id: displayKeyText; path: "mapping.settings.displayKeyText"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: displayActive; path: "mapping.settings.displayActive"; type: MappingPropertyDescriptor.Boolean; value: false }

    //General - Top&Bottom Panels
    MappingPropertyDescriptor { id: showAssignedFXOverlays; path: "mapping.settings.show_assigned_fx_overlays"; type: MappingPropertyDescriptor.Boolean; value: true }
    MappingPropertyDescriptor { id: hideBottomPanel; path: "mapping.settings.hide_bottom_panel"; type: MappingPropertyDescriptor.Boolean; value: false }

    //Browser
    MappingPropertyDescriptor { id: browserRows; path: "mapping.settings.browserRows"; type: MappingPropertyDescriptor.Integer; value: 7; min: 5; max: 12 }
    MappingPropertyDescriptor { id: browserFooterInfo; path: "mapping.settings.browserFooterInfo"; type: MappingPropertyDescriptor.Integer; value: 1 } //0: empty, 1: number of songs, 2: time, 3: key information
    MappingPropertyDescriptor { id: showTracksPlayedDarker; path: "mapping.settings.showTracksPlayedDarker"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: independentScreenBrowser; path: "mapping.settings.independentScreenBrowser"; type: MappingPropertyDescriptor.Boolean; value: true }

    //Browser - Displayed info
    MappingPropertyDescriptor { id: browserAlbum; path: "mapping.settings.browserAlbum"; type: MappingPropertyDescriptor.Boolean; value: true }
    MappingPropertyDescriptor { id: browserArtist; path: "mapping.settings.browserArtist"; type: MappingPropertyDescriptor.Boolean; value: true }
    MappingPropertyDescriptor { id: browserBPM; path: "mapping.settings.browserBPM"; type: MappingPropertyDescriptor.Boolean; value: true }
    MappingPropertyDescriptor { id: browserKey; path: "mapping.settings.browserKey"; type: MappingPropertyDescriptor.Boolean; value: true }
    MappingPropertyDescriptor { id: browserRating; path: "mapping.settings.browserRating"; type: MappingPropertyDescriptor.Boolean; value: true }

    //Browser - BPM
    MappingPropertyDescriptor { id: highlightMatchRecommendations; path: "mapping.settings.highlightMatchRecommendations"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: perfectTempoMatchLimit; path: "mapping.settings.perfectTempoMatchLimit"; type: MappingPropertyDescriptor.Integer; value: 3 }
    MappingPropertyDescriptor { id: regularTempoMatchLimit; path: "mapping.settings.regularTempoMatchLimit"; type: MappingPropertyDescriptor.Integer; value: 7 }

    //Browser - Key
    MappingPropertyDescriptor { id: keyColorsInBrowser; path: "mapping.settings.keyColorsInBrowser"; type: MappingPropertyDescriptor.Integer; value: 3 }
    MappingPropertyDescriptor { id: keyMatch2p; path: "mapping.settings.keyMatch2p"; type: MappingPropertyDescriptor.Boolean; value: true }
    MappingPropertyDescriptor { id: keyMatch2m; path: "mapping.settings.keyMatch2m"; type: MappingPropertyDescriptor.Boolean; value: true }
    MappingPropertyDescriptor { id: keyMatch5p; path: "mapping.settings.keyMatch5p"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: keyMatch5m; path: "mapping.settings.keyMatch5m"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: keyMatch6; path: "mapping.settings.keyMatch6"; type: MappingPropertyDescriptor.Boolean; value: false }
    //MappingPropertyDescriptor { id: keyMatchOppositeAdjacents; path: "mapping.settings.keyMatchOppositeAdjacents"; type: MappingPropertyDescriptor.Boolean; value: false }

    //Deck - Widget
    MappingPropertyDescriptor { id: phaseWidget; path: "mapping.settings.phaseWidget"; type: MappingPropertyDescriptor.Integer; value: 2; min: 0; max: 3 } //0: None, 1: Phase Widget, 2: Beat Counter, 3: Master Waveform
    MappingPropertyDescriptor { id: beatsxPhrase; path: "mapping.settings.beatsxPhrase"; type: MappingPropertyDescriptor.Integer; value: 16; min: 1; max: 64 }
    MappingPropertyDescriptor { id: beatCounterMode; path: "mapping.settings.beatCounterMode"; type: MappingPropertyDescriptor.Integer; value: 1; min: 0; max: 3 }

    //Deck - Waveform
    MappingPropertyDescriptor { id: waveformColor; path: "mapping.settings.waveformColor"; type: MappingPropertyDescriptor.Integer; value: 20; min: 0; max: 21 }
    MappingPropertyDescriptor { id: waveformOffset; path: "mapping.settings.waveformOffset"; type: MappingPropertyDescriptor.Integer; value: 50; min: 25; max: 50 }
    MappingPropertyDescriptor { id: dynamicWF; path: "mapping.settings.dynamicWF"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: showLoopSizeOverlay; path: "mapping.settings.loopSizeOverlay"; type: MappingPropertyDescriptor.Boolean; value: true }

    //Deck - Waveform Grid
    MappingPropertyDescriptor { id: gridMode; path: "mapping.settings.gridMode"; type: MappingPropertyDescriptor.Integer; value: 1; min: 0; max: 3 }
    MappingPropertyDescriptor { id: displayGridMarkersWF; path: "mapping.settings.displayGridMarkersWF"; type: MappingPropertyDescriptor.Boolean; value: true }
    MappingPropertyDescriptor { id: displayBarsWF; path: "mapping.settings.displayBarsWF"; type: MappingPropertyDescriptor.Boolean; value: true }
    MappingPropertyDescriptor { id: displayPhrasesWF; path: "mapping.settings.displayPhrasesWF"; type: MappingPropertyDescriptor.Boolean; value: true }

    //Deck - Stripe
    MappingPropertyDescriptor { id: displayDarkenerPlayed; path: "mapping.settings.displayDarkenerPlayed"; type: MappingPropertyDescriptor.Boolean; value: true }
    MappingPropertyDescriptor { id: displayGridMarkersStripe; path: "mapping.settings.displayGridMarkersStripe"; type: MappingPropertyDescriptor.Boolean; value: true }
    MappingPropertyDescriptor { id: displayMinuteMarkersStripe; path: "mapping.settings.displayMinuteMarkersStripe"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: displayRemainingTimeStripe; path: "mapping.settings.displayRemainingTimeStripe"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: displayDeckLetterStripe; path: "mapping.settings.displayDeckLetterStripe"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: displayResultingKey; path: "mapping.settings.displayResultingKey"; type: MappingPropertyDescriptor.Boolean; value: true }

    //Deck - Performance panel
    MappingPropertyDescriptor { id: panelMode; path: "mapping.settings.panelMode"; type: MappingPropertyDescriptor.Integer; value: 2; min: 0; max: 2 }
    MappingPropertyDescriptor { id: displayNumbersHotcuePanel; path: "mapping.settings.displayNumbersHotcuePanel"; type: MappingPropertyDescriptor.Boolean; value: true }

    //Remix Deck
    MappingPropertyDescriptor { id: showVolumeFaders; path: "mapping.settings.showVolumeFaders"; type: MappingPropertyDescriptor.Boolean; value: true }
    MappingPropertyDescriptor { id: showFilterFaders; path: "mapping.settings.showFilterFaders"; type: MappingPropertyDescriptor.Boolean; value: true }
    MappingPropertyDescriptor { id: showSlotIndicators; path: "mapping.settings.showSlotIndicators"; type: MappingPropertyDescriptor.Boolean; value: true }

//------------------------------------------------------------------------------------------------------------------
// TRAKTOR APP PROPERTIES
//------------------------------------------------------------------------------------------------------------------

    //Browser
    AppProperty { id: fullscreenBrowser; path:"app.traktor.browser.full_screen" }
    AppProperty { id: browserSortId; path: "app.traktor.browser.sort_id" }
    AppProperty { id: favoritesSelect; path: "app.traktor.browser.favorites.select" }

    //Preview Player
    AppProperty { id: previewPlayerIsLoaded; path: "app.traktor.browser.preview_player.is_loaded" }
    AppProperty { id: loadPreviewPlayer; path: "app.traktor.browser.preview_player.load" }
    AppProperty { id: unloadPreviewPlayer; path: "app.traktor.browser.preview_player.unload" }
    AppProperty { id: playPreviewPlayer; path: "app.traktor.browser.preview_player.play" }
    AppProperty { id: loadPlayPreviewPlayer; path: "app.traktor.browser.preview_player.load_or_play" }
    AppProperty { id: seekPreviewPlayer; path: "app.traktor.browser.preview_player.seek" }

    //FXs
    AppProperty { id: fxMode; path: "app.traktor.fx.4fx_units" }

    //Master
    AppProperty { id: masterId; path: "app.traktor.masterclock.source_id" } //-1: MasterClock, 0: Deck A, 1: Deck B, 2: Deck C, 3: Deck D
    AppProperty { id: masterMode; path: "app.traktor.masterclock.mode" }
    AppProperty { id: clockBpm; path: "app.traktor.masterclock.tempo" }

    //Master - Deck properties
    AppProperty { id: masterDeckType; path: "app.traktor.decks." + (masterId.value+1) + ".type" }
    AppProperty { id: masterResultingKeyIndex; path: "app.traktor.decks." + (masterId.value+1) + ".track.key.final_id" }

//------------------------------------------------------------------------------------------------------------------
// MODULES INITIALIZATION
//------------------------------------------------------------------------------------------------------------------

    S5 {
        name: "s5"
    }

    Mixer {
        name: "mixer"
        surface: "s5.mixer"
        shift: leftShift.value || rightShift.value
    }

    S5Side {
        id: left
        name: "left"
        topDeckId: 1
        bottomDeckId: 3
        surface: "s5.left"
        settingsPath: "mapping.settings.left"
        propertiesPath: "mapping.state.left"
        shift: (globalShift.value && globalShiftEnabled.value) || (leftShift.value && !globalShiftEnabled.value)
    }

    S5Side {
        id: right
        name: "right"
        topDeckId: 2
        bottomDeckId: 4
        surface: "s5.right"
        settingsPath: "mapping.settings.right"
        propertiesPath: "mapping.state.right"
        shift: (globalShift.value && globalShiftEnabled.value) || (rightShift.value && !globalShiftEnabled.value)
    }

    SettingsLoader {
        id: settingsLoader
    }

    onMappingLoaded: {
        left.initializeModule();
        right.initializeModule();
        settingsLoader.readTraktorSettings();
    }

//------------------------------------------------------------------------------------------------------------------
// CROSS-DISPLAY INTERACTION
//------------------------------------------------------------------------------------------------------------------

    //Focused Ids (necessary for duplicating decks)
    MappingPropertyDescriptor { id: leftFocusedDeckId; path: "mapping.state.leftFocusedDeckId"; type: MappingPropertyDescriptor.Integer; value: left.focusedDeckId }
    MappingPropertyDescriptor { id: rightFocusedDeckId; path: "mapping.state.rightFocusedDeckId"; type: MappingPropertyDescriptor.Integer; value: right.focusedDeckId }

    property bool leftScreenViewValue: left.screenView
    property bool rightScreenViewValue: right.screenView

    onLeftScreenViewValueChanged: {
        if (left.screenView == ScreenView.browser) {
            if (traktorRelatedBrowser.value) {
                fullscreenBrowser.value = true
            }
            if (!independentScreenBrowser.value && right.screenView == ScreenView.browser) {
                right.screenView = ScreenView.deck
            }
        }
        else if (left.screenView == ScreenView.deck) {
            if (traktorRelatedBrowser.value && right.screenView == ScreenView.deck) {
                fullscreenBrowser.value = false
            }
            if (right.screenView != ScreenView.browser) {
                unloadPreviewPlayer.value = true
            }
        }
    }
    onRightScreenViewValueChanged: {
        if (right.screenView == ScreenView.browser) {
            if (traktorRelatedBrowser.value) {
                fullscreenBrowser.value = true
            }
            if (!independentScreenBrowser.value && left.screenView == ScreenView.browser) {
                left.screenView = ScreenView.deck
            }
        }
        else if (right.screenView == ScreenView.deck) {
            if (traktorRelatedBrowser.value && left.screenView == ScreenView.deck) {
                fullscreenBrowser.value = false
            }
            if (left.screenView != ScreenView.browser) {
                unloadPreviewPlayer.value = true
            }
        }
    }
}
