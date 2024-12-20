import QtQuick 2.0
import QtQuick.Controls.Material 2.3
import QtQuick.Controls 2.5
import QtQuick.Window 2.12

Item {
    id: updateDocumentsPage

    property real fontPointSize: btStyle.uiFontPointSize

    function initPage() {
        console.log("updateDocumentsPage.initPage")
        installInterface.initializeUpdateDocumentsModel();
        bookshelfManager.changeButton("back", true);
        bookshelfManager.changeButton("install", true);
        bookshelfManager.changeButton("close", true);
        installInterface.modulesDownloadFinished.disconnect(finishedDownload);
        installInterface.modulesDownloadFinished.connect(finishedDownload);
    }

    function donePage() {
        installInterface.finishChoosingDocuments();
    }


    function finishedDownload() {
        bookshelfManager.changeButton("back", true);
        bookshelfManager.changeButton("close", true);
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
        font.pointSize: updateDocumentsPage.fontPointSize
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

            height: {
                var pixel = btStyle.pixelsPerMillimeterY * 11;
                var uiFont = chooseDocumentPage.fontPointSize * 3;
                var uiText = checkDelegate.height + info.contentHeight;
                return Math.max(pixel, uiFont, uiText);
            }
            width: updateWorksListView.width

            CheckDelegate {
                id: checkDelegate

                text: moduleName
                anchors.left:  parent.left
                anchors.leftMargin: Screen.pixelDensity * 1
                anchors.right: parent.right
                anchors.rightMargin: Screen.pixelDensity * 1
                anchors.top: parent.top
                font.pointSize: updateDocumentsPage.fontPointSize
                checked: installChecked
            }

            Text {
                id: info
                anchors.left:  parent.left
                anchors.leftMargin: Screen.pixelDensity * 6
                anchors.right: parent.right
                anchors.rightMargin: Screen.pixelDensity * 3
                anchors.top: checkDelegate.bottom
                anchors.topMargin: -Screen.pixelDensity * 2.5
                color: Material.foreground
                text: description
                wrapMode: Text.Wrap
                font.pointSize: updateDocumentsPage.fontPointSize
                elide: Text.ElideRight
            }

            Text {
                id: versionText
                anchors.left:  parent.left
                anchors.leftMargin: updateWorksListView.width * 0.65
                anchors.right: parent.right
                anchors.rightMargin: Screen.pixelDensity * 6
                anchors.verticalCenter: checkDelegate.verticalCenter
                anchors.topMargin: -Screen.pixelDensity * 2
                color: Material.foreground
                text: version
                font.pointSize: updateDocumentsPage.fontPointSize
                elide: Text.ElideRight
            }
        }
    }
}
