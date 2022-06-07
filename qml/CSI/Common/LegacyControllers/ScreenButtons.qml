import CSI 1.0
import QtQuick 2.12

import "../../../Defines"

Module {
    id: module
    property bool active: true
    property int deckId: 1 //1-4
    property string surface: "path"
    property bool hasEditButton: true
    property bool favoriteControls: false
    property bool editZoomControls: false

    Beatgrid { name: "grid"; channel: deckId }

    Blinker { name: "ScreenViewBlinker"; cycle: 250; defaultBrightness: bright; blinkBrightness: dimmed }
    Wire { from: "ScreenViewBlinker.trigger"; to: ExpressionAdapter { type: ExpressionAdapter.Boolean; expression: (screenView.value == ScreenView.deck && screenOverlay.value != Overlay.none) || screenView.value != ScreenView.deck } }

    MappingPropertyDescriptor { id: showButtonsOverlay; path: propertiesPath + ".show_button_area_input"; type: MappingPropertyDescriptor.Boolean; value: false }

    WiresGroup {
        enabled: active

        //Handle views
        Wire { from: "%surface%.display.buttons.5.led"; to: "ScreenViewBlinker" }
        Wire { from: "%surface%.display.buttons.5"; to: SetPropertyAdapter { path: screenView.path; value: ScreenView.deck; output: false } enabled: screenView.value != ScreenView.deck }

        //Browser View
        WiresGroup {
            enabled: screenView.value == ScreenView.browser

            //Side Overlay PopUp Timer
            Wire {
                enabled: browserIsContentList.value
                from: Or {
                    inputs:
                    [
                        "%surface%.display.buttons.6",
                        "%surface%.display.buttons.7"
                    ]
                }
                to: HoldPropertyAdapter { path: showButtonsOverlay.path; value: true; output: false }
            }

            //Browse through favorite lists
            WiresGroup {
                enabled: favoriteControls

                Wire { from: "%surface%.display.buttons.4"; to: RelativePropertyAdapter{ path: "app.traktor.browser.favorites.select"; mode: RelativeMode.Decrement } enabled: favoritesSelect.value > 0 }
                Wire { from: "%surface%.display.buttons.8"; to: RelativePropertyAdapter{ path: "app.traktor.browser.favorites.select"; mode: RelativeMode.Increment } enabled: favoritesSelect.value < 11 }
            }

            //Preparation List
            Wire { from: "%surface%.display.buttons.6"; to: TriggerPropertyAdapter { path:"app.traktor.browser.preparation.toggle" } enabled: browserIsContentList.value }
            Wire { from: "%surface%.display.buttons.7"; to: TriggerPropertyAdapter { path:"app.traktor.browser.preparation.jump_to_list" } }

            //Command in original file?
            //Wire { from: "%surface%.display.buttons.6"; to: RelativePropertyAdapter { path: "mapping.state.browser_view_mode"; wrap: true; mode: RelativeMode.Increment } }
        }

        //Deck View
        WiresGroup {
            enabled: screenView.value == ScreenView.deck

            //Handle View button
            WiresGroup {
                enabled: !shift

                Wire { from: "%surface%.display.buttons.5"; to: TogglePropertyAdapter { path: screenIsSingleDeck.path; value: false; output: false } enabled: screenOverlay.value == Overlay.none && editMode.value != EditMode.full }
                Wire { from: "%surface%.display.buttons.5"; to: SetPropertyAdapter { path: editMode.path; value: EditMode.disabled; output: false } enabled: editMode.value != EditMode.disabled }
                Wire { from: "%surface%.display.buttons.5"; to: SetPropertyAdapter { path: screenOverlay.path; value: Overlay.none; output: false } enabled: screenOverlay.value != Overlay.none }
            }
            Wire { from: "%surface%.display.buttons.5"; to: SetPropertyAdapter { path: screenView.path; value: ScreenView.settings; output: false } enabled: shift } //display.button.1 not working...

            //Side Overlay PopUp Timer
            Wire {
                enabled: hasDeckProperties
                from: Or {
                    inputs:
                    [
                        "%surface%.display.buttons.2",
                        "%surface%.display.buttons.3",
                        "%surface%.display.buttons.6",
                        "%surface%.display.buttons.7"
                    ]
                }
                to: HoldPropertyAdapter { path: showButtonsOverlay.path; value: true; output: false }
            }

            WiresGroup {
                enabled: editMode.value == EditMode.disabled

                //BPM, Key, Quantize, Swing, Freeze, Capture and SoftTakeOver Overlays
                WiresGroup {
                    Wire { from: "%surface%.display.buttons.2"; to: TogglePropertyAdapter { path: editMode.path; value: EditMode.full} enabled: hasEditMode && shift && !hasEditButton }
                    Wire { from: "%surface%.display.buttons.2"; to: TogglePropertyAdapter { path: screenOverlay.path; value: Overlay.bpm } enabled: hasDeckProperties && (!shift || hasEditButton) }
                    Wire { from: "%surface%.display.buttons.3"; to: TogglePropertyAdapter { path: screenOverlay.path; value: Overlay.key } enabled: hasTrackProperties }
                    Wire { from: "%surface%.display.buttons.3"; to: TogglePropertyAdapter { path: screenOverlay.path; value: Overlay.quantize } enabled: hasRemixProperties && !sequencerMode.value }
                    Wire { from: "%surface%.display.buttons.3"; to: TogglePropertyAdapter { path: screenOverlay.path; value: Overlay.swing } enabled: hasRemixProperties && sequencerMode.value }
                }

                //Controller Waveform zoom
                WiresGroup {
                    enabled: hasTrackProperties && !shift
                    Wire { from: "%surface%.display.buttons.6"; to: RelativePropertyAdapter { path: controllerZoom.path; mode: RelativeMode.Decrement } }
                    Wire { from: "%surface%.display.buttons.7"; to: RelativePropertyAdapter { path: controllerZoom.path; mode: RelativeMode.Increment } }
                }

                //Traktor Waveform Zoom
                WiresGroup {
                    enabled: deck.deckType == DeckType.Track && shift
                    Wire { from: "%surface%.display.buttons.6"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deckId + ".track.waveform_zoom"; step: 0.25; mode: RelativeMode.Increment } }
                    Wire { from: "%surface%.display.buttons.7"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deckId + ".track.waveform_zoom"; step: 0.25; mode: RelativeMode.Decrement } }
                }

                //StemView Mode
                WiresGroup {
                    enabled: deck.deckType == DeckType.Stem && shift
                    Wire { from: "%surface%.display.buttons.6"; to: SetPropertyAdapter { path: stemView.path; value: StemStyle.track } }
                    Wire { from: "%surface%.display.buttons.7"; to: SetPropertyAdapter { path: stemView.path; value: StemStyle.daw } }
                }

                //Tone Play Scale
                WiresGroup {
                    enabled: hasTrackProperties && shift && activePadsMode.value == PadsMode.tonePlay
                    Wire { from: "%surface%.display.buttons.4"; to: RelativePropertyAdapter { path: deckPropertiesPath + ".tonePlayMode"; mode: RelativeMode.Decrement } }
                    Wire { from: "%surface%.display.buttons.8"; to: RelativePropertyAdapter { path: deckPropertiesPath + ".tonePlayMode"; mode: RelativeMode.Increment } }
                }

                //Remix Deck
                WiresGroup {
                    enabled: hasRMXControls || hasSQCRControls

                    //Remix page scroll
                    WiresGroup {
                        enabled: !sequencerMode.value

                        Wire { from: "%surface%.display.buttons.6"; to: RelativePropertyAdapter { path: remixPadsControl.path; mode: RelativeMode.Decrement } enabled: !shift && legacyRemixMode.value }
                        Wire { from: "%surface%.display.buttons.7"; to: RelativePropertyAdapter { path: remixPadsControl.path; mode: RelativeMode.Increment } enabled: !shift && legacyRemixMode.value }
                        Wire { from: "%surface%.display.buttons.6"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.page"; mode: RelativeMode.Decrement } enabled: !legacyRemixMode.value || (shift && legacyRemixMode.value) }
                        Wire { from: "%surface%.display.buttons.7"; to: RelativePropertyAdapter { path: "app.traktor.decks." + deckId + ".remix.page"; mode: RelativeMode.Increment } enabled: !legacyRemixMode.value || (shift && legacyRemixMode.value) }
                        //The following 4 lines are necessary to update the remixPadsControl property
                        Wire { from: "%surface%.display.buttons.6"; to: SetPropertyAdapter { path: remixPadsFocus.path; value: 1; output: false } enabled: !shift && legacyRemixMode.value && remixPadsFocus.value == 2 }
                        Wire { from: "%surface%.display.buttons.6"; to: SetPropertyAdapter { path: remixPadsFocus.path; value: 2; output: false } enabled: !shift && legacyRemixMode.value && remixPadsFocus.value == 1 && remixPadsControl.value != 1 }
                        Wire { from: "%surface%.display.buttons.7"; to: SetPropertyAdapter { path: remixPadsFocus.path; value: 2; output: false } enabled: !shift && legacyRemixMode.value && remixPadsFocus.value == 1 }
                        Wire { from: "%surface%.display.buttons.7"; to: SetPropertyAdapter { path: remixPadsFocus.path; value: 1; output: false } enabled: !shift && legacyRemixMode.value && remixPadsFocus.value == 2 && remixPadsControl.value != 8 }
                    }

                    //Sequencer beats selector (1-8 or 9-16)
                    WiresGroup {
                        enabled: sequencerMode.value
                        Wire { from: "%surface%.display.buttons.6"; to: SetPropertyAdapter { path: sequencerPage.path; value: 1 } }
                        Wire { from: "%surface%.display.buttons.7"; to: SetPropertyAdapter { path: sequencerPage.path; value: 2 } }
                    }
                }

                //Slot Controls Selector (S5 Only)
                WiresGroup {
                    enabled: footerHasContentToSwitch.value && slotState.value
                    Wire { from: "%surface%.display.buttons.4"; to: RelativePropertyAdapter { path: performanceEncoderControls.path; mode: RelativeMode.Decrement } }
                    Wire { from: "%surface%.display.buttons.8"; to: RelativePropertyAdapter { path: performanceEncoderControls.path; mode: RelativeMode.Increment } }
                }
            }

            //Edit View
            WiresGroup {
                enabled: editMode.value == EditMode.full

                Wire { from: "%surface%.display.buttons.2"; to: "grid.lock" }
                Wire { from: "%surface%.display.buttons.3"; to: "grid.tick" }
                Wire { from: "%surface%.display.buttons.6"; to: SetPropertyAdapter { path: zoomedEditView.path; value: true } enabled: shift && editZoomControls }
                Wire { from: "%surface%.display.buttons.7"; to: SetPropertyAdapter { path: zoomedEditView.path; value: false } enabled: shift && editZoomControls }

                WiresGroup {
                    enabled: !gridLock.value

                    Wire { from: "%surface%.display.buttons.6"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.grid.set_autogrid" } enabled: !shift || !editZoomControls }
                    Wire { from: "%surface%.display.buttons.7"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.grid.reset_bpm" } enabled: !shift || !editZoomControls }
                    Wire { from: "%surface%.display.buttons.4"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.grid.half_bpm" } }
                    Wire { from: "%surface%.display.buttons.8"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.grid.double_bpm" } }
                }
            }
        }
    }

    WiresGroup {
        enabled: deck.footerControlled

        //Footer Selector
        WiresGroup {
            enabled: screenView.value == ScreenView.deck && footerHasContentToSwitch.value && !slotState.value && (activePadsMode.value != PadsMode.tonePlay || (activePadsMode.value == PadsMode.tonePlay && !shift))
            Wire { from: "%surface%.display.buttons.4"; to: ButtonScriptAdapter { brightness: bright; onPress: { footerPageDec() } } }
            Wire { from: "%surface%.display.buttons.8"; to: ButtonScriptAdapter { brightness: bright; onPress: { footerPageInc() } } }
        }
    }

//------------------------------------------------------------------------------------------------------------------
// Footer Overlay
//------------------------------------------------------------------------------------------------------------------

    function footerPageInc() {
        if (footerHasContent.value) {
            var tempPage = footerPage.value;
            while (true) {

                //Go to the next footer page...
                switch (tempPage) {
                    case FooterPage.empty:
                        tempPage = FooterPage.fx;
                        break;
                    case FooterPage.fx:
                        tempPage = FooterPage.pitch;
                        break;
                    case FooterPage.pitch:
                        tempPage = (deck.deckType == DeckType.Stem) ? FooterPage.filter : FooterPage.fxSend;
                        break;
                    case FooterPage.fxSend:
                        tempPage = (deck.deckType == DeckType.Stem) ? FooterPage.slot1 : FooterPage.filter;
                        break;
                    case FooterPage.filter:
                        tempPage = (deck.deckType == DeckType.Stem) ? FooterPage.fxSend : FooterPage.slot1;
                        break;
                    case FooterPage.slot1:
                        tempPage = FooterPage.slot2;
                        break;
                    case FooterPage.slot2:
                        tempPage = FooterPage.slot3;
                        break;
                    case FooterPage.slot3:
                        tempPage = FooterPage.slot4;
                        break;
                    case FooterPage.slot4:
                        tempPage = FooterPage.midi;
                        break;
                    case FooterPage.midi:
                        tempPage = FooterPage.fx;
                        break;
                }

                //Validate the page and eventually switch to it --> if not, it will keep cycling through the pages
                if (deck.validateFooterPage(tempPage)) {
                    footerPage.value = tempPage
                    updateSlotProperty()
                    return;
                }
            }
        }
        else {
            footerPage.value = FooterPage.empty
        }
    }

    function footerPageDec() {
        if (footerHasContent.value) {
            var tempPage = footerPage.value;
            while (true) {

                //Go to the previous footer page...
                switch (tempPage) {
                    case FooterPage.empty:
                        tempPage = FooterPage.fx;
                        break;
                    case FooterPage.fx:
                        tempPage = FooterPage.midi;
                        break;
                    case FooterPage.pitch:
                        tempPage = FooterPage.fx;
                        break;
                    case FooterPage.fxSend:
                        tempPage = (deck.deckType == DeckType.Stem) ? FooterPage.filter : FooterPage.pitch;
                        break;
                    case FooterPage.filter:
                        tempPage = (deck.deckType == DeckType.Stem) ? FooterPage.pitch : FooterPage.fxSend;
                        break;
                    case FooterPage.slot1:
                        tempPage = (deck.deckType == DeckType.Stem) ? FooterPage.fxSend : FooterPage.filter;
                        break;
                    case FooterPage.slot2:
                        tempPage = FooterPage.slot1;
                        break;
                    case FooterPage.slot3:
                        tempPage = FooterPage.slot2;
                        break;
                    case FooterPage.slot4:
                        tempPage = FooterPage.slot3;
                        break;
                    case FooterPage.midi:
                        tempPage = FooterPage.slot4;
                        break;
                }

                //Validate the page and eventually switch to it --> if not, it will keep cycling through the pages
                if (deck.validateFooterPage(tempPage)) {
                    footerPage.value = tempPage
                    updateSlotProperty()
                    return;
                }
            }
        }
        else {
            footerPage.value = FooterPage.empty;
        }
    }

    //For updating the sequencerSlot property and the Footer page when switching from slots
    function updateSlotProperty() {
        if (footerPage.value == FooterPage.slot1) {
            sequencerSlot.value = 1
        }
        else if (footerPage.value == FooterPage.slot2) {
            sequencerSlot.value = 2
        }
        else if (footerPage.value == FooterPage.slot3) {
            sequencerSlot.value = 3
        }
        else if (footerPage.value == FooterPage.slot4) {
            sequencerSlot.value = 4
        }
    }
}
