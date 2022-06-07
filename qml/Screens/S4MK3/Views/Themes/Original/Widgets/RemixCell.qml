  import QtQuick 2.12

  Rectangle {

	  property color  cellColor   : "black"
	  property color  textColor   : "white"
	  property int	cellSize	: 65
	  property int	cellRadius  : 5
	  property bool   isLoop	  : false
	  property bool   withIcon	: true

	  id						  : cell
	  color					   : cellColor
	  width					   : cellSize
	  height					  : cellSize
	  radius					  : cellRadius

	  Image {
		id: remixCellImage
		anchors.centerIn:	 parent
		width:				cellSize*0.65	
		visible:			  withIcon
		source:			   isLoop ? "../../../../../Shared/Images/RemixAssets/Sample_Loop.png" : "../../../../../Shared/Images/RemixAssets/Sample_OneShot.png"
		fillMode:			 Image.PreserveAspectFit
	  } 
	}
