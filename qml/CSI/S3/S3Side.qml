import CSI 1.0
import QtQuick 2.12

import "../../Defines"

Module {
    id: side
    property int topDeckId: 1
    property int bottomDeckId: 3
    property string surface: "hw.side"
    property string settingsPath: "mapping.settings.left"
    property string propertiesPath: "mapping.state.left"
    property bool shift: false

//------------------------------------------------------------------------------------------------------------------
// PREFERENCES PROPERTIES
//------------------------------------------------------------------------------------------------------------------

    //FXs Control Assignment
    MappingPropertyDescriptor { id: topFXUnit; path: settingsPath + ".topFXUnit"; type: MappingPropertyDescriptor.Integer; min: 1; max: 4 }
    MappingPropertyDescriptor { id: bottomFXUnit; path: settingsPath + ".bottomFXUnit"; type: MappingPropertyDescriptor.Integer; min: 0; max: 4; onValueChanged: { if (value != 0) padFXsUnit.value = value } }
    MappingPropertyDescriptor { id: padFXsUnit; path: settingsPath + ".padFXsUnit"; type: MappingPropertyDescriptor.Integer; min: 1; max: 4 }
    MappingPropertyDescriptor { id: padFXsBank; path: propertiesPath + ".padFXsBank"; type: MappingPropertyDescriptor.Integer; value: 1; min: 1; max: 8 }

//------------------------------------------------------------------------------------------------------------------
// DECKS INITIALIZATION
//------------------------------------------------------------------------------------------------------------------

    function initializeModule() {
        focusedDeck().padsMode = focusedDeck().defaultPadsMode()
        unfocusedDeck().padsMode = unfocusedDeck().defaultPadsMode()
        activePadsMode.value = focusedDeck().padsMode

        if (!topFXUnit.value) topFXUnit.value = topDeckId;
        if (!bottomFXUnit.value) bottomFXUnit.value = bottomDeckId;
        if (!padFXsUnit.value) padFXsUnit.value = bottomDeckId;
    }


    S3Deck {
        id: deckA
        name: "deckA"
        active: (topDeckId == 1 && topDeckFocused.value) || (bottomDeckId == 1 && !topDeckFocused.value)
        deckId: 1
        surface: side.surface
        enablePads: false
    }

    S3Deck {
        id: deckB
        name: "deckB"
        active: (topDeckId == 2 && topDeckFocused.value) || (bottomDeckId == 2 && !topDeckFocused.value)
        deckId: 2
        surface: side.surface
        enablePads: false
    }

    S3Deck {
        id: deckC
        name: "deckC"
        active: (topDeckId == 3 && topDeckFocused.value) || (bottomDeckId == 3 && !topDeckFocused.value)
        deckId: 3
        surface: side.surface
        enablePads: false
    }

    S3Deck {
        id: deckD
        name: "deckD"
        active: (topDeckId == 4 && topDeckFocused.value) || (bottomDeckId == 4 && !topDeckFocused.value)
        deckId: 4
        surface: side.surface
        enablePads: false
    }

//------------------------------------------------------------------------------------------------------------------
// DECK FOCUS
//------------------------------------------------------------------------------------------------------------------

    //Focus
    MappingPropertyDescriptor { id: topDeckFocused; path: propertiesPath + ".top_deck_focus"; type: MappingPropertyDescriptor.Boolean; value: true;
        onValueChanged: {

            activePadsMode.value = focusedDeck().padsMode //a no ser que estiguessis en remix mode, passis al remix deck, i TORNIS al track deck que estava en remix mode
        }
    }

    property int focusedDeckId: topDeckFocused.value ? topDeckId : bottomDeckId
    property int unfocusedDeckId: !topDeckFocused.value ? topDeckId : bottomDeckId
    property int remixId: (focusedDeck().hasRemixProperties || !unfocusedDeck().hasRemixProperties) ? focusedDeckId : unfocusedDeckId
    property int footerId: (focusedDeck().hasBottomControls || !unfocusedDeck().hasBottomControls) ? focusedDeckId : unfocusedDeckId

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

    //HotcueType
    MappingPropertyDescriptor { id: selectedHotcue; path: propertiesPath + ".selectedHotcue"; type: MappingPropertyDescriptor.Integer; value: 0 }
    MappingPropertyDescriptor { id: hotcueModifier; path: propertiesPath + ".hotcueModifier"; type: MappingPropertyDescriptor.Boolean; value: false }
    Wire { from: "%surface%.hotcues"; to: HoldPropertyAdapter { path: hotcueModifier.path; output: false } enabled: activePadsMode.value == PadsMode.hotcues }
}
