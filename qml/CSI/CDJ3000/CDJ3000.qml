import CSI 1.0

import "../Common/Pioneer"
import "../../Preferences"

Mapping {
    id: mapping

//------------------------------------------------------------------------------------------------------------------
// TRAKTOR SETTINGS
//------------------------------------------------------------------------------------------------------------------

    //Settings - LED Brightness
    readonly property real bright: 1.0
    readonly property real dimmed: 0.0

//------------------------------------------------------------------------------------------------------------------
// MAPPING SETTINGS
//------------------------------------------------------------------------------------------------------------------

    CDJ3000Preferences { name: "preferences"; id: preferences }

    //Transport buttons
    MappingPropertyDescriptor { id: playButton; path: "mapping.state.vinylBreakEnabled"; type: MappingPropertyDescriptor.Integer; value: preferences.playButton }
    MappingPropertyDescriptor { id: shiftPlayButton; path: "mapping.state.shiftPlayButton"; type: MappingPropertyDescriptor.Integer; value: preferences.shiftPlayButton }
    MappingPropertyDescriptor { id: playBlinker; path: "mapping.state.cueBlinker"; type: MappingPropertyDescriptor.Boolean; value: preferences.cueBlinker }

    MappingPropertyDescriptor { id: cueButton; path: "mapping.state.cueButton"; type: MappingPropertyDescriptor.Integer; value: preferences.cueButton }
    MappingPropertyDescriptor { id: shiftCueButton; path: "mapping.state.shiftCueButton"; type: MappingPropertyDescriptor.Integer; value: preferences.shiftCueButton }
    MappingPropertyDescriptor { id: cueBlinker; path: "mapping.state.cueBlinker"; type: MappingPropertyDescriptor.Boolean; value: preferences.cueBlinker }

    //Vinyl Break
    MappingPropertyDescriptor { id: vinylBreakInBeats; path: "mapping.settings.vinylBreakInBeats"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: vinylBreakDurationInBeats; path: "mapping.settings.vinylBreakDurationInBeats"; type: MappingPropertyDescriptor.Integer; value: 1; min: 0; max: 64 }
    MappingPropertyDescriptor { id: vinylBreakDurationInSeconds; path: "mapping.state.vinylBreakDurationInSeconds"; type: MappingPropertyDescriptor.Integer; value: preferences.vinylBreakDuration; min: 0; max: 30000 }

    //Key Sync
    MappingPropertyDescriptor { id: fuzzyKeySync; path: "mapping.state.keyMatchOppositeAdjacents"; type: MappingPropertyDescriptor.Boolean; value: preferences.fuzzyKeySync }
    MappingPropertyDescriptor { id: useKeyText; path: "mapping.state.useKeyText"; type: MappingPropertyDescriptor.Boolean; value: preferences.useKeyText }

    //Pads - Others
    MappingPropertyDescriptor { id: hotcuesPlayMode; path: "mapping.settings.hotcuesPlayMode"; type: MappingPropertyDescriptor.Boolean; value: preferences.hotcuesPlayMode }

    //Mods
    MappingPropertyDescriptor { id: beatmatchPracticeMode; path: "mapping.state.beatmatchPracticeMode"; type: MappingPropertyDescriptor.Boolean; value: false }

    //Timers
    MappingPropertyDescriptor { id: holdTimer; path: "mapping.state.holdTimer"; type: MappingPropertyDescriptor.Integer; value: preferences.holdTimer; min: 50; max: 3000 }

    //Pioneer mods
    MappingPropertyDescriptor { id: reloopMode; path: "mapping.state.reloopMode"; type: MappingPropertyDescriptor.Boolean; value: preferences.reloopMode }
    MappingPropertyDescriptor { id: quantizedLoopSizes; path: "mapping.state.quantizedLoopSizes"; type: MappingPropertyDescriptor.Boolean; value: preferences.quantizedLoopSizes }
    MappingPropertyDescriptor { id: needleLock; path: "mapping.state.needleLock"; type: MappingPropertyDescriptor.Boolean; value: preferences.needleLock }

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

    CDJ3000 { name: "surface" }

    DeckSelectionModule { name: "deck_selection"; id: deckSelection }

    CDJ3000Deck { name:"deck_a"; id: deckA; deckId: 1; active: deckSelection.selectedDeck === 1 }
    CDJ3000Deck { name:"deck_b"; id: deckB; deckId: 2; active: deckSelection.selectedDeck === 2 }
    CDJ3000Deck { name:"deck_c"; id: deckC; deckId: 3; active: deckSelection.selectedDeck === 3 }
    CDJ3000Deck { name:"deck_d"; id: deckD; deckId: 4; active: deckSelection.selectedDeck === 4 }

}
