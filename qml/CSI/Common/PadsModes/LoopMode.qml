import CSI 1.0
import QtQuick 2.12

import "../../../Helpers/LED.js" as LED

Module {
    id: module
    property bool active: true
    property int deckId: 1 //1-4
    property string surface: "path"

    Beatjump { name: "beatjump"; channel: deckId }
    Loop { name: "loop";  channel: deckId; numberOfLeds: 4; color: LED.legacy(deckId) }
    ButtonSection { name: "loop_pads"; buttons: 4; color: Color.Green; stateHandling: ButtonSection.External }
    ButtonSection { name: "beatjump_pads"; buttons: 4; color: Color.LightOrange }

    WiresGroup {
        enabled: active

        Wire { from: DirectPropertyAdapter { path:"mapping.settings.pad_loop_size.1"; input: false } to: "loop_pads.button1.value" }
        Wire { from: DirectPropertyAdapter { path:"mapping.settings.pad_loop_size.2"; input: false } to: "loop_pads.button2.value" }
        Wire { from: DirectPropertyAdapter { path:"mapping.settings.pad_loop_size.3"; input: false } to: "loop_pads.button3.value" }
        Wire { from: DirectPropertyAdapter { path:"mapping.settings.pad_loop_size.4"; input: false } to: "loop_pads.button4.value" }
        Wire { from: DirectPropertyAdapter { path:"mapping.settings.pad_jump_size.1"; input: false } to: "beatjump_pads.button1.value" }
        Wire { from: DirectPropertyAdapter { path:"mapping.settings.pad_jump_size.2"; input: false } to: "beatjump_pads.button2.value" }
        Wire { from: DirectPropertyAdapter { path:"mapping.settings.pad_jump_size.3"; input: false } to: "beatjump_pads.button3.value" }
        Wire { from: DirectPropertyAdapter { path:"mapping.settings.pad_jump_size.4"; input: false } to: "beatjump_pads.button4.value" }

        Wire { from: "%surface%.pads.1"; to: "loop_pads.button1" }
        Wire { from: "%surface%.pads.2"; to: "loop_pads.button2" }
        Wire { from: "%surface%.pads.3"; to: "loop_pads.button3" }
        Wire { from: "%surface%.pads.4"; to: "loop_pads.button4" }
        Wire { from: "%surface%.pads.5"; to: "beatjump_pads.button1" }
        Wire { from: "%surface%.pads.6"; to: "beatjump_pads.button2" }
        Wire { from: "%surface%.pads.7"; to: "beatjump_pads.button3" }
        Wire { from: "%surface%.pads.8"; to: "beatjump_pads.button4" }

        Wire { from: "loop_pads.value"; to: "loop.autoloop_size" }
        Wire { from: "loop_pads.active"; to: "loop.autoloop_active" }

        Wire { from: "beatjump_pads.value"; to: "beatjump.size" }
        Wire { from: "beatjump_pads.active"; to: "beatjump.active" }
    }
}
