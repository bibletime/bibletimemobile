import QtQuick 2.0
import QtQuick.Controls.Material 2.3
import QtQuick.Controls 2.5
import QtQuick.Window 2.12

Item {
    id: installDocumentsPage

    property real fontPointSize: btStyle.uiFontPointSize

    function initPage() {
        console.log("installDocumentsPage.initPage")
        installInterface.installDocuments();
        installInterface.modulesDownloadFinished.disconnect(finishedDownload);
        installInterface.modulesDownloadFinished.connect(finishedDownload);
    }

    function donePage() {
    }

    function finishedDownload() {
        bookshelfManager.changeButton("back", true);
        bookshelfManager.changeButton("close", true);
        console.log("finished download");
        bookshelfPages.nextPage();
    }

    Text {
        id: text1

        anchors.left: parent.left
        anchors.leftMargin: Screen.pixelDensity * 4
        anchors.top: parent.top
        anchors.topMargin: Screen.pixelDensity * 1
        text: qsTr("Installing documents from remote libraries")
        color: Material.foreground
        font.pointSize: installDocumentsPage.fontPointSize
    }

    Text {
        id: status

        text: installInterface.progressText
        color: Material.foreground
        font.pointSize: installDocumentsPage.fontPointSize
        anchors.horizontalCenter: progressBar.horizontalCenter
        anchors.bottom: progressBar.top
        anchors.bottomMargin: Screen.pixelDensity * 1
    }

    ProgressBar {
        id: progressBar

        anchors.left: parent.left
        anchors.leftMargin: Screen.pixelDensity * 5
        anchors.rightMargin: Screen.pixelDensity * 5
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        from: installInterface.progressMin
        to: installInterface.progressMax
        value: installInterface.progressValue
        height: Screen.pixelDensity * 2

        contentItem: Rectangle {
            width:50
            height:50
            color: {
                if (Material.theme == Material.Light)
                    return "#d7d7d7"
                return "#323232"
            }

            opacity: 1

            Rectangle {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                width: parent.width * progressBar.visualPosition
                height: parent.height
                color: Material.accent

            }
        }
    }

    Button {
        id: stopButton

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: progressBar.bottom
        anchors.topMargin: Screen.pixelDensity * 1
        width: Screen.pixelDensity * 14
        text: qsTr("Stop")
        font.pointSize: installDocumentsPage.fontPointSize
        onClicked: installInterface.cancel()
        background: Rectangle {
            color: {
                if (Material.theme == Material.Light)
                    return "#d7d7d7"
                return "#323232"
            }

        }

        contentItem: Text {
            anchors.horizontalCenter: stopButton.horizontalCenter
            text: stopButton.text
            font.pointSize: installDocumentsPage.fontPointSize
            color: Material.accent
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
    }
}
