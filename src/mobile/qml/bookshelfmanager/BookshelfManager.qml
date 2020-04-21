import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.3
import QtQuick.Layouts 1.12
import QtQuick.Window 2.12

Dialog {
    id: bookshelfManager

    //property font font: Qt.font({ family: "Helvetica", pointSize: 10, weight: Font.Normal })

    modal: true
    width: parent.width
    height: parent.height
    leftPadding: 0
    rightPadding: 0
    topPadding: 0
    bottomPadding: 0
    onAboutToShow: {
        pages.initialize();
    }

    Rectangle {
        id: bookshelfHeader

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: Screen.pixelDensity * 8
        color: Material.background

        Text {
            id: text0

            anchors.left: parent.left
            anchors.leftMargin: Screen.pixelDensity * 2
            anchors.right: parent.right
            anchors.rightMargin: Screen.pixelDensity * 2
            anchors.verticalCenter: parent.verticalCenter
            color: Material.accent
            font.pointSize: bookshelfManager.font.pointSize + 1
            text: "Bookshelf Manager"
        }

        Rectangle {
            id: spacer1

            anchors.bottom: parent.bottom
            anchors.left: text0.left
            anchors.right: text0.right
            height: 1
            color: Material.accent
        }
    }

    BookshelfManagerPages {
        id: pages

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: bookshelfHeader.bottom
        anchors.bottom: bookshelfFooter.top
        font: bookshelfManager.font
        onBeginPage: {
            backButton.visible = false;
            nextButton.visible = true;
            finishButton.visible = false;
            finishButton.width = 0;
            installButton.visible = false;
            installButton.width = 0;
        }
        onNormalPage: {
            backButton.visible = true;
            nextButton.visible = true;
            finishButton.visible = false;
            installButton.visible = false;
        }
        onFinishPage: {
            backButton.visible = true;
            nextButton.visible = false;
            finishButton.visible = true;
            installButton.visible = false;
        }
        onInstallPage: {
            backButton.visible = true;
            nextButton.visible = false;
            finishButton.visible = false;
            installButton.visible = true;
        }
    }

    Rectangle {
        id: bookshelfFooter

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: Screen.pixelDensity * 12
        color: Material.background

        Rectangle {
            id: spacer2

            anchors.top: parent.top
            anchors.left: parent.left
            anchors.leftMargin: Screen.pixelDensity * 2
            anchors.right: parent.right
            anchors.rightMargin: Screen.pixelDensity * 2
            height: 1
            color: Material.accent
        }

        RowLayout {
            anchors.right: parent.right
            anchors.rightMargin: Screen.pixelDensity * 4
            anchors.verticalCenter: parent.verticalCenter
            spacing: Screen.pixelDensity * 2

            Button {
                id: backButton

                text: "< " + qsTr("Back")
                font: bookshelfManager.font
                onClicked: pages.prevPage();
            }

            Button {
                id: nextButton

                text: qsTr("Next") + " >"
                font: bookshelfManager.font
                onClicked: pages.nextPage()
            }

            Button {
                id: installButton

                text: qsTr("Install")
                font: bookshelfManager.font
                onClicked: pages.installButtonPressed()
            }

            Button {
                id: finishButton

                text: qsTr("Finish") + " >"
                font: bookshelfManager.font
                onClicked: pages.finishPage()
            }

            Button {
                id: cancelButton

                text: qsTr("Cancel")
                font: bookshelfManager.font
                onClicked: bookshelfManager.done(Dialog.Rejected)

            }
        }
    }
}
