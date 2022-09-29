import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.3
import QtGraphicalEffects 1.0

Column {
    spacing: 10

    Row{
        width: parent.width
        height: implicitHeight
        spacing: 10

        ComboBox{
            id: cb1
            height: 50
            width: (parent.width-parent.spacing*3)/4
            model: camFinder.model
            currentIndex: -1
        }

        ComboBox{
            id: cb2
            height: 50
            width: (parent.width-parent.spacing*3)/4
            model: camFinder.model
            currentIndex: -1
        }

        Button{
            id: start
            text: "Старт"
            width: (parent.width-parent.spacing*3)/4
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
            width: (parent.width-parent.spacing*3)/4
            height: 50
            onClicked: {
                timer.stop()
            }
        }
    }

    Connections{
        target: videoProvider
        onImageChanged: im.reload()
    }



    Image{
        id: im
        width: 1920
        height: 1080
        cache: false
        smooth: true
        autoTransform: false
        fillMode: Image.PreserveAspectFit
        anchors.horizontalCenter: parent.horizontalCenter
        source: "image://mlive/image"
        function reload() {
            source= ""
            source = "image://mlive/image"
        }
    }

}
