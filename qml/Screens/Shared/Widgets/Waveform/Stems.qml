import CSI 1.0
import QtQuick 2.12
import QtGraphicalEffects 1.12
import Traktor.Gui 1.0 as T

Item {
  id: view
  property int deckId: 1
  property int sampleWidth
  property var waveformPosition

  readonly property int stemCount: 4

  MappingProperty { id: waveformColor; path: "mapping.settings.waveformColor" }

  Repeater {
    model: stemCount

    SingleWaveform {
        AppProperty { id: stemColor; path: "app.traktor.decks." + deckId + ".stems." + streamId + ".color_id" }

        deckId: view.deckId
        streamId: index + 1
        sampleWidth: view.sampleWidth
        waveformPosition: view.waveformPosition
        waveformColors: colors.getStemWaveformColors(stemColor.value, waveformColor.value )

        y: index * view.height/stemCount
        width: view.width
        height: view.height/stemCount
        clip: true
    }
  }

}
