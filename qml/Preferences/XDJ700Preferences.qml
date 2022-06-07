import CSI 1.0
import QtQuick 2.12

Module {

//-----------------------------------------------------------------------------------------------------------------------------------
// SETTINGS - TRANSPORT BUTTONS
//-----------------------------------------------------------------------------------------------------------------------------------

    property int playButton: 0
        /*
        0: Play --> play will instantly pause the deck
        1: Vinyl Break --> play will slowly pause the deck, imitating the effect a Vinyl dows when stopped
        */
    property int shiftPlayButton: 1
        /*
        0: Play --> play will instantly pause the deck
        1: Vinyl Break --> play will slowly pause the deck, imitating the effect a Vinyl dows when stopped
        */
    property bool playBlinker: true
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
    property bool cueBlinker: true
        /*
        true: the CUE LED will blink when the deck is paused, and the playhead position isn't in the Cue position (Which means that, effectively, when you press the button a new Cue position will be set instead of playing)
        false: the CUE LED will not blink, and will respond in the way Traktor's GUI does.
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
// SETTINGS - OTHERS
//-----------------------------------------------------------------------------------------------------------------------------------

    // Pioneer settings
    property bool reloopMode: false
        /*
        true: the Reloop button acts as it does in standalone mode
        false: the Reloop button toggles the Loop Active state
        */
    property bool quantizedLoopSizes: false
        /*
        true: (CDJ style) When doubling/halving a loop, it will double its current size without quantizing it to the most similar loop size
        true: (Traktor's behaviour) When doubling/halving a loop, it will double quantize the Loop Size and then double/half the Loop
        */
    property bool hotcuesPlayMode: false
        /*
        true: (CDJ style) If a hotcue pad is pressed, the deck will start playing from the Hotcue
        false: (Traktor's behaviour) While holding the pad, the deck will play. When released, unless play is pressed, the deck will pause and return to the Hotcue
        */
    property bool needleLock: false
        /*
        true: moving the finger through the stripe does nothing
        false: moving the finger through the stripe seeks through the track
        */

    //Timers
    property int holdTimer: 250
        /*
        Time (in mili seconds (ms)) required to hold a button to do the hold action instead of the push/trigger action
        Min: 50 ms
        Max: 3000 ms
        */

}
