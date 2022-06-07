import CSI 1.0
import QtQuick 2.12

Module {
    id: module
    property bool active: true
    property int deckId: 1 //1-4
    property string surface: "path"

    FreezeSlicer { name: "freeze_slicer"; channel: deckId; numberOfSlices: sliceCount.value }

    WiresGroup {
        enabled: active

        WiresGroup {
            enabled: sliceCount.value <= 8 || (sliceCount.value > 8 && !shift)

            Wire { from: "%surface%.pads.1"; to: "freeze_slicer.slice1" }
            Wire { from: "%surface%.pads.2"; to: "freeze_slicer.slice2"; enabled: sliceCount.value > 1 }
            Wire { from: "%surface%.pads.3"; to: "freeze_slicer.slice3"; enabled: sliceCount.value > 2 }
            Wire { from: "%surface%.pads.4"; to: "freeze_slicer.slice4"; enabled: sliceCount.value > 3 }
            Wire { from: "%surface%.pads.5"; to: "freeze_slicer.slice5"; enabled: sliceCount.value > 4 }
            Wire { from: "%surface%.pads.6"; to: "freeze_slicer.slice6"; enabled: sliceCount.value > 5 }
            Wire { from: "%surface%.pads.7"; to: "freeze_slicer.slice7"; enabled: sliceCount.value > 6 }
            Wire { from: "%surface%.pads.8"; to: "freeze_slicer.slice8"; enabled: sliceCount.value > 7 }
        }

        WiresGroup {
            enabled: sliceCount.value > 8 && shift

            /* AJF: CSI Error --> Cannot find input pin with path freeze_slicer.slice9-16
            Wire { from: "%surface%.pads.1"; to: "freeze_slicer.slice9"; enabled: sliceCount.value > 8 }
            Wire { from: "%surface%.pads.2"; to: "freeze_slicer.slice10"; enabled: sliceCount.value > 9 }
            Wire { from: "%surface%.pads.3"; to: "freeze_slicer.slice11"; enabled: sliceCount.value > 10 }
            Wire { from: "%surface%.pads.4"; to: "freeze_slicer.slice12"; enabled: sliceCount.value > 11 }
            Wire { from: "%surface%.pads.5"; to: "freeze_slicer.slice13"; enabled: sliceCount.value > 12 }
            Wire { from: "%surface%.pads.6"; to: "freeze_slicer.slice14"; enabled: sliceCount.value > 13 }
            Wire { from: "%surface%.pads.7"; to: "freeze_slicer.slice15"; enabled: sliceCount.value > 14 }
            Wire { from: "%surface%.pads.8"; to: "freeze_slicer.slice16"; enabled: sliceCount.value > 15 }
            */
        }
    }
}
