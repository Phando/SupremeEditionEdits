import CSI 1.0
import QtQuick 2.12

Module {

//-----------------------------------------------------------------------------------------------------------------------------------
// CUSTOMIZABLE WF COLORS (In the Preferences Menu of the controller --> Global Options --> Waveform Options --> Color: "Customized")
//-----------------------------------------------------------------------------------------------------------------------------------

    //Here's a useful link to get the rgba values: https://developer.mozilla.org/es/docs/Web/CSS/CSS_Colors/Herramienta_para_seleccionar_color

    function rgba(r,g,b,a) { return Qt.rgba( r/255., g/255., b/255., a ) }
    //red 0-255
    //green 0-255
    //blue 0-255
    //alpha 0.00-1.00

    property color low1:	rgba ( 17,  74, 238, 0.83)
    property color low2:	rgba ( 15,  70, 245, 0.80)
    property color mid1:	rgba ( 14, 241,  14, 0.81)
    property color mid2:	rgba ( 10, 230,  10, 0.79)
    property color high1:	rgba (178,  14, 200, 0.84)
    property color high2:	rgba (175,  12, 190, 0.82)

//-----------------------------------------------------------------------------------------------------------------------------------
// CUSTOMIZABLE HOTCUE COLORS (NOT IMPLEMENTED YET)
//-----------------------------------------------------------------------------------------------------------------------------------

    /*
    property color hotcue1Color: Color.Red
    property color hotcue2Color: Color.Red
    property color hotcue3Color: Color.Red
    property color hotcue4Color: Color.Red
    property color hotcue5Color: Color.Red
    property color hotcue6Color: Color.Red
    property color hotcue7Color: Color.Red
    property color hotcue8Color: Color.Red
    */

//-----------------------------------------------------------------------------------------------------------------------------------
// CUSTOMIZABLE TRACK DECK HEADER (In the Preferences Menu of the controller --> Global Options --> Deck Header --> "Traktor")
//-----------------------------------------------------------------------------------------------------------------------------------

    /*
    Here are the numbers that are associated to each entry:

        0:  "title",             1: "artist",		      2:  "release",
        3:  "mix",               4: "remixer",		      5:  "genre",
        6:  "track length",      7: "comment",		      8:  "comment2",
        9:  "label",             10: "catNo",		      11: "bitrate",
        12: "gain",              13: "elapsed time",      14: "remaining time",
        15: "beats",             16: "beats to next cue", 17: "sync/master indicator",
        18: "original bpm",      19: "bpm",               20: "stable bpm",
        21: "tempo",             22: "stable tempo",  	  23: "tempo range",
        24: "original key",      25: "resulting key",     26: "original keyText",
        27: "resulting keyText", 28: "remixBeats",        29: "remixQuantize",
        30: "capture source",    31: "mixerFX",           32: "mixerFXshort",
        33: "off"
    */

  property int topLeftState:      0;			property int topMiddleState:    14;			property int topRightState:     20;
  property int midLeftState:      1;			property int midMiddleState:    6;			property int midRightState:     22;
  property int bottomLeftState:   7;			property int bottomMiddleState: 5;			property int bottomRightState:  21;
}
