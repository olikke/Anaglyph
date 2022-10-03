import QtQuick 2.9

Item {
    id: root
    anchors.fill: parent
    property variant objectList: []
    property var currentObj:undefined
    property real radius:3
    property bool redactorEnable: false

    onRedactorEnableChanged: {
        if (objectList===undefined) return
        for (var i=0; i<objectList.length; i++)
            objectList[i].visible=redactorEnable
    }

    function clear() {
        if (objectList===undefined) return
        for (var i=0; i<objectList.length; i++)
            objectList[i].destroy()
        objectList=[]
        if (redactorEnable) myCanvas.requestPaint()
    }

    function somebodyIn(id) {
        currentObj=getObjectByID(id)
    }

    function getObjectByID(id) {
        for (var i=0; i< objectList.length; i++)
            if (objectList[i].id===id) return objectList[i]
        return undefined
    }

    signal checkMouse(var xpos,var ypos, var mid)

    Canvas {
        id: myCanvas
        visible: redactorEnable
        anchors.fill: parent
        onPaint: {
            var ctx = getContext('2d')
            ctx.reset()
            if (root.objectList===undefined) return
            context.lineWidth = 2
            context.strokeStyle = accent
            ctx.beginPath()
            ctx.fillStyle = accent
            for (var i=0; i< root.objectList.length-1; i++) {
                ctx.moveTo(root.objectList[i].centerX,root.objectList[i].centerY)
                ctx.lineTo(root.objectList[i+1].centerX,root.objectList[i+1].centerY)
            }
            ctx.stroke()
        }
    }

    MouseArea{
        anchors.fill: parent
        onPressed: {
            if (currentObj!==undefined) {
                checkMouse(mouseX,mouseY,currentObj.id)
                return
            }
            objectList.push(createNew(mouseX,mouseY,Date.now()))
            myCanvas.requestPaint()
        }
        onReleased: {
            if (currentObj!==undefined) {
                var mid=checkMouse(mouseX,mouseY,currentObj)
                var obj=getObjectByID(mid)
                if (obj!==undefined) {
                    currentObj.x=obj.centerX-radius
                    currentObj.y=obj.centerY-radius
                    obj.scale=1
                }
                currentObj.mouseEnabled=true
                currentObj=undefined
                for (var i=0; i<objectList.length; i++)
                    console.log(objectList[i].centerX,objectList[i].centerY,objectList[i].scale)
            }
            myCanvas.requestPaint()
        }

        onMouseXChanged: {
            if (currentObj!==undefined) {
                currentObj.x=mouseX-radius
                currentObj.y=mouseY-radius
                myCanvas.requestPaint()
                checkMouse(mouseX,mouseY,currentObj.id)
            }
        }
        onMouseYChanged: {
            if (currentObj!==undefined) {
                currentObj.x=mouseX-radius
                currentObj.y=mouseY-radius
                myCanvas.requestPaint()
                checkMouse(mouseX,mouseY,currentObj.id)
            }
        }

        function createNew(xp, yp,idd) {
            var component=Qt.createComponent("SomeRec.qml")
            var newObject=component.createObject(parent,{x:xp-radius, y: yp-radius, id:idd, radius: root.radius,visible: redactorEnable})
            newObject.imIn.connect(root.somebodyIn)
            root.checkMouse.connect(newObject.checkMouse)
            return newObject
        }
    }
}
