import QtQuick 2.0
import QtQuick.Controls.Material 2.3
import QtQuick.Controls 2.5
import QtQuick.Window 2.12
import QtQuick.Controls 1.4

Item {
    id: updatingLibraries

    property font font: Qt.font({ family: "Helvetica", pointSize: 10, weight: Font.Normal })

    Text {
        id: text1

        anchors.left: parent.left
        anchors.leftMargin: Screen.pixelDensity * 4
        anchors.right: parent.right
        anchors.rightMargin: Screen.pixelDensity * 4
        anchors.top: parent.top
        anchors.topMargin: Screen.pixelDensity * 1
        text: qsTr("Choose one or more documents to update")
        wrapMode: Text.Wrap
        color: Material.foreground
        font: updatingLibraries.font
    }

    TreeView {
        id: treeView

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: text1.bottom
        anchors.topMargin: Screen.pixelDensity * 5
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Screen.pixelDensity * 5

    }

}
