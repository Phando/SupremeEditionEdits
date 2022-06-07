import CSI 1.0
import QtQuick 2.12

import "../../Defines"
import "../Common/MK3Controllers"
import "../Common/PadsModes"
import "../../Helpers/LED.js" as LED
import "../S2MK3" as S2

Module {
    id: deck
    property bool active: true
    property int deckId: 1
    property string surface: "path"
    property bool enablePads: false

    property alias deckType: deckType.value
    property alias padsMode: padsMode.value

    //Helper properties
    property string deckSettingsPath: settingsPath + "." + deckId
    property string deckPropertiesPath: propertiesPath + "." + deckId
    property bool footerControlled: footerId == deckId
    property bool remixControlled: remixId == deckId

    readonly property var deckLEDColor: LED.getLED(deckColor(deckId))
    function deckColor(deckId) {
        switch (deckId) {
            case 1: return preferences.deckAColor
            case 2: return preferences.deckBColor
            case 3: return preferences.deckCColor
            case 4: return preferences.deckDColor
        }
    }

//------------------------------------------------------------------------------------------------------------------
// APP PROPERTIES
//------------------------------------------------------------------------------------------------------------------

    //State properties
    AppProperty { id: directThru; path: "app.traktor.decks." + deckId + ".direct_thru";
        onValueChanged: {
            if (active && directThru.value) activePadsMode.value = PadsMode.disabled
            else if (remixControlled && (activePadsMode.value == PadsMode.remix || activePadsMode.value == PadsMode.legacyRemix) && directThru.value) activePadsMode.value = focusedDeck().defaultPadsMode()
            else if (active && !directThru.value) defaultPadsMode()
        }
    }
    AppProperty { id: deckType; path: "app.traktor.decks." + deckId + ".type"; onValueChanged: { updatePads() } } //0: Track, 1: Remix, 2: Stem, 3: Live
    AppProperty { path: "app.traktor.decks." + deckId + ".is_loaded_signal";
        onValueChanged: {
            if (value) fullscreenBrowser.value = false
            if (active) { activePadsMode.value = defaultPadsMode() } //add option to reset pads mode on load
            updatePads()
        }
    }
    AppProperty { id: isLoaded; path: "app.traktor.decks." + deckId + ".is_loaded"; onValueChanged: updatePads() } //like this, the pads aren't reset when deck is load, WIP
    AppProperty { id: volume; path: "app.traktor.mixer.channels." + deckId + ".volume" }

    //Transport
    AppProperty { id: isRunning; path: "app.traktor.decks." + deckId + ".running" }
    AppProperty { id: isPlaying; path: "app.traktor.decks." + deckId + ".play" }
    AppProperty { id: isCueing; path: "app.traktor.decks." + deckId + ".cue" }
    AppProperty { id: isCuePlaying; path: "app.traktor.decks." + deckId + ".cup" }
    AppProperty { id: cuePosition; path: "app.traktor.decks." + deckId + ".track.cue.active.start_pos" }
    AppProperty { id: playheadPosition; path: "app.traktor.decks."  + deckId + ".track.player.playhead_position" }
    AppProperty { id: elapsedTime; path: "app.traktor.decks." + deckId + ".track.player.elapsed_time" }
    readonly property real timeTolerance: 0.001 // seconds
    readonly property bool isAtBeginning: elapsedTime.value < timeTolerance
    property bool activeCueWithPlayhead: Math.abs(cuePosition.value - playheadPosition.value) < timeTolerance

    //Loop
    AppProperty { id: loopActive; path: "app.traktor.decks."+ deckId + ".loop.active" }
    AppProperty { id: isInActiveLoop; path: "app.traktor.decks."+ deckId + ".loop.is_in_active_loop"; onValueChanged: { loopInAdjust.value = false; loopOutAdjust.value = false } }

    //Move
    AppProperty { id: move; path: "app.traktor.decks." + deckId + ".move" }
    AppProperty { id: moveMode; path: "app.traktor.decks." + deckId + ".move.mode" }
    AppProperty { id: moveSize; path: "app.traktor.decks." + deckId + ".move.size" }

    //Flux
    AppProperty { id: fluxEnabled; path: "app.traktor.decks." + deckId + ".flux.enabled" }
    AppProperty { id: fluxState; path: "app.traktor.decks." + deckId + ".flux.state" }

    //Tempo & BPM
    AppProperty { id: isSyncEnabled; path: "app.traktor.decks." + deckId + ".sync.enabled" }
    AppProperty { id: tempobend; path: "app.traktor.decks." + deckId + ".tempobend.stepless" }

    AppProperty { id: stableTempo; path: "app.traktor.decks." + deckId + ".tempo.true_tempo" }
    AppProperty { id: tempo; path: "app.traktor.decks." + deckId + ".tempo.tempo_for_display" }
    AppProperty { id: tempoPhase; path: "app.traktor.decks." + deckId + ".tempo.phase" }
    AppProperty { id: tempoRange; path: "app.traktor.decks." + deckId + ".tempo.range_value" }
    readonly property double phase: (tempoPhase.value*2).toFixed(4)
    readonly property bool syncInPhase: phase >= -0.0315 && phase <= 0.0315
    readonly property bool syncInRange: Math.abs(stableTempo.value-1).toFixed(4) <= tempoRange.value.toFixed(4)

    //Key
    AppProperty { id: key; path: "app.traktor.decks." + deckId + ".content.musical_key" }
    AppProperty { id: keyText; path: "app.traktor.decks." + deckId + ".content.legacy_key" }
    AppProperty { id: keyIndex; path: "app.traktor.decks." + deckId + ".content.key_index" }
    AppProperty { id: keyLock; path: "app.traktor.decks." + deckId + ".track.key.lock_enabled"; onValueChanged: { if (!keyLock.value) keyAdjust.value = 0 } }
    AppProperty { id: keyAdjust; path: "app.traktor.decks." + deckId + ".track.key.adjust" }
    AppProperty { id: resultingKey; path: "app.traktor.decks." + deckId + ".track.key.resulting.quantized" }
    AppProperty { id: resultingKeyIndex; path: "app.traktor.decks." + deckId + ".track.key.final_id" }
    property int keyTextIndex: useKeyText.value ? Key.getKeyTextId(keyText.value, keyAdjust.value) : resultingKeyIndex.value
    property double keyTextOffset: useKeyText.value ? KeySync.sync(resultingKeyIndex.value, Key.getKeyTextId(keyText.value, keyAdjust.value), false) : 0

    //Freeze Properties
    AppProperty { id: sliceCount; path: "app.traktor.decks." + deckId + ".freeze.slice_count" }
    AppProperty { id: freezeEnabled; path: "app.traktor.decks." + deckId + ".freeze.enabled";
        onValueChanged: {
            if (value) {
                sliceCount.value = 8
            }
        }
    }

    //Track Properties
    AppProperty { id: waveformZoom; path: "app.traktor.decks." + deckId + ".track.waveform_zoom" }
    AppProperty { id: gridLock; path: "app.traktor.decks." + deckId + ".track.grid.lock_bpm" }
    AppProperty { id: gridAdjust; path: "app.traktor.decks." + deckId + ".track.gridmarker.move" }

    //Remix Properties
    AppProperty { id: remixPage; path: "app.traktor.decks." + deckId + ".remix.page";
        onValueChanged: {
            if (remixPadsControl.value != remixPage.value*2 + remixPadsFocus.value) {
                remixPadsControl.value = remixPage.value*2 + remixPadsFocus.value
            }
        }
    }

    //Traktor Pro Advanced Panel
    AppProperty { id: advancedPanel; path: "app.traktor.decks." + deckId + ".view.select_advanced_panel" } //0: Hotcues, 1: Loop, 2: Grid
    function updateAdvancedPanelView() {
        if (hasDeckProperties){ //add preference to enable this features
            if (!holdGrid.value && !editMode.value){
                if (padsMode.value == PadsMode.loop || padsMode.value == PadsMode.advancedLoop) advancedPanel.value = 0
                else advancedPanel.value = 1
            }
            else {
                advancedPanel.value = 2
            }
        }
    }

//------------------------------------------------------------------------------------------------------------------
// MAPPING PROPERTIES
//------------------------------------------------------------------------------------------------------------------

    MappingPropertyDescriptor { id: jogMode; path: deckPropertiesPath + ".jog_mode"; type: MappingPropertyDescriptor.Integer }

    //StemDeck Properties
    MappingPropertyDescriptor { id: stemView; path: deckPropertiesPath + ".stem_deck_style"; type: MappingPropertyDescriptor.Integer; value: StemStyle.daw }

    //RemixDeck Properties
    MappingPropertyDescriptor { id: legacyRemixMode; path: deckSettingsPath + ".legacyRemixMode"; type: MappingPropertyDescriptor.Boolean; value: true;
        onValueChanged: {
            if (legacyRemixMode.value) {
                remixPadsControl.value = remixPage.value*2 + remixPadsFocus.value
            }
        }
    }
    MappingPropertyDescriptor { id: remixPadsFocus; path: deckPropertiesPath + ".remixPadsFocus"; type: MappingPropertyDescriptor.Integer; value: 1; min: 1; max: 2 }
    MappingPropertyDescriptor { id: remixPadsControl; path: deckPropertiesPath + ".remixPadsControl"; type: MappingPropertyDescriptor.Integer; value: 1; min: 1; max: 8 }

    //Sequencer Properties
    MappingPropertyDescriptor { id: sequencerMode; path: deckPropertiesPath + ".sequencerMode"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: sequencerSlot; path: deckPropertiesPath + ".sequencerSlot"; type: MappingPropertyDescriptor.Integer; value: 1; min: 1; max: 4 }
    MappingPropertyDescriptor { id: sequencerPage; path: deckPropertiesPath + ".sequencerPage"; type: MappingPropertyDescriptor.Integer; value: 1; min: 1; max: 2 }
    MappingPropertyDescriptor { id: sequencerSampleLockSlot1; path: deckPropertiesPath + ".sequencerSampleLockSlot1"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: sequencerSampleLockSlot2; path: deckPropertiesPath + ".sequencerSampleLockSlot2"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: sequencerSampleLockSlot3; path: deckPropertiesPath + ".sequencerSampleLockSlot3"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: sequencerSampleLockSlot4; path: deckPropertiesPath + ".sequencerSampleLockSlot4"; type: MappingPropertyDescriptor.Boolean; value: false }

    //Helper Properties
    property bool hasDeckProperties: (deckType.value == DeckType.Track || deckType.value == DeckType.Stem || deckType.value == DeckType.Remix) && !directThru.value
    property bool hasTrackProperties: (deckType.value == DeckType.Track || deckType.value == DeckType.Stem) && !directThru.value
    property bool hasRemixProperties: deckType.value == DeckType.Remix && !directThru.value
    property bool hasStemProperties: deckType.value == DeckType.Stem && !directThru.value

    property bool hasBottomControls: hasRemixProperties || hasStemProperties
    property bool hasRMXControls: hasRemixProperties && !sequencerMode.value
    property bool hasSQCRControls: hasRemixProperties && sequencerMode.value
    property bool hasEditMode: hasTrackProperties && isLoaded.value
    property bool hasEffects: !directThru.value

    //HW State Properties
    MappingPropertyDescriptor { id: loopInAdjust; path: deckPropertiesPath + ".loopInAdjust"; type: MappingPropertyDescriptor.Boolean; value: false; onValueChanged: { if (value) loopOutAdjust.value = false } }
    MappingPropertyDescriptor { id: loopOutAdjust; path: deckPropertiesPath + ".loopOutAdjust"; type: MappingPropertyDescriptor.Boolean; value: false; onValueChanged: { if (value) loopInAdjust.value = false } }
    MappingPropertyDescriptor { id: holdSamples; path: propertiesPath + ".holdSamples"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: slotState; path: deckPropertiesPath + ".slot_selector_mode.any"; type: MappingPropertyDescriptor.Boolean; value: slot1Selected.value || slot2Selected.value || slot3Selected.value || slot4Selected.value }
    property bool holdKeyLock: transport.holdKeyLock

//------------------------------------------------------------------------------------------------------------------
// ENCODERS
//------------------------------------------------------------------------------------------------------------------

    //Loop Encoder State
    MappingPropertyDescriptor { id: performanceEncoderControls; path: deckPropertiesPath + ".performanceEncoderControls"; type: MappingPropertyDescriptor.Integer; value: 2 } //property necessary for the S5... if not present on the S8, error due to being present in the ScreenButtons shared module.

    S3BrowseEncoder {
        name: "browse"
        active: deck.active
        deckId: deck.deckId
        surface: deck.surface
    }

    S2.S2MK3LoopMoveEncoder {
        name: "loopMove"
        active: deck.active
        deckId: deck.deckId
        surface: deck.surface
    }

    S2.S2MK3LoopSizeEncoder {
        name: "loopSize"
        active: deck.active
        deckId: deck.deckId
        surface: deck.surface
    }

//------------------------------------------------------------------------------------------------------------------
// PADS MODES
//------------------------------------------------------------------------------------------------------------------

    //Slot State
    MappingPropertyDescriptor { id: slot1Selected; path: deckPropertiesPath + ".slot_selector_mode.1"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: slot2Selected; path: deckPropertiesPath + ".slot_selector_mode.2"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: slot3Selected; path: deckPropertiesPath + ".slot_selector_mode.3"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: slot4Selected; path: deckPropertiesPath + ".slot_selector_mode.4"; type: MappingPropertyDescriptor.Boolean; value: false }

    //MOD: Auto-enable Flux when entering Loop Roll mode
    property bool loopRollAccessed: false
    property bool fluxActive: fluxEnabled.value
    onFluxActiveChanged: { if ((padsMode.value != PadsMode.loopRoll && !loopRollAccessed) || (padsMode.value != PadsMode.loopRoll && !fluxEnabled.value)) previousFluxState.value = fluxEnabled.value }
    MappingPropertyDescriptor { id: previousFluxState; path: deckPropertiesPath + ".previousFluxState"; type: MappingPropertyDescriptor.Boolean; value: false }

    MappingPropertyDescriptor { id: padsMode; path: deckPropertiesPath + ".pads_mode"; type: MappingPropertyDescriptor.Integer; value: PadsMode.disabled;
        onValueChanged: {
            if (padsMode.value == PadsMode.legacyRemix) {
                legacyRemixMode.value = true
            }
            else if (padsMode.value == PadsMode.remix) {
                legacyRemixMode.value = false
            }

            if (padsMode.value == PadsMode.sequencer) {
                sequencerMode.value = true
            }
            else {
                sequencerMode.value = false
            }

            if (padsMode.value == PadsMode.freeze) {
                freezeEnabled.value = true
            }
            else {
                freezeEnabled.value = false
            }

            if (padsMode.value == PadsMode.loopRoll && enableFluxOnLoopRoll.value) {
                loopRollAccessed = true
                fluxEnabled.value = true
            }
            else if (loopRollAccessed) {
                fluxEnabled.value = previousFluxState.value
                loopRollAccessed = false
            }
            updateAdvancedPanelView()
        }
    }

    function validatePadsMode(padsMode) {
        switch (padsMode) {
            case PadsMode.hotcues:
            case PadsMode.tonePlay:
                return hasTrackProperties
            case PadsMode.loop:
            case PadsMode.advancedLoop:
            case PadsMode.loopRoll:
            case PadsMode.freeze:
                return hasDeckProperties
            case PadsMode.legacyRemix:
            case PadsMode.remix:
            case PadsMode.sequencer:
                return hasRemixProperties
            case PadsMode.stems:
                return hasStemProperties
            case PadsMode.effects:
                return !directThru.value
            case PadsMode.disabled:
                return true
        }
    }

    function defaultPadsMode() {
        if (directThru.value) {
            return PadsMode.disabled
        }
        else {
            if (deckType.value == DeckType.Track || deckType.value == DeckType.Stem) {
                return PadsMode.hotcues
            }
            else if (deckType.value == DeckType.Remix) {
                if (legacyRemixMode.value) return PadsMode.legacyRemix
                else return PadsMode.remix
            }
            else if (deckType.value == DeckType.Live) {
                return PadsMode.effects //PadsMode.disabled
            }
        }
    }

    S2.S2MK3PadsModeButtons {
        name: "padsModeButtons"
        active: deck.active
        deckId: deck.deckId
        surface: deck.surface
    }

    HotcuesMode {
        name: "hotcuesMode"
        active: activePadsMode.value == PadsMode.hotcues && enablePads
        deckId: deck.deckId
        surface: deck.surface
    }
    //Hotcue Type Selector (Hotcue Button Acts as a 2nd Shift)
    //MappingPropertyDescriptor { id: selectedHotcue; path: deckPropertiesPath + ".selectedHotcue"; type: MappingPropertyDescriptor.Integer; value: 0; onValueChanged: { if (selectedHotcue.value != 0) screenOverlay.value = Overlay.hotcueType } }
    //MappingPropertyDescriptor { id: hotcueModifier; path: deckPropertiesPath + ".hotcueModifier"; type: MappingPropertyDescriptor.Boolean; value: false }
    //Wire { from: "%surface%.hotcues"; to: HoldPropertyAdapter { path: hotcueModifier.path; output: false } enabled: activePadsMode.value == PadsMode.hotcues }

    TonePlayMode {
        name: "tonePlayMode"
        active: activePadsMode.value == PadsMode.tonePlay && enablePads
        deckId: deck.deckId
        surface: deck.surface
    }

    FreezeMode {
        name: "freezeMode"
        active: activePadsMode.value == PadsMode.freeze && enablePads
        deckId: deck.deckId
        surface: deck.surface
    }

    LoopMode {
        name: "loopMode"
        active: activePadsMode.value == PadsMode.loop && enablePads
        deckId: deck.deckId
        surface: deck.surface
    }

    AdvancedLoopMode {
        name: "advancedLoopMode"
        active: activePadsMode.value == PadsMode.advancedLoop && enablePads
        deckId: deck.deckId
        surface: deck.surface
    }

    LoopRollMode {
        name: "loopRollMode"
        active: activePadsMode.value == PadsMode.loopRoll && enablePads
        deckId: deck.deckId
        surface: deck.surface
    }

    LegacyRemixMode {
        name: "legacyRemixMode"
        active: activePadsMode.value == PadsMode.legacyRemix && enablePads
        deckId: deck.deckId
        surface: deck.surface
        browsing: fullscreenBrowser.value
    }

    RemixMode {
        name: "remixMode"
        active: activePadsMode.value == PadsMode.remix && enablePads
        deckId: deck.deckId
        surface: deck.surface
        browsing: fullscreenBrowser.value
    }

    SequencerMode {
        name: "sequencerMode"
        active: activePadsMode.value == PadsMode.sequencer && enablePads
        deckId: deck.deckId
        surface: deck.surface
    }

    StemsMode {
        name: "stemsMode"
        active: activePadsMode.value == PadsMode.stems && enablePads
        deckId: deck.deckId
        surface: deck.surface
    }

    PadFXsMode {
        name: "effectsMode"
        active: activePadsMode.value == PadsMode.effects && enablePads
        deckId: deck.deckId
        surface: deck.surface
    }

//------------------------------------------------------------------------------------------------------------------
// TRANSPORT CONTROLS
//------------------------------------------------------------------------------------------------------------------

    S2.S2MK3TransportButtons {
        id: transport
        name: "transport"
        active: deck.active
        surface: deck.surface
        deckId: deck.deckId
    }

    S3JogWheel {
        name: "jogwheel"
        active: deck.active
        surface: deck.surface
        deckId: deck.deckId
    }

    //Grid Button
    property bool gridPressed: false
    Blinker { name: "GridBlinker"; cycle: 250; color: deckLEDColor; defaultBrightness: dimmed; blinkBrightness: bright }

    WiresGroup {
        enabled: active

        Wire { from: "%surface%.grid_adjust"; to: HoldPropertyAdapter { path: holdGrid.path; value: true } enabled: !shift }
        Wire { from: "%surface%.grid_adjust"; to: TogglePropertyAdapter { path: editMode.path; value: true; output: false } enabled: shift }
        Wire { from: "%surface%.grid_adjust.led"; to: "GridBlinker"; enabled: shift }
        Wire { from: "GridBlinker.trigger"; to: ExpressionAdapter { type: ExpressionAdapter.Boolean; expression: editMode.value } }
    }

    property double preEditZoom: -0.75
    AppProperty { id: enableTick; path: "app.traktor.decks." + deckId + ".track.grid.enable_tick" }
    MappingPropertyDescriptor { id: holdGrid; path: deckPropertiesPath + ".holdGrid"; type: MappingPropertyDescriptor.Boolean; value: false;
        onValueChanged: {
            updateAdvancedPanelView()
        }
    }
    MappingPropertyDescriptor { id: editMode; path: propertiesPath + ".edit_mode"; type: MappingPropertyDescriptor.Boolean; value: false;
        onValueChanged: {
            updateAdvancedPanelView()

            if (autoZoomTPwaveform.value) {
                /*
                if (editMode.value) {
                    preEditZoom = waveformZoom.value
                    waveformZoom.value = isRunning.value ?  -0.25 : 1.00
                }
                else {
                    waveformZoom.value = preEditZoom
                }
                */
            }

            enableTick.value = editMode.value
        }
    }
}
