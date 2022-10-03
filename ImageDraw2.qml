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


        property int xpos1
        property int ypos1
        property int xpos2
        property int ypos2
        property var obj1


        property var obj2


        MouseArea{
            anchors.fill: parent
            onPressed: {
                console.log("hello")
                parent.xpos1 = mouseX
                parent.ypos1 = mouseY
                parent.obj1=createNew(mouseX,mouseY)
                Connections{
                    target: obj1
                    onimhere: console.log("lklklk")
                }
            }
            onReleased: {
                parent.xpos2 = mouseX
                parent.ypos2 = mouseY
                parent.obj2=createNew(mouseX,mouseY)
            }

//            onMouseXChanged: {
//                xpos2 = mouseX
//                ypos2 = mouseY
//              //  myCanvas.requestPaint()
//            }
//            onMouseYChanged: {
//                myCanvas.xpos2 = mouseX
//                myCanvas.ypos2 = mouseY
//                myCanvas.requestPaint()
//            }

            Loader{
                id: pointloader
            }

            function createNew(xp, yp) {
                var newObject = Qt.createQmlObject('SomeRec {}', parent);
                newObject.x = xp-2
                newObject.y = yp-2
                return newObject

            }

            function deleteOne() {
                Qt.del
            }
        }

    }
}
