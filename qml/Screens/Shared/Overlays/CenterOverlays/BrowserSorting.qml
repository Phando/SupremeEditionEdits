import CSI 1.0
import QtQuick 2.12

/* necessary for obtainning qmlBrowser.sortId ?
import QtGraphicalEffects 1.12
import Traktor.Gui 1.0 as Traktor
*/

CenterOverlay {
  id: sortAdjust

  AppProperty { id: propSortId;   path: "app.traktor.browser.sort_id" }
  //property int propSortId: qmlBrowser.sortingId // the given numbers are determined by the ContentListColumns in Traktor

  //Overlay Headline
  Text {
    anchors.top: parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.topMargin: 11
    font.pixelSize: fonts.largeFontSize
    color: colors.colorCenterOverlayHeadline
    text: "SORT BY"
  }

  //Content
  Text {
    anchors.top: parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.topMargin: text.length < 10 ? 45 : 53
    font.pixelSize: text.length < 10 ? fonts.extraLargeValueFontSize : fonts.moreLargeValueFontSize
    color: colors.colorWhite
    text: getText(propSortId.value) //getText(propSortId) //no funciona... propSortId no ho agafa bé, a diferencia de en el list delegate i el browser footer on ho detecta perfectament
  }

  function getText(id) {
    switch (id) {
        case -1:
        case 0: return "#"
        case 1: return "ICONS"
        case 2: return "TITLE"
        case 3: return "ARTIST"
        case 4: return "TIME"
        case 5: return "BPM"
        case 6: return "TRACK"
        case 7: return "RELEASE"
        case 8: return "LABEL"
        case 9: return "GENRE"
        case 10: return "KEY TEXT"
        case 11: return "COMMENT"
        //case 11: return "ENERGY"
        case 12: return "LYRICS"
        case 13: return "COMMENT 2"
        case 14: return "FILE"
        case 15: return "ANALYZED"
        case 16: return "REMIXER"
        case 17: return "PRODUCER"
        case 18: return "MIX"
        case 19: return "CATALOG NUMBER"
        case 20: return "RELEASE DATE"
        case 21: return "BITRATE"
        case 22: return "RATING"
        case 23: return "PLAY COUNT"
        case 24: return "PRELISTEN"
        case 25: return "COVER ART"
        case 26: return "LAST PLAYED"
        case 27: return "IMPORT DATE"
        case 28: return "KEY"
        case 29: return "COLOR"
        default: break;
    }
    return "SORTED"
  }
}