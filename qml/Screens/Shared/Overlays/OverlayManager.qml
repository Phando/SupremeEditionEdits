import CSI 1.0
import QtQuick 2.12
import QtGraphicalEffects 1.12

import '../../../Defines'
import './CenterOverlays/' as CenterOverlays

Item {
  id: overlay
  property int deckId
  property int remixId

  anchors.fill: parent

//------------------------------------------------------------------------------------------------------------------
// OVERLAY CONTENT
//------------------------------------------------------------------------------------------------------------------

/*
  CenterOverlays.NameOfQMLFile {
    id: name you give to the overlay (overlay.name)
    deckId: overlay.deckId
  }
*/

  CenterOverlays.TempoAdjust {
    id: tempo
    deckId: overlay.deckId
  }

  CenterOverlays.Keylock {
    id: keylock
    deckId: overlay.deckId
  }

  CenterOverlays.CueType {
    id: hotcueType
    deckId: overlay.deckId
  }

  CenterOverlays.MixerFX {
    id: mixerfx
    deckId: overlay.deckId //for the S5, send the deckId of the corresponding deck
  }

  CenterOverlays.QuantizeSizeAdjust {
    id: quantize
    deckId: overlay.remixId //deckId
  }

  CenterOverlays.SwingAdjust {
    id: swing
    deckId: overlay.remixId //deckId
  }

  CenterOverlays.SliceSize {
    id: sliceSize
    deckId: overlay.deckId
  }

  CenterOverlays.RemixCaptureSource {
    id: captureSource
    deckId: overlay.remixId
  }

  CenterOverlays.BrowserWarnings {
    id: browserWarnings
    deckId: overlay.deckId
  }

  CenterOverlays.BrowserSorting {
    id: browserSorting
  }

//------------------------------------------------------------------------------------------------------------------
// STATES
//------------------------------------------------------------------------------------------------------------------

  state: Overlay.states[screenOverlay.value]
  onStateChanged: {
    //Function to disable all overlays. This is to keep the states simple and compact (only 1 deck overlay can be visible)
    tempo.visible = false;
    keylock.visible = false;
    hotcueType.visible = false;
    mixerfx.visible	= false;
    quantize.visible = false;
    swing.visible = false;
    sliceSize.visible = false;
    browserSorting.visible = false;
    captureSource.visible = false;
    browserWarnings.visible = false;
  }

  states: [
    State {
        name: Overlay.states[Overlay.none]
        PropertyChanges { target: overlay; visible: false }
    },
/*
    State {
        name: Overlay.states[Overlay.id]
        PropertyChanges { target: overlay; visible: true }
        PropertyChanges { target: id; visible: true }
    },
*/
    State {
        name: Overlay.states[Overlay.bpm]
        PropertyChanges { target: overlay; visible: true }
        PropertyChanges { target: tempo; visible: true }
    },
    State {
        name: Overlay.states[Overlay.key]
        PropertyChanges { target: overlay; visible: true }
        PropertyChanges { target: keylock; visible: true }
    },
    State {
        name: Overlay.states[Overlay.hotcueType]
        PropertyChanges { target: overlay; visible: true }
        PropertyChanges { target: hotcueType; visible: true }
    },
    State {
        name: Overlay.states[Overlay.mixerfx]
        PropertyChanges { target: overlay; visible: true }
        PropertyChanges { target: mixerfx; visible: true }
    },
    State {
        name: Overlay.states[Overlay.quantize]
        PropertyChanges { target: overlay; visible: true }
        PropertyChanges { target: quantize; visible: true }
    },
    State {
        name: Overlay.states[Overlay.swing]
        PropertyChanges { target: overlay; visible: true }
        PropertyChanges { target: swing; visible: true }
    },
    State {
        name: Overlay.states[Overlay.slice]
        PropertyChanges { target: overlay; visible: true }
        PropertyChanges { target: sliceSize; visible: true }
    },
    State {
        name: Overlay.states[Overlay.capture]
        PropertyChanges { target: overlay; visible: true }
        PropertyChanges { target: captureSource; visible: true }
    },
    State {
        name: Overlay.states[Overlay.browserWarnings]
        PropertyChanges { target: overlay; visible: true }
        PropertyChanges { target: browserWarnings; visible: true }
    },
    State {
        name: Overlay.states[Overlay.sorting]
        PropertyChanges { target: overlay; visible: true }
        PropertyChanges { target: browserSorting; visible: true }
    }
  ]
}