import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.3
import QtGraphicalEffects 1.0

Row{
    id: root
    width: parent.width
    height: Math.max(row1.height,btn.height)
    spacing: 0

    signal leftSignal(int value)
    signal rightSignal(int value)

    property var leftImage
    property var rightImage
    property var from
    property var to
    property var step
    property bool alwaysLocked: false
    property alias lockedEnable: lock.enabled

    property int sp: parent.width-left.width-right.width

    property bool locked: alwaysLocked? true : false

    Component.onCompleted: {
        leftImage.parent=image1
        rightImage.parent=image2
    }

    Item{
        id: left
        width: parent.width/3
        height: parent.height

        Row{
            id: row1
            width: parent.width
            height: implicitHeight
            anchors.verticalCenter: parent.verticalCenter
            spacing: 5

            Column{
                width: parent.width-sl2.width-parent.spacing
                height: implicitHeight
                anchors.verticalCenter: parent.verticalCenter

                Item{
                    id: image1
                    width: 64*ratio
                    height: width
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text{
                    id: txt1
                    text: sl1.value.toFixed(1)
                    font.pointSize: _pointSize
                    font.bold: true
                    color: accent
                    font.capitalization: Font.AllUppercase
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }

            Slider{
                id: sl1
                orientation: Qt.Vertical
                width: 30*ratio
                height: root.height
                from: root.from
                stepSize: root.step
                to:root.to
                value: 0
                onValueChanged: {
                    if (locked) {
                        sl2.value=sl1.value
                        leftSignal(value/root.step)
                        rightSignal(value/root.step)
                    } else
                    leftSignal(value/root.step)
                }
            }
        }
    }

    Item{
        width: parent.width/3
        height: parent.height
        Column{
            id: btn
            width: parent.width
            height: implicitHeight
            Button{
                id: lock
                width: parent.width
                font.pointSize: _pointSize
                icon.source: locked? "qrc:/icon/lock.png" : "qrc:/icon/unlock.png"
                onClicked: locked=!locked
                enabled: !root.alwaysLocked
            }

            Button{
                width: parent.width
                text: "zero"
                font.pointSize: _pointSize
                onClicked: sl1.value=sl2.value=0
            }
        }
    }

    Item{
        id: right
        width: parent.width/3
        height: parent.height

        Row{
            id: row2
            width: parent.width
            height: implicitHeight
            anchors.verticalCenter: parent.verticalCenter
            spacing: 5

            Slider{
                id: sl2
                orientation: Qt.Vertical
                width: 30*ratio
                height: root.height
                from: root.from
                stepSize: root.step
                to:root.to
                value: 0
                onValueChanged: {
                    if (locked) {
                        sl1.value=sl2.value
                        leftSignal(value/root.step)
                        rightSignal(value/root.step)
                    } else
                    rightSignal(value/root.step)
                }
            }

            Column{
                width: parent.width-sl2.width-parent.spacing
                height: implicitHeight
                anchors.verticalCenter: parent.verticalCenter

                Item{
                    id: image2
                    width: 64*ratio
                    height: width
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text{
                    id: txt2
                    text: sl2.value.toFixed(1)
                    font.pointSize: _pointSize
                    font.bold: true
                    color: accent
                    font.capitalization: Font.AllUppercase
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }
    }
}

