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
                width: (parent.width-parent.spacing*2)/3
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
                width: (parent.width-parent.spacing*2)/3
                height: 40
                onClicked: {
                    timer.stop()
                }
            }

            Button{
                text: "Запись"
                width: (parent.width-parent.spacing*2)/3
                height: 40
                onClicked: {
                   сonsole.log("начать запись")
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

            OneSlot{
                id: angle
                from: -45
                to: 45
                step: anaglyph.getPrecision()
                leftImage: Angle{id: leftAngle; color: red}
                rightImage: Angle{id: rightAngle; color: blue}
                onLeftSignal: {
                    anaglyph.setLeftAngle(value)
                    leftImage.value=value*step
                }
                onRightSignal: {
                    anaglyph.setRightAngle(value)
                    rightAngle.value=value*step
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

            OneSlot{
                id: vertivalRotation
                from: -10
                to: 10
                step: anaglyph.getPrecision()
                leftImage: TRotation{id: leftRotation; color: red}
                rightImage: TRotation{id: rightRotation; color: blue}
                onLeftSignal: {
                    anaglyph.setLeftIncline(value)
                    leftRotation.value=value*step*7
                }
                onRightSignal: {
                    anaglyph.setRightIncline(value)
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

            OneSlot{
                id: horizontalRotation
                from: -10
                to: 10
                step: anaglyph.getPrecision()
                leftImage: TRotation{id: leftHRotation; color: red; isVertical:false}
                rightImage: TRotation{id: rightHRotation; color: blue; isVertical:false}
                onLeftSignal: {
                    leftHRotation.value=value*step*7
                    anaglyph.setLeftTurn(value)
                }
                onRightSignal: {
                    rightHRotation.value=value*step*7
                    anaglyph.setRightTurn(value)
                }
            }
        }
    }

    Item{
        width: (parent.width-control.width-parent.spacing)
        height: parent.height

        ImageDraw2{}

    }
}
