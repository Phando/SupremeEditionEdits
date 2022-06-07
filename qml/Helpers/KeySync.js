function sync(trackKey, masterKey, fuzzySync) {

  if (!trackKey || !masterKey) return "ERR"

  var trackIndex = (trackKey >= 12) ? ((trackKey >= 21) ? (trackKey-21) : (trackKey-9)) : trackKey
  var trackScale = (trackKey >= 12) ? "Major" : "Minor"

  var masterIndex = (masterKey >= 12) ? ((masterKey >= 21) ? (masterKey-21) : (masterKey-9)) : masterKey
  var masterScale = (masterKey >= 12) ? "Major" : "Minor"

  var keyOffset = 0
  var keyOffsetPlus = 0
  var keyOffsetMinus = 0

  var masterIndexPlus = (masterIndex <= 4) ? masterIndex + 7 : masterIndex - 5
  var masterIndexMinus = (masterIndex <= 6) ? masterIndex + 5 : masterIndex - 7

  if ((trackIndex == masterIndex) || ((fuzzySync || trackScale == masterScale) && (trackIndex == masterIndexPlus || trackIndex == masterIndexMinus))) return 0
  else {
      var currentIndex = trackIndex
      for (var i=1; i<=11; ++i) {
          if (currentIndex == 11) currentIndex = 0
          else currentIndex = currentIndex+1
          if (currentIndex == masterIndex) {
              keyOffset = i
              break
          }
      }
      if (keyOffset > 6) keyOffset = keyOffset-12

      //If master & deck are both in the same scale or fuzzySync enabled
      if (fuzzySync || (trackScale === masterScale)) {
          currentIndex = trackIndex
          for (i=1; i<=12; ++i) {
              if (currentIndex == 11) currentIndex = 0
              else currentIndex = currentIndex+1

              if (currentIndex == masterIndexPlus || currentIndex == masterIndexMinus) {
                  keyOffsetPlus = i
                  break
              }
          }

          currentIndex = trackIndex
          for (i=1; i<=12; ++i) {
              if (currentIndex == 0) currentIndex = 11
              else currentIndex = currentIndex-1

              if (currentIndex == masterIndexPlus || currentIndex == masterIndexMinus) {
                  keyOffsetMinus = -i
                  break
              }
          }
          if (Math.abs(keyOffset) < Math.abs(keyOffsetMinus) && Math.abs(keyOffset) < Math.abs(keyOffsetPlus)) return keyOffset/12
          else if (Math.abs(keyOffsetPlus) < Math.abs(keyOffset) && Math.abs(keyOffsetPlus) < Math.abs(keyOffsetMinus)) return keyOffsetPlus/12
          else return keyOffsetMinus/12
      }
      //If master & deck are in different scale and fuzzySync disabled
      else return keyOffset/12
  }
}


function isSynchronized(trackKey, masterKey, fuzzySync) {
  var trackIndex = (trackKey >= 12) ? ((trackKey >= 21) ? (trackKey-21) : (trackKey-9)) : trackKey
  var trackScale = (trackKey >= 12) ? "Major" : "Minor"

  var masterIndex = (masterKey >= 12) ? ((masterKey >= 21) ? (masterKey-21) : (masterKey-9)) : masterKey
  var masterScale = (masterKey >= 12) ? "Major" : "Minor"

  var masterIndexPlus = (masterIndex <= 4) ? masterIndex + 7 : masterIndex - 5
  var masterIndexMinus = (masterIndex <= 6) ? masterIndex + 5 : masterIndex - 7

  return (trackIndex == masterIndex) || ((fuzzySync || trackScale == masterScale) && (trackIndex == masterIndexPlus || trackIndex == masterIndexMinus))
}
