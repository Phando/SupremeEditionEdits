import CSI 1.0
import QtQuick 2.12
import QtGraphicalEffects 1.12
import Traktor.Gui 1.0 as Traktor

Item {
  id: view
  property int deckId: 1
  property int streamId //necessary for the WF
  property var waveformColors
  property var waveformPosition
  property int sampleWidth
  readonly property var audioStreamKey: primaryKey.value == 0 ? ["MixerDeckKey", deckId] : ["PrimaryKey", primaryKey.value, streamId]

  Traktor.Waveform {
    id: waveform
    deckId: parent.deckId-1 //becuse in Traktor --> clock: -1, deckA: 0, deckB: 1, deckC: 2, deckD: 3
    anchors.fill: parent
    waveformPosition: view.waveformPosition

    colorMatrix.background: colors.background

    colorMatrix.high1: waveformColors.high1
    colorMatrix.high2: waveformColors.high2
    colorMatrix.mid1: waveformColors.mid1
    colorMatrix.mid2: waveformColors.mid2
    colorMatrix.low1: waveformColors.low1
    colorMatrix.low2: waveformColors.low2

    audioStreamKey: (!view.visible) ? ["PrimaryKey", 0] : view.audioStreamKey
  }

  WaveformColorize {
    id: waveformColorize
    waveform: waveform
    waveformPosition: view.waveformPosition
    anchors.fill:  parent
    loop_start: waveformCues.cueStart
    loop_length: waveformCues.loop_length
    visible: waveformCues.is_looping && theme.value == 1
  }

  AppProperty { id: channelHigh; path: "app.traktor.mixer.channels." + deckId + ".eq.high" }
  AppProperty { id: channelMid; path: "app.traktor.mixer.channels." + deckId + ".eq.mid" }
  AppProperty { id: channelLow; path: "app.traktor.mixer.channels." + deckId + ".eq.low" }

  function rgba(r,g,b,a) { return Qt.rgba(r/255. ,  g/255. ,  b/255. , a/255. ) }

  function wfopacity (eq, ref) {
    if (eq < 0.5) {
        return parseInt((eq/0.5)*ref)
    }
    else {
        return parseInt(ref + 2*(eq-0.5)*(255-ref))
    }
  }

  property variant dynamicWaveformColorsMap: [
    // Traktor Default
    { low1:  rgba (24,   48,  80, wfopacity(channelLow.value, 180)),  low2:  rgba (24,   56,  96, wfopacity(channelLow.value, 190)),
        mid1:  rgba (80,  160, 160, wfopacity(channelMid.value, 100)),  mid2:  rgba (48,  112, 112, wfopacity(channelMid.value, 150)),
        high1: rgba (184, 240, 232, wfopacity(channelHigh.value, 120)),  high2: rgba (208, 255, 248, wfopacity(channelHigh.value, 180)) },
    // Red - #c80000
    { low1:  rgba (200,   0,   0, wfopacity(channelLow.value, 150)),  low2:  rgba (200,  30,  30, wfopacity(channelLow.value, 155)),
        mid1:  rgba (180, 100, 100, wfopacity(channelMid.value, 120)),  mid2:  rgba (180, 110, 110, wfopacity(channelMid.value, 140)),
        high1: rgba (220, 180, 180, wfopacity(channelHigh.value, 140)),  high2: rgba (220, 200, 200, wfopacity(channelHigh.value, 160)) },
    // Dark Orange - #ff3200
    { low1:  rgba (255,  50,   0, wfopacity(channelLow.value, 150)),  low2:  rgba (255,  70,  20, wfopacity(channelLow.value, 170)),
        mid1:  rgba (180,  70,  50, wfopacity(channelMid.value, 120)),  mid2:  rgba (180,  90,  70, wfopacity(channelMid.value, 140)),
        high1: rgba (255, 200, 160, wfopacity(channelHigh.value, 140)),  high2: rgba (255, 220, 180, wfopacity(channelHigh.value, 160)) },
    // Light Orange - #ff6e00
    { low1:  rgba (255, 110,   0, wfopacity(channelLow.value, 150)),  low2:  rgba (245, 120,  10, wfopacity(channelLow.value, 160)),
        mid1:  rgba (255, 150,  80, wfopacity(channelMid.value, 120)),  mid2:  rgba (255, 160,  90, wfopacity(channelMid.value, 140)),
        high1: rgba (255, 220, 200, wfopacity(channelHigh.value, 140)),  high2: rgba (255, 230, 210, wfopacity(channelHigh.value, 160)) },
    // Warm Yellow - #ffa000
    { low1:  rgba (255, 160,   0, wfopacity(channelLow.value, 160)),  low2:  rgba (255, 170,  20, wfopacity(channelLow.value, 170)),
        mid1:  rgba (255, 180,  70, wfopacity(channelMid.value, 120)),  mid2:  rgba (255, 190,  90, wfopacity(channelMid.value, 130)),
        high1: rgba (255, 210, 135, wfopacity(channelHigh.value, 140)),  high2: rgba (255, 220, 145, wfopacity(channelHigh.value, 160)) },
    // Yellow - #ffc800
    { low1:  rgba (255, 200,   0, wfopacity(channelLow.value, 160)),  low2:  rgba (255, 210,  20, wfopacity(channelLow.value, 170)),
        mid1:  rgba (241, 230, 110, wfopacity(channelMid.value, 120)),  mid2:  rgba (241, 240, 120, wfopacity(channelMid.value, 130)),
        high1: rgba (255, 255, 200, wfopacity(channelHigh.value, 120)),  high2: rgba (255, 255, 210, wfopacity(channelHigh.value, 180)) },
    // Lime - #64aa00
    { low1:  rgba (100, 170,   0, wfopacity(channelLow.value, 150)),  low2:  rgba (100, 170,   0, wfopacity(channelLow.value, 170)),
        mid1:  rgba (190, 250,  95, wfopacity(channelMid.value, 120)),  mid2:  rgba (190, 255, 100, wfopacity(channelMid.value, 150)),
        high1: rgba (230, 255, 185, wfopacity(channelHigh.value, 120)),  high2: rgba (230, 255, 195, wfopacity(channelHigh.value, 180)) },
    // Green - #0a9119
    { low1:  rgba ( 10, 145,  25, wfopacity(channelLow.value, 150)),  low2:  rgba ( 20, 145,  35, wfopacity(channelLow.value, 170)),
        mid1:  rgba ( 80, 245,  80, wfopacity(channelMid.value, 110)),  mid2:  rgba ( 95, 245,  95, wfopacity(channelMid.value, 130)),
        high1: rgba (185, 255, 185, wfopacity(channelHigh.value, 140)),  high2: rgba (210, 255, 210, wfopacity(channelHigh.value, 180)) },
    // Mint - #00be5a
    { low1:  rgba (  0, 155, 110, wfopacity(channelLow.value, 150)),  low2:  rgba ( 10, 165, 130, wfopacity(channelLow.value, 170)),
        mid1:  rgba ( 20, 235, 165, wfopacity(channelMid.value, 120)),  mid2:  rgba ( 20, 245, 170, wfopacity(channelMid.value, 150)),
        high1: rgba (200, 255, 235, wfopacity(channelHigh.value, 140)),  high2: rgba (210, 255, 245, wfopacity(channelHigh.value, 170)) },
    // Cyan - #009b6e
    { low1:  rgba ( 10, 200, 200, wfopacity(channelLow.value, 150)),  low2:  rgba ( 10, 210, 210, wfopacity(channelLow.value, 170)),
        mid1:  rgba (  0, 245, 245, wfopacity(channelMid.value, 120)),  mid2:  rgba (  0, 250, 250, wfopacity(channelMid.value, 150)),
        high1: rgba (170, 255, 255, wfopacity(channelHigh.value, 140)),  high2: rgba (180, 255, 255, wfopacity(channelHigh.value, 170)) },
    // Turquoise - #0aa0aa
    { low1:  rgba ( 10, 130, 170, wfopacity(channelLow.value, 150)),  low2:  rgba ( 10, 130, 180, wfopacity(channelLow.value, 170)),
        mid1:  rgba ( 50, 220, 255, wfopacity(channelMid.value, 120)),  mid2:  rgba ( 60, 220, 255, wfopacity(channelMid.value, 140)),
        high1: rgba (185, 240, 255, wfopacity(channelHigh.value, 140)),  high2: rgba (190, 245, 255, wfopacity(channelHigh.value, 180)) },
    // Blue - #1e55aa
    { low1:  rgba ( 30,  85, 170, wfopacity(channelLow.value, 150)),  low2:  rgba ( 50, 100, 180, wfopacity(channelLow.value, 170)),
        mid1:  rgba (115, 170, 255, wfopacity(channelMid.value, 120)),  mid2:  rgba (130, 180, 255, wfopacity(channelMid.value, 140)),
        high1: rgba (200, 230, 255, wfopacity(channelHigh.value, 140)),  high2: rgba (215, 240, 255, wfopacity(channelHigh.value, 170)) },
    //Plum - #6446a0
    { low1:  rgba (100,  70, 160, wfopacity(channelLow.value, 150)),  low2:  rgba (120,  80, 170, wfopacity(channelLow.value, 170)),
        mid1:  rgba (180, 150, 230, wfopacity(channelMid.value, 120)),  mid2:  rgba (190, 160, 240, wfopacity(channelMid.value, 150)),
        high1: rgba (220, 210, 255, wfopacity(channelHigh.value, 140)),  high2: rgba (230, 220, 255, wfopacity(channelHigh.value, 160)) },
    // Violet - #a028c8
    { low1:  rgba (160,  40, 200, wfopacity(channelLow.value, 140)),  low2:  rgba (170,  50, 190, wfopacity(channelLow.value, 170)),
        mid1:  rgba (200, 135, 255, wfopacity(channelMid.value, 120)),  mid2:  rgba (210, 155, 255, wfopacity(channelMid.value, 150)),
        high1: rgba (235, 210, 255, wfopacity(channelHigh.value, 140)),  high2: rgba (245, 220, 255, wfopacity(channelHigh.value, 170)) },
    // Purple - #c81ea0
    { low1:  rgba (200,  30, 160, wfopacity(channelLow.value, 150)),  low2:  rgba (210,  40, 170, wfopacity(channelLow.value, 170)),
        mid1:  rgba (220, 130, 240, wfopacity(channelMid.value, 120)),  mid2:  rgba (230, 140, 245, wfopacity(channelMid.value, 140)),
        high1: rgba (250, 200, 255, wfopacity(channelHigh.value, 140)),  high2: rgba (255, 200, 255, wfopacity(channelHigh.value, 170)) },
    // Magenta - #e60a5a
    { low1:  rgba (230,  10,  90, wfopacity(channelLow.value, 150)),  low2:  rgba (240,  10, 100, wfopacity(channelLow.value, 170)),
        mid1:  rgba (255, 100, 200, wfopacity(channelMid.value, 120)),  mid2:  rgba (255, 120, 220, wfopacity(channelMid.value, 150)),
        high1: rgba (255, 200, 255, wfopacity(channelHigh.value, 140)),  high2: rgba (255, 220, 255, wfopacity(channelHigh.value, 160)) },
    // Fuchsia - #ff0032
    { low1:  rgba (255,   0,  50, wfopacity(channelLow.value, 150)),  low2:  rgba (255,  30,  60, wfopacity(channelLow.value, 170)),
        mid1:  rgba (255, 110, 110, wfopacity(channelMid.value, 130)),  mid2:  rgba (255, 125, 125, wfopacity(channelMid.value, 160)),
        high1: rgba (255, 210, 220, wfopacity(channelHigh.value, 140)),  high2: rgba (255, 220, 230, wfopacity(channelHigh.value, 160)) },
    // Denon SC5000/SC6000 Prime Style
    { low1:  rgba ( 41, 113, 246, wfopacity(channelLow.value, 100)),  low2:  rgba ( 41, 113, 246, wfopacity(channelLow.value, 250)),
        mid1:  rgba ( 98, 234,  82, wfopacity(channelMid.value, 100)),  mid2:  rgba ( 98, 234,  82, wfopacity(channelMid.value, 250)),
        high1: rgba (255, 255, 255, wfopacity(channelHigh.value, 100)),  high2: rgba (255, 255, 255, wfopacity(channelHigh.value, 250)) },
    // Pioneer CDJ-2000 Nexus 2 Style
    { low1:  rgba (200,   0,   0, wfopacity(channelLow.value, 100)),  low2:  rgba (200, 100,   0, wfopacity(channelLow.value, 250)),
        mid1:  rgba (60,  120, 240, wfopacity(channelMid.value, 100)),  mid2:  rgba (80,  160, 240, wfopacity(channelMid.value, 250)),
        high1: rgba (100, 200, 240, wfopacity(channelHigh.value, 100)),  high2: rgba (120, 240, 240, wfopacity(channelHigh.value, 250)) },
    // Pioneer CDJ-3000 Style
    { low1:  rgba (24,   48,  140, wfopacity(channelLow.value, 200)), low2:  rgba (0, 184, 232, wfopacity(channelLow.value, 180)),
        mid1: rgba (255, 110,   0, wfopacity(channelMid.value, 255)),   mid2:  rgba (245, 120,  10, wfopacity(channelMid.value, 160)),
        high1: rgba (232, 232, 232, wfopacity(channelHigh.value, 255)),  high2: rgba (152, 152, 152, wfopacity(channelHigh.value, 255)) },
    // Supreme MOD
    { low1:  rgba (24,   48,  140, wfopacity(channelLow.value, 200)), low2:  rgba (0, 184, 232, wfopacity(channelLow.value, 180)),
        mid1:  rgba ( 80, 245,  80, wfopacity(channelMid.value, 220)),  mid2:  rgba ( 95, 245,  115, wfopacity(channelMid.value, 150)),
        high1: rgba (255, 110,   0, wfopacity(channelHigh.value, 255)),  high2:  rgba (245, 120,  10, wfopacity(channelHigh.value, 160)) },
    // Customized Style
    { low1:  preferences.low1, low2: preferences.low2,
        mid1:  preferences.mid, mid2: preferences.mid2,
        high1: preferences.high1, high2: preferences.high2 }
  ]

}
