import CSI 1.0
import QtQuick 2.12

import "../../../Defines"

Module {
    id: module
    property bool active: true
    property int deckId: 1 //1-4
    property string surface: "path"
    property bool browsing: false

    RemixDeck { name: "remix"; channel: deckId; size: RemixDeck.Small } //small only offers 4x2 control, whereas large offers 4x4 control
    DirectPropertyAdapter { name: "remixLegacyPage"; path: deckPropertiesPath + ".remixPadsControl" }
    Wire { from: "remixLegacyPage.read"; to: "remix.page.write" }

    //RMX Deck Properties

    WiresGroup {
        enabled: active

        //Wire { from: "remix.capture_mode.input";  to: DirectPropertyAdapter { path: holdCapture.path; input: false } }

        WiresGroup {
            enabled: !shift

            Wire { from: "%surface%.pads.1"; to: "remix.1_1.trigger" }
            Wire { from: "%surface%.pads.2"; to: "remix.2_1.trigger" }
            Wire { from: "%surface%.pads.3"; to: "remix.3_1.trigger" }
            Wire { from: "%surface%.pads.4"; to: "remix.4_1.trigger" }
            Wire { from: "%surface%.pads.5"; to: "remix.1_2.trigger" }
            Wire { from: "%surface%.pads.6"; to: "remix.2_2.trigger" }
            Wire { from: "%surface%.pads.7"; to: "remix.3_2.trigger" }
            Wire { from: "%surface%.pads.8"; to: "remix.4_2.trigger" }

            WiresGroup {
                enabled: !browsing

                Wire { from: "%surface%.pads.1"; to: "remix.1_1.capture" }
                Wire { from: "%surface%.pads.2"; to: "remix.2_1.capture" }
                Wire { from: "%surface%.pads.3"; to: "remix.3_1.capture" }
                Wire { from: "%surface%.pads.4"; to: "remix.4_1.capture" }
                Wire { from: "%surface%.pads.5"; to: "remix.1_2.capture" }
                Wire { from: "%surface%.pads.6"; to: "remix.2_2.capture" }
                Wire { from: "%surface%.pads.7"; to: "remix.3_2.capture" }
                Wire { from: "%surface%.pads.8"; to: "remix.4_2.capture" }
            }

            WiresGroup {
                enabled: browsing

                Wire { from: "%surface%.pads.1"; to: "remix.1_1.load" }
                Wire { from: "%surface%.pads.2"; to: "remix.2_1.load" }
                Wire { from: "%surface%.pads.3"; to: "remix.3_1.load" }
                Wire { from: "%surface%.pads.4"; to: "remix.4_1.load" }
                Wire { from: "%surface%.pads.5"; to: "remix.1_2.load" }
                Wire { from: "%surface%.pads.6"; to: "remix.2_2.load" }
                Wire { from: "%surface%.pads.7"; to: "remix.3_2.load" }
                Wire { from: "%surface%.pads.8"; to: "remix.4_2.load" }
            }
        }

        WiresGroup {
            enabled: shift

            Wire { from: "%surface%.pads.1"; to: "remix.1_1.stop"  }
            Wire { from: "%surface%.pads.2"; to: "remix.2_1.stop"  }
            Wire { from: "%surface%.pads.3"; to: "remix.3_1.stop"  }
            Wire { from: "%surface%.pads.4"; to: "remix.4_1.stop"  }
            Wire { from: "%surface%.pads.5"; to: "remix.1_2.stop"  }
            Wire { from: "%surface%.pads.6"; to: "remix.2_2.stop"  }
            Wire { from: "%surface%.pads.7"; to: "remix.3_2.stop"  }
            Wire { from: "%surface%.pads.8"; to: "remix.4_2.stop"  }

            Wire { from: "%surface%.pads.1"; to: "remix.1_1.delete"  }
            Wire { from: "%surface%.pads.2"; to: "remix.2_1.delete"  }
            Wire { from: "%surface%.pads.3"; to: "remix.3_1.delete"  }
            Wire { from: "%surface%.pads.4"; to: "remix.4_1.delete"  }
            Wire { from: "%surface%.pads.5"; to: "remix.1_2.delete"  }
            Wire { from: "%surface%.pads.6"; to: "remix.2_2.delete"  }
            Wire { from: "%surface%.pads.7"; to: "remix.3_2.delete"  }
            Wire { from: "%surface%.pads.8"; to: "remix.4_2.delete"  }
        }

        WiresGroup {
            Wire { from: "remix.1_1";	 to: "%surface%.pads.1.led" }
            Wire { from: "remix.2_1";	 to: "%surface%.pads.2.led" }
            Wire { from: "remix.3_1";	 to: "%surface%.pads.3.led" }
            Wire { from: "remix.4_1";	 to: "%surface%.pads.4.led" }
            Wire { from: "remix.1_2";	 to: "%surface%.pads.5.led" }
            Wire { from: "remix.2_2";	 to: "%surface%.pads.6.led" }
            Wire { from: "remix.3_2";	 to: "%surface%.pads.7.led" }
            Wire { from: "remix.4_2";	 to: "%surface%.pads.8.led" }
        }
    }
}
