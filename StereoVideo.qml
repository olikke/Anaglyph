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

            OneSlot2{
                id: shift
                from: -200
                to: 200
                step: 1
                leftImage: HorizontalShift{id: horizontalShift}
                rightImage: VerticalShift{id: verticalShift}
                onLeftSignal: {
                    anaglyph.setHorizontShift(value)
                    horizontalShift.fshift=value/200;
                }
                onRightSignal: {
                    anaglyph.setVerticalShift(value)
                    verticalShift.fshift=value/200;
                }
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

            OneSlot2{
                id: angle
                from: -45
                to: 45
                step: 0.1
                leftImage: Angle{id: leftAngle; color: red}
                rightImage: Angle{id: rightAngle; color: blue}
                onLeftSignal: {
                    anaglyph.setLeftAngle(value*step)
                    leftImage.value=-value*step
                }
                onRightSignal: {
                    anaglyph.setRightAngle(value*step)
                    rightAngle.value=-value*step
                }
            }

            Rectangle{
                width: parent.width
                height: 3
                color: foreground
                opacity: 0.5
            }

            Text {
                text: "Наклон туда"
                width: 20
                font.pixelSize: 14
                color: foreground
                font.family: "Sans Serif"
                font.capitalization: Font.AllUppercase
            }

            OneSlot2{
                id: vertivalRotation
                from: -10
                to: 10
                step: 0.1
                leftImage: TRotation{id: leftRotation; color: red}
                rightImage: TRotation{id: rightRotation; color: blue}
                onLeftSignal: {
                    anaglyph.setLeftIncline(value/step)
                    leftRotation.value=value*step*7
                }
                onRightSignal: {
                    anaglyph.setRightIncline(value/step)
                    rightRotation.value=value*step*7
                }
            }

            Rectangle{
                width: parent.width
                height: 3
                color: foreground
                opacity: 0.5
            }

            Text {
                text: "Наклон сюда"
                width: 20
                font.pixelSize: 14
                color: foreground
                font.family: "Sans Serif"
                font.capitalization: Font.AllUppercase
            }

            OneSlot2{
                id: horizontalRotation
                from: -10
                to: 10
                step: 0.1
                leftImage: TRotation{id: leftHRotation; color: red; isVertical:false}
                rightImage: TRotation{id: rightHRotation; color: blue; isVertical:false}
                onLeftSignal: {
                    leftHRotation.value=value*step*7
                    anaglyph.setLeftTurn(value/step)
                }
                onRightSignal: {
                    rightHRotation.value=value*step*7
                    anaglyph.setRightTurn(value/step)
                }
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
