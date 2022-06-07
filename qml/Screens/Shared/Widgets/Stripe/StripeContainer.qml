import CSI 1.0
import QtQuick 2.12
import Traktor.Gui 1.0 as Traktor

import '../Waveform'

Item {
  id: stripe_box
  property int deckId: 1

  property bool remainingTime: displayRemainingTimeStripe.value
  property bool displayLetter: displayDeckLetterStripe.value

  clip: true //prevents that children paints over zones which aren't inside the stripe (parent)

  //Stripe
  Stripe {
    id: stripe
    deckId: trackDeck.deckId-1 //because is a Traktor Translator, and in Traktor --> clock: -1, deckA: 0, deckB: 1, deckC: 2, deckD: 3
    windowSampleWidth: trackDeck.sampleWidth

    anchors.left: deckLetter ? deck_letter_stripe.right : parent.left
    //anchors.leftMargin: 9 //To give some space for elements that go beyond the stripe element, like Cue/Loop markers
    anchors.right: parent.right
    anchors.top: parent.top
    anchors.bottom: parent.bottom

    audioStreamKey: ["PrimaryKey", primaryKey.value]
    gridMarkers: waveformContainer.gridMarkers
    Behavior on anchors.bottomMargin { PropertyAnimation {  duration: durations.deckTransition } }
  }

  //Waveform Stripe Left & Right Fillers
  /*
    Rectangle {
      id: stripeGapFillerLeft
      anchors.left:   parent.left
      anchors.right:  stripe.left
      anchors.bottom: stripe.bottom
      height:		 stripe.height
      color:		  colors.colorBgEmpty
      visible:		isLoaded.value && deckSize != "small"
    }

    Rectangle {
      id: stripeGapFillerRight
      anchors.left:   stripe.right
      anchors.right:  parent.right
      anchors.bottom: stripe.bottom
      height:		 stripe.height
      color:		  colors.colorBgEmpty
      visible:		isLoaded.value && deckSize != "small"
    }
  */

  //Deck Letter Indicator
  Rectangle {
    id: deck_letter_stripe

    anchors.left: parent.left
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    width: 20
    color: colors.colorBgEmpty
    radius: 1
    antialiasing: false
    visible: displayLetter

    Image {
        anchors.fill: parent
        fillMode: Image.Stretch
        source: "../../../Shared/Images/Deck_" + deckLetter + ".png"
    }
  }

  //Remainning time
  Rectangle {
    id: timeBox
    anchors.verticalCenter: parent.verticalCenter
    anchors.right: parent.right
    anchors.rightMargin: 3
    height: parent.height*0.70
    width: 55
    radius:	4
    color: colors.colorGrey24
    opacity: isLoaded.value && deckSize == "small" ? 0.75 : 0
    visible: remainingTime
  }

  Text {
    font.family: "Pragmatica"
    font.pixelSize:	fonts.middleFontSize
    anchors.fill: timeBox
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    color: "white"
    text: getRemainingTimeString()
    visible: remainingTime && deckSize == "small"
  }

  function getRemainingTimeString() {
    var seconds = trackLength.value - elapsedTime.value;
    if (seconds < 0) seconds = 0;

    var sec = Math.floor(seconds % 60);
    var min = (Math.floor(seconds) - sec) / 60;

    var secStr = sec.toString();
    if (sec < 10) secStr = "0" + secStr;

    var minStr = min.toString();
    if (min < 10) minStr = "0" + minStr;

    return "- " + minStr + ":" + secStr;
  }
}
