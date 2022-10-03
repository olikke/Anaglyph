import QtQuick 2.9

Item {
    anchors.fill: parent

    property bool redactorEnable: false
    onRedactorEnableChanged: {
        if (im.obj===undefined) return
        for (var i=0; i<im.obj.length; i++)
            im.obj[i].visible=redactorEnable
    }

    function clear() {
        if (im.obj===undefined) return
        for (var i=0; i<im.obj.length; i++)
            im.obj[i].destroy()
        im.obj.clear()
        if (redactorEnable) myCanvas.requestPaint()
    }

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

        property variant obj: []
        property var currentObj:undefined
        property real radius:3

        function somebodyIn(id) {
            for (var i=0; i< obj.length; i++)
                if (obj[i].id===id)
                    currentObj=obj[i]
        }

        Canvas {
            visible: redactorEnable
            id: myCanvas
            anchors.fill: parent

            onPaint: {
                var ctx = getContext('2d')
                ctx.reset()
                if (im.obj===undefined) return
                context.lineWidth = 2
                context.strokeStyle = accent
                ctx.beginPath()
                ctx.fillStyle = accent
                for (var i=0; i< im.obj.length-1; i++) {
                    ctx.moveTo(im.obj[i].centerX,im.obj[i].centerY)
                    ctx.lineTo(im.obj[i+1].centerX,im.obj[i+1].centerY)
                }
                ctx.stroke()
            }
        }

        MouseArea{
            anchors.fill: parent
            onPressed: {
                if (im.currentObj!==undefined) return
                im.obj.push(createNew(mouseX,mouseY,Date.now()))
                myCanvas.requestPaint()
            }
            onReleased: {
              if (im.currentObj!==undefined) {
                      im.currentObj.mouseEnabled=true
                    im.currentObj=undefined
              }
              myCanvas.requestPaint()
            }

            onMouseXChanged: {
                if (im.currentObj!==undefined) {
                    im.currentObj.x=mouseX-im.radius
                    im.currentObj.y=mouseY-im.radius
                }
            }
            onMouseYChanged: {
                if (parent.currentObj!==undefined) {
                    parent.currentObj.x=mouseX-parent.radius
                    parent.currentObj.y=mouseY-parent.radius
                }
            }

            function createNew(xp, yp,idd) {
                var component=Qt.createComponent("SomeRec.qml")
                var newObject=component.createObject(parent,{x:xp-5, y: yp-5, id:idd, radius: parent.radius,visible: redactorEnable})
                newObject.imIn.connect(parent.somebodyIn)
                return newObject
            }
        }
    }
}
