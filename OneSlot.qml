import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.3
import QtGraphicalEffects 1.0

Row{
    id: root
    width: parent.width
    height: implicitHeight

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
        width: 100
        height: 120

        Column{
            anchors.left: parent.left
            anchors.leftMargin: 0
            width: 64
            height: parent.height
            spacing: 5

            Item{
                id: image1
                width: 64
                height: parent.height-txt1.height*2
            }

            Text{
                id: txt1
                text: sl1.value.toFixed(1)
                font.pixelSize: 16
                font.bold: true
                color: accent
                font.capitalization: Font.AllUppercase
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        Slider{
            id: sl1
            anchors.right: parent.right
            anchors.rightMargin: 0
            orientation: Qt.Vertical
            width: 30
            height: parent.height
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

    Item{
        width: parent.sp
        height: parent.height
        Column{
            width: 64
            height: implicitHeight
            anchors.horizontalCenter: parent.horizontalCenter
            spacing:5
            Button{
                id: lock
                width: 64
                height: 48
                icon.source: locked? "qrc:/icon/lock.png" : "qrc:/icon/unlock.png"
                onClicked: locked=!locked
                enabled: !root.alwaysLocked
            }

            Button{
                width: 64
                height: 48
                text: "zero"
                onClicked: sl1.value=sl2.value=0
            }
        }
    }

    Item{
        id: right
        width: 100
        height: 120

        Column{
            width: 64
            height: parent.height
            spacing: 5
            anchors.right: parent.right

            Item{
                id: image2
                width: 64
                height: parent.height-txt2.height*2
            }

            Text{
                id: txt2
                text: sl2.value.toFixed(1)
                font.pixelSize: 16
                font.bold: true
                color: accent
                font.capitalization: Font.AllUppercase
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        Slider{
            id: sl2
            anchors.left: parent.left
            anchors.leftMargin: 10
            orientation: Qt.Vertical
            width: 30
            height: parent.height
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
    }
}

