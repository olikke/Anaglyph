import QtQuick 2.0

Item{
    anchors.fill: parent
    property int scale: 13
    property real value
    property string color: "yellow"
    Rectangle{
        id: rec
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.scale*4*ratio
        height: parent.scale*3*ratio
        color: "transparent"
        border.width: 3
        border.color: parent.color
        radius: 6
        transform: Rotation{
            origin.x: rec.width/2
            origin.y: rec.height/2
            angle: value
        }
    }
}
