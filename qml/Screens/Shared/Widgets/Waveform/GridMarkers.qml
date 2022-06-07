import CSI 1.0
import QtQuick 2.12
import Traktor.Gui 1.0 as Traktor

import '..' as Widgets

Item {
  id: view
  property int deckId: 1
  property var waveformPosition
  property var gridMarkers

  anchors.fill: parent

  Repeater {
    //id: grids
    model: gridMarkers.length

    Traktor.WaveformTranslator {
        //property int deckId: parent.deckId

        followTarget: waveformPosition
        pos: gridMarkers[index]

        Widgets.GridMarker {
            anchors.topMargin: 3
            height: view.height
            showHead: deckSize != "small"
            smallHead: false
        }
    }
  }
}
