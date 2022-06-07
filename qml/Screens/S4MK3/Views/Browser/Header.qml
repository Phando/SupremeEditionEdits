import CSI 1.0
import QtQuick 2.12
import QtGraphicalEffects 1.12
import Traktor.Gui 1.0 as Traktor

import '../../../Shared/Widgets' as Widgets

Rectangle {
    id: header
    property int deckId: 1
    property int nodeIconId: 0
    property string path // the complete path in one string given by QBrowser with separator " | "

    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    height: 15
    color: colors.colorBrowserHeader //colors.colorGrey24
    clip: true

    //readonly property color itemColor: colors.colorWhite19
    property int highlightIndex: 0

    property var pathList: path.split(" | ").slice(1)
    property string rootName: pathList[0] ? pathList[0] : ""
    property string nodeName: pathList[pathList.length-1] ? pathList[pathList.length-1] : ""
    property bool topTree: path == "Browser"

    property int displayedDirectories: 0
    property bool showPoints: displayedDirectories != pathList.length

    readonly property int fontSize: fonts.smallFontSize

    AppProperty { id: root; path: "app.traktor.settings.paths.root" }

//--------------------------------------------------------------------------------------------------------------------
// NOTE: text item used within the 'calculatePathWidth' function to determine how many of the pathList items can be fit in the header!
// IMPORTANT EXTRA NOTE: all texts in the header should have the same Capitalization and font size settings as the "dummy" as the dummy is used to calculate the number of text blocks fitting into the header.
//--------------------------------------------------------------------------------------------------------------------

    //Caculates the number of entries to be displayed in the header
    onPathListChanged: { displayedDirectories = pathList.length }
    property int flowWidth: textFlow.width
    onFlowWidthChanged: {
        if (textFlow.width > (parent.width - icon.width - dots.width - deckLetter.width - 10)) displayedDirectories--
    }

    Image {
        id: icon
        anchors.top: parent.top
        anchors.left: parent.left
        width: 26
        height: 16
        visible: false
        clip: false
        source: getIcon(rootName)
        fillMode: Image.PreserveAspectCrop
        cache: false
    }
    ColorOverlay {
        id: iconColorOverlay
        anchors.fill: icon
        source: icon
        color: "white"
        visible: !topTree
    }

    Text {
        id: version
        anchors.left: parent.left
        anchors.leftMargin: 3
        text: (root.value).split((root.value).indexOf(":\\") == 1 ? "//" : ":").splice(-2,1).toString().replace(/Traktor/i, "Traktor Pro")
        font.capitalization: Font.AllUppercase
        font.pixelSize: fonts.smallFontSize
        color: colors.colorFontBrowserHeader
        visible: topTree
    }


    Widgets.TextSeparatorArrow {
        id: iconArrow
        anchors.top: parent.top
        anchors.topMargin: 4
        anchors.left: icon.right
        color: colors.colorGrey80
        visible: !topTree
    }

    Item {
        id: textContainter

        readonly property int spaceToDeckLetter: 20
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: iconArrow.right
        anchors.right: deckLetter.left
        anchors.leftMargin: 6
        anchors.rightMargin: spaceToDeckLetter
        clip: true

        //Dots appear at the left side of the browser in case the full path does not fit into the header.
        Item {
            id: dots
            anchors.left: parent.left
            anchors.top: parent.top
            width: showPoints ? 32 : 0
            visible: showPoints

            Text {
                anchors.left: parent.left
                anchors.top: parent.top
                text: "..."
                font.capitalization: Font.AllUppercase
                font.pixelSize:	fonts.smallFontSize
                color: colors.colorFontBrowserHeader
            }
        }

        //Path flow
        Row {
            id: textFlow
            layoutDirection: Qt.RightToLeft

            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: dots.right

            Repeater {
                model: Math.max(displayedDirectories - 1, 0) //the -1 is there so that the rootName isn't displayed, because the root icon will be shown instead

                Item {
                    id: textContainer

                    width: headerPath.width + separatorArrow.width + 12 //6 for each side margin of the separatorArrow
                    height: 20

                    Widgets.TextSeparatorArrow {
                        id: separatorArrow
                        anchors.top: parent.top
                        anchors.topMargin: 4
                        anchors.right: headerPath.left
                        anchors.rightMargin: 6
                        color: colors.colorGrey80
                        visible: true
                    }

                    Text {
                        id: headerPath
                        visible: true
                        text: pathList[(pathList.length-1) - index]
                        color: (index == 0) ? colors.colorWhite : colors.colorGrey88
                        font.capitalization: Font.AllUppercase
                        font.pixelSize:	fonts.smallFontSize
                        elide: Text.ElideMiddle
                    }
                }
            }
        }
    }

    //Deck Letter
    readonly property var letters: ["A", "B", "C", "D"]
    Text {
        id: deckLetter
        anchors.right: parent.right
        anchors.top: parent.top
        height: parent.height
        width: parent.height

        text: letters[deckId]
        font.capitalization: Font.AllUppercase
        font.pixelSize: fonts.smallFontSize
        color: (deckId < 2) ? colors.brightBlue : colors.colorWhite
        visible: true
    }

    function getIcon(rootName) {
        switch (rootName) {
        case "Track Collection":
            return "../../../Shared/Images/Browser/Icons/TrackCollection.png"
        case "Playlist":
            return "../../../Shared/Images/Browser/Icons/Playlist.png"
        case "Explorer":
            return "../../../Shared/Images/Browser/Icons/Explorer.png"
        case "Recordinds":
            return "../../../Shared/Images/Browser/Icons/Recordings.png"
        case "iTunes":
            return "../../../Shared/Images/Browser/Icons/iTunes.png"
        case "Beatport LINK":
            return "../../../Shared/Images/Browser/Icons/BeatportLINK.png"
        case "Beatsource LINK":
            return "../../../Shared/Images/Browser/Icons/BeatsourceLINK.png"
        case "History":
            return "../../../Shared/Images/Browser/Icons/History.png"
        case "Favorites":
            return "../../../Shared/Images/Browser/Icons/Favorites.png"
        default:
            return ""
        }
    }
}
