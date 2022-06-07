import CSI 1.0
import "../../../Defines"

Module {
    id: module
    property bool active: true
    property int deckId: 1
    property int lines: 0
    property bool useHeader: false

    // View Modes ----------------------
    readonly property int listMode:           0
    readonly property int treeMode:           1
    // ------------------------------------

    MappingPropertyDescriptor {
      id: browseEnabled
      path: deckPropertiesPath + ".browse_enabled"
      type: MappingPropertyDescriptor.Boolean
    }
    Wire { from: "surface.info_enable"; to:  DirectPropertyAdapter{ path: deckPropertiesPath + ".browse_enabled" } }

    MappingPropertyDescriptor
    {
      id: browserView;
      path: deckPropertiesPath + ".browser_view";
      type: MappingPropertyDescriptor.Integer;
    }
    Wire { enabled: active; from: "browser_info.view"; to: DirectPropertyAdapter { path: deckPropertiesPath + ".browser_view" } }

    MappingPropertyDescriptor
    {
      id: treeSelectionIsPlaylist;
      path: deckPropertiesPath + ".tree_selection_is_playlist";
      type: MappingPropertyDescriptor.Boolean;
    }
    Wire { enabled: active; from: "browser_info.tree_selection_is_playlist"; to: DirectPropertyAdapter { path: deckPropertiesPath + ".tree_selection_is_playlist" } }

    MappingPropertyDescriptor
    {
      id: treeSelectionHasEntries;
      path: deckPropertiesPath + ".tree_selection_has_entries";
      type: MappingPropertyDescriptor.Boolean;
    }
    Wire { enabled: active; from: "browser_info.tree_selection_has_entries"; to: DirectPropertyAdapter { path: deckPropertiesPath + ".tree_selection_has_entries" } }

    Browser {
        name: "browser"
    }

    //XDJBrowserView { name: "browser_info"; channel: deckId; lines: module.lines; useHeader: module.useHeader } //3.4.2
    PioneerBrowser { name: "browser_info"; channel: deckId; lines: module.lines; useHeader: module.useHeader } //3.5+
    WiresGroup {
         enabled: active;
         Wire { from: "surface.browsing_info"; to: "browser_info.info" }
         Wire { from: "surface.album_art"; to: "browser_info.album_art" }
    }

    AppProperty { id: loadSelected; path: "app.traktor.decks." + deckId + ".load.selected" }

    WiresGroup {

        enabled: browseEnabled.value && active

        // list mode
        WiresGroup {
            enabled: browserView.value == module.listMode;
            Wire { from: "surface.tag_track";  to: "browser.add_remove_from_prep_list" }
            Wire { from: "surface.browse"; to: "browser.list_navigation" }

            Wire {
                from: "surface.browse.push";
                to: ButtonScriptAdapter {
                    ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled
                    onRelease: loadSelected.value = true;
                }
            }

        }

        // tree mode
        WiresGroup {
            enabled: browserView.value == module.treeMode;
            Wire { from: "surface.browse"; to: "browser.tree_navigation" }

            Wire {
                from: "surface.browse.push";
                to: ButtonScriptAdapter
                {
                    onPress:
                    {
                        if (treeSelectionIsPlaylist.value)
                            browserView.value = module.listMode;
                    }
                }
            }

            Wire {
                from: "surface.tag_track";
                to: ButtonScriptAdapter
                {
                    onPress:
                    {
                        if (treeSelectionHasEntries.value)
                            browserView.value = module.listMode;
                    }
                }
            }
        }
    }

    Wire
    {
        from: "surface.back";
        to: ButtonScriptAdapter
        {
            onPress: browserView.value = module.treeMode
        }
        enabled: active
    }
}
