import QtQuick 2.0

Item {
    width: radius*2+1
    height: width

    property int radius
    property var id
    property bool mouseEnabled: true
    property real centerX:x+radius/2+1
    property real centerY:y+radius/2+1

    signal imIn(var id)

    Rectangle{
        id: rec
        anchors.fill: parent
        color: accent
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

        onEntered: {
            rec.color="white"

        }
        onExited: {
            rec.color=accent
        }
    }
}
