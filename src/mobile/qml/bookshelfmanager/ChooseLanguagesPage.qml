import QtQuick 2.0
import QtQuick.Controls.Material 2.3
import QtQuick.Controls 2.5
import QtQuick.Window 2.12

Item {
    id: updatingLibraries

    property font font: Qt.font({ family: "Helvetica", pointSize: 10, weight: Font.Normal })

    function initPage() {
        installInterface.initializeLanguagesModel();
        listView.positionViewAtIndex(installInterface.indexOfFirstLanguageChecked,ListView.Beginning)
        bookshelfManager.changeButton("back", true);
        bookshelfManager.changeButton("next", true);
        bookshelfManager.changeButton("install", false);
        bookshelfManager.changeButton("finish", false);
        bookshelfManager.changeButton("close", false);
        bookshelfManager.changeButton("cancel", true);
    }

    function donePage() {
        installInterface.finishChoosingLanguages();
    }

    Text {
        id: text1

        anchors.left: parent.left
        anchors.leftMargin: Screen.pixelDensity * 4
        anchors.right: parent.right
        anchors.rightMargin: Screen.pixelDensity * 4
        anchors.top: parent.top
        anchors.topMargin: Screen.pixelDensity * 1
        text: qsTr("Choose one or more languages to install documents from.")
        wrapMode: Text.Wrap
        color: Material.foreground
        font: updatingLibraries.font
    }

    ListView {
        id: listView
        anchors.left: parent.left
        anchors.leftMargin: Screen.pixelDensity * 8
        anchors.right: parent.right
        anchors.top: text1.bottom
        anchors.topMargin: Screen.pixelDensity * 5
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Screen.pixelDensity * 5
        clip: true
        model: installInterface.languageModel2
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
                font: updatingLibraries.font
                onToggled: {
                    checked2 = checked;
                }
            }
        }
    }
}
