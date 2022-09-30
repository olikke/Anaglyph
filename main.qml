import QtQuick 2.11
import QtQuick.Window 2.2
import QtQuick.Controls 2.4
import QtQuick.Dialogs 1.3
import QtQuick.Controls.Material 2.3
import QtGraphicalEffects 1.0
import "."

Window {
    visible: true
    width: Screen.width
    height: Screen.height
    color: primary
    title: "ANAGLYPH"

    Component.onCompleted: {
        Material.theme=Material.Dark
        Material.accent=accent
    }

    property string background: "#2d2d2d"
    property string primary: "#474747"
    property string accent: "#039be5"
    property string foreground: "#f7f7f7"
    property int oneHeight: 40
    property int devNumb: 0
    property string _lastfolder: openDialog.shortcuts.home

    FileDialog {
        id: openDialog
        property bool left
        title: "Открыть файл"
        folder: _lastfolder
        nameFilters: [ "Image files (*.bmp *.jpg *.png *.jpeg)"  ]
        onAccepted: {
            left? leftGrab.photoName(fileUrl) : rightGrab.photoName(fileUrl)
            _lastfolder=fileUrl
        }
    }

    SwipeView{
        currentIndex: 0
        anchors.fill: parent
        anchors.margins: 10

        StereoVideo{

        }

        StereoPhoto{

        }
    }
}
