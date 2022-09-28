import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.3
import QtGraphicalEffects 1.0

Column{
    id: root
    height: implicitHeight
    spacing: 10

    property var grabber
    property var provider
    property var source: "hello"
    function startRec() {
        grabber.rec("olikke")
    }

    function stopRec() {
        grabber.play(cb1.currentIndex)
    }

    Row{
        width: parent.width
        height: implicitHeight
        spacing: 10

        Button{
            text: "Включить"
            height: 50
            width: (parent.width-parent.spacing)/2
            onClicked: root.grabber.play(cb1.currentIndex)
        }

        ComboBox{
            id: cb1
            height: 50
            width: (parent.width-parent.spacing)/2
            model: root.grabber.allDevice()
        }
    }

    Connections{
        target: provider
        onImageChanged: im.reload()
    }

    Image{
        id: im
        width: parent.width
        height: width/1920*1080
        cache: false
        smooth: true
        autoTransform: false
        fillMode: Image.PreserveAspectFit
        source: root.source
        function reload() {
            source= ""
            source = root.source
        }
    }


}
