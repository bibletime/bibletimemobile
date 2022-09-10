import QtQuick 2.0
import QtQuick.Controls.Material 2.3
import QtQuick.Controls 2.5
import QtQuick.Window 2.12

Item {
    id: chooseSourcesPage

    property real fontPointSize: btStyle.uiFontPointSize

    function initPage() {
        installInterface.initializeSourcesModel();
        bookshelfManager.changeButton("back", true);
        bookshelfManager.changeButton("next", true);
        bookshelfManager.changeButton("install", false);
        bookshelfManager.changeButton("finish", false);
        bookshelfManager.changeButton("close", false);
        bookshelfManager.changeButton("cancel", true);
    }

    function donePage() {
        installInterface.finishChoosingLibraries();
    }

    Text {
        id: text1

        anchors.left: parent.left
        anchors.leftMargin: Screen.pixelDensity * 4
        anchors.right: parent.right
        anchors.rightMargin: Screen.pixelDensity * 4
        anchors.top: parent.top
        anchors.topMargin: Screen.pixelDensity * 1
        text: qsTr("Choose one or more remote libraries to install documents from.")
        wrapMode: Text.Wrap
        color: Material.foreground
        font.pointSize: chooseSourcesPage.fontPointSize
    }

    ListView {
        id: listView
        anchors.left: parent.left
        anchors.leftMargin: Screen.pixelDensity * 3
        anchors.right: parent.right
        anchors.rightMargin: Screen.pixelDensity * 3
        anchors.top: text1.bottom
        anchors.topMargin: Screen.pixelDensity * 5
        anchors.bottom: addButton.top
        anchors.bottomMargin: Screen.pixelDensity * 5

        model: installInterface.sourceModel2
        spacing: btStyle.pixelsPerMillimeterX * 2
        clip: true
        delegate: Rectangle {
            id: d

            width: listView.width
            height: Screen.pixelDensity * 7
            color: Material.background

            CheckDelegate {
                id: checkBox
                anchors.left: d.left
                anchors.right: d.right
                anchors.verticalCenter: d.verticalCenter
                text: modelText
                checked: checked2
                font.pointSize: chooseSourcesPage.fontPointSize
                onToggled: {
                    checked2 = checked;
                }
            }
        }
    }

    BtmButton {
        id: addButton
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Screen.pixelDensity * 2
        anchors.left: parent.left
        anchors.leftMargin: Screen.pixelDensity * 5
        text: qsTr("Add Library")
        onClicked: {
            remoteLibraryDialog.open()
        }
    }
}
