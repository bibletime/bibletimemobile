import QtQuick 2.0
import QtQuick.Controls.Material 2.3
import QtQuick.Controls 2.5
import QtQuick.Window 2.12
import QtQuick.Controls 1.4

Item {
    id: removeDocumentsPage

    property font font: Qt.font({ family: "Helvetica", pointSize: 10, weight: Font.Normal })

    function initPage() {
        installInterface.initializeRemoveDocumentsModel();
        console.log(removeWorksListView.height, removeWorksListView.width)
        installInterface.filterWorksByCategory("");
        bookshelfManager.changeButton("back", false);
        bookshelfManager.changeButton("next", false);
        bookshelfManager.changeButton("install", false);
        bookshelfManager.changeButton("finish", true);
        bookshelfManager.changeButton("close", false);
        bookshelfManager.changeButton("cancel", true);
    }

    function donePage() {
        installInterface.finishRemovingDocuments();
    }


    Text {
        id: text1

        anchors.left: parent.left
        anchors.leftMargin: Screen.pixelDensity * 4
        anchors.right: parent.right
        anchors.rightMargin: Screen.pixelDensity * 4
        anchors.top: parent.top
        anchors.topMargin: Screen.pixelDensity * 1
        text: qsTr("Choose documents to remove")
        wrapMode: Text.Wrap
        color: Material.foreground
        font: removeDocumentsPage.font
    }

    ListView {
        id: removeWorksListView

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: text1.bottom
        anchors.topMargin: Screen.pixelDensity * 1.0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Screen.pixelDensity * 1.0
        clip: true
        model: installInterface.documentsSortFilterModel
        delegate: Item {
            id: iDelegate

            height: Screen.pixelDensity * 12
            width: removeWorksListView.width

            CheckDelegate {
                id: checkDelegate

                text: moduleName
                anchors.left:  parent.left
                anchors.leftMargin: Screen.pixelDensity * 1
                anchors.right: parent.right
                anchors.rightMargin: Screen.pixelDensity * 1
                anchors.top: parent.top
                font: removeDocumentsPage.font
                checked: installChecked
                onCheckedChanged: {
                    installChecked = checked;
                }
            }

            Text {
                id: info
                anchors.left:  parent.left
                anchors.leftMargin: Screen.pixelDensity * 6
                anchors.right: parent.right
                anchors.rightMargin: Screen.pixelDensity * 3
                anchors.top: checkDelegate.bottom
                anchors.topMargin: -Screen.pixelDensity * 2
                color: Material.foreground
                text: description
                font: removeDocumentsPage.font
                elide: Text.ElideRight
            }

            Text {
                id: versionText
                anchors.left:  parent.left
                anchors.leftMargin: removeWorksListView.width * 0.65
                anchors.right: parent.right
                anchors.rightMargin: Screen.pixelDensity * 3
                anchors.verticalCenter: checkDelegate.verticalCenter
                anchors.topMargin: -Screen.pixelDensity * 2
                color: Material.foreground
                text: version
                font: removeDocumentsPage.font
                elide: Text.ElideRight
            }
        }
    }
}
