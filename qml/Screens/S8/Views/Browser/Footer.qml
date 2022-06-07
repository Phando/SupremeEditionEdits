import CSI 1.0
import QtQuick 2.12
import QtGraphicalEffects 1.12
import Traktor.Gui 1.0 as Traktor

import '../../../../Defines'
import '../../../Shared/Widgets' as Widgets
import '../../../../Helpers/KeyHelpers.js' as Key

Rectangle {
    id: footer
    property real  sortingKnobValue
    property string bottomCountString

    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    height: 15
    color: colors.colorBrowserHeader
    clip: true

    //Preferences Properties
    MappingProperty { id: overlayState; path: propertiesPath + ".overlay" }
    MappingProperty { id: isContentListProp; path: propertiesPath + ".browser.is_content_list" }
    MappingProperty { id: selectedFooterItem; path: propertiesPath + ".selected_footer_item" }
    MappingProperty { id: displayCamelotKey; path: "mapping.settings.displayCamelotKey" }
    MappingProperty { id: browserFooterInfo; path: "mapping.settings.browserFooterInfo" }

    property bool  isContentList: browser.isContentList
    onIsContentListChanged: { // We need this to be able do disable mappings (e.g. sorting ascend/descend)
        isContentListProp.value = isContentList;
    }

//SortId and it's Traktor Text values, so that you can choose how and which ones you want to sort by below
/*
  0 --> Sort By #
  1 --> Icons (not possible to sort by icons)
  2 --> Title
  3 --> Artist
  4 --> Time
  5 --> BPM
  6 --> Track
  7 --> Release
  8 --> Label
  9 --> Genre
  10 --> KEY Text (if you want to sort by Key Text, just remove the sorting by Key, and sort by Key Text, but below these lines, write as sort name Key instead of Key Text)
  11 --> Comment
  12 --> Lyrics
  13 --> Comment 2
  14 --> File
  15 --> Analyzed
  16 --> Remixer
  17 --> Producer
  18 --> Mix
  19 --> Catalog Number
  20 --> Release Date
  21 --> Bitrate
  22 --> Rating
  23 --> Play Count
  24 --> PreListen (not possible to sort by PreListened songs)
  25 --> Cover Art
  26 --> Last Played
  27 --> Import Date
  28 --> KEY (Traktor's detected Key, not the personalizable one)
  29 --> Color
*/

    //here you can add the sortId that you want (look above these lines), and you have to put it on the following 2 lines (in the same order in the 2 lines) so that it is in the order that you want when selecting how is it sorted
    //in the browser sorting overlay you can change the name for each case too
    readonly property variant sortIds: [0 , 2, 3, 5, 28, 10, 22, 11, 9, 27]
    readonly property variant sortNames: ["Sort By #", "Title", "Artist", "BPM", "Key", "Key Text", "Rating", "Energy", "Genre", "Import Date"]

    readonly property int selectedFooterId: (selectedFooterItem.value === undefined) ? 0 : ( ( selectedFooterItem.value % 2 === 1 ) ? 1 : 4 ) // selectedFooterItem.value takes values from 1 to 4.

    property real preSortingKnobValue: 0.0

    //--------------------------------------------------------------------------------------------------------------------

    AppProperty { id: previewPlayerIsLoaded;	 path : "app.traktor.browser.preview_player.is_loaded" }
    AppProperty { id: previewTrackLenght;  path : "app.traktor.browser.preview_content.track_length" }
    AppProperty { id: previewTrackElapsed; path : "app.traktor.browser.preview_player.elapsed_time" }

    AppProperty { id: deckAKeyDisplay; path: "app.traktor.decks.1.track.key.resulting.precise" }
    AppProperty { id: deckBKeyDisplay; path: "app.traktor.decks.2.track.key.resulting.precise" }
    AppProperty { id: deckCKeyDisplay; path: "app.traktor.decks.3.track.key.resulting.precise" }
    AppProperty { id: deckDKeyDisplay; path: "app.traktor.decks.4.track.key.resulting.precise" }

    readonly property variant deckLabels: ["C", "A", "B", "D"]
    property string currentDate: new Date().toLocaleTimeString(Qt.locale(), 'hh:mm:ss')
    readonly property variant displayKey: [deckCKeyDisplay, deckAKeyDisplay, deckBKeyDisplay, deckDKeyDisplay]

    onSortingKnobValueChanged: {
        if (!footer.isContentList)
            return;

        overlayState.value = Overlay.sorting;
        sortingOverlayTimer.restart();

        var val = utils.clamp(footer.sortingKnobValue - footer.preSortingKnobValue, -1, 1);
        val	 = parseInt(val);
        if (val != 0) {
            browser.sortingId   = getSortingIdWithDelta( val );
            footer.preSortingKnobValue = footer.sortingKnobValue;
        }
    }


    Timer {
        id: sortingOverlayTimer
        interval: 800  // duration of the scrollbar opacity
        repeat:   false

        onTriggered: overlayState.value = Overlay.none;
    }

    Timer {
        interval: 1000
        repeat: true
        running: true

        onTriggered: {
            currentDate =  new Date().toLocaleTimeString(Qt.locale(), 'hh:mm:ss')
        }
    }


    Row {
        id: row
        anchors.fill: parent

        //Browser Sorting
        Item {
            width: parent.width/4
            height: footer.height

            Text {
                font.pixelSize: fonts.scale(12)
                anchors.left: parent.left
                anchors.leftMargin: 3
                font.capitalization: Font.AllUppercase
                color: selectedFooterId == 1 ? "white" : colors.colorFontBrowserHeader
                text: getSortingNameForSortId(browser.sortingId)
                visible: browser.isContentList
            }
            Widgets.Triangle {
                id : sortDirArrow
                width:  8
                height: 4
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.topMargin:  6
                anchors.rightMargin: 6
                antialiasing: false
                visible: (browser.isContentList && browser.sortingId > 0)
                color: colors.colorGrey80
                rotation: ((browser.sortingDirection == 1) ? 0 : 180)
            }
            Rectangle {
                id: divider
                height: footer.height
                width: 1
                color: colors.colorGrey40 // footer divider color
                anchors.right: parent.right
                visible: browser.isContentList
            }
        }

        //Browser Footer Info
        Repeater {
            model: browserFooterInfo.value == 3 ? 4 : 1

            Item {
                width:  browserFooterInfo.value == 3 ? parent.width/8 : parent.width/2
                height: footer.height
                Text {
                    visible: browser.isContentList && browserFooterInfo.value == 1
                    font.pixelSize: fonts.scale(12)
                    anchors.left: parent.left
                    color: colors.colorFontBrowserHeader
                    width: parent.width
                    text: bottomCountString
                    horizontalAlignment: Text.AlignHCenter
                }
                Text {
                    id: timeField
                    visible: browser.isContentList && browserFooterInfo.value == 2
                    font.pixelSize: fonts.scale(12)
                    anchors.left: parent.left
                    color: colors.colorFontBrowserHeader
                    width: parent.width
                    text: currentDate
                    horizontalAlignment: Text.AlignHCenter
                }
                Text {
                    id: deckletter
                    visible: browserFooterInfo.value == 3
                    font.pixelSize: fonts.scale(12)
                    anchors.left:   parent.left
                    anchors.leftMargin: displayCamelotKey.value ? 15 : 8
                    color: (index == 1 || index == 2) ? colors.brightBlue : colors.colorWhite //colors.colorFontBrowserHeader
                    width: parent.width
                    text: deckLabels[index] + ": "
                }
                Text {
                    visible: browserFooterInfo.value == 3
                    font.pixelSize: fonts.scale(12)
                    anchors.left:   parent.left
                    anchors.leftMargin: displayCamelotKey.value ? 33 : 25
                    color: Key.getKeyId(displayKey[index].value) > 0 ? colors.musicalKeyColors[Key.getKeyId(displayKey[index].value)] : ((index == 1 || index == 2) ? colors.brightBlue : colors.colorWhite)
                    width: parent.width
                    text: ((displayKey[index].value == "none") || (displayKey[index].value == "None")) ? "n.a." : (displayCamelotKey.value ? Key.toCamelot(displayKey[index].value): displayKey[index].value)
                }
                Rectangle {
                    id: divider
                    height: footer.height
                    width: 1
                    color: colors.colorGrey40 // footer divider color
                    anchors.right: parent.right
                }
            }
        }

        //Preview Player footer
        Item {
            width: parent.width/4
            height: footer.height

            Text {
                font.pixelSize: fonts.scale(12)
                anchors.left: parent.left
                anchors.leftMargin: 5
                font.capitalization: Font.AllUppercase
                color: selectedFooterId == 4 ? "white" : colors.colorFontBrowserHeader
                text: "Preview"
            }

            Image {
                id: previewIcon
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.topMargin:	 2
                anchors.rightMargin:  45
                visible: false
                antialiasing: false
                source: "../../../Shared/Images/PreviewIcon_Small.png"
                fillMode: Image.Pad
                clip: true
                cache: false
                sourceSize.width: width
                sourceSize.height: height
            }
            ColorOverlay {
                id: previewIconColorOverlay
                color: colors.browser.prelisten
                anchors.fill: previewIcon
                source: previewIcon
                visible: previewPlayerIsLoaded.value
            }

            Text {
                width: 40
                clip: true
                horizontalAlignment: Text.AlignRight
                visible: previewPlayerIsLoaded.value
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.topMargin:	 2
                anchors.rightMargin:  7
                font.pixelSize: fonts.scale(12)
                font.capitalization: Font.AllUppercase
                font.family: "Pragmatica"
                color: colors.browser.prelisten
                text: utils.getTime(previewTrackElapsed.value)
            }
        }
    }

//--------------------------------------------------------------------------------------------------------------------
// black border & shadow
//--------------------------------------------------------------------------------------------------------------------

    /*
    Rectangle {
        id: browserHeaderBottomGradient
        height: 3
        anchors.left:   parent.left
        anchors.right:  parent.right
        anchors.bottom: browserHeaderBlackBottomLine.top
        gradient: Gradient {
            GradientStop { position: 0.0; color: colors.colorBlack0 }
            GradientStop { position: 1.0; color: colors.colorBlack38 }
        }
    }

    Rectangle {
        id: browserHeaderBlackBottomLine
        height:		 2
        color:		  colors.colorBlack
        anchors.left:   parent.left
        anchors.right:  parent.right
        anchors.bottom: browserFooterBg.top
    }
    */

    function getSortingIdWithDelta(delta) {
        var curPos = getPosForSortId( browser.sortingId );
        var pos	= curPos + delta;
        var count  = sortIds.length;

        pos = (pos < 0)	  ? count-1 : pos;
        pos = (pos >= count) ? 0	   : pos;

        return sortIds[pos];
    }


    function getPosForSortId(id) {
        if (id == -1) return 0; // -1 is a special case which should be interpreted as "0"
        for (var i=0; i<sortIds.length; i++) {
            if (sortIds[i] == id) return i;
        }
        return -1;
    }

    function getSortingNameForSortId(id) {
        var pos = getPosForSortId(id);
        if (pos >= 0 && pos < sortNames.length)	return sortNames[pos]
        return "SORTED"
    }
}
