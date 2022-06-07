import CSI 1.0
import QtQuick 2.12
import Traktor.Gui 1.0 as Traktor

import '../../../Shared/Overlays'
import '../../../Shared/Widgets' as Widgets

//----------------------------------------------------------------------------------------------------------------------
//											BROWSER VIEW
//
//  The Browser View is connected to traktor's QBrowser from which it receives its data model.
//  The navigation through the data is done by calling functions invoked from QBrowser.
//
// QBrowser functions (to call them use qBrowser.functionName):
// dataSetChanged, isActiveChanged, isContentListChanged, sortingChanged, sortingDirectionChanged, currentPathChanged, iconIdChanged, currentIndexChanged
// changeCurrentIndex, index, relocateCurrentIndex, enterNode, deckId, nodeIndex, exitNode, dataSet, isActive, isContentList, sorting, sortingDirection, currentIndex, currentPath, iconId
//----------------------------------------------------------------------------------------------------------------------

FullscreenOverlay {
    id: browser
    property bool isActive: false
    property int deckId: screen.focusedDeckId-1 //because in Traktor --> clock: -1, deckA: 0, deckB: 1, deckC: 2, deckD: 3
    property bool enterNode: false
    property bool exitNode: false
    property int increment: 0
    property color focusColor: deckId < 2 ? colors.brightBlue: colors.colorGrey232
    property int speed: 150
    property int pageSize: browserRows.value
    property real sortingKnobValue:  0

    //This is used by the footer to change/display the sorting!
    property alias sortingId: qBrowser.sorting //create a settings property so that it is always correctly displayed?
    property alias sortingDirection: qBrowser.sortingDirection
    property alias isContentList: qBrowser.isContentList

    property double itemHeight: Math.floor((parent.height-browserHeader.height-browserFooter.height-2)/browserRows.value) //-2 due to anchors //contentList.height seems to slow the process of loading the browser
    //readonly property int itemHeight: parseInt(240/browserRows.value)

    anchors.fill: parent

    readonly property int maxItemsOnScreen: browserRows.value+1
    readonly property int fastScrollCenter: Math.round(browserRows.value/2) //AJF: fer un 272%browserRows.value per a que no faci l'efecte de moure lleugerament les files al navegar

    //--------------------------------------------------------------------------------------------------------------------
    // BROWSER VIEW
    //-------------------------------------------------------------------------------------------------------------------

    Traktor.Browser {
        id: qBrowser
        isActive: browser.visible
    }

    Header {
        id: browserHeader
        deckId: browser.deckId
        nodeIconId: qBrowser.iconId
        path: qBrowser.currentPath

        Behavior on height { NumberAnimation { duration: speed; } }
    }

    ListView {
        id: contentList
        anchors.top: browserHeader.bottom
        anchors.topMargin: 1
        anchors.bottom: browserFooter.top
        anchors.bottomMargin: 1
        anchors.left: parent.left
        anchors.right: parent.right
        clip: true

        preferredHighlightBegin: ((browser.fastScrollCenter - 1) * (browser.itemHeight)) + 3
        preferredHighlightEnd: browser.fastScrollCenter * browser.itemHeight +3
        highlightRangeMode: ListView.ApplyRange
        highlightMoveDuration: 0

        focus: true
        verticalLayoutDirection: ListView.TopToBottom
        spacing: 1
        currentIndex: qBrowser.currentIndex
        delegate:
            ListDelegate {
            id: browserDelegate
            deckId: browser.deckId
            parentIconId: qBrowser.iconId
            parentPath: qBrowser.currentPath
        }
        model: qBrowser.dataSet
        cacheBuffer: browserRows.value //browser.itemHeight*(browserRows.value/2)
    }

    Grid { //zebra filling up the rest of the list if smaller than maxItemsOnScreen
        anchors.top: contentList.top
        anchors.topMargin: contentList.topMargin +  contentList.contentHeight + contentList.spacing
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.leftMargin: 3
        columns: 1
        spacing: 1

        Repeater {
            model: (contentList.count < browser.maxItemsOnScreen) ? (browser.maxItemsOnScreen - contentList.count) : 0
            Rectangle {
                color: brightMode.value == true ? (((contentList.count + index)%2 == 0) ? colors.colorGrey128 : colors.colorGrey96) : (((contentList.count + index)%2 == 0) ? colors.colorGrey08 : "transparent" )
                width: browser.width;
                height: browser.itemHeight
            }
        }
    }

    Footer {
        id: browserFooter
        sortingKnobValue: browser.sortingKnobValue
        bottomCountString: contentList.count + " songs" //(qBrowser.currentIndex + 1) + "/" + contentList.count

        Behavior on height { NumberAnimation { duration: speed; } }
    }

    Widgets.ScrollBar {
        id: scrollbar
        flickable: contentList
        opacity: 0
        handleColor: parent.focusColor
        Behavior on opacity { NumberAnimation { duration: (opacity == 0) ? 0 : speed; } }
    }

//--------------------------------------------------------------------------------------------------------------------
// BROWSER CONTROLS
//-------------------------------------------------------------------------------------------------------------------

    onIncrementChanged: {
        if (browser.increment != 0) {
            var newValue = utils.clamp(qBrowser.currentIndex + browser.increment, 0, contentList.count - 1);
            // center selection if user is _fast scrolling_ but we're at the _beginning_ or _end_ of the list
            if (browser.increment >= browserRows.value) {
                var centerTop = fastScrollCenter
                if(qBrowser.currentIndex < centerTop) {
                    newValue = centerTop
                }
            }
            if(browser.increment <= (-browserRows.value)) {
                var centerBottom = contentList.count - 1 - fastScrollCenter
                if(qBrowser.currentIndex > centerBottom) {
                    newValue = centerBottom
                }
            }
            qBrowser.changeCurrentIndex(newValue)
            browser.increment = 0
            doScrolling()
        }
    }

    onExitNodeChanged: {
        if (browser.exitNode) {
            qBrowser.exitNode()
        }
        //showHeaderFooterAnimated(false); // see comment at function declaration
        browser.exitNode = false;
    }

    onEnterNodeChanged: {
        if (browser.enterNode) {
            var movedDown = qBrowser.enterNode(deckId, contentList.currentIndex);
            if (movedDown) {
                qBrowser.relocateCurrentIndex()
            }
        }
        //showHeaderFooterAnimated(false); // see comment at function declaration
        browser.enterNode = false;
    }

    function doScrolling() {
        scrollbar.opacity = 1;
        //hideHeaderFooterAnimated(true); // see comment at function declaration
        opacityTimer.restart();
    }

    Timer {
        id: opacityTimer
        interval: 800  // duration of the scrollbar opacity
        repeat: false

        onTriggered: {
            scrollbar.opacity = 0;
            //showHeaderFooterAnimated(true); // see comment at function declaration
        }
    }

//--------------------------------------------------------------------------------------------------------------------
// NOTE: Supress show/hide for now, but KEEP this code.
//	   The "come back" is planned for a later release!
//--------------------------------------------------------------------------------------------------------------------

    /*
    function showHeaderFooterAnimated(animated) {
        var defaultSpeed = browser.speed;
        browser.speed = (animated) ? browser.speed : 0
        browserHeader.state = "show"
        browserFooter.state = "show"
        browser.speed = defaultSpeed;
    }

    function hideHeaderFooterAnimated(animated) {
        var defaultSpeed = browser.speed;
        browser.speed = (animated) ? browser.speed : 0
        browserHeader.state = "hide"
        browserFooter.state = "hide"
        browser.speed = defaultSpeed;
    }
    */
}