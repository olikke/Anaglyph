import QtQuick 2.11
import QtQuick.Window 2.2
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.3
import QtGraphicalEffects 1.0
import "."

Window {
    visible: true
    width: 1200
    height: 800
    color: primary
    title: qsTr("Hello World")

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
