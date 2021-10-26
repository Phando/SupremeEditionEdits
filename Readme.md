# Traktor Supreme Edition Mod
## EffectsMode Mod 

This mod is based on the work of Aleix Jiménez and his badass [Supreme Edition Mod](https://www.patreon.com/supremeedition). 

Inspired by DJ Tech Tools [One Button Builds](https://djtechtools.com/2014/02/10/creating-one-button-fx-builds-in-traktor).

See it in action: [here](https://youtu.be/GomKd7v-qL8).

### Features:

* Fixed - where the effect is only enabled after the 2nd press.
* Added - ability to use Single or Group effects
* Added - ability to have Dynamic effects with 'animated' values

## Required Setup

- On the right side of your controller press *shift+deck* to view the effects settings
- Assign FXUnit 2 to the top effects unit on the right side.

## Static and Dynamic Effects

Static effects are routed to FX units 1 and 2 so they can be tweaked with the FX controls. Dynamic effects are routed to FX units 3 and 4. The Dynamic effects are intended to be on auto-pilot and are push+hold only. Knobs with float values will define static effects. Knobs with objects define dynamic effects. The dynamic effect
descriptor takes a value, min, max and delta. The effect will start at the value and then progress at the rate defined by the delta (+ or -) till it hits the min or max. The smaller the delta the slower the value will build.

You can customize the predefined effects or define your own in the qml/Preferences/InstantFXs.qml file.

### Static Effects

Single Effect:

`
{  
	name : "Echo Fade",
	color : "color08",
	effect1 : 1, /* Delay */
	effect2 : 0,
	effect3 : 0,
	knob0 : 0.25, /* Dry Wet */
	knob1 : 0.5,
	knob2 : 0.5,
	knob3 : 0.4,
	button1 : 0,
	button2 : 1,
	button3 : 0
}
`

Group Effect:

`
{
	name : "Echo Fade Multi",
	color : "color09",
	effect1 : 7,	/* Beatmasher2 */
	effect2 : 38,	/* Event Horizon */
	effect3 : 14,	/* Filter:92 */
	knob0 : 1.0,	/* Dry Wet */
	knob1 : 0,	/* 1 Measure */
	knob2 : 0.5,	
	knob3 : 0.5,
	button1 : 1,
	button2 : 1,
	button3 : 1
}
`

### Dynamic Effects

A dynamic effect has animated values. In order to make an effect dynamic, the knob value should be set to an object like below. Buttons are automatically enabled for any knob that has a dynamic definition. 

`
{
	name : "Echo Fade Multi (4 BEATS)",
	color : "color14",
	effect1 : 7,	/* Beatmasher2 */
	effect2 : 38,	/* Event Horizon */
	effect3 : 14,	/* Filter:92 */
	knob0 : 0.8,	/* Dry Wet */
	knob1 : 0,	/* 1 Measure */
	knob2 : { value: 0.5, min: 0.1, max: 1, delta: -6 },
	knob3 : { value: 0.5, min: 0, max: 0.9, delta: 5 },
	button1 : 1,
	button2 : 0,
	button3 : 0
},
`

### Issues

Seeing the following errors/warnings on startup. They don't seem to effect runtime. 

- qml/Screens/Defines/Colors.qml:513: TypeError: Value is undefined and could not be converted to an object
- qml/Screens/Defines/Colors.qml:513: TypeError: Cannot read property 'low1' of undefined
- qml/CSI/S5/S5Deck.qml:249:3: Unable to assign [undefined] to bool
