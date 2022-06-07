pragma Singleton

import QtQuick 2.12
import CSI 1.0

QtObject {

  readonly property int disabled:    	0
  readonly property int hotcues:     	1
  readonly property int tonePlay:     	2
  readonly property int freeze:      	3
  readonly property int loop:        	4
  readonly property int advancedLoop:	5
  readonly property int loopRoll:    	6
  readonly property int legacyRemix:   	7
  readonly property int remix: 			8
  readonly property int sequencer:     	9
  readonly property int stems:       	10
  readonly property int effects:     	11

  function isPadsModeSupported(padMode, deckType) {
	switch(padMode) {
		case disabled:
			return deckType == DeckType.Live
		case hotcues:
			return deckType == DeckType.Stem || deckType == DeckType.Track
		case legacyRemix:
		case remix:
		case sequencer:
			return deckType == DeckType.Remix
		case stems:
			return deckType == DeckType.Stem
		case freeze:
		case loop:
		case advancedLoop:
		case loopRoll:
			return deckType != DeckType.Live
		case effects:
			return true
	}
  }

  function defaultPadsModeForDeck(deckType) {
    switch(deckType) {
		case DeckType.Stem:
			return stems
		case DeckType.Remix:
			return remix
		case DeckType.Track:
			return hotcues
		case DeckType.Live:
			//return preferencesQuickFXMode ? PadsMode.effects : PadsMode.disabled
		default:
			return disabled
    }
  }

}

  
