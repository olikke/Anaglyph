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
        spacing: 5

        Text {
            text: "Открыть видео"
            width: 20
            font.pixelSize: 14
            color: foreground
            font.family: "Sans Serif"
            font.capitalization: Font.AllUppercase
        }

        Row{
            width: parent.width
            height: implicitHeight
            spacing: 10

            ComboBox{
                id: cb1
                height: 40
                width: parent.width/2-5
                model: camFinder.model
                currentIndex: -1
            }

            ComboBox{
                id: cb2
                height: 40
                width: parent.width/2-5
                model: camFinder.model
                currentIndex: -1
            }
        }

        Row{
            width: parent.width
            height: implicitHeight
            spacing: 10

            Button{
                id: start
                text: "Старт"
                width: parent.width/2-5
                height: 40
                onClicked: {
                    leftGrab.start(cb1.currentIndex)
                    rightGrab.start(cb2.currentIndex)
                    timer.start()
                }
            }

            Button{
                id: stop
                text: "Стоп"
                width: parent.width/2-5
                height: 40
                onClicked: {
                    timer.stop()
                }
            }
        }

        Rectangle{
            width: parent.width
            height: 3
            color: foreground
            opacity: 0.5
        }

        Text {
            text: "Открыть фото"
            width: 20
            font.pixelSize: 14
            color: foreground
            font.family: "Sans Serif"
            font.capitalization: Font.AllUppercase
        }

        Row{
            width: parent.width
            height: implicitHeight
            spacing: 10

            Button{
                id: leftOpen
                text: "Левое"
                width: parent.width/2-5
                height: 40
                onClicked: {
                    openDialog.title="Открыть левое изображение"
                    openDialog.left=true
                    openDialog.open()
                }
            }

            Button{
                id: rightOpen
                text: "Правое"
                width: parent.width/2-5
                height: 40
                onClicked: {
                    openDialog.title="Открыть правое изображение"
                    openDialog.left=false
                    openDialog.open()
                }
            }
        }

        Row{
            width: parent.width
            height: implicitHeight
            spacing: 10

            Button{
                id: start1
                text: "Старт"
                width: parent.width/2-5
                height: 40
                onClicked: {
                    leftGrab.start(-1)
                    rightGrab.start(-1)
                    timer.start()
                }
            }

            Button{
                id: stop1
                text: "Стоп"
                width: parent.width/2-5
                height: 40
                onClicked: {
                    timer.stop()
                }
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
                text: "Cмещение"
                width: 20
                font.pixelSize: 14
                color: foreground
                font.family: "Sans Serif"
                font.capitalization: Font.AllUppercase
            }

            OneSlot{
                id: shift
                source1: "qrc:/icon/frame_shiftH.png"
                source2: "qrc:/icon/frame_shiftV.png"
                rotation1: 0
                rotation2: 180
                from: -200
                to: 200
                step: 1
                onLeftSignal: anaglyph.setHorizontShift(value)
                onRightSignal: anaglyph.setVerticalShift(value)
                lockedEnable: false
            }

            Rectangle{
                width: parent.width
                height: 3
                color: foreground
                opacity: 0.5
            }

            Text {
                text: "Поворот"
                width: 20
                font.pixelSize: 14
                color: foreground
                font.family: "Sans Serif"
                font.capitalization: Font.AllUppercase
            }

            OneSlot{
                id: angle
                source1: "qrc:/icon/frame.png"
                rotation1: 15
                source2: "qrc:/icon/frame.png"
                rotation2: -15
                from: -45
                to: 45
                step: 0.1
                onLeftSignal: anaglyph.setLeftAngle(value*step)
                onRightSignal: anaglyph.setRightAngle(value*step)
            }

            Rectangle{
                width: parent.width
                height: 3
                color: foreground
                opacity: 0.5
            }

            Text {
                text: "Наклон 1"
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
                text: "Наклон 2"
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


        Rectangle {
            width:300
            height: 200
            color:"transparent"
            border.color: "red"
            transform: Rotation { origin.x: 150; origin.y: 100; axis { x: 1; y: 0; z: 0 } angle: 45 }

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
