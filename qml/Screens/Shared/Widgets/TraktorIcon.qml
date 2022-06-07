import CSI 1.0
import QtQuick 2.12
import Traktor.Gui 1.0 as Traktor

Item {
    id: traktorIcon

    property color fillColor: "white"
    property color backgroundColor: "red"

    Canvas {
        anchors.fill: parent
        anchors.centerIn: parent
        //anchors.margins: Math.max(parent.width, parent.height)*0.1
        onPaint: {
            var ctx = getContext("2d");
            ctx.reset();

            var centreX = width / 2;
            var centreY = height / 2;

            var radius = Math.min(parent.width, parent.height) / 2;

            var outerWidth = 0.18
            var innerRadius = radius*(1-2*outerWidth)
            var horizontalOffset = 0.35
            var horizontalAngle = 2 * Math.PI / 20
            var verticalOffset = horizontalOffset * 1.5
var verticalAngle = 2 * Math.PI / 7.5
            var verticalRadius = radius*0.3


            /*
            context.moveTo(cx,cy);
            context.arc(cx,cy,radius,startangle,endangle);
            context.lineTo(cx,cy);
            context.stroke(); // or context.fill()
            */

            //Outer circle
            ctx.beginPath();
            ctx.fillStyle = fillColor;
            ctx.arc(centreX, centreY, radius, 0, Math.PI * 2, false);
            ctx.moveTo(centreX*(2-outerWidth), centreY);
            ctx.arc(centreX, centreY, radius*(1-outerWidth), 0, Math.PI * 2, false);
            //ctx.fill();
            ctx.stroke();

            //Left
            ctx.beginPath();
            ctx.fillStyle = fillColor;
            ctx.lineTo(centreX*(1-horizontalOffset), centreY);
            ctx.arc(centreX, centreY, innerRadius, Math.PI - horizontalAngle, Math.PI + horizontalAngle, false);
            ctx.lineTo(centreX*(1-horizontalOffset), centreY);
            ctx.fill();

            //Right
            ctx.beginPath();
            ctx.fillStyle = fillColor;
            ctx.lineTo(centreX*(1+horizontalOffset), centreY);
            ctx.arc(centreX, centreY, innerRadius, -horizontalAngle, horizontalAngle, false);
            ctx.lineTo(centreX*(1+horizontalOffset), centreY);
            ctx.fill();

            //Top
            ctx.beginPath();
            ctx.fillStyle = fillColor;
            ctx.arc(centreX, centreY, innerRadius, -Math.PI/2 - verticalAngle, -Math.PI/2 + verticalAngle, false);
            var alpha = -Math.PI/2 + verticalAngle
            ctx.lineTo(centreX+verticalRadius*Math.cos(alpha), centreY+verticalRadius*Math.sin(alpha));
            ctx.arc(centreX, centreY, verticalRadius, -Math.PI/2 + verticalAngle, -Math.PI/2 - verticalAngle, true);
            ctx.lineTo(centreX-innerRadius*Math.cos(alpha), centreY+innerRadius*Math.sin(alpha));
            ctx.fill();

            //Bottom
            ctx.beginPath();
            ctx.fillStyle = fillColor;
            ctx.arc(centreX, centreY, innerRadius, Math.PI/2 - verticalAngle, Math.PI/2 + verticalAngle, false);
            var alpha = -Math.PI/2 + verticalAngle
            ctx.lineTo(centreX-verticalRadius*Math.cos(alpha), centreY-verticalRadius*Math.sin(alpha));
            ctx.arc(centreX, centreY, verticalRadius, Math.PI/2 + verticalAngle, Math.PI/2 - verticalAngle, true);
            ctx.lineTo(centreX+innerRadius*Math.cos(alpha), centreY-innerRadius*Math.sin(alpha));
            ctx.fill();


            //4 graus de llibertat
            /*
            var radi = 50 //libre
            var horizontalOffset = 0.25 //--> libre
            var horizontalAngle = 2 * Math.PI / 20 //libre
            //var verticalAngle = (Math.PI - horizontalAngle*2)/2 //fijada --> obtener ecuacion
            var xouter = 0 //determinada
            var youter = 0 //determinada

            //3 eq. lligam--> 3 punts en linea

            //horizontalAngle = arctan(youter-yoffset(=0) / xouter-xoffset) //yoffset será 0
            //xoffset = radi * (1 - horizontalOffset)
            //y outer ^2 + x outer^2 = r^2

            //por tanto
            horizontalAngle = arctan(youter / (xouter-radi - (1 - horizontalOffset)))
            youter ^2 + xouter^2 = r^2

            //finalmente, considerando lo anterior
            youter = tan(horizontalAngle)*(xouter-radi-(1-horizontalOffset))
            */

        }
    }
}