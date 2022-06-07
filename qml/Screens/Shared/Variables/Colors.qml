import CSI 1.0
import QtQuick 2.12

Module {

  function rgba (r,g,b,a) { return Qt.rgba(r/255.,  g/255., b/255., a/255.) }
  //Dev Stuff - To correct the RGBA on the S8 screen when modding the S4 MK3 screen
  //function rgba(r,g,b,a) { return Qt.rgba(  b/255. ,  g/255. ,  r/255. , a/255. ) }

  function darkerColor (color, factor) { return Qt.rgba(factor*color.r, factor*color.g, factor*color.b, color.a) }
  function opacity (color, factor) { return Qt.rgba(color.r, color.g, color.b, factor * color.a) }

//--------------------------------------------------------------------------------------------------------------------
// General Use Colors
//--------------------------------------------------------------------------------------------------------------------

  //Backgrounds
  property color background: brightMode.value ? "white" : "black"
  property color footerBlue: "#011f26"

  //Texts
  property color text: brightMode.value ? "black" : "white"
  property color lightText: brightMode.value ? colorGrey32 : colorGrey232
  property color darkText: brightMode.value ? colorGrey32 : colorGrey72

  //Generic Colors
  property variant brightGrey: rgba (85, 85,  85,  255)
  property variant grey: rgba (70, 70,  70,  255)
  property variant darkGrey: rgba (40, 40,  40,   255)

  property variant brightBlue: rgba(0, 184, 232, 255) //rgba(0, 136, 184, 255)
  property variant darkBlue: rgba(0, 64, 88, 255)
  property variant orange: rgba(208, 104, 0, 255) // FX Selection; FX Faders etc
  property variant orangeDimmed: rgba(96, 48, 0, 255)

  property color loopActiveColor:			   rgba(0,255,70,255)
  property color loopActiveDimmedColor:		 rgba(0,255,70,190)
  property color grayBackground:				"#ff333333"

  //Freeze colors
  property variant freeze_blue: rgba(0, 174, 239, 51)
  property variant freeze_green: opacity(green, 20/255)
  property variant freezeBackground_selected: opacity(green, 128/255)
  property variant freezeBackground_inactive: opacity(green, 31/255)

  //Custom colors
  property variant softtakeover_red: rgba(185, 6, 6, 255)

  //Theme custom colors
  property variant pioneerRedDark: rgba (154, 54, 61, 255) //rgba (100, 38, 32, 255)
  property variant pioneerRed: rgba (177, 10, 50, 255)
  property variant pioneerGreen: rgba(5, 90, 30, 255)

  // PhaseMeter Widget
  property variant greenActive:			rgba( 82, 255, 148, 255)
  property variant greenInactive:		  rgba(  8,  56,  24, 255)
  property variant redActive:			  rgba(255, 50, 50, 255)
  property variant redInactive:			rgba(120, 0, 0, 255)
  property variant colorGreyInactive:		   rgba(139, 145, 139, 255)

  // font colors
  property variant colorFontsListBrowser:	   colorGrey128
  property variant colorFontsListFx:			colorGrey56
  property variant colorFontBrowserHeader:	  colorGrey88
  property variant colorFontFxHeader:		   colorGrey80 // also for FX header, FX select buttons

  // headers & footers backgrounds
  property variant colorBgEmpty:				colorGrey16 // also for empty decks & Footer Small (used to be colorGrey08)
  property variant colorBrowserHeader:		  colorGrey24
  property variant colorFxHeaderBg:			 colorGrey16 // also for large footer; fx overlay tabs
  property variant colorFxHeaderLightBg:		colorGrey24


  property variant colorProgressBg:			 colorGrey32
  property variant colorProgressBgLight:		colorGrey48
  property variant colorDivider:				colorGrey40

  property variant colorIndicatorBg:			rgba(20, 20, 20, 255)
  property variant colorIndicatorBg2:		   rgba(31, 31, 31, 255)

  property variant colorIndicatorLevelGrey:	 rgba(51, 51, 51, 255)
  property variant colorIndicatorLevelOrange:   rgba(247, 143, 30, 255)

  property variant colorCenterOverlayHeadline:  colorGrey88

  // fx Select overlay colors
  property variant fxSelectHeaderTextRGB:			rgba( 96,  96,  96, 255)
  property variant fxSelectHeaderNormalRGB:		  rgba( 32,  32,  32, 255)
  property variant fxSelectHeaderNormalBorderRGB:	rgba( 32,  32,  32, 255)
  property variant fxSelectHeaderHighlightRGB:	   rgba( 64,  64,  48, 255)
  property variant fxSelectHeaderHighlightBorderRGB: rgba(128, 128,  48, 255)


//--------------------------------------------------------------------------------------------------------------------
// Browser Colors
//--------------------------------------------------------------------------------------------------------------------

  property variant browser:
  QtObject {
    property color prelisten: rgba(0, 184, 232, 255) //rgba(223, 178, 30, 255)
    property color prevPlayed:  rgba(32, 32, 32, 255)
  }
  //property variant darkBlueBrowser: rgba(25, 75, 100, 255)
  property variant darkBlueBrowser: rgba(25, 75, 100, 170)
  property variant orangeBrowser: rgba(255, 135, 37, 255)

//--------------------------------------------------------------------------------------------------------------------
// PlayMarker Colors
//--------------------------------------------------------------------------------------------------------------------

  // Playmarker Red
  property variant playmarker: red
  property variant playmarker_flux:	rgba(96, 184, 192, 255) //rgba(136, 224, 232, 255)

//--------------------------------------------------------------------------------------------------------------------
// Loop Colors
//--------------------------------------------------------------------------------------------------------------------

  property variant loop_marker:		   rgba(139, 240, 139, 82)
  property variant loopOverlayBackground_green:	   rgba(96, 192, 128,48)
  property variant orangeLoopOverlay:	  rgba (245, 120, 10, 64)
  property variant colorLightGreyLoopOverlay:   rgba (255, 255, 255, 28)
  property variant colorDarkGreyLoopOverlay:	rgba (255, 255, 255, 20)
  property variant defaultLoopOverlay:		  rgba(96, 192, 128, 16)

//--------------------------------------------------------------------------------------------------------------------
// Freeze & Slicer Colors
//--------------------------------------------------------------------------------------------------------------------

  property variant freeze:
  QtObject {
    property color box_inactive:  "#199be7ef"
    property color box_active:	"#ff9be7ef"
    property color marker:		"#4DFFFFFF"
    property color slice_overlay: "white" // flashing rectangle
  }

  property variant slicer:
  QtObject {
    property color box_active:	  rgba(20,195,13,255)
    property color box_inrange:	rgba(20,195,13,90)
    property color box_inactive:   rgba(20,195,13,25)
    property color marker_default: rgba(20,195,13,77)
    property color marker_beat:	rgba(20,195,13,150)
    property color marker_edge:	box_active
  }

//--------------------------------------------------------------------------------------------------------------------
// Hotcue Colors
//--------------------------------------------------------------------------------------------------------------------

  //Colors of the hotcues on the waveform && stripe
  property variant hotcue:
  QtObject {
    property color grid:    colorWhite
    property color hotcue:  cyan
    property color fadeIn:  lightOrange
    property color fadeOut: darkOrange
    property color load:    yellow
    property color loop:    green
    property color temp:    "grey"
  }

  function hotcueTypeColor(type) {
    if (typeof type == "number") {
        switch (type) {
            case 0: return hotcue.hotcue;
            case 1: return hotcue.fadeIn;
            case 2: return hotcue.fadeOut;
            case 3: return hotcue.load;
            case 4: return hotcue.grid;
            case 5: return hotcue.loop;
        }
    }
    else if (typeof type === "string") {
        switch (type.toLowerCase().replace(' ', '')) {
            case "hotcue": return hotcue.hotcue;
            case "fadein": return hotcue.fadeIn;
            case "fadeout": return hotcue.fadeOut;
            case "load": return hotcue.load;
            case "grid": return hotcue.grid;
            case "loop": return hotcue.loop;
        }
    }
  }

  function pioneerCDJColors(type) {
    if (typeof type == "number") {
        switch (type) {
            case 0:
            case 1:
            case 2:
            case 3:
            case 4: return green
            case 5: return lightOrange
        }
    }
    else if (typeof type === "string") {
        switch (type.toLowerCase().replace(' ', '')) {
            case "hotcue":
            case "fadein":
            case "fadeout":
            case "load":
            case "grid": return green
            case "loop": return lightOrange
        }
    }
  }

  function pioneerColorfulColors(index) {
    switch (index) {
        case 1: return fuchsia;
        case 2: return turquoise;
        case 3: return green;
        case 4: return purple;
        case 5: return mint;
        case 6: return darkOrange;
        case 7: return blue;
        case 8: return yellow;
    }
  }

  function hotcueColor(index, type, exists, mode) {
    if (!exists) return "transparent"
    else {
        switch (mode) {
            case 0: return hotcueTypeColor(type)
            case 1: return pioneerCDJColors(type)
            case 2: return pioneerColorfulColors(index)
            default: return hotcueTypeColor(type)
        }
    }
  }

//--------------------------------------------------------------------------------------------------------------------
// Mixer FX Colors
//--------------------------------------------------------------------------------------------------------------------

  readonly property variant mixerFXColors: [lightOrange, red, green, cyan, yellow]

//--------------------------------------------------------------------------------------------------------------------
// Musical Key Colors
//--------------------------------------------------------------------------------------------------------------------

  property variant musicalKeyColors: [
      rgba(255,   0, 120, 255),	//0   -11 c
      rgba(153, 255,   0, 255),	//1   -4  c#, db
      rgba( 81, 179, 254, 255),	//2   -13 d
      rgba(255,  80,   0, 255),	//3   -6  d#, eb
      rgba(  0, 255, 200, 255),	//4   -16 e
      rgba(255,   0,   0, 255),	//5   -9  f
      rgba(  0, 255,   0, 255),	//6   -2  f#, gb
      rgba(160,   0, 200, 255),	//7   -12 g
      rgba(255, 200,   0, 255),	//8   -5  g#, ab
      rgba(  0, 210, 230, 255),	//9   -15 a
      rgba(255,  50,   0, 255),	//10  -7  a#, bb
      rgba(  0, 255, 128, 255),	//11  -1  b

      rgba(255,  80,   0, 255),	//12  -6  cm
      rgba(  0, 255, 200, 255),	//13  -16 c#m, dbm
      rgba(255,   0,   0, 255),	//14  -9  dm
      rgba(  0, 255,   0, 255),	//15  -2  d#m, ebm
      rgba(160,   0, 200, 255),	//16  -12 em
      rgba(255, 200,   0, 255),	//17  -5  fm
      rgba(  0, 210, 230, 255),	//18  -15 f#m, gbm
      rgba(255,  50,   0, 255),	//19  -7  gm
      rgba(  0, 255, 128, 255),	//20  -1  g#m, abm
      rgba(255,   0, 120, 255),	//21  -11 am
      rgba( 80, 255,  30, 255),	//22  -4  a#m, bbm
      rgba( 50, 100, 255, 255)	 //23  -13 bm
  ]

/*
  property variant musicalKeyColors: [
    rgba(255,   0, 120, 255),	//0   -11 c
    rgba(153, 255,   0, 255),	//1   -4  c#, db
    rgba( 81, 179, 254, 255),	//2   -13 d
    rgba(255,  80,   0, 255),	//3   -6  d#, eb
    rgba(  0, 255, 200, 255),	//4   -16 e
    rgba(255,   0,   0, 255),	//5   -9  f
    rgba(  0, 255,   0, 255),	//6   -2  f#, gb
    rgba(160,   0, 200, 255),	//7   -12 g
    rgba(255, 200,   0, 255),	//8   -5  g#, ab
    rgba(  0, 210, 230, 255),	//9   -15 a
    rgba(255,  50,   0, 255),	//10  -7  a#, bb
    rgba(  0, 255, 128, 255),	//11  -1  b

    rgba(255,  80,   0, 255),	//12  -6  cm
    rgba(  0, 255, 200, 255),	//13  -16 c#m, dbm
    rgba(255,   0,   0, 255),	//14  -9  dm
    rgba(  0, 255,   0, 255),	//15  -2  d#m, ebm
    rgba(160,   0, 200, 255),	//16  -12 em
    rgba(255, 200,   0, 255),	//17  -5  fm
    rgba(  0, 210, 230, 255),	//18  -15 f#m, gbm
    rgba(255,  50,   0, 255),	//19  -7  gm
    rgba(  0, 255, 128, 255),	//20  -1  g#m, abm
    rgba(255,   0, 120, 255),	//21  -11 am
    rgba( 80, 255,  30, 255),	//22  -4  a#m, bbm
    rgba( 50, 100, 255, 255)	 //23  -13 bm
  ]
*/
  //this list will be filled with Component.onCompleted() based on musicalKeyColor (see further down)
  property variant musicalKeyDarkColors: []
  Component.onCompleted: {
    for (var i = 0; i<musicalKeyColors.length; i++) {
        musicalKeyDarkColors.push(darkerColor(musicalKeyColors[i], 0.7))
    }
  }

/*
  property variant musicalKeyColors: [
    //The following RGBAs have been directly measured from Traktor using a digital color measuring tool. However, when translated to the Controller's, the colours lack of brightness and a little bit of red intensity.
    rgba(254,  63, 234, 255),	//0   -11 c
    rgba(152, 254,   0, 255),	//1   -4  c#, db
    rgba( 62, 138, 253, 255),	//2   -13 d
    rgba(249, 140,  40, 255),	//3   -6  d#, eb
    rgba(  0, 231, 231, 255),	//4   -16 e
    rgba(252, 73,  73, 255),	//5   -9  f
    rgba( 63, 254,  63, 255),	//6   -2  f#, gb
    rgba(172, 100, 254, 255),	//7   -12 g
    rgba(254, 214,   0, 255),	//8   -5  g#, ab
    rgba(  0, 201, 254, 255),	//9   -15 a
    rgba(254, 100,  46, 255),	//10  -7  a#, bb
    rgba(  0, 213, 143, 255),	//11  -1  b

    rgba(249, 140,  40, 255),	//12  -6  cm
    rgba(  0, 231, 231, 255),	//13  -16 c#m, dbm
    rgba(252,  73,  73, 255),	//14  -9  dm
    rgba( 63, 254,  63, 255),	//15  -2  d#m, ebm
    rgba(172, 100, 254, 255),	//16  -12 em
    rgba(254, 214,   0, 255),	//17  -5  fm
    rgba(  0, 201, 254, 255),	//18  -15 f#m, gbm
    rgba(254, 100,  46, 255),	//19  -7  gm
    rgba(  0, 213, 143, 255),	//20  -1  g#m, abm
    rgba(254,  63, 234, 255),	//21  -11 am
    rgba(152, 254,   0, 255),	//22  -4  a#m, bbm
    rgba( 62, 138, 253, 255)	 //23  -13 bm
  ]
*/

  //--------------------------------------------------------------------------------------------------------------------
  // BLACK Color Palette
  //--------------------------------------------------------------------------------------------------------------------

    property variant colorBlack:                rgba (0, 0, 0, 255)
    property variant colorBlack94:				rgba (0, 0, 0, 240)
    property variant colorBlack88:				rgba (0, 0, 0, 224)
    property variant colorBlack85:				rgba (0, 0, 0, 217)
    property variant colorBlack81:				rgba (0, 0, 0, 207)
    property variant colorBlack78:				rgba (0, 0, 0, 199)
    property variant colorBlack75:				rgba (0, 0, 0, 191)
    property variant colorBlack69:				rgba (0, 0, 0, 176)
    property variant colorBlack66:				rgba (0, 0, 0, 168)
    property variant colorBlack63:				rgba (0, 0, 0, 161)
    property variant colorBlack60:				rgba (0, 0, 0, 153) // from 59 - 61%
    property variant colorBlack56:				rgba (0, 0, 0, 143) //
    property variant colorBlack53:				rgba (0, 0, 0, 135) // from 49 - 51%
    property variant colorBlack50:				rgba (0, 0, 0, 128) // from 49 - 51%
    property variant colorBlack47:				rgba (0, 0, 0, 120) // from 46 - 48%
    property variant colorBlack44:				rgba (0, 0, 0, 112) // from 43 - 45%
    property variant colorBlack41:				rgba (0, 0, 0, 105) // from 40 - 42%
    property variant colorBlack38:				rgba (0, 0, 0, 97) // from 37 - 39%
    property variant colorBlack35:				rgba (0, 0, 0, 89) // from 33 - 36%
    property variant colorBlack31:				rgba (0, 0, 0, 79) // from 30 - 32%
    property variant colorBlack28:				rgba (0, 0, 0, 71) // from 27 - 29%
    property variant colorBlack25:				rgba (0, 0, 0, 64) // from 24 - 26%
    property variant colorBlack22:				rgba (0, 0, 0, 56) // from 21 - 23%
    property variant colorBlack19:				rgba (0, 0, 0, 51) // from 18 - 20%
    property variant colorBlack16:				rgba (0, 0, 0, 41) // from 15 - 17%
    property variant colorBlack12:				rgba (0, 0, 0, 31) // from 11 - 13%
    property variant colorBlack09:				rgba (0, 0, 0, 23) // from 8 - 10%
    property variant colorBlack0:               rgba (0, 0, 0, 0)

  //--------------------------------------------------------------------------------------------------------------------
  // GREY Color Palette
  //--------------------------------------------------------------------------------------------------------------------

    property variant colorGrey232:				rgba (232, 232, 232, 255)
    property variant colorGrey216:				rgba (216, 216, 216, 255)
    property variant colorGrey208:				rgba (208, 208, 208, 255)
    property variant colorGrey200:				rgba (200, 200, 200, 255)
    property variant colorGrey192:				rgba (192, 192, 192, 255)
    property variant colorGrey152:				rgba (152, 152, 152, 255)
    property variant colorGrey143:				rgba (143, 143, 143, 255)
    property variant colorGrey128:				rgba (128, 128, 128, 255)
    property variant colorGrey120:				rgba (120, 120, 120, 255)
    property variant colorGrey112:				rgba (112, 112, 112, 255)
    property variant colorGrey104:				rgba (104, 104, 104, 255)
    property variant colorGrey96:               rgba (96, 96, 96, 255)
    property variant colorGrey88:               rgba (88, 88, 88, 255)
    property variant colorGrey80:               rgba (80, 80, 80, 255)
    property variant colorGrey72:               rgba (72, 72, 72, 255)
    property variant colorGrey64:               rgba (64, 64, 64, 255)
    property variant colorGrey56:               rgba (56, 56, 56, 255)
    property variant colorGrey48:               rgba (48, 48, 48, 255)
    property variant colorGrey40:               rgba (40, 40, 40, 255)
    property variant colorGrey32:               rgba (32, 32, 32, 255)
    property variant colorGrey24:               rgba (24, 24, 24, 255)
    property variant colorGrey16:               rgba (16, 16, 16, 255)
    property variant colorGrey08:               rgba (08, 08, 08, 255)

  //--------------------------------------------------------------------------------------------------------------------
  // WHITE Color Palette
  //--------------------------------------------------------------------------------------------------------------------

    property variant colorWhite:                rgba (255, 255, 255, 255)
    property variant colorWhite75:				rgba (255, 255, 255, 191)
    property variant colorWhite85:				rgba (255, 255, 255, 217)
    // property variant colorWhite60:				rgba (255, 255, 255, 153) // from 59 - 61%
    property variant colorWhite50:				rgba (255, 255, 255, 128) // from 49 - 51%
    // property variant colorWhite47:				rgba (255, 255, 255, 120) // from 46 - 48%
    // property variant colorWhite44:				rgba (255, 255, 255, 112) // from 43 - 45%
    property variant colorWhite41:				rgba (255, 255, 255, 105) // from 40 - 42%
    // property variant colorWhite38:				rgba (255, 255, 255, 97) // from 37 - 39%
    property variant colorWhite35:				rgba (255, 255, 255, 89) // from 33 - 36%
    // property variant colorWhite31:				rgba (255, 255, 255, 79) // from 30 - 32%
    property variant colorWhite28:				rgba (255, 255, 255, 71) // from 27 - 29%
    property variant colorWhite25:				rgba (255, 255, 255, 64) // from 24 - 26%
    property variant colorWhite22:				rgba (255, 255, 255, 56) // from 21 - 23%
    property variant colorWhite19:				rgba (255, 255, 255, 51) // from 18 - 20%
    property variant colorWhite16:				rgba (255, 255, 255, 41) // from 15 - 17%
    property variant colorWhite12:				rgba (255, 255, 255, 31) // from 11 - 13%
    property variant colorWhite09:				rgba (255, 255, 255, 23) // from 8 - 10%
    property variant colorWhite06:				rgba (255, 255, 255, 15) // from 5 - 7%
    // property variant colorWhite03:				rgba (255, 255, 255, 8) // from 2 - 4%

  //--------------------------------------------------------------------------------------------------------------------
  // 16 Colors Palette
  //--------------------------------------------------------------------------------------------------------------------

/*
  Here are the numbers that are associated to each color.
    Color 01 --> Red			Color 02 --> Dark Orange		Color 03 --> Light Orange		Color 04 --> Warm Yellow
    Color 05 --> Yellow		Color 06 --> Lime				Color 07 --> Green				Color 08 --> Mint
    Color 09 --> Cyan			Color 10 --> Turquoise			Color 11 --> Blue				Color 12 --> Plum
    Color 13 --> Violet		Color 14 --> Purple				Color 15 --> Magenta			Color 16 --> Fuchsia
*/

    // 16 Colors Palette (Bright)
    property variant red: rgba (255,  0,  0, 255)
    property variant darkOrange: rgba (255,  60,  0, 255)
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
          case 0: return colorBgEmpty	 // default color for this palette!
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
          case 0: return colorBgEmpty	// default color for this palette!
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
          case 0: return colorBgEmpty   // default color for this palette!
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
          return colorBgEmpty;
      }
      return colorBgEmpty;  // default color if no palette is set
    }

//--------------------------------------------------------------------------------------------------------------------
// Waveform Color Maps
//--------------------------------------------------------------------------------------------------------------------

  property variant waveformColorsMap: [
    // Traktor Default
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
      high1: rgba (255, 210, 220, 140),  high2: rgba (255, 220, 230, 160) },
    // Denon SC5000/SC6000 Prime Style
    { low1:  rgba ( 41, 113, 246, 100),  low2:  rgba ( 41, 113, 246, 250),
      mid1:  rgba ( 98, 234,  82, 100),  mid2:  rgba ( 98, 234,  82, 250),
      high1: rgba (255, 255, 255, 100),  high2: rgba (255, 255, 255, 250) },
    // Pioneer CDJ-2000 Nexus 2 Style
    { low1:  rgba (200,   0,   0, 100),  low2:  rgba (200, 100,   0, 250),
      mid1:  rgba (60,  120, 240, 100),  mid2:  rgba (80,  160, 240, 250),
      high1: rgba (100, 200, 240, 100),  high2: rgba (120, 240, 240, 250) },
    // Pioneer CDJ-3000 Style
    { low1:  rgba (24,   48,  140, 200), low2:  rgba (0, 184, 232, 180),
      mid1: rgba (255, 110,   0, 255),   mid2:  rgba (245, 120,  10, 160),
      high1: rgba (232, 232, 232, 255),  high2: rgba (152, 152, 152, 255) },
    // Supreme MOD
    { low1:  rgba (24,   48,  140, 200), low2:  rgba (0, 184, 232, 180),
      mid1:  rgba ( 80, 245,  80, 220),  mid2:  rgba ( 95, 245,  115, 150),
      high1: rgba (255, 110,   0, 255),  high2:  rgba (245, 120,  10, 160) },
    // Customized Style
    { low1:  preferences.low1,  		low2:  preferences.low2,
      mid1:  preferences.mid,  			mid2:  preferences.mid2,
      high1: preferences.high1,  		high2: preferences.high2 }
  ]

  function getDefaultWaveformColors(preferencesWFColors) {
    return waveformColorsMap[preferencesWFColors];
  }

  function getStemWaveformColors(colorId, preferencesWFColors) {
    if(colorId <= 16) {
        return waveformColorsMap[colorId];
    }
    else {
        return waveformColorsMap[preferencesWFColors];
    }
  }

  function colorForLED(colorId) {
    switch(colorId) {
        case 0: return colorBgEmpty	 // default color for this palette!
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
        case 17: return "white"
    }
  }

}
