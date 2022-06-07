import CSI 1.0
import QtQuick 2.12
import QtGraphicalEffects 1.12

Rectangle {
  id: overlay

  //Overlay size & position
  color: "transparent"
  width: parent.width*0.75
  height: parent.height*0.60 //147
  anchors.centerIn: parent 
  //anchors.verticalCenterOffset: -19

  //Background with border, inner glow & drop shadow
  Item { // bugfix for clipped drop shadow / glow
	id: container
	anchors.centerIn: parent;
	width: border.width + (2 * rectShadow.radius)
	height: border.height + (2 * rectShadow.radius)

	Rectangle {
		id: border
		width: overlay.width
		height: overlay.height
		anchors.centerIn: parent 
		color: colors.colorBlack69 
		border.color: colors.colorGrey40
		border.width: 1
		radius: 4
	}
  }
  
  //Outer glow
  Glow {
	id: rectShadow
	anchors.fill: source
	cached: true
	radius: 6.0
	samples: 12
	color: colors.colorBlack75
	smooth: true
	source: container
  }

  Rectangle {
	id: innerGlow
	width: overlay.width -2
	height: overlay.height -2
	anchors.centerIn: parent 
	color: "transparent"
	border.color: colors.colorGrey08
	border.width: 1
	radius: 3
  }
}

