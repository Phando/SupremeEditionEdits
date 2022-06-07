import CSI 1.0
import QtQuick 2.12

import "../../Defines"
import "../Common/LegacyControllers"
import "../Common/PadsModes"

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

//------------------------------------------------------------------------------------------------------------------
// APP PROPERTIES
//------------------------------------------------------------------------------------------------------------------

    //State properties
    AppProperty { id: directThru; path: "app.traktor.decks." + deckId + ".direct_thru";
        onValueChanged: {
            if (active && directThru.value) activePadsMode.value = PadsMode.disabled
            else if (remixControlled && (activePadsMode.value == PadsMode.remix || activePadsMode.value == PadsMode.legacyRemix) && directThru.value) activePadsMode.value = focusedDeck().defaultPadsMode()
            else if (active && !directThru.value) activePadsMode.value = padsMode.value //defaultPadsMode()
            else { updatePads() }
        }
    }
    AppProperty { id: deckType; path: "app.traktor.decks." + deckId + ".type";
        onValueChanged: {
            if (active) {
                activePadsMode.value = defaultPadsMode()
            }
            updatePads()
            updateFooterPage()
        }
    }
    AppProperty { path: "app.traktor.decks." + deckId + ".is_loaded_signal";
        onValueChanged: {
            if (screenView.value == ScreenView.browser) {
                screenView.value = ScreenView.deck
                if (active) { activePadsMode.value = defaultPadsMode() } //TO-DO: add option to reset pads mode on load
                updatePads()
                updateFooterPage()
            }
        }
    }
    AppProperty { id: isLoaded; path: "app.traktor.decks." + deckId + ".is_loaded" }
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
    AppProperty { id: activeCell_slot1; path: "app.traktor.decks." + deckId + ".remix.players.1.active_cell_row"; onValueChanged: if (!sequencerSampleLockSlot1.value) selectedCell_slot1.value = activeCell_slot1.value }
    AppProperty { id: activeCell_slot2; path: "app.traktor.decks." + deckId + ".remix.players.2.active_cell_row"; onValueChanged: if (!sequencerSampleLockSlot2.value) selectedCell_slot2.value = activeCell_slot2.value }
    AppProperty { id: activeCell_slot3; path: "app.traktor.decks." + deckId + ".remix.players.3.active_cell_row"; onValueChanged: if (!sequencerSampleLockSlot3.value) selectedCell_slot3.value = activeCell_slot3.value }
    AppProperty { id: activeCell_slot4; path: "app.traktor.decks." + deckId + ".remix.players.4.active_cell_row"; onValueChanged: if (!sequencerSampleLockSlot4.value) selectedCell_slot4.value = activeCell_slot4.value }

    //Sequencer Properties
    AppProperty { id: sequencerOn; path: "app.traktor.decks." + deckId + ".remix.sequencer.on" }
    AppProperty { id: sequencerRecOn; path: "app.traktor.decks." + deckId + ".remix.sequencer.rec.on" }
    AppProperty { id: selectedCell_slot1; path: "app.traktor.decks." + deckId + ".remix.players.1.sequencer.selected_cell" }
    AppProperty { id: selectedCell_slot2; path: "app.traktor.decks." + deckId + ".remix.players.2.sequencer.selected_cell" }
    AppProperty { id: selectedCell_slot3; path: "app.traktor.decks." + deckId + ".remix.players.3.sequencer.selected_cell" }
    AppProperty { id: selectedCell_slot4; path: "app.traktor.decks." + deckId + ".remix.players.4.sequencer.selected_cell" }

    //Traktor Pro Advanced Panel
    AppProperty { id: advancedPanel; path: "app.traktor.decks." + deckId + ".view.select_advanced_panel" }
    function updateAdvancedPanelView() {
        if (hasTrackProperties){ //TO-DO: add preference to enable this features
            if (editMode.value == EditMode.disabled){
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

    MappingPropertyDescriptor { id: performanceEncoderControls; path: deckPropertiesPath + ".performanceEncoderControls"; type: MappingPropertyDescriptor.Integer; value: 2; min: 1; max: 4 } //TO-DO: onDeckType changed --> if not filter or fx send, reset

    //Hold button State
    MappingPropertyDescriptor { id: holdFreeze; path: propertiesPath + ".holdFreeze"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: holdRemix; path: propertiesPath + ".holdRemix"; type: MappingPropertyDescriptor.Boolean; value: false }

    //Loop Adjust State
    MappingPropertyDescriptor { id: loopInAdjust; path: deckPropertiesPath + ".loopInAdjust"; type: MappingPropertyDescriptor.Boolean; value: false; onValueChanged: { if (value) loopOutAdjust.value = false } }
    MappingPropertyDescriptor { id: loopOutAdjust; path: deckPropertiesPath + ".loopOutAdjust"; type: MappingPropertyDescriptor.Boolean; value: false; onValueChanged: { if (value) loopInAdjust.value = false } }

    //Slot Selectors State
    MappingPropertyDescriptor { id: slot1Selected; path: deckPropertiesPath + ".slot_selector_mode.1"; type: MappingPropertyDescriptor.Boolean; value: false; onValueChanged: { updateFooterSelectedSlot() } }
    MappingPropertyDescriptor { id: slot2Selected; path: deckPropertiesPath + ".slot_selector_mode.2"; type: MappingPropertyDescriptor.Boolean; value: false; onValueChanged: { updateFooterSelectedSlot() } }
    MappingPropertyDescriptor { id: slot3Selected; path: deckPropertiesPath + ".slot_selector_mode.3"; type: MappingPropertyDescriptor.Boolean; value: false; onValueChanged: { updateFooterSelectedSlot() } }
    MappingPropertyDescriptor { id: slot4Selected; path: deckPropertiesPath + ".slot_selector_mode.4"; type: MappingPropertyDescriptor.Boolean; value: false; onValueChanged: { updateFooterSelectedSlot() } }
    MappingPropertyDescriptor { id: slotState; path: deckPropertiesPath + ".slot_selector_mode.any"; type: MappingPropertyDescriptor.Boolean; value: slot1Selected.value || slot2Selected.value || slot3Selected.value || slot4Selected.value;
        onValueChanged: {
            if (!slotState.value) {
                footerPage.value = previousFooterPage.value
            }
        }
    }

    //TrackDeck Properties
    MappingPropertyDescriptor { id: controllerZoom; path: deckSettingsPath + ".waveform_zoom"; type: MappingPropertyDescriptor.Integer; value: 7; min: 0;  max: 10;   }

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
    MappingPropertyDescriptor { id: sequencerMode; path: deckPropertiesPath + ".sequencerMode"; type: MappingPropertyDescriptor.Boolean; value: false; onValueChanged: { updateFooterPage() } }
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

//------------------------------------------------------------------------------------------------------------------
// SCREEN BUTTONS
//------------------------------------------------------------------------------------------------------------------

    ScreenButtons {
        name: "screenButtons"
        active: deck.active
        deckId: deck.deckId
        surface: deck.surface

        hasEditButton: false
        favoriteControls: true
        editZoomControls: true
    }

    function validateFooterPage(page) {
        switch (page) {
            case FooterPage.fx:
                return hasFXFooter.value
            case FooterPage.midi:
                return useMIDIControls.value
            case FooterPage.pitch:
                return hasRMXControls
            case FooterPage.volume:
            case FooterPage.filter:
            case FooterPage.fxSend:
                return hasRMXControls || hasStemProperties
            case FooterPage.slot1:
            case FooterPage.slot2:
            case FooterPage.slot3:
            case FooterPage.slot4:
                return hasSQCRControls
            default:
                return !hasBottomControls && !hasFXFooter.value && !useMIDIControls.value
        }
    }

    function defaultFooterPage() {
        if (hasFXFooter.value) {
            footerPage.value = FooterPage.fx;
        }
        else if (hasStemProperties) {
            footerPage.value = FooterPage.volume;
        }
        else if (hasRMXControls) {
            footerPage.value = FooterPage.volume;
        }
        else if (hasSQCRControls) {
            footerPage.value = FooterPage.slot1;
        }
        else if (useMIDIControls.value) {
            footerPage.value = FooterPage.midi;
        }
        else {
            footerPage.value = FooterPage.empty;
        }
    }

    function updateFooterSelectedSlot() {
        if ((slot1Selected.value && slot2Selected.value) || (slot1Selected.value && slot3Selected.value) || (slot1Selected.value && slot4Selected.value) || (slot2Selected.value && slot3Selected.value) || (slot2Selected.value && slot4Selected.value) || (slot3Selected.value && slot4Selected.value)) {
            footerPage.value = FooterPage.slots
        }
        else if (slot1Selected.value) {
            footerPage.value = FooterPage.slot1
        }
        else if (slot2Selected.value) {
            footerPage.value = FooterPage.slot2
        }
        else if (slot3Selected.value) {
            footerPage.value = FooterPage.slot3
        }
        else if (slot4Selected.value) {
            footerPage.value = FooterPage.slot4
        }
        else {
            footerPage.value = previousFooterPage.value
        }
    }

//------------------------------------------------------------------------------------------------------------------
// ENCODERS
//------------------------------------------------------------------------------------------------------------------

    S5BrowseEncoder {
        name: "browse&back"
        active: deck.active
        deckId: deck.deckId
        surface: deck.surface
    }

    S5LoopEncoder {
        name: "loopEncoder"
        active: deck.active //(deck.active && !focusedHoldRemix) || (remixId == deck.deckId && focusedHoldRemix)
        deckId: deck.deckId
        surface: deck.surface
    }

//------------------------------------------------------------------------------------------------------------------
// PADS MODES
//------------------------------------------------------------------------------------------------------------------

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
                return hasDeckProperties
            case PadsMode.freeze:
                return hasDeckProperties
            case PadsMode.legacyRemix:
            case PadsMode.remix:
            case PadsMode.sequencer:
                return hasRemixProperties
            case PadsMode.stems:
                return hasStemProperties
            case PadsMode.effects:
                return hasEffects
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

    S5PadsModeButtons {
        name: "padsModeButtons"
        deckId: deck.deckId
        surface: deck.surface
    }

    HotcuesMode {
        name: "hotcuesMode"
        active: activePadsMode.value == PadsMode.hotcues && enablePads
        deckId: deck.deckId
        surface: deck.surface
    }

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
        browsing: screenView.value == ScreenView.browser
    }

    RemixMode {
        name: "remixMode"
        active: activePadsMode.value == PadsMode.remix && enablePads
        deckId: deck.deckId
        surface: deck.surface
        browsing: screenView.value == ScreenView.browser
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
// TRANSPORT SECTION
//------------------------------------------------------------------------------------------------------------------

    TouchStrip {
        name: "touchStrip"
        active: deck.active && hasDeckProperties && isLoaded.value
        deckId: deck.deckId
        surface: deck.surface
    }

    TransportButtons {
        name: "transport"
        active: deck.active && hasDeckProperties
        deckId: deck.deckId
        surface: deck.surface
    }
}
