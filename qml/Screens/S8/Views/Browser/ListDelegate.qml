import CSI 1.0
import QtQuick 2.12
import QtGraphicalEffects 1.12

import '../../../Shared/Widgets' as Widgets
import '../../../../Helpers/KeyHelpers.js' as Key

//------------------------------------------------------------------------------------------------------------------
//  LIST ITEM - DEFINES THE INFORMATION CONTAINED IN ONE LIST ITEM
//------------------------------------------------------------------------------------------------------------------

// the model dataSet contains the following roles:
// dataType, nodeIconId, nodeName, nrOfSubnodes, coverUrl, artistName, trackName, bpm, key, keyIndex, rating, loadedInDeck, prevPlayed, prelisten

// dataType, nodeIconId, nodeName, hasSubnodes, nrOfSubnodes, coverUrl, artistName, trackName, keyIndex, prelisten, prevPlayed, loadedInDeck, prepared
// Browser\ d:\bamboo-build\tp-mb-buildpc\sources\base\gui\remotescreen\qbrowser.cpp		!(iAppBase() / controlManager)  !(iAppBase() / mainWindow / browserForm)
// d:\bamboo-build\tp-mb-buildpc\sources\base\gui\remotescreen\qdatasetmodel.cpp   dataType, nodeIconId, nodeName, hasSubnodes, nrOfSubnodes, coverUrl, artistName, trackName, keyIndex, prelisten, prevPlayed, loadedInDeck, prepared

/* IconIds
(0: Browser)
77: Track Collection (parentIconId: 2)
    4: Artists (Generic folder)
    4: Releases (Generic folder)
    4: Labels (Generic folder)
    4: Genres (Generic folder)
    6: All Tracks
    16: All Remix Sets --> incorrect index set to 4 right now?
    18: All Stems
    6: All Samples --> incorrect index?

78: Explorer
    22: Demo Content (System folder?)
    22: Music folders (System folder?)
    26: Home
    28: Archive
        24: History playlist
    30: HDD
        22: Any system folder
    36: Audio Recordings

79: Playlists
    4: Folder of playlists
    4: Playlist (Generic folder)
    14: Smart playlist

80: iTunes / Music (parentIconId: 38)
    4: Folder of playlists
    8: iTunes/Music playlist (the library playlist included)
    40: iTunes/Music smartlist

83: Beatport
    0: Search node
    4: Folder of playlists
    8: Playlist (the library playlist included)

84: Beatsource
    0: Search node
    4: Folder of playlists
    8: Playlist (the library playlist included)

81: History (parentIconId: 44)
82: Favorites
*/

Item {
  id: contactDelegate
  property int deckId: 1
  property int parentIconId: 0
  property string parentPath: ""

  height: browser.itemHeight
  anchors.left: parent.left
  anchors.right: parent.right

  property color deckColor: browser.focusColor
  property color textColor: brightMode.value ? "black" : "white" //(ListView.isCurrentItem ? "black" : "black") : (ListView.isCurrentItem ? deckColor : colors.colorFontsListBrowser)
  property color darkTextColor: brightMode.value ? colors.colorGrey32 : colors.colorGrey192 //((deckId < 2 && ListView.isCurrentItem) ? colors.darkBlue : colors.colorGrey72)
  property bool isCurrentItem: ListView.isCurrentItem
  property string prepIconColorPostfix: (deckId < 2 && ListView.isCurrentItem) ? "Blue" : ((deckId > 1 && ListView.isCurrentItem) ? "White" : "Grey")
  readonly property bool isLoaded: (model.dataType == BrowserDataType.Track) ? model.loadedInDeck.length > 0 : false

  AppProperty { id: keyAdjust; path: "app.traktor.decks." + (deckId+1) + ".track.key.adjust" }
  AppProperty { id: keyLock; path: "app.traktor.decks." + (deckId+1) + ".track.key.lock_enabled" }
  AppProperty { id: keyDisplay; path: "app.traktor.decks." + (deckId+1) + ".track.key.resulting.precise" }

  property real key: keyAdjust.value * 12
  property int offset: (key.toFixed(2) - key.toFixed(0)) * 100.0

  // visible: !ListView.isCurrentItem

  Rectangle {
    id: row
    color: brightMode.value ? (isCurrentItem ? colors.cyan : (index%2 == 0) ? colors.colorGrey128 : colors.colorGrey96) : (isCurrentItem ? colors.darkBlueBrowser : (index%2 == 0) ? colors.colorGrey08 : "transparent" )
    anchors.fill: parent

    //Folder Icon
    Image {
        id: folderIcon
        source: getIcon(model.nodeIconId, model.nodeName, model.hasSubnodes, parentPath)
        //source: "image://icons/" + model.nodeIconId
        width: 33
        height: 33
        fillMode: Image.PreserveAspectFit
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 3
        clip: true
        cache: false
        visible: false
    }
    ColorOverlay {
        id: folderIconColorOverlay
        color: brightMode.value ? "black" : (isCurrentItem ? "white" : colors.colorGrey192 ) // unselected vs. selected
        anchors.fill: folderIcon
        source: folderIcon
        visible: model.dataType == BrowserDataType.Folder
    }

    //Folder Name
    Text {
        id: firstFieldFolder
        anchors.left: parent.left
        anchors.leftMargin: 35
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        color: brightMode.value ? "black" : (isCurrentItem ? "white" : colors.colorGrey192 ) // unselected vs. selected
        clip: true
        text: model.nodeName ? model.nodeName : ""
        //text: model.nodeIconId + "   " + model.hasSubnodes + "   " + model.nodeName
        //text: model.nodeName + "   " + parentIconId + "   " + parentPath
        font.pixelSize: fonts.middleFontSize
        elide: Text.ElideRight
        visible: model.dataType == BrowserDataType.Folder
    }

    //Album Container
    Rectangle {
        id: albumField
        anchors.top: parent.top
        anchors.left: parent.left
        width: parent.height
        height: parent.height
        color: "transparent" //(model.coverUrl != "") ? "transparent" : ((deckId < 2) ? colors.brightBlue50Full : colors.colorGrey128 )
        /*
        border.width: 1
        border.color: colors.colorGrey16 // semi-transparent border on artwork
        */
        visible: model.dataType == BrowserDataType.Track && browserAlbum.value

        //Album Cover
        Image {
            id: artwork
            anchors.fill: parent
            source: (model.dataType == BrowserDataType.Track && model.coverUrl) ? ("image://covers/" + model.coverUrl ) : ""
            fillMode: Image.PreserveAspectFit
            clip: true
            cache: false
            sourceSize.width: width
            sourceSize.height: height
            visible: model.coverUrl && model.coverUrl != "" ? true : false
        }

        //CD Style image for empty Album Covers
        Widgets.CD {
            id: empty
            anchors.fill: parent
            anchors.margins: parent.border.width
            cdColor: "white"
            centerColor: "black" //TO-DO: Change to darkerDeckColor
            visible: !artwork.visible
        }

        //Darkens unselected covers
        Rectangle {
            id: darkener
            anchors.fill: parent
            color: model.prelisten ? colors.browser.prelisten : (model.prevPlayed ? colors.colorBlack88 : "transparent")
          }

        //Preview Player Icon
        Image {
            anchors.centerIn: albumField
            width: 17
            height: 17
            source: "../../../Shared/Images/PreviewIcon_Big.png"
            fillMode: Image.Pad
            clip: true
            cache: false
            sourceSize.width: width
            sourceSize.height: height
            visible: (model.dataType == BrowserDataType.Track) ? model.prelisten : false
        }

        //Previously Played Icon
        Image {
            anchors.centerIn: albumField
            width: 17
            height: 17
            source: "../../../Shared/Images/Browser/PreviouslyPlayed_Icon.png"
            fillMode: Image.Pad
            clip: true
            cache: false
            sourceSize.width: width
            sourceSize.height: height
            visible: (model.dataType == BrowserDataType.Track) ? (model.prevPlayed && !model.prelisten) : false
            //visible: (model.dataType == BrowserDataType.Track) ? (model.prevPlayed && !model.prelisten && !(parent.isLoadedInDeck("A") || parent.isLoadedInDeck("B") || parent.isLoadedInDeck("C") || parent.isLoadedInDeck("D"))) : false
        }

        //Track Loaded in Deck Indicators

/*
        Rectangle {
          id: playing_darkener
          anchors.fill: parent
          color: {
              if ((model.loadedInDeck == "A" || model.loadedInDeck == "B" || model.loadedInDeck == "C" || model.loadedInDeck == "D")) {
                return colors.colorBlack88;
              }

              //no carregades enlloc, les cançons apareixen com a taronges (loadedInDeck > -1 és cert), i carregades en 2 o +, apareixen en transparent (loadedInDeck > -1 és falç)
              else if (model.loadedInDeck > -1) {
                return "transparent"
              }
              else {
                return colors.colorBlack88
              }
            }
        }

        Image {
          id: loadedDeckA
          anchors.fill: parent
          clip: true
          fillMode: Image.PreserveAspectFit
          source: "../../../Shared/Images//Deck_A.png"
          sourceSize.width: width
          sourceSize.height: height
          visible: model.dataType == BrowserDataType.Track && model.loadedInDeck == "A"
        }

        Image {
          id: loadedDeckAbis
          anchors.top: parent.top
          anchors.left: parent.left
          anchors.leftMargin: 2
          clip: true
          fillMode: Image.PreserveAspectFit
          source: "../../../Shared/Images//Deck_A.png"
          sourceSize.width: width/2
          sourceSize.height: height/2-1
          visible: model.dataType == BrowserDataType.Track && !(model.loadedInDeck == "A" || model.loadedInDeck == "B" || model.loadedInDeck == "C" || model.loadedInDeck == "D") && !(model.loadedInDeck > -1) && parent.isLoadedInDeck("A")
        }

        Image {
          id: loadedDeckB
          anchors.fill: parent
          fillMode: Image.PreserveAspectFit
          source: "../../../Shared/Images//Deck_B.png"
          anchors.centerIn: track.image
          sourceSize.width: width
          sourceSize.height: height
          visible: model.dataType == BrowserDataType.Track && model.loadedInDeck == "B"
        }

        Image {
          id: loadedDeckBbis
          anchors.top: parent.top
          anchors.right: parent.right
          anchors.rightMargin: 2
          clip: true
          fillMode: Image.PreserveAspectFit
          source: "../../../Shared/Images//Deck_B.png"
          sourceSize.width: width/2
          sourceSize.height: height/2-1
          visible: model.dataType == BrowserDataType.Track && !(model.loadedInDeck == "A" || model.loadedInDeck == "B" || model.loadedInDeck == "C" || model.loadedInDeck == "D") && !(model.loadedInDeck > -1) && parent.isLoadedInDeck("B")
        }

        Image {
          id: loadedDeckC
          anchors.fill: parent
          fillMode: Image.PreserveAspectFit
          source: "../../../Shared/Images//Deck_C.png"
          anchors.centerIn: track.image
          sourceSize.width: width
          sourceSize.height: height
          visible: model.dataType == BrowserDataType.Track && model.loadedInDeck == "C"
        }

        Image {
          id: loadedDeckCbis
          anchors.bottom: parent.bottom
          anchors.left: parent.left
          anchors.leftMargin: 2
          clip: true
          fillMode: Image.PreserveAspectFit
          source: "../../../Shared/Images//Deck_C.png"
          sourceSize.width: width/2
          sourceSize.height: height/2-1
          visible: model.dataType == BrowserDataType.Track && !(model.loadedInDeck == "A" || model.loadedInDeck == "B" || model.loadedInDeck == "C" || model.loadedInDeck == "D") && !(model.loadedInDeck > -1) && parent.isLoadedInDeck("C")
        }

        Image {
          id: loadedDeckD
          anchors.fill: parent
          fillMode: Image.PreserveAspectFit
          source: "../../../Shared/Images//Deck_D.png"
          anchors.centerIn: track.image
          sourceSize.width: width
          sourceSize.height: height
          visible: model.dataType == BrowserDataType.Track && model.loadedInDeck == "D"
        }

        Image {
          id: loadedDeckDbis
          anchors.bottom: parent.bottom
          anchors.right: parent.right
          anchors.rightMargin: 2
          clip: true
          fillMode: Image.PreserveAspectFit
          source: "../../../Shared/Images//Deck_D.png"
          sourceSize.width: width/2
          sourceSize.height: height/2-1
          visible: model.dataType == BrowserDataType.Track && !(model.loadedInDeck == "A" || model.loadedInDeck == "B" || model.loadedInDeck == "C" || model.loadedInDeck == "D") && !(model.loadedInDeck > -1) && parent.isLoadedInDeck("D")
        }
*/

        Image {
          id: loadedDeckA
          source: "../../../Shared/Images/Browser/LoadedDeckA.png"
          anchors.top: parent.top
          anchors.left: parent.left
          sourceSize.width: 11
          sourceSize.height: 11
          visible: (model.dataType == BrowserDataType.Track && parent.isLoadedInDeck("A"))
        }

        Image {
          id: loadedDeckB
          source: "../../../Shared/Images/Browser/LoadedDeckB.png"
          anchors.top: parent.top
          anchors.right: parent.right
          sourceSize.width: 11
          sourceSize.height: 11
          visible: (model.dataType == BrowserDataType.Track && parent.isLoadedInDeck("B"))
        }

        Image {
          id: loadedDeckC
          source: "../../../Shared/Images/Browser/LoadedDeckC.png"
          anchors.bottom: parent.bottom
          anchors.left: parent.left
          sourceSize.width: 11
          sourceSize.height: 11
          visible: (model.dataType == BrowserDataType.Track && parent.isLoadedInDeck("C"))
        }

        Image {
          id: loadedDeckD
          source: "../../../Shared/Images/Browser/LoadedDeckD.png"
          anchors.bottom: parent.bottom
          anchors.right: parent.right
          sourceSize.width: 11
          sourceSize.height: 11
          visible: (model.dataType == BrowserDataType.Track && parent.isLoadedInDeck("D"))
        }

        function isLoadedInDeck(deckLetter) {
          return model.loadedInDeck.indexOf(deckLetter) != -1;
        }
    }

    //Title
    Item {
        id: titleField
        anchors.top: parent.top
        anchors.left: browserAlbum.value ? albumField.right : parent.left
        anchors.leftMargin: 6
        anchors.right: browserBPM.value ? bpmField.left : (browserKey.value ? keyField.left : (browserRating.value ? ratingField.left : parent.right))
        height: browserRows.value > 9 ? browser.itemHeight : (browser.itemHeight/2 + 3)
        visible: model.dataType == BrowserDataType.Track

        Widgets.ScrollingTextBrowser {
            id: scrollingTrackName
            anchors.left: (model.dataType == BrowserDataType.Track && model.prepared) ? prepListIcon.right : parent.left
            anchors.leftMargin: (model.dataType == BrowserDataType.Track && model.prepared) ? 3 : 0
            anchors.right: parent.right
            anchors.verticalCenter: titleField.verticalCenter
            height: parent.height
            width: parent.width
            textString: (model.dataType == BrowserDataType.Track) ? model.trackName  : ((model.dataType == BrowserDataType.Folder) ? model.nodeName : "")
            textColor: contactDelegate.textColor
            textFontSize: browserRows.value > 7 ? 14 : 16
            doScroll: isCurrentItem
            visible: (model.dataType == BrowserDataType.Track)
            opacity: model.prevPlayed && showTracksPlayedDarker.value ? 0.25 : 1
        }

        Image {
            id: prepListIcon
            visible: (model.dataType == BrowserDataType.Track) ? model.prepared : false
            source: "../../../Shared/Images/Browser/PrepListIcon" + prepIconColorPostfix + ".png"
            width: sourceSize.width
            height: sourceSize.height
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.topMargin: 4
            opacity: model.prevPlayed && showTracksPlayedDarker.value ? 0.25 : 1
        }
    }

    //Artist
    Text {
        id: artistField
        anchors.top: parent.top
        anchors.topMargin: browser.itemHeight/2 + 1
        anchors.left: browserAlbum.value ? albumField.right : parent.left
        anchors.leftMargin: 6
        anchors.right: browserBPM.value ? bpmField.left : (browserKey.value ? keyField.left : (browserRating.value ? ratingField.left : parent.right))
        color: isCurrentItem ? darkTextColor : colors.colorGrey72
        clip: true

        text: (model.dataType == BrowserDataType.Track) ? model.artistName: ""
        font.pixelSize: browserRows.value > 7 ? 10 : fonts.smallFontSize
        elide: Text.ElideRight
        visible: browserRows.value <= 9 && browserArtist.value
        opacity: model.prevPlayed && showTracksPlayedDarker.value ? 0.25 : 1
    }

    //BPM
    //property double bpmOffset: (((parseFloat(model.bpm).toFixed(2)-clockBpm.value)/clockBpm.value)-1)*100
    Text {
        id: bpmField
        anchors.right: browserKey.value ? keyField.left : (browserRating.value ? ratingField.left : parent.right)
        anchors.verticalCenter: parent.verticalCenter
        width: 44
        visible: model.dataType == BrowserDataType.Track && browserBPM.value
        clip: true

        text: model.dataType == BrowserDataType.Track ? model.bpm.toFixed(0) : ""
        color: bpmColor()
        opacity: model.prevPlayed && showTracksPlayedDarker.value ? 0.25 : 1
        font.pixelSize: fonts.largeFontSize
        horizontalAlignment: Text.AlignRight
    }

    //Key
    Text {
        id: keyField
        anchors.right: browserRating.value ? ratingField.left : parent.right
        anchors.rightMargin: browserRating.value ? 20 : 0
        anchors.verticalCenter: parent.verticalCenter
        width: 44
        visible: browserKey.value
        clip: true

        text: model.dataType == BrowserDataType.Track ? (((model.key == "none") || (model.key == "None")) ? "n.a." : (displayCamelotKey.value ? Key.toCamelot(model.key): model.key)) : ""
        color: model.dataType == BrowserDataType.Track ? (((model.key == "none") || (model.key == "None")) ? colors.red : keyColor(model.key, masterResultingKey.value)) : textColor
        opacity: model.prevPlayed && showTracksPlayedDarker.value ? 0.25 : 1
        font.pixelSize: fonts.largeFontSize
        horizontalAlignment: Text.AlignRight
    }

    //Track Rating
    Widgets.TrackRating {
        id: ratingField
        anchors.right: parent.right
        anchors.rightMargin: 2
        anchors.verticalCenter: parent.verticalCenter
        height: 15
        width: 20
        visible: model.dataType == BrowserDataType.Track && browserRating.value

        rating: model.dataType == BrowserDataType.Track ? ((model.rating == "") ? 0 : model.rating ) : 0
        //rating: ((model.dataType == BrowserDataType.Track) && (model.rating != "")) ? ratingMap[model.rating] : 0
        bigLineColor: colors.orangeBrowser //brightMode.value ? "black" : (contactDelegate.isCurrentItem ? ((deckId < 2) ? colors.brightBlue : colors.colorWhite ) : colors.colorGrey64)
        smallLineColor: brightMode.value ? colors.colorGrey32 : colors.colorGrey32
        opacity: model.prevPlayed && showTracksPlayedDarker.value ? 0.25 : 1
    }
  }

  function getIcon(iconId, nodeName, hasSubnodes, parentPath) {
      switch (iconId) {
          case 77: //Track Collection
              return "../../../Shared/Images/Browser/Icons/TrackCollection.png"
          /*
          case 6: //All tracks / Samples
              return "../../../Shared/Images/Browser/Icons/Tracks.png"
          */
          case 16: //All Remix Sets
              return "../../../Shared/Images/Browser/Icons/RemixSets.png"
          case 18: //All stems
              return "../../../Shared/Images/Browser/Icons/Stems.png"

          case 78: //Explorer
              return "../../../Shared/Images/Browser/Icons/Explorer.png"
          case 22: //Music folders
              return nodeName == "Music Folders" ? "../../../Shared/Images/Browser/Icons/Tracks.png" : "../../../Shared/Images/Browser/Icons/Folder.png"
          case 26: //Home
              return "../../../Shared/Images/Browser/Icons/Home.png"
          case 28: //Archive
              return "../../../Shared/Images/Browser/Icons/History.png"
          case 24: //Archive playlist
              return "../../../Shared/Images/Browser/Icons/Playlist.png"
          case 30: //External drives
              return "../../../Shared/Images/Browser/Icons/HDD.png"

          case 36: //Audio recordinds
              return "../../../Shared/Images/Browser/Icons/Recordings.png"

          case 79: //Playlists folder
              return "../../../Shared/Images/Browser/Icons/Playlist.png"
          case 14: //Smartlist
              return "../../../Shared/Images/Browser/Icons/Smartlist.png"
          case 10: //Preparation
              return "../../../Shared/Images/Browser/Icons/Preparation.png"

          case 80: //iTunes/Music
              return "../../../Shared/Images/Browser/Icons/iTunes.png"
          case 8: //iTunes Playlist
              return "../../../Shared/Images/Browser/Icons/Playlist.png"
          case 40: //iTunes Smartlist
              return "../../../Shared/Images/Browser/Icons/Smartlist.png"


          case 83: //Beatport
              return "../../../Shared/Images/Browser/Icons/BeatportLINK.png"
          case 84: //Beatsource
              return "../../../Shared/Images/Browser/Icons/BeatsourceLINK.png"

          case 81:
              return "../../../Shared/Images/Browser/Icons/History.png"
          case 82:
              return "../../../Shared/Images/Browser/Icons/Favorites.png"

          case 4: //Generic folder
          case 6: //Generic folder
              switch (parentPath) {
                  case "Browser | Track Collection":
                      var node = nodeName.replace(/ *\([^)]*\) */g, "")
                      switch (node) {
                          case "All Tracks":
                              return "../../../Shared/Images/Browser/Icons/Tracks.png"
                          case "All Stems":
                              return "../../../Shared/Images/Browser/Icons/Stems.png"
                          case "All Samples":
                              return "../../../Shared/Images/Browser/Icons/RemixSets.png"
                          case "All Remix Sets":
                              return "../../../Shared/Images/Browser/Icons/RemixSets.png"
                          case "Artists":
                              return "../../../Shared/Images/Browser/Icons/Artists.png"
                          case "Releases":
                              return "../../../Shared/Images/Browser/Icons/Releases.png"
                          case "Labels":
                              return "../../../Shared/Images/Browser/Icons/Labels.png"
                          case "Genres":
                              return "../../../Shared/Images/Browser/Icons/Genres.png"
                      }
                  case "Browser | Track Collection | Artists":
                      return "../../../Shared/Images/Browser/Icons/Artists.png"
                  case "Browser | Track Collection | Releases":
                      return "../../../Shared/Images/Browser/Icons/Releases.png"
                  case "Browser | Track Collection | Labels":
                      return "../../../Shared/Images/Browser/Icons/Labels.png"
                  case "Browser | Track Collection | Genres":
                      return "../../../Shared/Images/Browser/Icons/Genres.png"

                  case "Browser | Playlist":
                  case "Browser | Favorites":
                      return hasSubnodes ? "../../../Shared/Images/Browser/Icons/Folder.png" : "../../../Shared/Images/Browser/Icons/Playlist.png"
              }
          default:
              return "../../../Shared/Images/Browser/Icons/Folder.png"
      }
  }

  function bpmColor() {
    var bpmRangeLUP = clockBpm.value * (1 + perfectTempoMatchLimit.value/100);
    var bpmRangeLDN = clockBpm.value * (1 - perfectTempoMatchLimit.value/100);
    var bpmRangeHUP = clockBpm.value * (1 + regularTempoMatchLimit.value/100);
    var bpmRangeHDN = clockBpm.value * (1 - regularTempoMatchLimit.value/100);

    if (highlightMatchRecommendations.value) {
        if (bpmRangeLDN <= model.bpm && model.bpm <= bpmRangeLUP){
            return colors.greenActive
        }
        else if ((bpmRangeLUP < model.bpm  && model.bpm <= bpmRangeHUP) || (bpmRangeLDN > model.bpm && model.bpm >= bpmRangeHDN)){
            return colors.orangeBrowser
        }
        else if (model.bpm == 0){
            return colors.red
        }
        else {
            return "white"
        }
    }
    else {
        return "white"
    }
  }

  property int propSortId: browser.sortingId
  function keyColor(browserKey, masterResultingKey){
    if (keyColorsInBrowser.value == 0) {
        return colors.musicalKeyColors[model.keyIndex]
    }
    else if (keyColorsInBrowser.value == 1) {
        if (masterId.value == -1) { return "white" }
        else if (Key.match(browserKey, masterResultingKey) == 0 || Key.match(browserKey, masterResultingKey) == 1) { return colors.musicalKeyColors[model.keyIndex] }
        else if (Key.match(browserKey, masterResultingKey) == -1 && keyMatchOppositeAdjacents.value ) { return colors.musicalKeyColors[model.keyIndex] }
        else if ((Key.match(browserKey, masterResultingKey) == 2 && keyMatch2p.value) || (Key.match(browserKey, masterResultingKey) == -2 && keyMatch2m.value) || (Key.match(browserKey, masterResultingKey) == 5 && keyMatch5p.value) || (Key.match(browserKey, masterResultingKey) == -5 && keyMatch5m.value) || (Key.match(browserKey, masterResultingKey) == 6 && keyMatch6.value)) { return colors.musicalKeyColors[model.keyIndex] }
        else { return "white" }
    }
    else if (keyColorsInBrowser.value == 2) {
        if (masterId.value == -1) { return "white" }
        else if (Key.match(browserKey, masterResultingKey) == 0 || Key.match(browserKey, masterResultingKey) == 1 ) { return brightMode.value ? colors.colorMixerFXGreen : colors.greenActive }
        else if (Key.match(browserKey, masterResultingKey) == -1 && keyMatchOppositeAdjacents.value ) { return brightMode.value ? colors.colorMixerFXGreen : colors.greenActive }
        else if (Key.match(browserKey, masterResultingKey) == 2 && keyMatch2p.value) { return brightMode.value ? colors.lightOrange : colors.orangeBrowser }
        else if (Key.match(browserKey, masterResultingKey) == -2 && keyMatch2m.value) { return brightMode.value ? colors.lightOrange : colors.orangeBrowser }
        else if (Key.match(browserKey, masterResultingKey) == 5 && keyMatch5p.value) { return brightMode.value ? colors.lightOrange : colors.orangeBrowser }
        else if (Key.match(browserKey, masterResultingKey) == -5 && keyMatch5m.value) { return brightMode.value ? colors.lightOrange : colors.orangeBrowser }
        else if (Key.match(browserKey, masterResultingKey) == 6 && keyMatch6.value) { return brightMode.value ? colors.lightOrange : colors.orangeBrowser }
        else { return "white" }
    }
    else if (keyColorsInBrowser.value == 3) {
        return "white"
    }
  }
}
