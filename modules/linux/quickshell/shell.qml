import Quickshell
import Quickshell.Wayland
import QtQuick

PanelWindow {
    anchors.top: true
    anchors.left: true
    anchors.right: true
    implicitHeight: 30
    color: "#0F111A"

    Text {
        anchors.centerIn: parent
        text: "My First Bar"
        color: "#A6ACCD"
        font.pixelSize: 14
    }
}
