import QtQuick 2.0
import QtQuick.Controls.Material 2.3
import QtQuick.Controls 2.5
import QtQuick.Window 2.12

Item {
    id: updatingLibraries

    property alias update: checkBox.checked
    property real fontPointSize: btStyle.uiFontPointSize

    function initPage() {
        console.log("updateSourcesQuestionPage.initPage");
        checkBox.checked = false;
        bookshelfManager.changeButton("back", true);
        bookshelfManager.changeButton("next", true);
        bookshelfManager.changeButton("close", true);
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
        anchors.topMargin: Screen.pixelDensity * 5
        text: qsTr("Do you want to update the list of documents available from remote libraries?")
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
