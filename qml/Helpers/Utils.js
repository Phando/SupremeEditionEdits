//--------------------------------------------------------------------------------------------------------------------
// Math functions
//--------------------------------------------------------------------------------------------------------------------

function log10(num) {
    return Math.log(num) / Math.LN10
}

function clamp(value, min, max) { //clamp returns the index if it is in the min-max interval. If the ind is minor than the min, it will return the min. If major than the max, it will return the major.
    return Math.max(min, Math.min(value, max))
}

//--------------------------------------------------------------------------------------------------------------------
// Time Conversion Helpers
//--------------------------------------------------------------------------------------------------------------------

function getTime(time){ //Time in seconds
    var neg = time < 0
    var roundedSec = Math.floor(time);

    if (neg) {
        roundedSec = -roundedSec;
    }

    var sec = roundedSec % 60;
    var min = (roundedSec - sec) / 60

    var secStr = sec.toString();
    if (sec < 10) secStr = "0" + secStr

    var minStr = min.toString();
    if (min < 10) minStr = "0" + minStr;

    return (neg ? "-" : "") + minStr + ":" + secStr;
}

function getRemainingTime(length, elapsed){
    return (elapsed > length) ? getTime(0) : getTime(Math.floor(elapsed) - Math.floor(length))
}

//--------------------------------------------------------------------------------------------------------------------
// Other Helpers
//--------------------------------------------------------------------------------------------------------------------

function convertToDb(gain) {
    var level0dB = 1.0;
    var norm = gain / level0dB;
    if (norm <= 0.0)
      return -0.0000000001;

    return 20.0*log10(norm);
}