import QtQuick 2.12

QtObject {

  function rgba(r,g,b,a) { return Qt.rgba(  r/255. ,  g/255. ,  b/255. , a/255. ) }
  function darkerColor( c, factor ) { return Qt.rgba(factor*c.r, factor*c.g, factor*c.b, c.a); }
  function opacity( c, factor ) { return Qt.rgba(c.r, c.g, c.b, factor * c.a); }


  property color background:			 "black"
  property color text:			  "white"
  property color loopActiveColor:			   rgba(0,255,70,255)
  property color loopActiveDimmedColor:		 rgba(0,255,70,190)
  property color grayBackground:				"#ff333333"

  property variant playmarker:		  rgba(255, 0, 0, 255)
  property variant playmarker75:		rgba(255, 56, 26, 191)
  property variant playmarker06:		rgba(255, 56, 26, 31)
  property variant playmarker_flux:		 rgba(96, 184, 192, 255)

  property variant colorBlack50:				rgba (0, 0, 0, 128) 
  property variant colorBlack:				  rgba (0, 0, 0, 255) 

  property variant brightGrey:		 rgba (85, 85,  85,  255)
  property variant grey:			   rgba (70, 70,  70,  255)
  property variant darkGrey:		   rgba (40, 40,  40,   255)
  
  property variant brightBlue:		 rgba(0, 136, 184, 255) 
  property variant colorWhite:				  rgba (255, 255, 255, 255)

  property variant red:					rgba(255,0,80,255)

  property variant cyan:			rgba(96, 220, 255, 255)

  //--------------------------------------------------------------------------------------------------------------------

  //  Waveform coloring

  //--------------------------------------------------------------------------------------------------------------------
  

  property variant waveformColorsMap: [
	// Default
	{ low1:  rgba (24,   48,  80, 180),  low2:  rgba (24,   56,  96, 190),
	  mid1:  rgba (80,  160, 160, 100),  mid2:  rgba (48,  112, 112, 150),
	  high1: rgba (184, 240, 232, 120),  high2: rgba (208, 255, 248, 180) },
	// Red - #c80000
	{ low1:  rgba (200,   0,   0, 150),  low2:  rgba (200,  30,  30, 155),
	  mid1:  rgba (180, 100, 100, 120),  mid2:  rgba (180, 110, 110, 140),
	  high1: rgba (220, 180, 180, 140),  high2: rgba (220, 200, 200, 160) },
	// Dark Orange - #ff3200
	{ low1:  rgba (255,  50,   0, 150),  low2:  rgba (255,  70,  20, 170),
	  mid1:  rgba (180,  70,  50, 120),  mid2:  rgba (180,  90,  70, 140),
	  high1: rgba (255, 200, 160, 140),  high2: rgba (255, 220, 180, 160) },
	// Light Orange - #ff6e00
	{ low1:  rgba (255, 110,   0, 150),  low2:  rgba (245, 120,  10, 160),
	  mid1:  rgba (255, 150,  80, 120),  mid2:  rgba (255, 160,  90, 140),
	  high1: rgba (255, 220, 200, 140),  high2: rgba (255, 230, 210, 160) },
	// Warm Yellow - #ffa000
	{ low1:  rgba (255, 160,   0, 160),  low2:  rgba (255, 170,  20, 170),
	  mid1:  rgba (255, 180,  70, 120),  mid2:  rgba (255, 190,  90, 130),
	  high1: rgba (255, 210, 135, 140),  high2: rgba (255, 220, 145, 160) },
	// Yellow - #ffc800
	{ low1:  rgba (255, 200,   0, 160),  low2:  rgba (255, 210,  20, 170),
	  mid1:  rgba (241, 230, 110, 120),  mid2:  rgba (241, 240, 120, 130),
	  high1: rgba (255, 255, 200, 120),  high2: rgba (255, 255, 210, 180) },
	// Lime - #64aa00
	{ low1:  rgba (100, 170,   0, 150),  low2:  rgba (100, 170,   0, 170),
	  mid1:  rgba (190, 250,  95, 120),  mid2:  rgba (190, 255, 100, 150),
	  high1: rgba (230, 255, 185, 120),  high2: rgba (230, 255, 195, 180) },
	// Green - #0a9119
	{ low1:  rgba ( 10, 145,  25, 150),  low2:  rgba ( 20, 145,  35, 170),
	  mid1:  rgba ( 80, 245,  80, 110),  mid2:  rgba ( 95, 245,  95, 130),
	  high1: rgba (185, 255, 185, 140),  high2: rgba (210, 255, 210, 180) },
	// Mint - #00be5a
	{ low1:  rgba (  0, 155, 110, 150),  low2:  rgba ( 10, 165, 130, 170),
	  mid1:  rgba ( 20, 235, 165, 120),  mid2:  rgba ( 20, 245, 170, 150),
	  high1: rgba (200, 255, 235, 140),  high2: rgba (210, 255, 245, 170) },
	// Cyan - #009b6e
	{ low1:  rgba ( 10, 200, 200, 150),  low2:  rgba ( 10, 210, 210, 170),
	  mid1:  rgba (  0, 245, 245, 120),  mid2:  rgba (  0, 250, 250, 150),
	  high1: rgba (170, 255, 255, 140),  high2: rgba (180, 255, 255, 170) },
	// Turquoise - #0aa0aa
	{ low1:  rgba ( 10, 130, 170, 150),  low2:  rgba ( 10, 130, 180, 170),
	  mid1:  rgba ( 50, 220, 255, 120),  mid2:  rgba ( 60, 220, 255, 140),
	  high1: rgba (185, 240, 255, 140),  high2: rgba (190, 245, 255, 180) },
	// Blue - #1e55aa
	{ low1:  rgba ( 30,  85, 170, 150),  low2:  rgba ( 50, 100, 180, 170),
	  mid1:  rgba (115, 170, 255, 120),  mid2:  rgba (130, 180, 255, 140),
	  high1: rgba (200, 230, 255, 140),  high2: rgba (215, 240, 255, 170) },
	//Plum - #6446a0
	{ low1:  rgba (100,  70, 160, 150),  low2:  rgba (120,  80, 170, 170),
	  mid1:  rgba (180, 150, 230, 120),  mid2:  rgba (190, 160, 240, 150),
	  high1: rgba (220, 210, 255, 140),  high2: rgba (230, 220, 255, 160) },
	// Violet - #a028c8
	{ low1:  rgba (160,  40, 200, 140),  low2:  rgba (170,  50, 190, 170),
	  mid1:  rgba (200, 135, 255, 120),  mid2:  rgba (210, 155, 255, 150),
	  high1: rgba (235, 210, 255, 140),  high2: rgba (245, 220, 255, 170) },
	// Purple - #c81ea0
	{ low1:  rgba (200,  30, 160, 150),  low2:  rgba (210,  40, 170, 170),
	  mid1:  rgba (220, 130, 240, 120),  mid2:  rgba (230, 140, 245, 140),
	  high1: rgba (250, 200, 255, 140),  high2: rgba (255, 200, 255, 170) },
	// Magenta - #e60a5a
	{ low1:  rgba (230,  10,  90, 150),  low2:  rgba (240,  10, 100, 170),
	  mid1:  rgba (255, 100, 200, 120),  mid2:  rgba (255, 120, 220, 150),
	  high1: rgba (255, 200, 255, 140),  high2: rgba (255, 220, 255, 160) },
	// Fuchsia - #ff0032
	{ low1:  rgba (255,   0,  50, 150),  low2:  rgba (255,  30,  60, 170),
	  mid1:  rgba (255, 110, 110, 130),  mid2:  rgba (255, 125, 125, 160),
	  high1: rgba (255, 210, 220, 140),  high2: rgba (255, 220, 230, 160) }
  ]

  function getDefaultWaveformColors()
  {
	return waveformColorsMap[0];
  }

  function getWaveformColors(colorId)
  {
	if(colorId <= 16) {
	  return waveformColorsMap[colorId];
	}

	return waveformColorsMap[0];
  }

  // 16 Colors Palette (Bright)
  property variant red: rgba (255,  0,  0, 255)
  property variant darkOrange: rgba (255,  16,  16, 255)
  property variant lightOrange: rgba (255, 120,   0, 255)
  property variant warmYellow: rgba (255, 184,   0, 255)
  property variant yellow: rgba (255, 255,   0, 255)
  property variant lime: rgba (144, 255,   0, 255)
  property variant green: rgba ( 40, 255,  40, 255)
  property variant mint: rgba (  0, 208, 128, 255)
  property variant cyan: rgba (  0, 184, 232, 255)
  property variant turquoise: rgba (  0, 120, 255, 255)
  property variant blue: rgba (  0,  72, 255, 255)
  property variant plum: rgba (128,   0, 255, 255)
  property variant violet: rgba (160,   0, 200, 255)
  property variant purple: rgba (240,   0, 200, 255)
  property variant magenta: rgba (255,   0, 120, 255)
  property variant fuchsia: rgba (248,   8,  64, 255)

  // 16 Colors Palette (Mid)
  property variant redMid: rgba (112, 8,   8, 255)
  property variant darkOrangeMid: rgba (112, 24,  8, 255)
  property variant lightOrangeMid: rgba (112, 56,  0, 255)
  property variant warmYellowMid: rgba (112, 80,  0, 255)
  property variant yellowMid: rgba (96,  96, 0, 255)
  property variant limeMid: rgba (56,  96, 0, 255)
  property variant greenMid: rgba (8,  96,  8, 255)
  property variant mintMid: rgba (0,   90, 60, 255)
  property variant cyanMid: rgba (0,   77, 77, 255)
  property variant turquoiseMid: rgba (0, 84, 108, 255)
  property variant blueMid: rgba (32, 56, 112, 255)
  property variant plumMid: rgba (72, 32, 120, 255)
  property variant violetMid: rgba (80, 24, 96, 255)
  property variant purpleMid: rgba (111, 12, 149, 255)
  property variant magentaMid: rgba (122, 0, 122, 255)
  property variant fuchsiaMid: rgba (130, 1, 43, 255)

  // 16 Colors Palette (Dark)
  property variant redDark: rgba (16,  0,  0,  255)
  property variant darkOrangeDark: rgba (16,  8,  0,  255)
  property variant lightOrangeDark: rgba (16,  8,  0,  255)
  property variant warmYellowDark: rgba (16,  16, 0,  255)
  property variant yellowDark: rgba (16,  16, 0,  255)
  property variant limeDark: rgba (8,   16, 0,  255)
  property variant greenDark: rgba (8,   16, 8,  255)
  property variant mintDark: rgba (0,   16, 8,  255)
  property variant cyanDark: rgba (0,   8,  16, 255)
  property variant turquoiseDark: rgba (0,   8,  16, 255)
  property variant blueDark: rgba (0,   0,  16, 255)
  property variant plumDark: rgba (8,   0,  16, 255)
  property variant violetDark: rgba (8,   0,  16, 255)
  property variant purpleDark: rgba (16,  0,  16, 255)
  property variant magentaDark: rgba (16,  0,  8,  255)
  property variant fuchsiaDark: rgba (16,  0,  8,  255)

  function palette(brightness, colorId) {
	if ( brightness >= 0.666 && brightness <= 1.0 ) { // bright color
	  switch(colorId) {
		case 0: return background	 // default color for this palette!
		case 1: return red
		case 2: return darkOrange
		case 3: return lightOrange
		case 4: return warmYellow
		case 5: return yellow
		case 6: return lime
		case 7: return green
		case 8: return mint
		case 9: return cyan
		case 10: return turquoise
		case 11: return blue
		case 12: return plum
		case 13: return violet
		case 14: return purple
		case 15: return magenta
		case 16: return fuchsia
		case 17: return "grey"
		case 18: return colorGrey232
	  }
	} else if ( brightness >= 0.333 && brightness < 0.666 ) { // mid color
	  switch(colorId) {
		case 0: return background	// default color for this palette!
		case 1: return redMid
		case 2: return darkOrangeMid
		case 3: return lightOrangeMid
		case 4: return warmYellowMid
		case 5: return yellowMid
		case 6: return limeMid
		case 7: return greenMid
		case 8: return mintMid
		case 9: return cyanMid
		case 10: return turquoiseMid
		case 11: return blueMid
		case 12: return plumMid
		case 13: return violetMid
		case 14: return purpleMid
		case 15: return magentaMid
		case 16: return fuchsiaMid
		case 17: return "grey"
		case 18: return colorGrey232
	  }
	} else if ( brightness >= 0 && brightness < 0.333 ) { // dimmed color
	  switch(colorId) {
		case 0: return background   // default color for this palette!
		case 1: return redDark
		case 2: return darkOrangeDark
		case 3: return lightOrangeDark
		case 4: return warmYellowDark
		case 5: return yellowDark
		case 6: return limeDark
		case 7: return greenDark
		case 8: return mintDark
		case 9: return cyanDark
		case 10: return turquoiseDark
		case 11: return blueDark
		case 12: return plumDark
		case 13: return violetDark
		case 14: return purpleDark
		case 15: return magentaDark
		case 16: return fuchsiaDark
		case 17: return "grey"
		case 18: return colorGrey232
	  }
	} else if ( brightness < 0) { // color Off
		return background;
	}
	return background;  // default color if no palette is set
  } 



  property variant hotcue:
  QtObject {
	property color grid:   colorWhite
	property color hotcue: rgba(96, 220, 255, 255)
	property color fade:   lightOrange
	property color load:   yellow
	property color loop:   green
	property color temp:   "grey"
  }

  //--------------------------------------------------------------------------------------------------------------------
  //  Musical Key coloring
  //--------------------------------------------------------------------------------------------------------------------

  property variant musicalKeyColors: [
  rgba(255,  64, 235, 255),	//0   -11 c
  rgba(153, 255,   0, 255),	//1   -4  c#, db
  rgba( 81, 179, 254, 255),	//2   -13 d
  rgba(250, 141,  41, 255),	//3   -6  d#, eb
  rgba(  0, 232, 232, 255),	//4   -16 e
  rgba(253,  74,  74, 255),	//5   -9  f
  rgba( 64, 255,  64, 255),	//6   -2  f#, gb
  rgba(225, 131, 255, 255),	//7   -12 g
  rgba(255, 215,   0, 255),	//8   -5  g#, ab
  rgba(  0, 202, 255, 255),	//9   -15 a
  rgba(255, 101,  46, 255),	//10  -7  a#, bb
  rgba(  0, 214, 144, 255),	//11  -1  b
  rgba(250, 141,  41, 255),	//12  -6  cm
  rgba(  0, 232, 232, 255),	//13  -16 c#m, dbm
  rgba(253,  74,  74, 255),	//14  -9  dm
  rgba( 64, 255,  64, 255),	//15  -2  d#m, ebm
  rgba(213, 125, 255, 255),	//16  -12 em
  rgba(255, 215,   0, 255),	//17  -5  fm
  rgba(  0, 202, 255, 255),	//18  -15 f#m, gbm
  rgba(255, 101,  46, 255),	//19  -7  gm
  rgba(  0, 214, 144, 255),	//20  -1  g#m, abm
  rgba(255,  64, 235, 255),	//21  -11 am
  rgba(153, 255,   0, 255),	//22  -4  a#m, bbm
  rgba( 86, 189, 254, 255)	 //23  -13 bm
]

  //this list will be filled with Component.onCompleted() based on musicalKeyColor (see further down)
  property variant musicalKeyDarkColors: []

  Component.onCompleted: {
	for(var i = 0; i<musicalKeyColors.length; i++)
	{
	  musicalKeyDarkColors.push( darkerColor(musicalKeyColors[i], 0.7) );
	}
  }
  
}


