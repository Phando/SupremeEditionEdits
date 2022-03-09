import CSI 1.0
import QtQuick 2.5

//-----------------------------------------------------------------------------------------------------------------------------------
// INFORMATION ABOUT FXs
//-----------------------------------------------------------------------------------------------------------------------------------

/*
Available colors:
NOTE: If there is any spelling mistakes, it will be considered as white (the default color)

  Red       Dark Orange     Light Orange      Warm Yellow
  Yellow    Lime            Green             Mint
  Cyan      Turquoise       Blue              Plum
  Violet    Purple          Magenta           Fuchsia
  White

FXs index:
NOTE: This is the default order, but it may be different depending on your Traktor settings (including FX settings + language).

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
  10 : Filter Pulse   21 : Reverb T3        32: Bouncer            43: [M] Dark Matter


Interesting Group FXs combos
  1. BeatSlicer       Filter:92 LFO       Delay
  2. Beatmasher2      Transpose Stretch   Reverb
  3. PolarWind        Gater               Digital Lofi
  4. Reverb T3        Delay T3            Digital Lofi
  5. Reverb T3        Delay T3            Filter
  6. Beatmasher2      Gater               Flanger
  7. Beatmasher2      Phaser              Digital Lofi
  8. Delay            Phaser Flux         Reverb T3

// DJTechTools
  9. BeatMasher2      Filter              FlangerPulse
  10. Beatmasher2     Delay               Reverse Grain
  11. Beatmasher2     Lofi                TurntableFX
  12. Gater           Formant Filter      Reverb

*/

Module {
	id: instantFX
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// PAD FX - SLOT 1
	//-----------------------------------------------------------------------------------------------------------------------------------
		
	property var pads: [
	{
		// PadFX 1.1
		name	: "Echo Fade",
		color	: "Magenta",
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
	{ 
		// PadFX 1.2
		name	: "Echo Multi",
		color	: "Warm Yellow",
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
	{ 
		// PadFX 1.3
		name	: "Techno Phil",
		color	: "Lime",
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
	{ 
		// PadFX 1.4
		name	: "Space Toys",
		color	: "Cyan",
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
	{
		// PadFX 1.5
		name	: "Echo Fade*",
		color	: "Fuchsia",
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
	{
		//PadFX 1.6
		name	: "Echo Multi*",
		color	: "Light Orange",
		effect1	: 7,	// Beatmasher2
		effect2	: 38,	// Event Horizon
		effect3	: 14,	// Filter:92
		knob0	: 0.8,	// Dry Wet
		knob1	: 0,	// 1 Measure
		knob2	: { value: 0.5, min: 0.1, max: 1, delta: -6 },	
		knob3	: { value: 0.5, min: 0, max: 0.9, delta: 5 },
		button1	: 1,
		button2	: 0,
		button3	: 0
	},
	{
		// PadFX 1.7
		name	: "Filter Pulse*",
		color	: "Green",
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
	{
		// PadFX 1.8
		name	: "Electro Flyby*",
		color	: "Turquoise",
		effect1	: 0,	// Empty
		effect2	: 39,	// [M] Zzzurp
		effect3	: 41,	// [M] Strrretch
		knob0	: 0.7,	// Dry Wet
		knob1	: 0,
		knob2	: { value: 1, min: 0, max: 1, delta: -150 },
		knob3	: { value: 0, min: 0, max: 1, delta: 150 },
		button1	: 0,
		button2	: 0,
		button3	: 0
	},
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// PAD FX - SLOT 2
	// Duplicates from above
	//-----------------------------------------------------------------------------------------------------------------------------------

	{
		// PadFX 2.1
		name	: "Echo Fade1",
		color	: "Cyan",
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
	{ 
		// PadFX 2.2
		name	: "Echo Multi",
		color	: "Lime",
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
	{ 
		// PadFX 2.3
		name	: "Techno Phil",
		color	: "Warm Yellow",
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
	{ 
		// PadFX 2.4
		name	: "Space Toys",
		color	: "Magenta",
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
	{
		// PadFX 2.5
		name	: "Echo Fade*",
		color	: "Turquoise",
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
	{
		//PadFX 2.6
		name	: "Echo Multi*",
		color	: "Green",
		effect1	: 7,	// Beatmasher2
		effect2	: 38,	// Event Horizon
		effect3	: 14,	// Filter:92
		knob0	: 0.8,	// Dry Wet
		knob1	: 0,	// 1 Measure
		knob2	: { value: 0.5, min: 0.1, max: 1, delta: -6 },	
		knob3	: { value: 0.5, min: 0, max: 0.9, delta: 5 },
		button1	: 1,
		button2	: 0,
		button3	: 0
	},
	{
		// PadFX 2.7
		name	: "Filter Pulse*",
		color	: "Light Orange",
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
	{
		// PadFX 2.8
		name	: "Electro Flyby*",
		color	: "Fuchsia",
		effect1	: 0,	// Empty
		effect2	: 39,	// [M] Zzzurp
		effect3	: 41,	// [M] Strrretch
		knob0	: 0.7,	// Dry Wet
		knob1	: 0,
		knob2	: { value: 1, min: 0, max: 1, delta: -150 },
		knob3	: { value: 0, min: 0, max: 1, delta: 150 },
		button1	: 0,
		button2	: 0,
		button3	: 0
	}]
}