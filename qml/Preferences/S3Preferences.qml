import CSI 1.0
import QtQuick 2.12

Module {

//-----------------------------------------------------------------------------------------------------------------------------------
// SETTINGS - DECK COLORS
//-----------------------------------------------------------------------------------------------------------------------------------

/*
Available colors:
NOTE: If there is any spelling mistakes, it will be considered as white (the default color)

    Red			Dark Orange			Light Orange		Warm Yellow
    Yellow		Lime				Green				Mint
    Cyan		Turquoise			Blue				Plum
    Violet		Purple				Magenta				Fuchsia
    White		Black (Off)
*/

    property string deckAColor: "Blue"
    property string deckBColor: "Blue"
    property string deckCColor: "Light Orange"
    property string deckDColor: "Light Orange"

//-----------------------------------------------------------------------------------------------------------------------------------
// SETTINGS - SHIFT
//-----------------------------------------------------------------------------------------------------------------------------------

    property bool globalShift: false

//-----------------------------------------------------------------------------------------------------------------------------------
// SETTINGS - TRANSPORT BUTTONS
//-----------------------------------------------------------------------------------------------------------------------------------

    property int playButton: 0
        /*
        0: Play --> play will instantly pause the deck
        1: Vinyl Break --> play will slowly pause the deck, imitating the effect a Vinyl dows when stopped
        */
    property int shiftPlayButton: 0
        /*
        0: Play --> play will instantly pause the deck
        1: Vinyl Break --> play will slowly pause the deck, imitating the effect a Vinyl dows when stopped
        */
    property bool playBlinker: false
        /*
        true: the play LED will blink when the deck is paused or when it's cueing and the deck isn't playing
        false: the play LED will not blink, and will respond in the way Traktor's GUI does.
        */

    property int cueButton: 0
    property int shiftCueButton: 2
        /*
        0: CUE
        1: CUP
        2: Restart
        */
    property bool cueBlinker: false
        /*
        true: the CUE LED will blink when the deck is paused, and the playhead position isn't in the Cue position (Which means that, effectively, when you press the button a new Cue position will be set instead of playing)
        false: the CUE LED will not blink, and will respond in the way Traktor's GUI does.
        */

    property bool faderStart: false
        /*
        true: deck will automatically Play/Cue when deck is 'on air' (Volume Fader + XFader)
        false: default behavior
        */
    property bool reverseCensor: true
        /*
        true: the reverse button will censor (flux reverse) no matter the flux state
        false: the reverse button will reverse or flux reverse depending on the flux state
        */

    property int vinylBreakDuration: 1000 //in miliseconds (ms) --> 1000ms = 1s


//-----------------------------------------------------------------------------------------------------------------------------------
// SETTINGS - KEY SYNC
//-----------------------------------------------------------------------------------------------------------------------------------

    property bool fuzzyKeySync: true
        /*
        true: opposite scale adjacent keys will be considered a match --> if deck is 5A, the algorithm will match to: 5A/B + 4A/B & 6A/B
        false: opposite scale adjacent keys will NOT be considered a match --> if deck is 5A, the algorithm will match ONLY to: 5A/B + 4A & 6A
        */
    property bool useKeyText: false
        /*
        true: if the Key Text field is a readable key (must be correctly formatted), it will use this key instead of Traktor's Key Field
        false: it will synchronize keys using the Key field
        */

//-----------------------------------------------------------------------------------------------------------------------------------
// SETTINGS - PADS
//-----------------------------------------------------------------------------------------------------------------------------------

    property bool hotcuesPlayMode: false
        /*
        true: (CDJ style) If a hotcue pad is pressed, the deck will start playing from the Hotcue
        false: (Traktor's behaviour) While holding the pad, the deck will play. When released, unless play is pressed, the deck will pause and return to the Hotcue
        */

    property int hotcueColors: 0
        /*
        0: (Traktor's behavior) pads LEDs will depend on the hotcue type
        1: (CDJ style) pad LEDs will depend on the hotcue type --> orange: loops, green: other hot cues
        2: (RB: Colorful) pads LEDs will be based on the default values of the Colorful scheme for Hot Cues in Rekordbox
        */

//-----------------------------------------------------------------------------------------------------------------------------------
// SETTINGS - PADS - MODE SELECTOR
//-----------------------------------------------------------------------------------------------------------------------------------

    property int shiftHotcueButton: 0
        /*
        0: Disabled (Hotcues Mode)
        1: Loop Mode (S5/S8/D2 default loop mode)
        2: Advanced Loop Mode
        3: Loop Roll Mode
        4: Pad FXs
        */
    //property int samplesButton: 0
    //property int shiftSamplesButton: 0

//-----------------------------------------------------------------------------------------------------------------------------------
// SETTINGS - BROWSER
//-----------------------------------------------------------------------------------------------------------------------------------

    property bool browserOnFullScreenOnly: false
        /*
        true: when enabled, the navigation + load commands through the Browse encoder will only be enabled when browser is on full-screen mode, allowing for other functionalities when the browser isn't in full-screen
        false: the browser will be focused excusively to browsing purposes, no matter its full-screen state
        */
    property bool showBrowserOnTouch: false
        /*
        true: when touching the Browse encoder, Traktor's browser will automatically become full-screen
        false: you need to manually press the view button to open the full-screen browser.
        */
    property bool autocloseBrowser: false
        /*
        true: if there is no interaction after X seconds, the browser will automatically close (browserTimer)
        false: you need to manually press the view button to close the full-screen browser (or not)r load a track).
        */
    property int browserTimer: 1000
        /*
        Time (in mili seconds (ms)) after which the browser will close automatically if autocloseBrowser is enabled
        Min: 100 ms
        Max: 10000 ms
        */

//-----------------------------------------------------------------------------------------------------------------------------------
// SETTINGS - BROWSE ENCODER
//-----------------------------------------------------------------------------------------------------------------------------------

    property int browseEncoder: 3
        /*
        WARNING: showBrowserOnTouch needs to be disabled
        0: BPM adjust
        1: Tempo adjust
        2: Waveform Zoom
        3: Playlist navigation
        */
    property int browsePush: 0
        /*
        WARNING: showBrowserOnTouch needs to be disabled
        0: Load Track
        1: Instant Doubles
        2: Load Next Track
        3: Load Previous Track
        4: BPM/Tempo Reset
        */

    property int shiftBrowseEncoder: 3
        /*
        0: BPM adjust
        1: Tempo adjust
        2: Waveform Zoom
        3: Tree navigation
        */
    property int shiftBrowsePush: 0
        /*
        0: Open/Collapse tree node
        1: Instant Doubles
        2: Load Next Track
        3: Load Previous Track
        4: BPM/Tempo Reset
        */

    property double stepBPM: 1.00
        /*
        Step that will jump the encoder when adjusting the BPM, when browseEncoder is 0
        Min: 0.01
        Max: 5.00
        */
    property double stepShiftBPM: 0.01
        /*
        Step that will jump the encoder when adjusting the BPM, when shiftBrowseEncoder is 0
        Min: 0.01
        Max: 5.00
        */

    property double stepTempo: 0.01 //0.01 = 1%
        /*
        Step that will jump the encoder when adjusting the tempo, when browseEncoder is 1
        Min: 0.0005
        Max: 0.1
        */
    property double stepShiftTempo: 0.001
        /*
        Step that will jump the encoder when adjusting the tempo, when shiftBrowseEncoder is 1
        Min: 0.0005
        Max: 0.1
        */

//-----------------------------------------------------------------------------------------------------------------------------------
// SETTINGS - OTHERS
//-----------------------------------------------------------------------------------------------------------------------------------

    //Timers
    property int holdTimer: 250
        /*
        Time (in mili seconds (ms)) required to hold a button to do the hold action instead of the push/trigger action
        Min: 50 ms
        Max: 3000 ms
        */

    property bool autoZoomTPwaveform: true
        /*
        true: Traktor's waveform will automatically zoom in/out when entering/leaving the edit mode (Pressing the Grid button)
        false: the waveform zoom isn't modified when entering/leaving the edit mode
        */
}
