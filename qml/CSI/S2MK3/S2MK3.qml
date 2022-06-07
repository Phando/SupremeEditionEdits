import CSI 1.0
import QtQuick 2.12

import "../../Defines"
import "../Common/Settings"
import "../../Preferences"

Mapping {

//------------------------------------------------------------------------------------------------------------------
// TRAKTOR SETTINGS
//------------------------------------------------------------------------------------------------------------------

    MappingPropertyDescriptor { path: "mapping.settings.tempo_fader_relative"; type: MappingPropertyDescriptor.Boolean; value: true }
    MappingPropertyDescriptor { id: scratchOnTouch; path: "mapping.settings.scratch_on_touch"; type: MappingPropertyDescriptor.Boolean; value: true }
    MappingPropertyDescriptor { id: navigateFavoritesOnShiftSetting; path: "mapping.settings.browse_shift_fav_navigation"; type: MappingPropertyDescriptor.Boolean; value: true }

    //Settings - LED Brightness
    readonly property real bright: 1.0
    readonly property real dimmed: 0.0

//------------------------------------------------------------------------------------------------------------------
// MAPPING SETTINGS
//------------------------------------------------------------------------------------------------------------------

    S2MK3Preferences { name: "preferences"; id: preferences }

    //Shift
    MappingPropertyDescriptor { id: globalShiftEnabled; path: "mapping.state.globalShift"; type: MappingPropertyDescriptor.Boolean; value: preferences.globalShift }
    MappingPropertyDescriptor { id: globalShift; path: "mapping.state.shift"; type: MappingPropertyDescriptor.Boolean; value: false }
    Wire { from: "s2mk3.left.shift"; to: DirectPropertyAdapter { path: "mapping.state.shift" } enabled: globalShiftEnabled.value }
    Wire { from: "s2mk3.right.shift"; to: DirectPropertyAdapter { path: "mapping.state.shift" } enabled: globalShiftEnabled.value }

    MappingPropertyDescriptor { id: leftShift; path: "mapping.state.left.shift"; type: MappingPropertyDescriptor.Boolean; value: false }
    Wire { from: "s2mk3.left.shift"; to: DirectPropertyAdapter { path: "mapping.state.left.shift" } enabled: !globalShiftEnabled.value }

    MappingPropertyDescriptor { id: rightShift; path: "mapping.state.right.shift"; type: MappingPropertyDescriptor.Boolean; value: false }
    Wire { from: "s2mk3.right.shift"; to: DirectPropertyAdapter { path: "mapping.state.right.shift" } enabled: !globalShiftEnabled.value }

    //Mixer
    MappingPropertyDescriptor { id: filterFX; path: "mapping.state.filterFX"; type: MappingPropertyDescriptor.Boolean; value: preferences.filterFX }
    MappingPropertyDescriptor { id: individualFXs; path: "mapping.state.individualFXs"; type: MappingPropertyDescriptor.Boolean; value: preferences.individualFXs }
    MappingPropertyDescriptor { id: precueButton; path: "mapping.state.precueButton"; type: MappingPropertyDescriptor.Integer; value: preferences.precueButton }
    MappingPropertyDescriptor { id: shiftPrecueButton; path: "mapping.state.shiftPrecueButton"; type: MappingPropertyDescriptor.Integer; value: preferences.shiftPrecueButton }
    MappingPropertyDescriptor { id: mixerFXsBlinkers; path: "mapping.state.mixerFXsBlinkers"; type: MappingPropertyDescriptor.Boolean; value: preferences.mixerFXsBlinkers }

    //Transport buttons
    MappingPropertyDescriptor { id: playButton; path: "mapping.state.vinylBreakEnabled"; type: MappingPropertyDescriptor.Integer; value: preferences.playButton }
    MappingPropertyDescriptor { id: shiftPlayButton; path: "mapping.state.shiftPlayButton"; type: MappingPropertyDescriptor.Integer; value: preferences.shiftPlayButton }
    MappingPropertyDescriptor { id: playBlinker; path: "mapping.state.cueBlinker"; type: MappingPropertyDescriptor.Boolean; value: preferences.cueBlinker }

    MappingPropertyDescriptor { id: cueButton; path: "mapping.state.cueButton"; type: MappingPropertyDescriptor.Integer; value: preferences.cueButton }
    MappingPropertyDescriptor { id: shiftCueButton; path: "mapping.state.shiftCueButton"; type: MappingPropertyDescriptor.Integer; value: preferences.shiftCueButton }
    MappingPropertyDescriptor { id: cueBlinker; path: "mapping.state.cueBlinker"; type: MappingPropertyDescriptor.Boolean; value: preferences.cueBlinker }

    MappingPropertyDescriptor { id: faderStart; path: "mapping.state.faderStart"; type: MappingPropertyDescriptor.Boolean; value: preferences.faderStart }
    MappingPropertyDescriptor { id: reverseCensor; path: "mapping.state.reverseCensor"; type: MappingPropertyDescriptor.Boolean; value: preferences.reverseCensor }
    MappingPropertyDescriptor { id: shiftKeyLockButton; path: "mapping.settings.shiftKeyLockButton"; type: MappingPropertyDescriptor.Integer; value: 0; min: 0; max: 2 } //Key sync, tempo reset or nothing?

    //Vinyl Break
    MappingPropertyDescriptor { id: vinylBreakInBeats; path: "mapping.settings.vinylBreakInBeats"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: vinylBreakDurationInBeats; path: "mapping.settings.vinylBreakDurationInBeats"; type: MappingPropertyDescriptor.Integer; value: 1; min: 0; max: 64 }
    MappingPropertyDescriptor { id: vinylBreakDurationInSeconds; path: "mapping.state.vinylBreakDurationInSeconds"; type: MappingPropertyDescriptor.Integer; value: preferences.vinylBreakDuration; min: 0; max: 30000 }

    //Key Sync
    MappingPropertyDescriptor { id: fuzzyKeySync; path: "mapping.state.keyMatchOppositeAdjacents"; type: MappingPropertyDescriptor.Boolean; value: preferences.fuzzyKeySync }
    MappingPropertyDescriptor { id: useKeyText; path: "mapping.state.useKeyText"; type: MappingPropertyDescriptor.Boolean; value: preferences.useKeyText }

    //Encoders
    MappingPropertyDescriptor { id: browseEncoder; path: "mapping.state.browseEncoder"; type: MappingPropertyDescriptor.Integer; value: preferences.browseEncoder; min: 0; max: 3 } //0: BPM, 1: Tempo, 2: Waveform Zoom, 3: Playlist Navigation
    MappingPropertyDescriptor { id: browsePush; path: "mapping.state.browsePush"; type: MappingPropertyDescriptor.Integer; value: preferences.browsePush; min: 0; max: 6 } //0: Load Track, 1: Instant Doubles, 2: Load Next Track, 3: Load Previous Track, 4: BPM/Tempo Reset, 5: Load/Play to Preview Player, 6: Play/Pause Preview Player
    MappingPropertyDescriptor { id: shiftBrowseEncoder; path: "mapping.state.shiftBrowseEncoder"; type: MappingPropertyDescriptor.Integer; value: preferences.shiftBrowseEncoder; min: 0; max: 3 } //0: BPM, 1: Tempo, 2: Waveform Zoom, 3: Tree/Favourites Navigation
    MappingPropertyDescriptor { id: shiftBrowsePush; path: "mapping.state.shiftBrowsePush"; type: MappingPropertyDescriptor.Integer; value: preferences.shiftBrowsePush; min: 0; max: 6 } //0: Open/Collapse tree node, 1: Instant Doubles, 2: Load Next Track, 3: Load Previous Track, 4: BPM/Tempo Reset, 5: Load/Play to Preview Player, 6: Play/Pause Preview Player

    MappingPropertyDescriptor { id: stepBpm; path: "mapping.state.stepBpm"; type: MappingPropertyDescriptor.Float; value: preferences.stepBPM; min: 0.01; max: 5.00 }
    MappingPropertyDescriptor { id: stepShiftBpm; path: "mapping.state.stepShiftBpm"; type: MappingPropertyDescriptor.Float; value: preferences.stepShiftBPM; min: 0.01; max: 5.00 }
    MappingPropertyDescriptor { id: stepTempo; path: "mapping.state.stepTempo"; type: MappingPropertyDescriptor.Float; value: preferences.stepTempo; min: 0.0005; max: 0.1 }
    MappingPropertyDescriptor { id: stepShiftTempo; path: "mapping.state.stepShiftTempo"; type: MappingPropertyDescriptor.Float; value: 0.001; min: 0.0005; max: 0.1 }

    //Pads - Mode Selector
    MappingPropertyDescriptor { id: shiftHotcueButton; path: "mapping.state.shiftHotcueButton"; type: MappingPropertyDescriptor.Integer; value: preferences.shiftHotcueButton; min: 0; max: 4 }
    //MappingPropertyDescriptor { id: samplesButton; path: "mapping.state.samplesButton"; type: MappingPropertyDescriptor.Integer; value: preferences.samplesButton; min: 0; max: 1 }
    //MappingPropertyDescriptor { id: shiftSamplesButton; path: "mapping.state.shiftSamplesButton"; type: MappingPropertyDescriptor.Integer; value: preferences.shiftSamplesButton; min: 0; max: 1 }

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
    MappingPropertyDescriptor { id: hotcuesPlayMode; path: "mapping.settings.hotcuesPlayMode"; type: MappingPropertyDescriptor.Boolean; value: preferences.hotcuesPlayMode }
    MappingPropertyDescriptor { id: slotSelectorMode; path: "mapping.settings.slotSelectorMode"; type: MappingPropertyDescriptor.Integer; value: 2; min: 0; max: 2 }
    MappingPropertyDescriptor { id: hotcueColors; path: "mapping.settings.hotcueColors"; type: MappingPropertyDescriptor.Integer; value: preferences.hotcueColors }

    //Mods
    MappingPropertyDescriptor { id: fixBPMControl; path: "mapping.settings.fixBPMControl"; type: MappingPropertyDescriptor.Boolean; value: true }
    MappingPropertyDescriptor { id: fixHotcueTrigger; path: "mapping.settings.fixHotcueTrigger"; type: MappingPropertyDescriptor.Boolean; value: true }
    MappingPropertyDescriptor { id: beatmatchPracticeMode; path: "mapping.state.beatmatchPracticeMode"; type: MappingPropertyDescriptor.Boolean; value: false }

    //Timers
    MappingPropertyDescriptor { id: holdTimer; path: "mapping.state.holdTimer"; type: MappingPropertyDescriptor.Integer; value: preferences.holdTimer; min: 50; max: 3000 }
    MappingPropertyDescriptor { id: browserTimer; path: "mapping.state.browserTimer"; type: MappingPropertyDescriptor.Integer; value: preferences.browserTimer; min: 100; max: 10000 }

    //Other Settings
    MappingPropertyDescriptor { id: browserOnFullScreenOnly; path: "mapping.state.browserOnFullScreenOnly"; type: MappingPropertyDescriptor.Boolean; value: preferences.browserOnFullScreenOnly }
    MappingPropertyDescriptor { id: showBrowserOnTouch; path: "mapping.state.show_browser_on_touch"; type: MappingPropertyDescriptor.Boolean; value: preferences.showBrowserOnTouch }
    MappingPropertyDescriptor { id: autocloseBrowser; path: "mapping.state.autoclose_browser"; type: MappingPropertyDescriptor.Boolean; value: preferences.autocloseBrowser }
    MappingPropertyDescriptor { id: autoZoomTPwaveform; path: "mapping.state.autoZoomTPwaveform"; type: MappingPropertyDescriptor.Boolean; value: preferences.autoZoomTPwaveform }

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

    S2MK3 {
        name: "s2mk3"
    }

    Mixer {
        name: "mixer"
        surface: "s2mk3.mixer"
        shift: (globalShift.value && globalShiftEnabled.value) || ((leftShift.value || rightShift.value) && !globalShiftEnabled.value)
        leftShift: leftShift.value //Necessary for controling FXs on the S2
        rightShift: rightShift.value //Necessary for controling FXs on the S2
    }

    S2MK3Side {
        id: left
        name: "left"
        topDeckId: 1
        bottomDeckId: 3
        surface: "s2mk3.left"
        settingsPath: "mapping.settings.left"
        propertiesPath: "mapping.state.left"
        shift: (globalShift.value && globalShiftEnabled.value) || (leftShift.value && !globalShiftEnabled.value)
    }

    S2MK3Side {
        id: right
        name: "right"
        topDeckId: 2
        bottomDeckId: 4
        surface: "s2mk3.right"
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
}
