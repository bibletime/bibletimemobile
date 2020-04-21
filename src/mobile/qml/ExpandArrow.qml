
import QtQuick 2.11
import QtQuick.Controls.Material 2.3

Item {
    id:container

    property bool expanded: false
    property color background: Material.background
    property color textColor: Material.foreground
    onTextColorChanged: canvas.requestPaint();
    onExpandedChanged: canvas.requestPaint();

    Canvas {
        id: canvas
        width:  parent.width
        height: parent.height
        antialiasing: true
        onPaint: {
            var ctx = getContext("2d");
            ctx.save();
            ctx.globalAlpha = canvas.alpha
            ctx.fillStyle = container.textColor;
            ctx.clearRect(0,0,canvas.width, canvas.height);
            ctx.beginPath();
            if (expanded) {
                ctx.moveTo(width * 1,   height*0.1);
                ctx.lineTo(width * 0.6, height);
                ctx.lineTo(width * 0.3, height*0.1);
            } else {
                ctx.moveTo(width * 0.1, height*0.85);
                ctx.lineTo(width,       height*0.5);
                ctx.lineTo(width * 0.1, height*0.15);
            }
            ctx.closePath();
            ctx.fill();
            ctx.restore();
        }
    }
}
