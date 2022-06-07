import CSI 1.0
import QtQuick 2.12

Module {
    id: padFXs

//-----------------------------------------------------------------------------------------------------------------------------------
// INFORMATION ABOUT FXs
//-----------------------------------------------------------------------------------------------------------------------------------

/*
Available colors:
NOTE: If there is any spelling mistakes, it will be considered as white (the default color)

    Red			Dark Orange			Light Orange		Warm Yellow
    Yellow		Lime				Green				Mint
    Cyan		Turquoise			Blue				Plum
    Violet		Purple				Magenta				Fuchsia
    White		Black (Off)


Available Routing:

    Send | Insert | Post Fader


Available FXs:

    None/Disabled       Filter              Ringmodulator           [M] WormHole
    Delay               Filter:92 LFO       Digital LoFi            [M] LaserSlicer
    Reverb              Filter:92 Pulse     Mulholland Drive        [M] GranuPhase
    Flanger             Filter:92           Transpose Stretch       [M] Bass-o-Matic
    Flanger Pulse       Phaser              BeatSlicer              [M] PolarWind
    Flanger Flux        Phaser Pulse        Formant Filter          [M] EventHorizon
    Gater               Phaser Flux         Peak Filter             [M] Zzzurp
    Beatmasher 2        Reverse Grain       Tape Delay              [M] FlightTest
    Delay T3            Turntable FX        Ramp Delay              [M] Strrretch (Slow)
    Filter LFO          Iceverb             Auto Bouncer            [M] Strrretch (Fast)
    Filter Pulse        Reverb T3           Bouncer                 [M] DarkMatter

Interesting Group FXs combos:
    1. BeatSlicer       Filter:92 LFO       Delay
    2. Beatmasher 2     Transpose Stretch   Reverb
    3. PolarWind        Gater               Digital LoFi
    4. Reverb T3        Delay T3            Digital LoFi
    5. Reverb T3        Delay T3            Filter
    6. Beatmasher 2     Gater               Flanger
    7. Beatmasher 2     Phaser              Digital LoFi
    8. Delay            Phaser Flux         Reverb T3

DJTechTools GroupFXs combos:
    9. BeatMasher 2     Filter              Flanger Pulse
    10. Beatmasher 2    Delay               Reverse Grain
    11. Beatmasher 2    Lofi                Turntable FX
    12. Gater           Formant Filter      Reverb

*/


//-----------------------------------------------------------------------------------------------------------------------------------
// PAD FX - SLOT 1
//-----------------------------------------------------------------------------------------------------------------------------------

    property var pads: [
    {
        // PadFX 1.1
        name	: "Echo Fade",
        color	: "Magenta",
        routing	: "Insert",
        effect1	: "Delay",
        effect2	: "Off",
        effect3	: "Off",
        drywet	: 0.25,
        knob1	: 0.5,
        knob2	: 0.5,
        knob3	: 0.4,
        button1	: 0, // Off
        button2	: 1, // On
        button3	: 0  // Off
    },
    {
        // PadFX 1.2
        name	: "Echo Multi",
        color	: "Warm Yellow",
        routing	: "Insert",
        effect1	: "Beatmasher 2",
        effect2	: "EventHorizon",
        effect3	: "Filter:92",
        drywet	: 1.0,
        knob1	: 0,	// 1 Measure
        knob2	: 0.5,
        knob3	: 0.5,
        button1	: 1,
        button2	: 1,
        button3	: 1
    },
    {
        // PadFX 1.3
        name	: "Techno Phil",
        color	: "Lime",
        routing	: "Insert",
        effect1	: "Beatmasher 2",
        effect2	: "Transpose Stretch",
        effect3	: "Filter:92",
        drywet	: 1.0,
        knob1	: 0,	// 1 Measure
        knob2	: 0.5,
        knob3	: 0.5,
        button1	: 1,
        button2	: 1,
        button3	: 1
    },
    {
        // PadFX 1.4
        name	: "Space Toys",
        color	: "Cyan",
        routing	: "Insert",
        effect1	: "Gater",
        effect2	: "Formant Filter",
        effect3	: "Peak Filter",
        drywet	: 0.4,
        knob1	: 0,
        knob2	: 0,
        knob3	: 0,
        button1	: 1,
        button2	: 1,
        button3	: 1
    },
    {
        // PadFX 1.5
        name	: "Echo Fade*",
        color	: "Fuchsia",
        routing	: "Insert",
        effect1	: "Delay",
        effect2	: "Off",
        effect3	: "Off",
        drywet	: { value: 0.0, min: 0, max: 0.9, delta: 4 }, // Dry Wet
        knob1	: 0.25, // Seems unanimatable
        knob2	: { value: 0.0, min: 0, max: 1, delta: 4 },
        knob3	: { value: 0.35, min: 0, max: 1, delta: 6 },
        button1	: 0,
        button2	: 1,
        button3	: 0
    },
    {
        //PadFX 1.6
        name	: "Echo Multi*",
        color	: "Light Orange",
        routing	: "Insert",
        effect1	: "Beatmasher 2",
        effect2	: "EventHorizon",
        effect3	: "Filter:92",
        drywet	: { value: 0.4, min: 0, max: 1, delta: 3 },
        knob1	: 0,	// 1 Measure
        knob2	: { value: 0.5, min: 0.1, max: 1, delta: -6 },
        knob3	: { value: 0.4, min: 0, max: 0.95, delta: 5 },
        button1	: 1,
        button2	: 0,
        button3	: 0
    },
    {
        // PadFX 1.7
        name	: "Filter Pulse*",
        color	: "Green",
        routing	: "Insert",
        effect1	: "Gater",
        effect2	: "Digital LoFi",
        effect3	: "PolarWind",
        drywet	: 0.5,
        knob1	: { value: 0.0, min: 0, max: 0.7, delta: 10 },
        knob2	: { value: 0.0, min: 0, max: 0.8, delta: 18 },
        knob3	: { value: 0.5, min: 0, max: 1.0, delta: 16 },
        button1	: 0,
        button2	: 0,
        button3	: 0
    },
    {
        // PadFX 1.8
        name	: "Electro Flyby*",
        color	: "Turquoise",
        routing	: "Insert",
        effect1	: "Off",
        effect2	: "Zzzurp",
        effect3	: "Strrretch (Slow)",
        drywet	: 0.8,
        knob1	: 0,
        knob2	: { value: 1, min: 0, max: 1, delta: -100 },
        knob3	: { value: 0, min: 0, max: 1, delta: 100 },
        button1	: 0,
        button2	: 0,
        button3	: 0
    },

//-----------------------------------------------------------------------------------------------------------------------------------
// PAD FX - SLOT 2
//-----------------------------------------------------------------------------------------------------------------------------------

    {
        // PadFX 2.1
        name	: "",
        color	: "Black",
        routing	: "Insert",
        effect1	: "Off",
        effect2	: "Off",
        effect3	: "Off",
        drywet	: 0,
        knob1	: 0,
        knob2	: 0,
        knob3	: 0,
        button1	: 0,
        button2	: 0,
        button3	: 0,
    },
    {
        // PadFX 2.2
        name	: "",
        color	: "Black",
        routing	: "Insert",
        effect1	: "Off",
        effect2	: "Off",
        effect3	: "Off",
        drywet	: 0,
        knob1	: 0,
        knob2	: 0,
        knob3	: 0,
        button1	: 0,
        button2	: 0,
        button3	: 0,
    },
    {
        // PadFX 2.3
        name	: "",
        color	: "Black",
        routing	: "Insert",
        effect1	: "Off",
        effect2	: "Off",
        effect3	: "Off",
        drywet	: 0,
        knob1	: 0,
        knob2	: 0,
        knob3	: 0,
        button1	: 0,
        button2	: 0,
        button3	: 0,
    },
    {
        // PadFX 2.4
        name	: "",
        color	: "Black",
        routing	: "Insert",
        effect1	: "Off",
        effect2	: "Off",
        effect3	: "Off",
        drywet	: 0,
        knob1	: 0,
        knob2	: 0,
        knob3	: 0,
        button1	: 0,
        button2	: 0,
        button3	: 0,
    },
    {
        // PadFX 2.5
        name	: "",
        color	: "Black",
        routing	: "Insert",
        effect1	: "Off",
        effect2	: "Off",
        effect3	: "Off",
        drywet	: 0,
        knob1	: 0,
        knob2	: 0,
        knob3	: 0,
        button1	: 0,
        button2	: 0,
        button3	: 0,
    },
    {
        //PadFX 2.6
        name	: "",
        color	: "Black",
        routing	: "Insert",
        effect1	: "Off",
        effect2	: "Off",
        effect3	: "Off",
        drywet	: 0,
        knob1	: 0,
        knob2	: 0,
        knob3	: 0,
        button1	: 0,
        button2	: 0,
        button3	: 0,
    },
    {
        // PadFX 2.7
        name	: "",
        color	: "Black",
        routing	: "Insert",
        effect1	: "Off",
        effect2	: "Off",
        effect3	: "Off",
        drywet	: 0,
        knob1	: 0,
        knob2	: 0,
        knob3	: 0,
        button1	: 0,
        button2	: 0,
        button3	: 0,
    },
    {
        // PadFX 2.8
        name	: "",
        color	: "Black",
        routing	: "Insert",
        effect1	: "Off",
        effect2	: "Off",
        effect3	: "Off",
        drywet	: 0,
        knob1	: 0,
        knob2	: 0,
        knob3	: 0,
        button1	: 0,
        button2	: 0,
        button3	: 0,
    },

//-----------------------------------------------------------------------------------------------------------------------------------
// PAD FX - SLOT 3
//-----------------------------------------------------------------------------------------------------------------------------------

    {
        // PadFX 3.1
        name	: "",
        color	: "Black",
        routing	: "Insert",
        effect1	: "Off",
        effect2	: "Off",
        effect3	: "Off",
        drywet	: 0,
        knob1	: 0,
        knob2	: 0,
        knob3	: 0,
        button1	: 0,
        button2	: 0,
        button3	: 0,
    },
    {
        // PadFX 3.2
        name	: "",
        color	: "Black",
        routing	: "Insert",
        effect1	: "Off",
        effect2	: "Off",
        effect3	: "Off",
        drywet	: 0,
        knob1	: 0,
        knob2	: 0,
        knob3	: 0,
        button1	: 0,
        button2	: 0,
        button3	: 0,
    },
    {
        // PadFX 3.3
        name	: "",
        color	: "Black",
        routing	: "Insert",
        effect1	: "Off",
        effect2	: "Off",
        effect3	: "Off",
        drywet	: 0,
        knob1	: 0,
        knob2	: 0,
        knob3	: 0,
        button1	: 0,
        button2	: 0,
        button3	: 0,
    },
    {
        // PadFX 3.4
        name	: "",
        color	: "Black",
        routing	: "Insert",
        effect1	: "Off",
        effect2	: "Off",
        effect3	: "Off",
        drywet	: 0,
        knob1	: 0,
        knob2	: 0,
        knob3	: 0,
        button1	: 0,
        button2	: 0,
        button3	: 0,
    },
    {
        // PadFX 3.5
        name	: "",
        color	: "Black",
        routing	: "Insert",
        effect1	: "Off",
        effect2	: "Off",
        effect3	: "Off",
        drywet	: 0,
        knob1	: 0,
        knob2	: 0,
        knob3	: 0,
        button1	: 0,
        button2	: 0,
        button3	: 0,
    },
    {
        //PadFX 1.6
        name	: "",
        color	: "Black",
        routing	: "Insert",
        effect1	: "Off",
        effect2	: "Off",
        effect3	: "Off",
        drywet	: 0,
        knob1	: 0,
        knob2	: 0,
        knob3	: 0,
        button1	: 0,
        button2	: 0,
        button3	: 0,
    },
    {
        // PadFX 3.7
        name	: "",
        color	: "Black",
        routing	: "Insert",
        effect1	: "Off",
        effect2	: "Off",
        effect3	: "Off",
        drywet	: 0,
        knob1	: 0,
        knob2	: 0,
        knob3	: 0,
        button1	: 0,
        button2	: 0,
        button3	: 0,
    },
    {
        // PadFX 3.8
        name	: "",
        color	: "Black",
        routing	: "Insert",
        effect1	: "Off",
        effect2	: "Off",
        effect3	: "Off",
        drywet	: 0,
        knob1	: 0,
        knob2	: 0,
        knob3	: 0,
        button1	: 0,
        button2	: 0,
        button3	: 0,
    },

//-----------------------------------------------------------------------------------------------------------------------------------
// PAD FX - SLOT 4
//-----------------------------------------------------------------------------------------------------------------------------------

    {
        // PadFX 4.1
        name	: "",
        color	: "Black",
        routing	: "Insert",
        effect1	: "Off",
        effect2	: "Off",
        effect3	: "Off",
        drywet	: 0,
        knob1	: 0,
        knob2	: 0,
        knob3	: 0,
        button1	: 0,
        button2	: 0,
        button3	: 0,
    },
    {
        // PadFX 4.2
        name	: "",
        color	: "Black",
        routing	: "Insert",
        effect1	: "Off",
        effect2	: "Off",
        effect3	: "Off",
        drywet	: 0,
        knob1	: 0,
        knob2	: 0,
        knob3	: 0,
        button1	: 0,
        button2	: 0,
        button3	: 0,
    },
    {
        // PadFX 4.3
        name	: "",
        color	: "Black",
        routing	: "Insert",
        effect1	: "Off",
        effect2	: "Off",
        effect3	: "Off",
        drywet	: 0,
        knob1	: 0,
        knob2	: 0,
        knob3	: 0,
        button1	: 0,
        button2	: 0,
        button3	: 0,
    },
    {
        // PadFX 4.4
        name	: "",
        color	: "Black",
        routing	: "Insert",
        effect1	: "Off",
        effect2	: "Off",
        effect3	: "Off",
        drywet	: 0,
        knob1	: 0,
        knob2	: 0,
        knob3	: 0,
        button1	: 0,
        button2	: 0,
        button3	: 0,
    },
    {
        // PadFX 4.5
        name	: "",
        color	: "Black",
        routing	: "Insert",
        effect1	: "Off",
        effect2	: "Off",
        effect3	: "Off",
        drywet	: 0,
        knob1	: 0,
        knob2	: 0,
        knob3	: 0,
        button1	: 0,
        button2	: 0,
        button3	: 0,
    },
    {
        //PadFX 1.6
        name	: "",
        color	: "Black",
        routing	: "Insert",
        effect1	: "Off",
        effect2	: "Off",
        effect3	: "Off",
        drywet	: 0,
        knob1	: 0,
        knob2	: 0,
        knob3	: 0,
        button1	: 0,
        button2	: 0,
        button3	: 0,
    },
    {
        // PadFX 4.7
        name	: "",
        color	: "Black",
        routing	: "Insert",
        effect1	: "Off",
        effect2	: "Off",
        effect3	: "Off",
        drywet	: 0,
        knob1	: 0,
        knob2	: 0,
        knob3	: 0,
        button1	: 0,
        button2	: 0,
        button3	: 0,
    },
    {
        // PadFX 4.8
        name	: "",
        color	: "Black",
        routing	: "Insert",
        effect1	: "Off",
        effect2	: "Off",
        effect3	: "Off",
        drywet	: 0,
        knob1	: 0,
        knob2	: 0,
        knob3	: 0,
        button1	: 0,
        button2	: 0,
        button3	: 0,
    },

//-----------------------------------------------------------------------------------------------------------------------------------
// PAD FX - SLOT 5
//-----------------------------------------------------------------------------------------------------------------------------------

    {
        // PadFX 5.1
        name	: "",
        color	: "Black",
        routing	: "Insert",
        effect1	: "Off",
        effect2	: "Off",
        effect3	: "Off",
        drywet	: 0,
        knob1	: 0,
        knob2	: 0,
        knob3	: 0,
        button1	: 0,
        button2	: 0,
        button3	: 0,
    },
    {
        // PadFX 5.2
        name	: "",
        color	: "Black",
        routing	: "Insert",
        effect1	: "Off",
        effect2	: "Off",
        effect3	: "Off",
        drywet	: 0,
        knob1	: 0,
        knob2	: 0,
        knob3	: 0,
        button1	: 0,
        button2	: 0,
        button3	: 0,
    },
    {
        // PadFX 5.3
        name	: "",
        color	: "Black",
        routing	: "Insert",
        effect1	: "Off",
        effect2	: "Off",
        effect3	: "Off",
        drywet	: 0,
        knob1	: 0,
        knob2	: 0,
        knob3	: 0,
        button1	: 0,
        button2	: 0,
        button3	: 0,
    },
    {
        // PadFX 5.4
        name	: "",
        color	: "Black",
        routing	: "Insert",
        effect1	: "Off",
        effect2	: "Off",
        effect3	: "Off",
        drywet	: 0,
        knob1	: 0,
        knob2	: 0,
        knob3	: 0,
        button1	: 0,
        button2	: 0,
        button3	: 0,
    },
    {
        // PadFX 5.5
        name	: "",
        color	: "Black",
        routing	: "Insert",
        effect1	: "Off",
        effect2	: "Off",
        effect3	: "Off",
        drywet	: 0,
        knob1	: 0,
        knob2	: 0,
        knob3	: 0,
        button1	: 0,
        button2	: 0,
        button3	: 0,
    },
    {
        //PadFX 1.6
        name	: "",
        color	: "Black",
        routing	: "Insert",
        effect1	: "Off",
        effect2	: "Off",
        effect3	: "Off",
        drywet	: 0,
        knob1	: 0,
        knob2	: 0,
        knob3	: 0,
        button1	: 0,
        button2	: 0,
        button3	: 0,
    },
    {
        // PadFX 5.7
        name	: "",
        color	: "Black",
        routing	: "Insert",
        effect1	: "Off",
        effect2	: "Off",
        effect3	: "Off",
        drywet	: 0,
        knob1	: 0,
        knob2	: 0,
        knob3	: 0,
        button1	: 0,
        button2	: 0,
        button3	: 0,
    },
    {
        // PadFX 5.8
        name	: "",
        color	: "Black",
        routing	: "Insert",
        effect1	: "Off",
        effect2	: "Off",
        effect3	: "Off",
        drywet	: 0,
        knob1	: 0,
        knob2	: 0,
        knob3	: 0,
        button1	: 0,
        button2	: 0,
        button3	: 0,
    },

//-----------------------------------------------------------------------------------------------------------------------------------
// PAD FX - SLOT 6
//-----------------------------------------------------------------------------------------------------------------------------------

    {
        // PadFX 6.1
        name	: "",
        color	: "Black",
        routing	: "Insert",
        effect1	: "Off",
        effect2	: "Off",
        effect3	: "Off",
        drywet	: 0,
        knob1	: 0,
        knob2	: 0,
        knob3	: 0,
        button1	: 0,
        button2	: 0,
        button3	: 0,
    },
    {
        // PadFX 6.2
        name	: "",
        color	: "Black",
        routing	: "Insert",
        effect1	: "Off",
        effect2	: "Off",
        effect3	: "Off",
        drywet	: 0,
        knob1	: 0,
        knob2	: 0,
        knob3	: 0,
        button1	: 0,
        button2	: 0,
        button3	: 0,
    },
    {
        // PadFX 6.3
        name	: "",
        color	: "Black",
        routing	: "Insert",
        effect1	: "Off",
        effect2	: "Off",
        effect3	: "Off",
        drywet	: 0,
        knob1	: 0,
        knob2	: 0,
        knob3	: 0,
        button1	: 0,
        button2	: 0,
        button3	: 0,
    },
    {
        // PadFX 6.4
        name	: "",
        color	: "Black",
        routing	: "Insert",
        effect1	: "Off",
        effect2	: "Off",
        effect3	: "Off",
        drywet	: 0,
        knob1	: 0,
        knob2	: 0,
        knob3	: 0,
        button1	: 0,
        button2	: 0,
        button3	: 0,
    },
    {
        // PadFX 6.5
        name	: "",
        color	: "Black",
        routing	: "Insert",
        effect1	: "Off",
        effect2	: "Off",
        effect3	: "Off",
        drywet	: 0,
        knob1	: 0,
        knob2	: 0,
        knob3	: 0,
        button1	: 0,
        button2	: 0,
        button3	: 0,
    },
    {
        //PadFX 1.6
        name	: "",
        color	: "Black",
        routing	: "Insert",
        effect1	: "Off",
        effect2	: "Off",
        effect3	: "Off",
        drywet	: 0,
        knob1	: 0,
        knob2	: 0,
        knob3	: 0,
        button1	: 0,
        button2	: 0,
        button3	: 0,
    },
    {
        // PadFX 6.7
        name	: "",
        color	: "Black",
        routing	: "Insert",
        effect1	: "Off",
        effect2	: "Off",
        effect3	: "Off",
        drywet	: 0,
        knob1	: 0,
        knob2	: 0,
        knob3	: 0,
        button1	: 0,
        button2	: 0,
        button3	: 0,
    },
    {
        // PadFX 6.8
        name	: "",
        color	: "Black",
        routing	: "Insert",
        effect1	: "Off",
        effect2	: "Off",
        effect3	: "Off",
        drywet	: 0,
        knob1	: 0,
        knob2	: 0,
        knob3	: 0,
        button1	: 0,
        button2	: 0,
        button3	: 0,
    },

//-----------------------------------------------------------------------------------------------------------------------------------
// PAD FX - SLOT 7
//-----------------------------------------------------------------------------------------------------------------------------------

    {
        // PadFX 7.1
        name	: "",
        color	: "Black",
        routing	: "Insert",
        effect1	: "Off",
        effect2	: "Off",
        effect3	: "Off",
        drywet	: 0,
        knob1	: 0,
        knob2	: 0,
        knob3	: 0,
        button1	: 0,
        button2	: 0,
        button3	: 0,
    },
    {
        // PadFX 7.2
        name	: "",
        color	: "Black",
        routing	: "Insert",
        effect1	: "Off",
        effect2	: "Off",
        effect3	: "Off",
        drywet	: 0,
        knob1	: 0,
        knob2	: 0,
        knob3	: 0,
        button1	: 0,
        button2	: 0,
        button3	: 0,
    },
    {
        // PadFX 7.3
        name	: "",
        color	: "Black",
        routing	: "Insert",
        effect1	: "Off",
        effect2	: "Off",
        effect3	: "Off",
        drywet	: 0,
        knob1	: 0,
        knob2	: 0,
        knob3	: 0,
        button1	: 0,
        button2	: 0,
        button3	: 0,
    },
    {
        // PadFX 7.4
        name	: "",
        color	: "Black",
        routing	: "Insert",
        effect1	: "Off",
        effect2	: "Off",
        effect3	: "Off",
        drywet	: 0,
        knob1	: 0,
        knob2	: 0,
        knob3	: 0,
        button1	: 0,
        button2	: 0,
        button3	: 0,
    },
    {
        // PadFX 7.5
        name	: "",
        color	: "Black",
        routing	: "Insert",
        effect1	: "Off",
        effect2	: "Off",
        effect3	: "Off",
        drywet	: 0,
        knob1	: 0,
        knob2	: 0,
        knob3	: 0,
        button1	: 0,
        button2	: 0,
        button3	: 0,
    },
    {
        //PadFX 1.6
        name	: "",
        color	: "Black",
        routing	: "Insert",
        effect1	: "Off",
        effect2	: "Off",
        effect3	: "Off",
        drywet	: 0,
        knob1	: 0,
        knob2	: 0,
        knob3	: 0,
        button1	: 0,
        button2	: 0,
        button3	: 0,
    },
    {
        // PadFX 7.7
        name	: "",
        color	: "Black",
        routing	: "Insert",
        effect1	: "Off",
        effect2	: "Off",
        effect3	: "Off",
        drywet	: 0,
        knob1	: 0,
        knob2	: 0,
        knob3	: 0,
        button1	: 0,
        button2	: 0,
        button3	: 0,
    },
    {
        // PadFX 7.8
        name	: "",
        color	: "Black",
        routing	: "Insert",
        effect1	: "Off",
        effect2	: "Off",
        effect3	: "Off",
        drywet	: 0,
        knob1	: 0,
        knob2	: 0,
        knob3	: 0,
        button1	: 0,
        button2	: 0,
        button3	: 0,
    },

//-----------------------------------------------------------------------------------------------------------------------------------
// PAD FX - SLOT 8
//-----------------------------------------------------------------------------------------------------------------------------------

    {
        // PadFX 8.1
        name	: "",
        color	: "Black",
        routing	: "Insert",
        effect1	: "Off",
        effect2	: "Off",
        effect3	: "Off",
        drywet	: 0,
        knob1	: 0,
        knob2	: 0,
        knob3	: 0,
        button1	: 0,
        button2	: 0,
        button3	: 0,
    },
    {
        // PadFX 8.2
        name	: "",
        color	: "Black",
        routing	: "Insert",
        effect1	: "Off",
        effect2	: "Off",
        effect3	: "Off",
        drywet	: 0,
        knob1	: 0,
        knob2	: 0,
        knob3	: 0,
        button1	: 0,
        button2	: 0,
        button3	: 0,
    },
    {
        // PadFX 8.3
        name	: "",
        color	: "Black",
        routing	: "Insert",
        effect1	: "Off",
        effect2	: "Off",
        effect3	: "Off",
        drywet	: 0,
        knob1	: 0,
        knob2	: 0,
        knob3	: 0,
        button1	: 0,
        button2	: 0,
        button3	: 0,
    },
    {
        // PadFX 8.4
        name	: "",
        color	: "Black",
        routing	: "Insert",
        effect1	: "Off",
        effect2	: "Off",
        effect3	: "Off",
        drywet	: 0,
        knob1	: 0,
        knob2	: 0,
        knob3	: 0,
        button1	: 0,
        button2	: 0,
        button3	: 0,
    },
    {
        // PadFX 8.5
        name	: "",
        color	: "Black",
        routing	: "Insert",
        effect1	: "Off",
        effect2	: "Off",
        effect3	: "Off",
        drywet	: 0,
        knob1	: 0,
        knob2	: 0,
        knob3	: 0,
        button1	: 0,
        button2	: 0,
        button3	: 0,
    },
    {
        //PadFX 1.6
        name	: "",
        color	: "Black",
        routing	: "Insert",
        effect1	: "Off",
        effect2	: "Off",
        effect3	: "Off",
        drywet	: 0,
        knob1	: 0,
        knob2	: 0,
        knob3	: 0,
        button1	: 0,
        button2	: 0,
        button3	: 0,
    },
    {
        // PadFX 8.7
        name	: "",
        color	: "Black",
        routing	: "Insert",
        effect1	: "Off",
        effect2	: "Off",
        effect3	: "Off",
        drywet	: 0,
        knob1	: 0,
        knob2	: 0,
        knob3	: 0,
        button1	: 0,
        button2	: 0,
        button3	: 0,
    },
    {
        // PadFX 8.8
        name	: "",
        color	: "Black",
        routing	: "Insert",
        effect1	: "Off",
        effect2	: "Off",
        effect3	: "Off",
        drywet	: 0,
        knob1	: 0,
        knob2	: 0,
        knob3	: 0,
        button1	: 0,
        button2	: 0,
        button3	: 0,
    },
    ]
}
