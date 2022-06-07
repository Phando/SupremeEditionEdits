import CSI 1.0

import "../../../Helpers/KeySync.js" as KeySyncHelper

Module {
    id: module
    property bool active: true
    property int deckId: 1

    ButtonScriptAdapter {
        name: "KeySyncButton"
        brightness: KeySyncHelper.isSynchronized(resultingKeyIndex.value, masterResultingKeyIndex.value, fuzzyKeySync.value) && keyLock.value
        onPress: {
            if (keyLock.value) {
                if (KeySyncHelper.isSynchronized(resultingKeyIndex.value, masterResultingKeyIndex.value, fuzzyKeySync.value)) keyAdjust.value = 0
                else keyAdjust.value = keyAdjust.value + KeySyncHelper.sync(resultingKeyIndex.value, masterResultingKeyIndex.value, fuzzyKeySync.value)
            }
            else {
                // keyLock.value = true
                keyAdjust.value = KeySyncHelper.sync(resultingKeyIndex.value, masterResultingKeyIndex.value, fuzzyKeySync.value)
            }
        }
    }

    WiresGroup {
        enabled: active

        Wire { from: "surface.key_sync"; to: SetPropertyAdapter { path: "app.traktor.decks." + deckId + ".track.key.lock_enabled"; value: true; output: false } enabled: !keyLock.value && masterId.value != -1 && (masterDeckType.value == DeckType.Track || masterDeckType.value == DeckType.Stem) && (deckType.value == DeckType.Track || deckType.value == DeckType.Stem) }
        Wire { from: "surface.key_sync"; to: "KeySyncButton"; enabled: masterId.value != -1 && (masterDeckType.value == DeckType.Track || masterDeckType.value == DeckType.Stem) && (deckType.value == DeckType.Track || deckType.value == DeckType.Stem) }
    }
}
