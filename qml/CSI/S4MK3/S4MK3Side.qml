import CSI 1.0
import QtQuick 2.12

import "../../Defines"
import "../../Helpers/LED.js" as LED

Module {
    id: side
    property int topDeckId: 1
    property int bottomDeckId: 3
    property string surface: "hw.side"
    property string settingsPath: "mapping.settings.left"
    property string propertiesPath: "mapping.state.left"
    property bool shift: false

    property alias screenView: screenView.value //necessary for the cross-display interaction

//------------------------------------------------------------------------------------------------------------------
// PREFERENCES PROPERTIES
//------------------------------------------------------------------------------------------------------------------

    //FXs Control Assignment
    MappingPropertyDescriptor { id: topFXUnit; path: settingsPath + ".topFXUnit"; type: MappingPropertyDescriptor.Integer; min: 1; max: 4 }
    MappingPropertyDescriptor { id: bottomFXUnit; path: settingsPath + ".bottomFXUnit"; type: MappingPropertyDescriptor.Integer; min: 0; max: 4; onValueChanged: { if (value != 0) padFXsUnit.value = value } }
    MappingPropertyDescriptor { id: padFXsUnit; path: settingsPath + ".padFXsUnit"; type: MappingPropertyDescriptor.Integer; min: 1; max: 4 }
    MappingPropertyDescriptor { id: padFXsBank; path: propertiesPath + ".padFXsBank"; type: MappingPropertyDescriptor.Integer; value: 1; min: 1; max: 8 }

    //Preferences Navigation Properties
    MappingPropertyDescriptor { id: browserScroll; path: propertiesPath + ".browserScroll"; type: MappingPropertyDescriptor.Integer; value: 0 }
    MappingPropertyDescriptor { id: browserEnterNode; path: propertiesPath + ".browserEnterNode"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: browserExitNode; path: propertiesPath + ".browserExitNode"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: fxSettingsNavigation; path: propertiesPath + ".fxSettingsNavigation"; type: MappingPropertyDescriptor.Integer; value: 0 }
    MappingPropertyDescriptor { id: fxSettingsPush; path: propertiesPath + ".fxSettingsPush"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: fxSettingsTab; path: propertiesPath + ".fxSettings_tab"; type: MappingPropertyDescriptor.Integer; value: 1; min: 1; max: 8 }
    MappingPropertyDescriptor { id: preferencesNavigation; path: propertiesPath + ".preferencesNavigation"; type: MappingPropertyDescriptor.Integer; value: 0 }
    MappingPropertyDescriptor { id: preferencesPush; path: propertiesPath + ".preferencesPush"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: preferencesBack; path: propertiesPath + ".preferencesBack"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: backBright; path: propertiesPath + ".backBright"; type: MappingPropertyDescriptor.Boolean; value: false }

    //Integer Editor State Properties
    MappingPropertyDescriptor { id: integerEditor; path: propertiesPath + ".integer_editor"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: deckALEDEditor; path: propertiesPath + ".deckALED_editor"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: deckBLEDEditor; path: propertiesPath + ".deckBLED_editor"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: deckCLEDEditor; path: propertiesPath + ".deckCLED_editor"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: deckDLEDEditor; path: propertiesPath + ".deckDLED_editor"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: jogwheelTensionEditor; path: propertiesPath + ".jogwheelTension_editor"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: onBrightnessEditor; path: propertiesPath + ".onBrightness_editor"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: dimmedBrightnessEditor; path: propertiesPath + ".dimmedBrightness_editor"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: vinylBreakDurationInBeatsEditor; path: propertiesPath + ".vinylBreakDurationInBeats_editor"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: vinylBreakDurationInSecondsEditor; path: propertiesPath + ".vinylBreakDurationInSeconds_editor"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: waveformOffsetEditor; path: propertiesPath + ".waveformOffset_editor"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: beatsxPhraseEditor; path: propertiesPath + ".beatsxPhrase_editor"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: browserRowsEditor; path: propertiesPath + ".browserRows_editor"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: waveformColorEditor; path: propertiesPath + ".waveformColor_editor"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: gridModeEditor; path: propertiesPath + ".gridMode_editor"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: beatCounterModeEditor; path: propertiesPath + ".beatCounterMode_editor"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: perfectTempoMatchLimitEditor; path: propertiesPath + ".perfectTempoMatchLimit_editor"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: regularTempoMatchLimitEditor; path: propertiesPath + ".regularTempoMatchLimit_editor"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: browserTimerEditor; path: propertiesPath + ".browserTimer_editor"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: overlayTimerEditor; path: propertiesPath + ".overlayTimer_editor"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: hotcueTypeTimerEditor; path: propertiesPath + ".hotcueTypeTimer_editor"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: holdTimerEditor; path: propertiesPath + ".holdTimer_editor"; type: MappingPropertyDescriptor.Boolean; value: false }

//------------------------------------------------------------------------------------------------------------------
// GENERIC TRAKTOR PROPERTIES
//------------------------------------------------------------------------------------------------------------------

    MappingPropertyDescriptor { id: holdMaster; path: propertiesPath + ".holdMaster"; type: MappingPropertyDescriptor.Boolean; value: false }

//------------------------------------------------------------------------------------------------------------------
// DECKS INITIALIZATION
//------------------------------------------------------------------------------------------------------------------

    function initializeModule() {
        focusedDeck().padsMode = focusedDeck().defaultPadsMode()
        unfocusedDeck().padsMode = unfocusedDeck().defaultPadsMode()
        activePadsMode.value = focusedDeck().padsMode

        if (!topFXUnit.value) topFXUnit.value = topDeckId;
        if (!bottomFXUnit.value) bottomFXUnit.value = 0;
        if (!padFXsUnit.value) padFXsUnit.value = bottomDeckId;
    }

    S4MK3Deck {
        id: deckA
        name: "deckA"
        active: (topDeckId == 1 && topDeckFocused.value) || (bottomDeckId == 1 && !topDeckFocused.value)
        deckId: 1
        surface: side.surface
    }

    S4MK3Deck {
        id: deckB
        name: "deckB"
        active: (topDeckId == 2 && topDeckFocused.value) || (bottomDeckId == 2 && !topDeckFocused.value)
        deckId: 2
        surface: side.surface
    }

    S4MK3Deck {
        id: deckC
        name: "deckC"
        active: (topDeckId == 3 && topDeckFocused.value) || (bottomDeckId == 3 && !topDeckFocused.value)
        deckId: 3
        surface: side.surface
    }

    S4MK3Deck {
        id: deckD
        name: "deckD"
        active: (topDeckId == 4 && topDeckFocused.value) || (bottomDeckId == 4 && !topDeckFocused.value)
        deckId: 4
        surface: side.surface
    }

//------------------------------------------------------------------------------------------------------------------
// DECK FOCUS
//------------------------------------------------------------------------------------------------------------------

    //Focus
    MappingPropertyDescriptor { id: topDeckFocused; path: propertiesPath + ".top_deck_focus"; type: MappingPropertyDescriptor.Boolean; value: true;
        onValueChanged: {
            if (screenView.value == ScreenView.deck) {
                screenOverlay.value = Overlay.none
            }
            if (editMode.value != EditMode.disabled) {
                editMode.value = EditMode.disabled
            }
            if (!((activePadsMode.value == PadsMode.remix || activePadsMode.value == PadsMode.legacyRemix) && focusedDeck().validatePadsMode(unfocusedDeck().padsMode) && focusedDeck().deckType != unfocusedDeck().deckType)) {
                activePadsMode.value = focusedDeck().padsMode
            }
            updatePads()
        }
    }

    property int focusedDeckId: topDeckFocused.value ? topDeckId : bottomDeckId
    property int unfocusedDeckId: !topDeckFocused.value ? topDeckId : bottomDeckId
    property int remixId: (focusedDeck().hasRemixProperties || !unfocusedDeck().hasRemixProperties) || onlyFocusedDeck.value ? focusedDeckId : unfocusedDeckId
    property int footerId: (focusedDeck().hasBottomControls || !unfocusedDeck().hasBottomControls) || onlyFocusedDeck.value ? focusedDeckId : unfocusedDeckId

    function master() { return deck(masterId.value + 1) }
    function focusedDeck() { return deck(focusedDeckId) }
    function unfocusedDeck() { return deck(unfocusedDeckId) }
    function remixDeck() { return deck(remixId) }
    function footerDeck() { return deck(footerId) }

    function deck(id) {
        switch (id) {
            case 1: return deckA
            case 2: return deckB
            case 3: return deckC
            case 4: return deckD
        }
    }

    Wire { from: "%surface%.top_deck"; to: SetPropertyAdapter { path: propertiesPath + ".top_deck_focus"; value: true; color: topDeckId == 1 ? deckA.deckLEDColor : deckB.deckLEDColor } }
    Wire { from: "%surface%.bottom_deck"; to: SetPropertyAdapter { path: propertiesPath + ".top_deck_focus"; value: false; color: bottomDeckId == 3 ? deckC.deckLEDColor : deckD.deckLEDColor } }
    //Dev Stuff
    Wire { from: "%surface%.deck"; to: "deckButton" }
    ButtonScriptAdapter {
        name: "deckButton"
        brightness: bright
        color: LED.legacy(focusedDeckId)
        onPress: {
            if (shift && screenView.value == ScreenView.deck) screenView.value = ScreenView.fxSettings
            else if (screenView.value == ScreenView.fxSettings) screenView.value == ScreenView.deck
            else topDeckFocused.value = !topDeckFocused.value
        }
    }

    //Pads focus Properties
    MappingPropertyDescriptor { id: activePadsMode; path: propertiesPath + ".pads_mode"; type: MappingPropertyDescriptor.Integer; value: PadsMode.disabled; onValueChanged: updatePads() }

    function updatePads() {
        if (focusedDeck().validatePadsMode(activePadsMode.value)) {
            focusedDeck().padsMode = activePadsMode.value
            focusedDeck().enablePads = true
            disablePads(focusedDeckId)
        }
        else if (remixDeck().validatePadsMode(activePadsMode.value) && (activePadsMode.value == PadsMode.legacyRemix || activePadsMode.value == PadsMode.remix)) {
            remixDeck().padsMode = activePadsMode.value
            remixDeck().enablePads = true
            disablePads(remixId)
            if (focusedDeck().defaultPadsMode() != PadsMode.disabled) {
                focusedDeck().padsMode = focusedDeck().defaultPadsMode()
            }
        }
        else if (focusedDeck().validatePadsMode(focusedDeck().defaultPadsMode())) {
            activePadsMode.value = focusedDeck().defaultPadsMode()
            focusedDeck().enablePads = true
            disablePads(focusedDeckId)
        }
        else {
            disablePads(0)
            activePadsMode.value = PadsMode.disabled
        }
    }

    function disablePads(focusId) {
        if (focusId != 1) deckA.enablePads = false
        if (focusId != 2) deckB.enablePads = false
        if (focusId != 3) deckC.enablePads = false
        if (focusId != 4) deckD.enablePads = false
    }

//------------------------------------------------------------------------------------------------------------------
// SCREEN INITIALIZATION
//------------------------------------------------------------------------------------------------------------------

    KontrolScreen {
        name: "screen"
        side: topDeckId == 1 ? ScreenSide.Left : ScreenSide.Right
        flavor: ScreenFlavor.S4MK3
        settingsPath: side.settingsPath
        propertiesPath: side.propertiesPath
    }
    Wire { from: "screen.output"; to: "%surface%.display" }

    MappingPropertyDescriptor { id: screenView; path: propertiesPath + ".screen_view"; type: MappingPropertyDescriptor.Integer; value: ScreenView.deck; //deck: 0, browser: 1, screen settings: 2
        onValueChanged: {
            if (screenView.value != ScreenView.deck) {
                screenOverlay.value = Overlay.none
            }
        }
    }

    //Browser View
    MappingPropertyDescriptor { id: browserIsContentList; path: propertiesPath + ".browser.is_content_list"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: browserIsTemporary; path: propertiesPath + ".browser.is_temporary"; type: MappingPropertyDescriptor.Boolean; value: false;
        onValueChanged: {
            if (screenView.value == ScreenView.deck) {
                screenView.value = ScreenView.browser
            }
            else if (screenView.value == ScreenView.browser && browserIsTemporary.value) {
                browserLeaveTimer.stop()
            }
            else if (screenView.value == ScreenView.browser && !browserIsTemporary.value) {
                browserLeaveTimer.restart()
            }
        }
    }
    Timer { id: browserLeaveTimer; interval: browserTimer.value;
        onTriggered: {
            if (screenView.value == ScreenView.browser && showBrowserOnTouch.value && !browserIsTemporary.value) {
                screenView.value = ScreenView.deck
            }
        }
    }

//------------------------------------------------------------------------------------------------------------------
// EDIT VIEW PROPERTIES
//------------------------------------------------------------------------------------------------------------------

    property double preEditZoom: 0
    property bool preEditIsSingleDeck: true
    MappingPropertyDescriptor { id: holdGrid; path: propertiesPath + ".holdGrid"; type: MappingPropertyDescriptor.Boolean; value: false; onValueChanged: focusedDeck().updateAdvancedPanelView() }
    MappingPropertyDescriptor { id: editMode; path: propertiesPath + ".edit_mode"; type: MappingPropertyDescriptor.Integer; value: EditMode.disabled;
        onValueChanged: {
            if (editMode.value == EditMode.full) {
                screenOverlay.value = Overlay.none
                //preEditIsSingleDeck = screenIsSingleDeck.value
                //screenIsSingleDeck.value = true
            }
            else {
                //screenIsSingleDeck.value = preEditIsSingleDeck
                if (zoomedEditView.value) zoomedEditView.value = false
            }
            focusedDeck().updateAdvancedPanelView()
        }
    }

    AppProperty { id: waveformZoom; path: "app.traktor.decks." + focusedDeckId + ".track.waveform_zoom" }
    MappingPropertyDescriptor { id: zoomedEditView; path: propertiesPath + ".beatgrid.zoomed_view"; type: MappingPropertyDescriptor.Boolean; value: false
        onValueChanged: {
            if (zoomedEditView.value) {
                preEditZoom = waveformZoom.value
                if (editMode.value == EditMode.full && autoZoomTPwaveform.value) {
                    waveformZoom.value = 1.00
                }
            }
            else {
                waveformZoom.value = preEditZoom
            }
        }
    }
    MappingPropertyDescriptor { path: propertiesPath + ".beatgrid.position"; type: MappingPropertyDescriptor.Float; value: 0.0 }
    MappingPropertyDescriptor { path: propertiesPath + ".beatgrid.scan_beats_offset"; type: MappingPropertyDescriptor.Integer; value: 0 }
    MappingPropertyDescriptor { id: scanDirection; path: propertiesPath + ".beatgrid.scan_direction"; type: MappingPropertyDescriptor.Integer; value: 0 }
    MappingPropertyDescriptor { id: scanUpdater; path: propertiesPath + ".beatgrid.scan_updater"; type: MappingPropertyDescriptor.Boolean; value: false }

//------------------------------------------------------------------------------------------------------------------
// CENTER OVERLAY
//------------------------------------------------------------------------------------------------------------------

    MappingPropertyDescriptor { id: screenOverlay; path: propertiesPath + ".overlay"; type: MappingPropertyDescriptor.Integer; value: Overlay.none;
        onValueChanged: {
            //Restart timeout count for autoclosing overlays
            if (screenOverlay.value == Overlay.bpm || screenOverlay.value == Overlay.key || screenOverlay.value == Overlay.quantize || screenOverlay.value == Overlay.swing) {
                overlay_countdown.restart();
            }
            //Restart timeout count for shorter autoclosing overlays
            if (screenOverlay.value == Overlay.hotcueType) {
                hotcueType_overlay_countdown.restart();
            }
            else { selectedHotcue.value = 0 }
        }
    }

    //Generic overlays
    Timer { id: overlay_countdown; interval: overlayTimer.value;
        onTriggered: {
            if (screenOverlay.value == Overlay.bpm || screenOverlay.value == Overlay.key || screenOverlay.value == Overlay.quantize || screenOverlay.value == Overlay.swing) {
                screenOverlay.value = Overlay.none
            }
        }
    }
    Wire {
        enabled: screenOverlay.value == Overlay.bpm || screenOverlay.value == Overlay.key || screenOverlay.value == Overlay.quantize || screenOverlay.value == Overlay.swing
        from: Or {
            inputs:
            [
            "%surface%.browse.push",
            "%surface%.browse.touch",
            "%surface%.browse.is_turned",
            "%surface%.back",
            "%surface%.shift",
            //"s4mk3.mixer.tempo"
            ]
        }
        to: ButtonScriptAdapter { onPress: overlay_countdown.stop(); onRelease: overlay_countdown.restart() }
    }

    //HotcueType overlay
    MappingPropertyDescriptor { id: selectedHotcue; path: propertiesPath + ".selectedHotcue"; type: MappingPropertyDescriptor.Integer; value: 0; onValueChanged: { if (selectedHotcue.value != 0) screenOverlay.value = Overlay.hotcueType } }
    MappingPropertyDescriptor { id: hotcueModifier; path: propertiesPath + ".hotcueModifier"; type: MappingPropertyDescriptor.Boolean; value: false }
    Wire { from: "%surface%.hotcues"; to: HoldPropertyAdapter { path: propertiesPath + ".hotcueModifier"; value: true; output: false } }
    Timer { id: hotcueType_overlay_countdown; interval: hotcueTypeTimer.value;
        onTriggered: {
            if (screenOverlay.value == Overlay.hotcueType) {
                screenOverlay.value = Overlay.none
            }
        }
    }
    Wire {
        enabled: screenOverlay.value == Overlay.hotcueType
        from: Or {
            inputs:
            [
            "%surface%.browse.push",
            "%surface%.browse.touch",
            "%surface%.browse.is_turned",
            "%surface%.back",
            "%surface%.hotcue"
            ]
        }
        to: ButtonScriptAdapter { onPress: hotcueType_overlay_countdown.stop(); onRelease: hotcueType_overlay_countdown.restart() }
    }

    //BPM overlay
    AppProperty { id: isSyncEnabled; path: "app.traktor.decks." + focusedDeckId + ".sync.enabled" }
    AppProperty { path: "app.traktor.masterclock.tempo";
        onValueChanged: {
            if (screenOverlay.value == Overlay.bpm && (isSyncEnabled.value || (masterId.value+1) == focusedDeckId)){
                overlay_countdown.restart();
            }
        }
    }

//------------------------------------------------------------------------------------------------------------------
// FX CONTROLS
//------------------------------------------------------------------------------------------------------------------

    S4MK3FXControls {
        name: "topFX"
        active: !shift || bottomFXUnit.value == 0
        surface: side.surface
        unit: topFXUnit.value
        focusedPanel: "top"
    }
    S4MK3FXControls {
        name: "bottomFX"
        active: shift && bottomFXUnit.value != 0
        surface: side.surface
        unit: bottomFXUnit.value
        focusedPanel: "bottom"
    }
}
