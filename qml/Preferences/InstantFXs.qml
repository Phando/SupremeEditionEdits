import CSI 1.0
import QtQuick 2.5

import "../Screens/Defines"

//-----------------------------------------------------------------------------------------------------------------------------------
// Dynamic Effects
//-----------------------------------------------------------------------------------------------------------------------------------
/*

The EffectsMode supports static and dynamic effects. Dynamic effects are routed to effects units 3 and 4 so units 1 and 2 are free 
for manipulation. Knobs with float values will define static effects. Knobs with objects define dynamic effects. The dynamic effect
descriptor takes a value, min, max and delta. The effect will start at the value and then progress  at the rate defined by the 
delta (+ or -) till it hits the min or max. The smaller the delta the slower the effect will build.

Static Effect:
...
effect1	: 6,
knob1	: 0.50,
...

Dynamic Effect:
...
effect1	: 6,
knob1	: { value: 0.25, min: 0, max: 1, delta: 8 },
...

*/
//-----------------------------------------------------------------------------------------------------------------------------------
// Cool Combos
//-----------------------------------------------------------------------------------------------------------------------------------
/*

1.  BeatSlicer - 26/ Filter:92 LFO - 12/ Delay - 1
2.  Beatmasher2 - 7/ Transpose Stretch - 25/ Reverb - 2
3.  PolarWind - 37/ Gater - 6/ Digital Lofi - 23
4.  Reverb T3 - 21/ Delay T3 - 8/ Digital Lofi - 23
5.  Reverb T3 - 21/ Delay T3 - 8/ Filter - 11
6.  Beatmasher2 - 7/ Gater - 6/ Flanger - 3
7.  Beatmasher2 - 7/ Phaser - 15/ Digital Lofi - 23
8.  Delay - 1/ Phaser Flux - 17/ Reverb T3 - 21

// DJTT
9.  BeatMasher2 - 7/ Filter - 11/ FlangerPulse - 4
10. Beatmasher2 - 7/ Delay - 1 / Reverse Grain - 18
11. Beatmasher2 - 7/ Lofi - 23 / TurntableFX - 19
12. Gater - 6 / Formant Filter - 27 / Reverb - 2

//-----------------------------------------------------------------------------------------------------------------------------------
// PAD FX PARAMETERS
//-----------------------------------------------------------------------------------------------------------------------------------
/*

Here are the numbers that are associated to each color.
  Color 01 --> Red			Color 02 --> Dark Orange		Color 03 --> Light Orange		Color 04 --> Warm Yellow
  Color 05 --> Yellow		Color 06 --> Lime				Color 07 --> Green				Color 08 --> Mint
  Color 09 --> Cyan			Color 10 --> Turquoise			Color 11 --> Blue				Color 12 --> Plum
  Color 13 --> Violet		Color 14 --> Purple				Color 15 --> Magenta			Color 16 --> Fuchsia
  
Please, for the 'color' and 'led', only modify the number so that the colors are displayed correctly on the S8. 
*/

//-----------------------------------------------------------------------------------------------------------------------------------
// Effect Indexes
//-----------------------------------------------------------------------------------------------------------------------------------
/*

0  : None           11 : Filter           22: Ringmodulator      33: [M] WormHole
1  : Delay          12 : Filter:92 LFO    23: Digital LoFi       34: [M] Laser Slicer
2  : Reverb         13 : Filter:92 Pulse  24: Mulholland Drive   35: [M] Granu Phase
3  : Flanger        14 : Filter:92        25: Transpose Stretch  36: [M] Bass-o-Matic
4  : Flanger Pulse  15 : Phaser           26: Beatslicer         37: [M] Polar Wind
5  : Flanger Flux   16 : Phaser Pulse     27: Formant Filter     38: [M] Event Horizon
6  : Gater          17 : Phaser Flux      28: Peak Filter        39: [M] Zzzurp
7  : Beatmasher 2   18 : Reverse Grain    29: Tape Delay         40: [M] Flight Test
8  : Delay T3       19 : Turntable FX     30: Ramp Delay         41: [M] Strrretch (Slow)
9  : Filter LFO     20 : Iceverb          31: Auto Bouncer       42: [M] Strrretch (Fast)
10 : Filter Pulse   21 : Reverb T3        32: Bouncer            43: [M] Dark Matter

*/

Module {

	// TODO : Not sure we need 'color' and 'led' on the pad definitions
    Colors { name: "colors"; id: colors }

//-----------------------------------------------------------------------------------------------------------------------------------
// PAD FX - SLOT 1
//-----------------------------------------------------------------------------------------------------------------------------------

	property var pads: [
	//PadFX 1.1
		{
			name	: "Echo Fade",
			color	: colors.color08Bright,
			led		: "colors.color08Bright",
			effect1	: 1,	// Delay
			effect2	: 0,
			effect3	: 0,
			knob0	: 0.25,	// Dry Wet
			knob1	: 0.5,
			knob2	: 0.5,
			knob3	: 0.4,
			button1	: 0,
			button2	: 1,
			button3	: 0
		},
	//PadFX 1.2
	    { 
			name	: "Echo Fade Multi",
			color	: colors.color09Bright,
			led		: "colors.color09Bright",
			effect1	: 7,	// Beatmasher2
			effect2	: 38,	// Event Horizon
			effect3	: 14,	// Filter:92
			knob0	: 1.0,	// Dry Wet
			knob1	: 0,	// 1 Measure
			knob2	: 0.5,	
			knob3	: 0.5,
			button1	: 1,
			button2	: 1,
			button3	: 1
		},
	//PadFX 1.3
	    { 
			name	: "Techno Phil / Vocal Looper",
			color	: colors.color10Bright,
			led		: "colors.color10Bright",
			effect1	: 7,  	// Beatmasher2
			effect2	: 25, 	// Transpose Stretch
			effect3	: 14, 	// Filter92  
			knob0	: 1.0, 	// Dry Wet
			knob1	: 0,	// 1 Measure
			knob2	: 0.5,
			knob3	: 0.5,
			button1	: 1,
			button2	: 1,
			button3	: 1
		},
	//PadFX 1.4
	    { 
			name	: "Space Toys",
			color	: colors.color11Bright,
			led		: "colors.color11Bright",
			effect1	: 6,	// Gater
			effect2	: 27,	// Formant Filter
			effect3	: 28,	// Peak Filter
			knob0	: 0.4, 	// Dry Wet
			knob1	: 0,
			knob2	: 0,
			knob3	: 0,
			button1	: 0,
			button2	: 0,
			button3	: 0
		},
	//PadFX 1.5
		{
			name	: "Echo Fade (Auto)",
			color	: colors.color13Bright,
			led		: "colors.color13Bright",
			effect1	: 1,	// Delay
			effect2	: 0,
			effect3	: 0,
			knob0	: { value: 0.0, min: 0, max: 0.75, delta: 4 },	// Dry Wet
			knob1	: { value: 0.5, min: 0, max: 1, delta: 4 },
			knob2	: 0.5,
			knob3	: { value: 0.35, min: 0, max: 1, delta: 6 },
			button1	: 0,
			button2	: 1,
			button3	: 0
		},
	//PadFX 1.6
		{
			name	: "Echo Fade Multi (4 BEATS)",
			color	: colors.color14Bright,
			led		: "colors.color14Bright",
			effect1	: 7,	// Beatmasher2
			effect2	: 38,	// Event Horizon
			effect3	: 14,	// Filter:92
			knob0	: 0.8,	// Dry Wet
			knob1	: 0,	// 1 Measure
			knob2	: { value: 0.5, min: 0.1, max: 1, delta: -6 },	
			knob3	: { value: 0.5, min: 0, max: 0.9, delta: 5 },
			button1	: 1,
			button2	: 1,
			button3	: 1
		},
	//PadFX 1.7
		{
			name	: "FILTER PULSE",
			color	: colors.color15Bright,
			led		: "colors.color15Bright",
			effect1	: 6,	// Gater
			effect2	: 23,	// Digital Lofi
			effect3	: 37,	// PolarWind
			knob0	: 0.5,	// Dry Wet
			knob1	: { value: 0.0, min: 0, max: 0.7, delta: 10 },
			knob2	: { value: 0.0, min: 0, max: 0.8, delta: 18 },
			knob3	: { value: 0.5, min: 0, max: 1.0, delta: 16 },
			button1	: 0,
			button2	: 0,
			button3	: 0
		},
	//PadFX 1.8
		{
			name	: "Electro Flyby",
			color	: colors.color16Bright,
			led		: "colors.color16Bright",
			effect1	: 8,	// Delay T3
			effect2	: 21,	// Reverb T3
			effect3	: 23,	// Digital Lofi
			knob0	: 0.4,	// Dry Wet
			knob1	: 0.35,
			knob2	: { value: 1, min: 0, max: 1, delta: -150 },
			knob3	: { value: 0.0, min: 0, max: 1, delta: 150 },
			button1	: 0,
			button2	: 0,
			button3	: 0
		},
	
//-----------------------------------------------------------------------------------------------------------------------------------
// PAD FX - SLOT 2
//
// Duplicate settings to above
//
//-----------------------------------------------------------------------------------------------------------------------------------

	//PadFX 2.1
		{
			name	: "Echo Fade",
			color	: colors.color08Bright,
			led		: "colors.color08Bright",
			effect1	: 1,	// Delay
			effect2	: 0,
			effect3	: 0,
			knob0	: 0.25,	// Dry Wet
			knob1	: 0.5,
			knob2	: 0.5,
			knob3	: 0.4,
			button1	: 0,
			button2	: 1,
			button3	: 0
		},
	//PadFX 2.2
	    { 
			name	: "Echo Fade Multi",
			color	: colors.color09Bright,
			led		: "colors.color09Bright",
			effect1	: 7,	// Beatmasher2
			effect2	: 38,	// Event Horizon
			effect3	: 14,	// Filter:92
			knob0	: 1.0,	// Dry Wet
			knob1	: 0,	// 1 Measure
			knob2	: 0.5,	
			knob3	: 0.5,
			button1	: 1,
			button2	: 1,
			button3	: 1
		},
	//PadFX 2.3
	    { 
			name	: "Techno Phil / Vocal Looper",
			color	: colors.color10Bright,
			led		: "colors.color10Bright",
			effect1	: 7,  	// Beatmasher2
			effect2	: 25, 	// Transpose Stretch
			effect3	: 14, 	// Filter92  
			knob0	: 1.0, 	// Dry Wet
			knob1	: 0,	// 1 Measure
			knob2	: 0.5,
			knob3	: 0.5,
			button1	: 1,
			button2	: 1,
			button3	: 1
		},
	//PadFX 2.4
	    { 
			name	: "Space Toys",
			color	: colors.color11Bright,
			led		: "colors.color11Bright",
			effect1	: 6,	// Gater
			effect2	: 27,	// Formant Filter
			effect3	: 28,	// Peak Filter
			knob0	: 0.4, 	// Dry Wet
			knob1	: 0,
			knob2	: 0,
			knob3	: 0,
			button1	: 0,
			button2	: 0,
			button3	: 0
		},
	//PadFX 2.5
		{
			name	: "Echo Fade (Auto)",
			color	: colors.color13Bright,
			led		: "colors.color13Bright",
			effect1	: 1,	// Delay
			effect2	: 0,
			effect3	: 0,
			knob0	: { value: 0.0, min: 0, max: 0.75, delta: 4 },	// Dry Wet
			knob1	: { value: 0.5, min: 0, max: 1, delta: 4 },
			knob2	: 0.5,
			knob3	: { value: 0.35, min: 0, max: 1, delta: 6 },
			button1	: 0,
			button2	: 1,
			button3	: 0
		},
	//PadFX 2.6
		{
			name	: "Echo Fade Multi (4 BEATS)",
			color	: colors.color14Bright,
			led		: "colors.color14Bright",
			effect1	: 7,	// Beatmasher2
			effect2	: 38,	// Event Horizon
			effect3	: 14,	// Filter:92
			knob0	: 0.8,	// Dry Wet
			knob1	: 0,	// 1 Measure
			knob2	: { value: 0.5, min: 0.1, max: 1, delta: -6 },	
			knob3	: { value: 0.5, min: 0, max: 0.9, delta: 5 },
			button1	: 1,
			button2	: 1,
			button3	: 1
		},
	//PadFX 2.7
		{
			name	: "FILTER PULSE",
			color	: colors.color15Bright,
			led		: "colors.color15Bright",
			effect1	: 6,	// Gater
			effect2	: 23,	// Digital Lofi
			effect3	: 37,	// PolarWind
			knob0	: 0.5,	// Dry Wet
			knob1	: { value: 0.0, min: 0, max: 0.7, delta: 10 },
			knob2	: { value: 0.0, min: 0, max: 0.8, delta: 18 },
			knob3	: { value: 0.5, min: 0, max: 1.0, delta: 16 },
			button1	: 0,
			button2	: 0,
			button3	: 0
		},
	//PadFX 2.8
		{
			name	: "Electro Flyby",
			color	: colors.color16Bright,
			led		: "colors.color16Bright",
			effect1	: 8,	// Delay T3
			effect2	: 21,	// Reverb T3
			effect3	: 23,	// Digital Lofi
			knob0	: 0.4,	// Dry Wet
			knob1	: 0.35,
			knob2	: { value: 1, min: 0, max: 1, delta: -150 },
			knob3	: { value: 0.0, min: 0, max: 1, delta: 150 },
			button1	: 0,
			button2	: 0,
			button3	: 0
		}
	]
	
}
