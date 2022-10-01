import QtQuick 2.0

Item{
    id:root
    anchors.fill: parent
    property int scale: 13
    property real value
    property string color: "yellow"
    property bool isVertical: true
    Rectangle{
        id: rec
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.scale*4
        height: parent.scale*3
        color: "transparent"
        border.width: 3
        border.color: parent.color
        radius: 6
        transform: Rotation{
            origin.x: rec.width/2
            origin.y: rec.height/2
            axis{ x:isVertical?1:0;  y:isVertical? 0: 1;  z:0}
            angle: root.value
        }
    }
}
