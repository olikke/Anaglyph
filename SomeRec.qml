import QtQuick 2.0

Item {
    width: radius*2*scale
    height: width

    property int radius
    property int scale: 1
    property var id
    property bool mouseEnabled: true
    property real centerX:x+radius/2
    property real centerY:y+radius/2

    signal imIn(var id)

    function inRange(val,d) {
        return val>=(d-radius*2) && val<=(d+radius*2)
    }

    function checkMouse(xpos,ypos, mid) {
        if (mid===id) return
        scale =inRange(xpos,x) && inRange(ypos,y)? 2: 1
        return scale===2? id: 0
    }

    Rectangle{
        id: rec
        anchors.fill: parent
        color: mouseEnabled? accent : foreground
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        radius: parent.radius
    }

    MouseArea {
        anchors.fill: parent
        enabled: mouseEnabled
        hoverEnabled: true
        onClicked: {
            mouseEnabled=false
            imIn(id)
        }
    }
}
