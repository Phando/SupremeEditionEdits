import QtQuick 2.12

// TODO: resolve issue on mode 2 where xPos reset at wrong time when taking into account both scrollWait and scrollPause - could be fiddly...
// TODO: look at function that can be called to restart when completely finished - use in deck display when, say, browse encoder is touched

Item {
  id: scrollText

  property bool doScroll: false

  property string textString: ""
  property color textColor: "black"
  property string textFontFamily:   "Pragmatica MediumTT"
  property int textFontSize: 20
  property bool textFontBold: false
  property bool textFontItalic: false

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
  property bool	 isWaiting:		(scrollText.scrollWait > 0)
  property bool	 isPaused:		 false
  property int	  xPos:			 0
  property int	  xRestart:		 0
  property int	  speed:			30

  function resetScroll() {
	scrollText.xPos = 0;
	scrollText.xRestart = 0;
	scrollText.scrollCount = 0;
	scrollText.isFinished = false;
	scrollText.isWaiting = (scrollText.scrollWait > 0);
	scrollText.isPaused = false;
	// make sure scrollSize is reset back to negative value
	scrollText.scrollSize = Math.abs(scrollText.scrollSize) * -1;
	if (scrollText.isWaiting) {
		mPauseWait.restart();
	}
  }

  // if text changes then reset the scrolling state
  onTextStringChanged: {
	resetScroll();
  }

  onDoScrollChanged: {
	resetScroll();
  }

  onScrollCountChanged: {
	// should we stop scrolling due to number of completed scrolls?
	if ((scrollText.scrollFor > 0) && (scrollText.scrollCount >= scrollText.scrollFor)) {
		scrollText.isFinished = true;
		scrollText.xPos = 0;
	}
	else {
		// delay until scroll is restarted
		scrollText.isPaused = true;
		mPauseBetween.restart();
	}
  }

  Item {
	id: mContainer
	anchors.fill: parent
	clip: true
	//Behavior on anchors.topMargin  { NumberAnimation { duration: speed } }
	//Behavior on anchors.leftMargin { NumberAnimation { duration: speed } }

	Text {
		id: mText
		anchors.verticalCenter: parent.verticalCenter
		x: scrollText.xPos
		text: scrollText.textString
		color: scrollText.textColor
		font.family: scrollText.textFontFamily
		font.bold: scrollText.textFontBold
		font.italic: scrollText.textFontItalic
		font.pixelSize: scrollText.textFontSize
	}

	// Timer for pause before scroll cycle starts
	Timer { id: mPauseWait; interval: scrollText.scrollWait;
		onTriggered: {
			scrollText.isWaiting = false;
		}
	}

	// Timer for pause between scroll cycles
	Timer { id: mPauseBetween; interval: scrollText.scrollPause; 
		onTriggered: {
			scrollText.isWaiting = (scrollText.scrollWait > 0);
			if (scrollText.scrollMode == 1) {
				// only reset this delay when text has returned to original position
				scrollText.isWaiting = ((scrollText.scrollWait > 0) && (scrollText.scrollCount % 2 == 0));
			}
			scrollText.isPaused = false;
				if (scrollText.isWaiting) {
				mPauseWait.restart();
			}
			// TODO: this needs moving...
			scrollText.xPos = scrollText.xRestart;
		}
	}

	Timer { id: mTimer; interval: scrollText.scrollInterval; running: (scrollText.doScroll && !scrollText.isWaiting && !scrollText.isPaused && !scrollText.isFinished); repeat: true;
		onTriggered: {
			if ((mText.width - scrollText.scrollTolerance) < scrollText.width) {
				scrollText.isFinished = true;
			}
			else {
				if (scrollText.scrollMode == 1) {
					if ((Math.abs(scrollText.xPos) + scrollText.width) >= mText.width) {
						scrollText.scrollSize *= -1;
						scrollText.xRestart = scrollText.xPos + scrollText.scrollSize;
						scrollText.scrollCount += 1;
						return;
					}
					if ((scrollText.xPos >= 0) && (scrollText.scrollCount > 0)) {
						scrollText.scrollSize *= -1;
						scrollText.xRestart = scrollText.xPos + scrollText.scrollSize;
						scrollText.scrollCount += 1;
						return;
					}
					scrollText.xPos += scrollText.scrollSize;
				}
				if (scrollText.scrollMode == 2) {
					if ((Math.abs(scrollText.xPos) + scrollText.width) >= mText.width) {
						scrollText.xRestart = Math.abs(scrollText.scrollSize);
						scrollText.scrollCount += 1;
						return;
					}
					scrollText.xPos += scrollText.scrollSize;
				}
			}

		}
	}
  }
}