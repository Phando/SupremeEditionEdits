import QtQuick 2.12

// TODO: resolve issue on mode 2 where xPos reset at wrong time when taking into account both scrollWait and scrollPause - could be fiddly...
// TODO: look at function that can be called to restart when completely finished - use in deck display when, say, browse encoder is touched

Item {
  id: marquee

  property bool	 doScroll:		 false	 // should scrolling be active?

  // properties widget consumer can set to populate and position marquee
  property bool	 centered:		 false
  property color	containerColor:	 "black"
  property int	  containerRadius:	0
  property string   marqueeText:	  ""
  property int	  textTopMargin:	0
  property string   textFontFamily:   "Pragmatica MediumTT"
  property int	  textFontSize:	 20
  property bool	 textFontBold:	 false
  property bool	 textFontItalic:   false
  property color	textColor:	   "white"
  property real	 textOpacity:	  1

  // properties widget consumer can set to control scrolling behaviour
  property int	  scrollWait:	   1000	  // pause before scroll sequence starts (in ms)
  property int	  scrollPause:	  2000	  // pause when scroll finished before restarting (in ms) - scrollWait if set will also apply
  property int	  scrollInterval:   150	   // pause between each scroll movement (in ms)
  property int	  scrollSize:	   -10	   // number of pixels scrolled (expressed as negative value)
  property int	  scrollFor:		0		 // number of times scroll sequence should take place (0=unlimited)
  property int	  scrollMode:	   1		 // 1=text scrolls repeatedly left (counts as +1 scroll) then right (counts as +1 scroll)
                                                // 2=text scrolls left then resets to original position before restarting
  property int	  scrollTolerance:  3		 // adjustment to stop 'just on edge' scrolling (in px)

  // internal properties
  property int	  scrollCount:	  0
  property bool	 isFinished:	   false
  property bool	 isWaiting:		(marquee.scrollWait > 0)
  property bool	 isPaused:		 false
  property int	  xPos:			 0
  property int	  xRestart:		 0
  property int	  speed:			30

  function resetScroll() {
    marquee.xPos = 0;
    marquee.xRestart = 0;
    marquee.scrollCount = 0;
    marquee.isFinished = false;
    marquee.isWaiting = (marquee.scrollWait > 0);
    marquee.isPaused = false;
    // make sure scrollSize is reset back to negative value
    marquee.scrollSize = Math.abs(marquee.scrollSize) * -1;
    if (marquee.isWaiting) {
      mPauseWait.restart();
    }
  }

  // if text changes then reset the scrolling state
  onMarqueeTextChanged: {
    resetScroll();
  }

  onDoScrollChanged: {
    resetScroll();
  }

  onScrollCountChanged: {
    // should we stop scrolling due to number of completed scrolls?
    if ((marquee.scrollFor > 0) && (marquee.scrollCount >= marquee.scrollFor)) {
      marquee.isFinished = true;
      marquee.xPos = 0;
    } else {
      // delay until scroll is restarted
      marquee.isPaused = true;
      mPauseBetween.restart();
    }
  }

  Rectangle {
    id: mContainer

    anchors.left: parent.left
    anchors.top: parent.top
    anchors.leftMargin: parent.leftMargin
    width: parent.width
    height: parent.height
    color: parent.containerColor
    radius: containerRadius
    clip: true
    //Behavior on anchors.topMargin  { NumberAnimation { duration: speed } }
    //Behavior on anchors.leftMargin { NumberAnimation { duration: speed } }

    Text {
      id: mText
      font.family: marquee.textFontFamily
      font.bold: marquee.textFontBold
      font.italic: marquee.textFontItalic
      font.pixelSize: marquee.textFontSize
      color: marquee.textColor
      x: marquee.xPos
      y: marquee.textTopMargin
      text: marquee.marqueeText
      visible: (width - scrollTolerance) > parent.width || !centered
    } // Text

    Text {
      id: mTextCentered
      font.family: marquee.textFontFamily
      font.bold: marquee.textFontBold
      font.italic: marquee.textFontItalic
      font.pixelSize: marquee.textFontSize
      color: marquee.textColor
      anchors.fill: parent
      horizontalAlignment: Text.AlignHCenter
      text: marquee.marqueeText
      visible: !mText.visible
    } // Text

    // Timer for pause before scroll cycle starts
    Timer {
      id: mPauseWait
      interval: marquee.scrollWait

      onTriggered: {
        marquee.isWaiting = false;
      }
    }

    // Timer for pause between scroll cycles
    Timer {
      id: mPauseBetween
      interval: marquee.scrollPause

      onTriggered: {
        marquee.isWaiting = (marquee.scrollWait > 0);
        if (marquee.scrollMode == 1) {
          // only reset this delay when text has returned to original position
          marquee.isWaiting = ((marquee.scrollWait > 0) && (marquee.scrollCount % 2 == 0));
        }
        marquee.isPaused = false;
        if (marquee.isWaiting) {
          mPauseWait.restart();
        }
        // TODO: this needs moving...
        marquee.xPos = marquee.xRestart;
      }
    }

    Timer {
      id: mTimer
      interval: marquee.scrollInterval
      running: (marquee.doScroll && !marquee.isWaiting && !marquee.isPaused && !marquee.isFinished)
      repeat: true

      onTriggered: {
        // Test for whether scrolling needed can only be done at this stage as mText.width may not have been
        // determined before this event
        if ((mText.width - marquee.scrollTolerance) < marquee.width) {
          //marquee.doScroll = false;
          marquee.isFinished = true;
        } else {
          // mode 1 - scroll left then right and repeat
          if (marquee.scrollMode == 1) {
            // scrolling left - change direction needed
            if ((Math.abs(marquee.xPos) + marquee.width) >= mText.width) {
              marquee.scrollSize *= -1;
              marquee.xRestart = marquee.xPos + marquee.scrollSize;
              marquee.scrollCount += 1;
              return;
            }
            // scrolling right - change direction needed
            if ((marquee.xPos >= 0) && (marquee.scrollCount > 0)) {
              marquee.scrollSize *= -1;
              marquee.xRestart = marquee.xPos + marquee.scrollSize;
              marquee.scrollCount += 1;
              return;
            }
            // just scroll
            marquee.xPos += marquee.scrollSize;
          } // if (marquee.scrollMode == 1)

          // mode 2 - scroll left then reset to original position and repeat
          if (marquee.scrollMode == 2) {
            // scroll left then reset to original position
            if ((Math.abs(marquee.xPos) + marquee.width) >= mText.width) {
              marquee.xRestart = Math.abs(marquee.scrollSize);
              marquee.scrollCount += 1;
              return;
            }
            marquee.xPos += marquee.scrollSize;
          } // if (marquee.scrollMode == 2)

        } // if/else test for scrolling is needed

      } // onTriggered

    } // Timer

  } // Rectangle

} // Item

