import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.3
import QtGraphicalEffects 1.0

Row {
    spacing: 10

    Column{
        id: control
        width: 300
        height: parent.height
        spacing: 10

        ComboBox{
            id: cb1
            height: 50
            width: parent.width
            model: camFinder.model
            currentIndex: -1
        }

        ComboBox{
            id: cb2
            height: 50
            width: parent.width
            model: camFinder.model
            currentIndex: -1
        }

        Button{
            id: start
            text: "Старт"
            width: parent.width
            height: 50
            onClicked: {
                leftGrab.start(cb1.currentIndex)
                rightGrab.start(cb2.currentIndex)
                timer.start()
            }
        }

        Button{
            id: stop
            text: "Стоп"
            width: parent.width
            height: 50
            onClicked: {
                timer.stop()
            }
        }

        Rectangle{
            width: parent.width
            height: 3
            color: foreground
            opacity: 0.5
        }

        Column {
            width: parent.width
            height: implicitHeight
            spacing: 10

            Text {
                text: "Горизонтальное смещение"
                width: 20
                font.pixelSize: 14
                color: foreground
                font.family: "Sans Serif"
                font.capitalization: Font.AllUppercase
            }

            OneSlot{
                id: horizontalShift
                source1: "qrc:/icon/frame_shiftH.png"
                source2: "qrc:/icon/frame_shiftH.png"
                rotation1: 0
                rotation2: 180
                from: -100
                to: 100
                step: 1
                onLeftSignal: anaglyph.setHorizontShift(value)
                alwaysLocked: true
            }

            Rectangle{
                width: parent.width
                height: 3
                color: foreground
                opacity: 0.5
            }

            Text {
                text: "Вертикальное смещение"
                width: 20
                font.pixelSize: 14
                color: foreground
                font.family: "Sans Serif"
                font.capitalization: Font.AllUppercase
            }

            OneSlot{
                id: verticalShift
                source1: "qrc:/icon/frame_shiftV.png"
                rotation1: 0
                source2: "qrc:/icon/frame_shiftV.png"
                rotation2: 0
                from: -100
                to: 100
                step: 1
                onLeftSignal: anaglyph.setVerticalShift(value)
                alwaysLocked: true
            }

            Rectangle{
                width: parent.width
                height: 3
                color: foreground
                opacity: 0.5
            }

            Text {
                text: "Наклон плоскости кадра"
                width: 20
                font.pixelSize: 14
                color: foreground
                font.family: "Sans Serif"
                font.capitalization: Font.AllUppercase
            }

            OneSlot{
                id: vertivalRotation
                source1: "qrc:/icon/frame_angleV.png"
                rotation1: 0
                source2: "qrc:/icon/frame_angleV.png"
                rotation2: 0
                from: -10
                to: 10
                step: 0.1
                onLeftSignal: anaglyph.setLeftIncline(value/step)
                onRightSignal: anaglyph.setRightIncline(value/step)
            }

            Rectangle{
                width: parent.width
                height: 3
                color: foreground
                opacity: 0.5
            }

            Text {
                text: "Поворот плоскости кадра"
                width: 20
                font.pixelSize: 14
                color: foreground
                font.family: "Sans Serif"
                font.capitalization: Font.AllUppercase
            }

            OneSlot{
                id: horizontalRotation
                source1:  "qrc:/icon/frame_angleV.png"
                source2:  "qrc:/icon/frame_angleV.png"
                rotation1: 90
                rotation2: 270
                from: -10
                to: 10
                step: 0.1
                onLeftSignal: anaglyph.setLeftTurn(value/step)
                onRightSignal: anaglyph.setRightTurn(value/step)
            }
        }
    }

    Item{
        width: (parent.width-control.width-parent.spacing)
        height: parent.height

        Connections{
            target: videoProvider
            onImageChanged: im.reload()
        }

        Image{
            id: im
            property bool byVertical: parent.width/1920>parent.height/1080
            width:   byVertical?  1920/1080*parent.height  :  parent.width
            height: byVertical? 1080/1920*parent.width : parent.height
            cache: false
            smooth: true
            autoTransform: false
            fillMode: Image.PreserveAspectFit
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source: "image://mlive/image"
            function reload() {
                source= ""
                source = "image://mlive/image"
            }
        }
    }

}
