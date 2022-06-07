//Returns a color for the specified Deck index
function legacy(deckId) {
    switch (deckId){
        case 1:
        case 2:
            // Deck A and B are color-coded in Blue by Default
            return Color.Blue

        case 3:
        case 4:
            // Deck C and D are color-coded in White by Default in the S5, S8 and D2 controllers
            return Color.White
    }
    // Fall-through...
    return Color.Black
}

//Returns a color for the specified Deck index
function custom(deckId, colorId) {
    switch (deckId) {
        case 1:
        case 2:
            if (colorId !== undefined) getLED(colorId)
            else return Color.Blue

        case 3:
        case 4:
            if (colorId !== undefined) getLED(colorId)
            else return Color.LightOrange
    }
    // Fall-through...
    return Color.Black
}

function getLED(colorId) {
    if (typeof colorId === "number") {
        switch (colorId) {
            case 0: return Color.Black
            case 1: return Color.Red
            case 2: return Color.DarkOrange
            case 3: return Color.LightOrange
            case 4: return Color.WarmYellow
            case 5: return Color.Yellow
            case 6: return Color.Lime
            case 7: return Color.Green
            case 8: return Color.Mint
            case 9: return Color.Cyan
            case 10: return Color.Turquoise
            case 11: return Color.Blue
            case 12: return Color.Plum
            case 13: return Color.Violet
            case 14: return Color.Purple
            case 15: return Color.Magenta
            case 16: return Color.Fuchsia
            case 17: return Color.White
            default: return Color.Black
        }
    }
    else if (typeof colorId === "string"){
        switch (colorId.toLowerCase().replace(' ', '')) {
            case "black": return Color.Black
            case "red": return Color.Red
            case "darkorange": return Color.DarkOrange
            case "lightorange": return Color.LightOrange
            case "warmyellow": return Color.WarmYellow
            case "yellow": return Color.Yellow
            case "lime": return Color.Lime
            case "green": return Color.Green
            case "mint": return Color.Mint
            case "cyan": return Color.Cyan
            case "turquoise": return Color.Turquoise
            case "blue": return Color.Blue
            case "plum": return Color.Plum
            case "violet": return Color.Violet
            case "purple": return Color.Purple
            case "magenta": return Color.Magenta
            case "fuchsia": return Color.Fuchsia
            case "white": return Color.White
            default: return Color.Black
        }
    }
    else return Color.Black
}

function hotcueTypeToLED(type) {
    switch (type) {
      case 0: return Color.Turquoise
      case 1: return Color.LightOrange
      case 2: return Color.DarkOrange
      case 3: return Color.Yellow
      case 4: return Color.White
      case 5: return Color.Green
      default: return Color.Black
    }
}

function pioneerCDJLEDs(type) {
    switch (type) {
      case 0:
      case 1:
      case 2:
      case 3:
      case 4: return Color.Green
      case 5: return Color.LightOrange
      default: return Color.Black
    }
}

function pioneerColorfulLEDs(index) {
    switch (index) {
      case 1: return Color.Fuchsia;
      case 2: return Color.Turquoise;
      case 3: return Color.Green;
      case 4: return Color.Purple;
      case 5: return Color.Mint;
      case 6: return Color.DarkOrange;
      case 7: return Color.Blue;
      case 8: return Color.Yellow;
    }
}

function hotcueLED(index, type, exists, mode) {
    if (!exists) return Color.Black
    else {
        switch (mode) {
            case 0: return hotcueTypeToLED(type)
            case 1: return pioneerCDJLEDs(type)
            case 2: return pioneerColorfulLEDs(index)
            default: return hotcueTypeToLED(type)
        }
    }
}