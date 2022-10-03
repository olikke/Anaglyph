import QtQuick 2.9

Item {
    anchors.fill: parent

    Connections{
        target: videoProvider
        onImageChanged: im.reload()
    }

    Image{
        id: im
        property bool byVertical: parent.width/1920>parent.height/1080
        width:   byVertical?  1920/1080*parent.height  :  parent.width
        height: byVertical? 1080/1920*parent.width : parent.height
        cache: false
        smooth: true
        autoTransform: false
        fillMode: Image.PreserveAspectFit
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        source: "image://mlive/image"
        function reload() {
            source= ""
            source = "image://mlive/image"
        }

        Canvas {
            id: myCanvas
            anchors.fill: parent


            property int xpos1
            property int ypos1
            property int xpos2
            property int ypos2


            onPaint: {
                var ctx = getContext('2d')
                ctx.reset()
                context.lineWidth = 2
                context.strokeStyle = accent
                ctx.beginPath()
                ctx.fillStyle = accent
                ctx.ellipse(xpos1-2,ypos1-2,4,4)
                ctx.ellipse(xpos2-2,ypos2-2,4,4)
                ctx.moveTo(xpos1,ypos1)
                ctx.lineTo(xpos2,ypos2)
                ctx.stroke()
            }

            MouseArea{
                anchors.fill: parent
                onPressed: {
                    myCanvas.xpos1 = mouseX
                    myCanvas.ypos1 = mouseY
                    myCanvas.requestPaint()
                }
                onReleased: {
                    myCanvas.xpos2 = mouseX
                    myCanvas.ypos2 = mouseY
                    myCanvas.requestPaint()
                }

                onMouseXChanged: {
                    myCanvas.xpos2 = mouseX
                    myCanvas.ypos2 = mouseY
                    myCanvas.requestPaint()
                }
                onMouseYChanged: {
                    myCanvas.xpos2 = mouseX
                    myCanvas.ypos2 = mouseY
                    myCanvas.requestPaint()
                }
            }

        }



    }
}
