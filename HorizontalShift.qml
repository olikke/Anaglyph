import QtQuick 2.0

Item{
    anchors.fill: parent
    anchors.leftMargin: 10
    property int scale: 13
    property int zeroShift: 3
    property real fshift: 0

    Rectangle{
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: parent.zeroShift
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: -parent.zeroShift-(parent.fshift*width/4)
        width: parent.scale*4*ratio
        height: parent.scale*3*ratio
        color: "transparent"
        border.color: red
        border.width: 3
        radius: 6
    }

    Rectangle{
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -parent.zeroShift
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: parent.zeroShift+parent.fshift*width/4
        width: parent.scale*4*ratio
        height: parent.scale*3*ratio
        color: "transparent"
        border.color: blue
        border.width: 3
        radius: 6
    }
}

