import QtQuick 2.0
import QtQuick.Controls.Material 2.3
import QtQuick.Controls 2.5
import QtQuick.Window 2.12

Item {
    id: finishPage

    property real fontPointSize: btStyle.uiFontPointSize

    function initPage() {
        console.log("finishedPage.initPage")
        bookshelfManager.changeButton("back", true);
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
        anchors.topMargin: Screen.pixelDensity * 1
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Screen.pixelDensity * 1
        verticalAlignment: Text.AlignVCenter
	    horizontalAlignment: Text.AlignHCenter
        text: qsTr("Done")
        wrapMode: Text.Wrap
        color: Material.foreground
        font.pointSize: finishPage.fontPointSize
    }

}
