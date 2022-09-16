import QtQuick 2.0
import QtQuick.Controls.Material 2.3
import QtQuick.Controls 2.5
import QtQuick.Window 2.12

Item {
    id: chooseLanguagesPage

    property real fontPointSize: btStyle.uiFontPointSize

    function initPage() {
        console.log("chooseLanguagesPage.initPage")
        installInterface.initializeLanguagesModel();
        listView.positionViewAtIndex(installInterface.indexOfFirstLanguageChecked,ListView.Beginning)
        bookshelfManager.changeButton("back", true);
        bookshelfManager.changeButton("next", true);
        bookshelfManager.changeButton("close", true);
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
        font.pointSize: chooseLanguagesPage.fontPointSize
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
                font.pointSize: chooseLanguagesPage.fontPointSize
                onToggled: {
                    checked2 = checked;
                }
            }
        }
    }
}
