import QtQuick 2.0
import QtQuick.Window 2.2
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.3
import QtGraphicalEffects 1.0

Column{
    spacing: 10

    Row{
        width: parent.width
        height: implicitHeight
        spacing: 10

        Button{
            id: rec
            text: "Запись"
            width: (parent.width-parent.spacing)/2
            height: 50
            onClicked: {
                first.startRec()
                second.startRec()
            }
        }

        Button{
            id: stop
            text: "Стоп"
            width: (parent.width-parent.spacing)/2
            height: 50
            onClicked: {
                first.stopRec()
                second.stopRec()
            }
        }
    }

    Row{
        width: parent.width
        height: implicitHeight
        spacing: 10

        OneRec{
            id: first
            width: (parent.width-parent.spacing)/2
            height: implicitHeight
            grabber: grabber1
            provider: provider1
            source: "image://mlive1/image"
        }

        OneRec{
            id:second
            width: (parent.width-parent.spacing)/2
            height: implicitHeight
            grabber: grabber2
            provider: provider2
            source: "image://mlive2/image"
        }
    }
}



