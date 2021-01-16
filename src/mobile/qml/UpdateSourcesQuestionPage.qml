import QtQuick 2.0
import QtQuick.Controls.Material 2.3
import QtQuick.Controls 2.5
import QtQuick.Window 2.12
//import QtQuick.Controls 1.4

Item {
    id: updatingLibraries

    property alias update: checkBox.checked
    property real fontPointSize: btStyle.uiFontPointSize

    function initPage() {
        bookshelfManager.changeButton("back", true);
        bookshelfManager.changeButton("next", true);
        bookshelfManager.changeButton("install", false);
        bookshelfManager.changeButton("finish", false);
        bookshelfManager.changeButton("close", false);
        bookshelfManager.changeButton("cancel", true);
    }

    function donePage() {

    }

    Text {
        id: text1

        anchors.left: parent.left
        anchors.leftMargin: Screen.pixelDensity * 4
        anchors.right: parent.right
        anchors.rightMargin: Screen.pixelDensity * 4
        anchors.top: parent.top
        anchors.topMargin: Screen.pixelDensity * 1
        text: qsTr("Do you want to update the list of documents from remote libraries?")
        wrapMode: Text.Wrap
        color: Material.foreground
        font.pointSize: updateSourcesQuestionPage.fontPointSize
    }

    CheckBox {
        id: checkBox

        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: Screen.pixelDensity * 4
        text: qsTr("Update from remote libraries")
        font.pointSize: updateSourcesQuestionPage.fontPointSize
    }


}
