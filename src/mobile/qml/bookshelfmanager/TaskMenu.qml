import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.3

Menu {
    id: taskMenu

    signal newSelected
    signal openSelected
    signal saveSelected

    width: parent.width
    visible: true
    background: Rectangle {
        implicitWidth: 200
        implicitHeight: 40
        color: Material.background
    }
    MenuItem {
        contentItem: Text {
            text: "New..."
            font: taskMenu.font
            color: Material.foreground
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
        }
        onTriggered: newSelected()
    }
    MenuItem {
        contentItem: Text {
            text: "Open..."
            font: taskMenu.font
            color: Material.foreground
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
        }
        onTriggered: openSelected()
    }
    MenuItem {
        contentItem: Text {
            text: "Save..."
            font: taskMenu.font
            color: Material.foreground
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
        }
        onTriggered: saveSelected()
    }
}
