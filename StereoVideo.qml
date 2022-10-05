import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.3
import QtGraphicalEffects 1.0

Row {
    spacing: 5

    Rectangle{
        id: controlMain
        width: 300*ratio
        height: parent.height
        color: background
        radius: 3

        Column{
            id: control
            anchors.fill: parent
            anchors.margins: 10
            spacing: 5

            Text {
                text: "Открыть видео"
                font.pointSize:_pointSize
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
                    font.pointSize: _pointSize*0.9
                    width: parent.width/2-5
                    model: camFinder.model
                    currentIndex: -1
                }

                ComboBox{
                    id: cb2
                    font.pointSize: _pointSize*0.9
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
                    text: "Стерео"
                    width: (parent.width-parent.spacing)/2
                    font.pointSize: _pointSize
                    onClicked: {
                        leftGrab.start(cb1.currentIndex)
                        rightGrab.start(cb2.currentIndex)
                        anaglyph.setBoth()
                        timer.start()
                    }
                }

                Button{
                    id: stop
                    text: "Стоп"
                    width: (parent.width-parent.spacing)/2
                    font.pointSize: _pointSize
                    onClicked: {
                        timer.stop()
                        leftGrab.stop()
                        rightGrab.stop();
                    }
                }
            }

            Row{
                width: parent.width
                height: implicitHeight
                spacing: 10

                Button{
                    id: snapshot
                    text: "СКРИН"
                    width: (parent.width-parent.spacing)/2
                    font.pointSize: _pointSize
                    onClicked: {
                        saveDialog.title="Сохранить стерео"
                        saveDialog.open()
                    }
                }

                Button{
                    id: record
                    text:  writer.isRecord?   "СТОП" :  "ЗАПИСЬ"
                    font.pointSize: _pointSize
                    width: (parent.width-parent.spacing)/2
                    onClicked: {
                        writer.isRecord? writer.stop() : writeDialog.open()
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
                font.pointSize: _pointSize
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
                 //   height: 40*ratio
                    font.pointSize: _pointSize
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
                 //   height: 40*ratio
                    font.pointSize: _pointSize
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
                  //  height: 40*ratio
                    font.pointSize: _pointSize
                    onClicked: {
                        leftGrab.start(-1)
                        rightGrab.start(-1)
                        timer.start()
                    }
                }

                Button{
                    text: "Стоп"
                    width: parent.width/2-5
                 //   height: 40*ratio
                    font.pointSize: _pointSize
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
                    font.pointSize: _pointSize
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
                    text: "Поворот не туда"
                    font.pointSize: _pointSize
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
                    font.pointSize: _pointSize
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
                    font.pointSize: _pointSize
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

            Rectangle{
                width: parent.width
                height: 3
                color: foreground
                opacity: 0.5
            }

            Text {
                text: "Фокусировка"
                font.pointSize: _pointSize
                color: foreground
                font.family: "Sans Serif"
                font.capitalization: Font.AllUppercase
            }

            Row{
                width: parent.width
                height: implicitHeight
                spacing: 10

                Button{
                    text: "Левая"
                    width: parent.width/2-5
                //    height: 40*ratio
                    font.pointSize: _pointSize
                    onClicked: {
                        leftGrab.start(cb1.currentIndex)
                        anaglyph.setOnlyOne(true,true)
                        timer.start()
                    }
                }

                Button{
                    text: "Правая"
                    width: parent.width/2-5
                //    height: 40*ratio
                    font.pointSize: _pointSize
                    onClicked: {
                        rightGrab.start(cb2.currentIndex)
                        anaglyph.setOnlyOne(true,false)
                        timer.start()
                    }
                }
            }
        }
    }

    Column{
        width: (parent.width-control.width-parent.spacing)
        height: parent.height
        spacing: 5

        Rectangle{
            id: buttons
            width: parent.width
            height: some.height+20
            radius: 3
            color: background

            Row{
                anchors.fill: parent
                anchors.margins: 10
                spacing: 5

                Button{
                    id: some
                    text: imDraw.redactorEnable? "Стоп" :"Старт"
                    width: 100*ratio
                    font.pointSize: _pointSize
                    onClicked: imDraw.redactorEnable=!imDraw.redactorEnable
                }

                Button{
                    text: "Убрать"
                    width: 100*ratio
                    font.pointSize: _pointSize
                    onClicked: imDraw.clear()
                }
            }
        }

        Connections{
            target: videoProvider
            onImageChanged: im.reload()
        }

        Item{
            width: parent.width
            height: parent.height-buttons.height
            Rectangle{
                anchors.fill: parent
                color: primary
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
                ImageDraw{
                    id: imDraw
                }
            }
            MouseArea{
                property bool fullscreen: false
                anchors.fill: im
                onDoubleClicked: {
                    fullscreen=!fullscreen
                    controlMain.width=fullscreen? 0 : 300*ratio
                    buttons.height=fullscreen? 0: some.height+20
                    appWindow.visibility=fullscreen? ApplicationWindow.FullScreen : ApplicationWindow.Windowed
                }
            }
        }
    }
}
