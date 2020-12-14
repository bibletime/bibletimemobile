import QtQuick 2.0
import QtQuick.Controls.Material 2.3
import QtQuick.Controls 2.5
import QtQuick.Window 2.12
import QtQuick.Controls 1.4

Item {
    id: updateDocumentsPage

    property font font: Qt.font({ family: "Helvetica", pointSize: 10, weight: Font.Normal })

    function initPage() {
        console.log(" updateDocumentsPage init")
        installInterface.initializeUpdateDocumentsModel();
        bookshelfManager.changeButton("back", false);
        bookshelfManager.changeButton("next", false);
        bookshelfManager.changeButton("install", false);
        bookshelfManager.changeButton("finish", false);
        bookshelfManager.changeButton("close", false);
        bookshelfManager.changeButton("cancel", false);
        installInterface.modulesDownloadFinished.disconnect(finishedDownload);
        installInterface.modulesDownloadFinished.connect(finishedDownload);
    }

    function donePage() {
        console.log(" updateDocumentsPage done")
        installInterface.finishChoosingDocuments();
    }


    function finishedDownload() {
        console.log(" updateDocumentsPage finish")
        bookshelfManager.changeButton("back", true);
        bookshelfManager.changeButton("next", true);
    }

    Text {
        id: text1

        anchors.left: parent.left
        anchors.leftMargin: Screen.pixelDensity * 4
        anchors.right: parent.right
        anchors.rightMargin: Screen.pixelDensity * 4
        anchors.top: parent.top
        anchors.topMargin: Screen.pixelDensity * 1
        text: qsTr("Choose documents to update")
        wrapMode: Text.Wrap
        color: Material.foreground
        font: removeDocumentsPage.font
    }

    ListView {
        id: updateWorksListView

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
            width: updateWorksListView.width

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
                anchors.leftMargin: updateWorksListView.width * 0.65
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
