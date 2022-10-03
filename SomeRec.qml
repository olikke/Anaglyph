import QtQuick 2.0

Item {
    width: 15
    height: 15
    signal imhere()

    Rectangle{
        id: rec
        color: accent
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        radius: width/2
        width: 5
        height: width
    }

    MouseArea {
        anchors.fill: parent
        anchors.margins: -5
        hoverEnabled: true
        onEntered: {
            rec.width=15
            imhere(this)
            console.log("itsMe")
        }
        onExited: {
            rec.width=5
        }
    }

}
