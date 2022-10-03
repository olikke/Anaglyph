import QtQuick 2.0

Item{
    id: testArea2
    anchors.fill: parent
    property int scale: 13
    property int zeroShift: 3
    property real fshift: 0

    Rectangle{
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: parent.zeroShift-(parent.fshift*width/4)
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: -parent.zeroShift
        width: parent.scale*4
        height: parent.scale*3
        color: "transparent"
        border.color: red
        border.width: 3
        radius: 6
    }

    Rectangle{
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -parent.zeroShift+parent.fshift*width/4
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: parent.zeroShift
        width: parent.scale*4
        height: parent.scale*3
        color: "transparent"
        border.color: blue
        border.width: 3
        radius: 6
    }
}
