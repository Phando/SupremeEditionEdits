import CSI 1.0
import QtQuick 2.12

import "../../../Helpers/LED.js" as LED

Module {
    id: module
    property bool active: true
    property int deckId: 1 //1-4
    property string surface: "path"

    Loop { name: "loop";  channel: deckId; numberOfLeds: 4; color: LED.legacy(deckId) }
    ButtonSection { name: "loop_roll_pads"; buttons: 8; color: Color.Green; stateHandling: ButtonSection.External }

    WiresGroup {
        enabled: active

        Wire { from: DirectPropertyAdapter { path: "mapping.settings.pad_loop_roll_size1"; input: false } to: "loop_roll_pads.button1.value" }
        Wire { from: DirectPropertyAdapter { path: "mapping.settings.pad_loop_roll_size2"; input: false } to: "loop_roll_pads.button2.value" }
        Wire { from: DirectPropertyAdapter { path: "mapping.settings.pad_loop_roll_size3"; input: false } to: "loop_roll_pads.button3.value" }
        Wire { from: DirectPropertyAdapter { path: "mapping.settings.pad_loop_roll_size4"; input: false } to: "loop_roll_pads.button4.value" }
        Wire { from: DirectPropertyAdapter { path: "mapping.settings.pad_loop_roll_size5"; input: false } to: "loop_roll_pads.button5.value" }
        Wire { from: DirectPropertyAdapter { path: "mapping.settings.pad_loop_roll_size6"; input: false } to: "loop_roll_pads.button6.value" }
        Wire { from: DirectPropertyAdapter { path: "mapping.settings.pad_loop_roll_size7"; input: false } to: "loop_roll_pads.button7.value" }
        Wire { from: DirectPropertyAdapter { path: "mapping.settings.pad_loop_roll_size8"; input: false } to: "loop_roll_pads.button8.value" }

        Wire { from: "%surface%.pads.1"; to: "loop_roll_pads.button1" }
        Wire { from: "%surface%.pads.2"; to: "loop_roll_pads.button2" }
        Wire { from: "%surface%.pads.3"; to: "loop_roll_pads.button3" }
        Wire { from: "%surface%.pads.4"; to: "loop_roll_pads.button4" }
        Wire { from: "%surface%.pads.5"; to: "loop_roll_pads.button5" }
        Wire { from: "%surface%.pads.6"; to: "loop_roll_pads.button6" }
        Wire { from: "%surface%.pads.7"; to: "loop_roll_pads.button7" }
        Wire { from: "%surface%.pads.8"; to: "loop_roll_pads.button8" }

        Wire { from: "loop_roll_pads.value"; to: "loop.autoloop_size" }
        Wire { from: "loop_roll_pads.active"; to: "loop.autoloop_active" }
    }
}
