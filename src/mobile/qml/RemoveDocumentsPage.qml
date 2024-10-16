import QtQuick 2.0
import QtQuick.Controls.Material 2.3
import QtQuick.Controls 2.5
import QtQuick.Window 2.12

Item {
    id: removeDocumentsPage

    property real fontPointSize: btStyle.uiFontPointSize

    function initPage() {
        console.log("removeDocumentsPage.initPage")
        installInterface.initializeRemoveDocumentsModel();
        installInterface.filterWorksByCategory("");
        bookshelfManager.changeButton("back", true);
        bookshelfManager.changeButton("remove", true);
        bookshelfManager.changeButton("close", true);
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
        font.pointSize: removeDocumentsPage.fontPointSize
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

            height: {
                var pixel = btStyle.pixelsPerMillimeterY * 11;
                var uiFont = chooseDocumentPage.fontPointSize * 3;
                var uiText = checkDelegate.height + info.contentHeight;
                return Math.max(pixel, uiFont, uiText);
            }
            width: removeWorksListView.width

            CheckDelegate {
                id: checkDelegate

                text: moduleName
                anchors.left:  parent.left
                anchors.leftMargin: Screen.pixelDensity * 1
                anchors.right: parent.right
                anchors.rightMargin: Screen.pixelDensity * 1
                anchors.top: parent.top
                font.pointSize: removeDocumentsPage.fontPointSize
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
                font.pointSize: removeDocumentsPage.fontPointSize
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
                font.pointSize: removeDocumentsPage.fontPointSize
                elide: Text.ElideRight
            }
        }
    }
}
