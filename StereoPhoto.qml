import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.3
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.3
import QtGraphicalEffects 1.0

Column {
    property string _lastfolder: openDialog.shortcuts.home
    spacing: 10
    property var hello

    FileDialog {
        id: openDialog
        property bool left
        title: "Открыть файл"
        folder: _lastfolder
        nameFilters: [ "Image files (*.bmp *.jpg *.png)"  ]
        onAccepted: {
            imagePro.openFile(fileUrl,left)
            _lastfolder=fileUrl
        }
    }

    FileDialog {
        id: openDialog1
        property bool left
        title: "Открыть файл"
        folder: _lastfolder
        nameFilters: [ "Image files (*.bmp *.jpg *.png)"  ]
        onAccepted: {
            imagePro.loadDouble(fileUrl)
            _lastfolder=fileUrl
        }
    }

    Row{
        width: parent.width
        height: implicitHeight
        spacing: 10

        Button{
            id: leftOpen
            text: "Левое изображение"
            width: (parent.width-parent.spacing*3)/4
            height: 50
            onClicked: {
                openDialog.title="Открыть левое изображение"
                openDialog.left=true
                openDialog.open()
            }
        }

        Button{
            id: rightOpen
            text: "Правое изображение"
            width: (parent.width-parent.spacing*3)/4
            height: 50
            onClicked: {
                openDialog.title="Открыть правое изображение"
                openDialog.left=false
                openDialog.open()
            }
        }

        Button{
            id: gogo
            enabled: imagePro.ready
            text: "Собрать"
            width: (parent.width-parent.spacing*3)/4
            height: 50
            onClicked: {
                imagePro.start()
            }
        }

        Button{
            id: split
            text: "Разделить"
            width: (parent.width-parent.spacing*3)/4
            height: 50
            onClicked: {
                openDialog1.open()
            }
        }
    }

    Connections{
        target: stereoProvider
        onImageChanged: im.reload()
    }

    Image{
        id: im
        width: 1920/2//565
        height: 1080/2//848
        cache: false
        smooth: true
        autoTransform: false
        fillMode: Image.PreserveAspectFit
        anchors.horizontalCenter: parent.horizontalCenter
        source: "image://mlive3/image"
        function reload() {
            source= ""
            source = "image://mlive3/image"
        }
    }


}
