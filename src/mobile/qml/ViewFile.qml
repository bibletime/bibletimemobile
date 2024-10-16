/*********
*
* In the name of the Father, and of the Son, and of the Holy Spirit.
*
* This file is part of BibleTime's source code, http://www.bibletime.info/.
*
* Copyright 1999-2016 by the BibleTime developers.
* The BibleTime source code is licensed under the GNU General Public License
* version 2.0.
*
**********/

import QtQuick 2.11
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.3
import QtQuick.Window 2.12
import BibleTime 1.0

Rectangle {
    id: viewFile

    property string filename: ""

    color: Material.background
    anchors.fill: parent

    function open(filename) {
        visible = true;
        logFileInterface.setSource(filename);
        fileViewer.text = logFileInterface.contents;
    }

    FileInterface {
        id: logFileInterface
    }

    BtStyle {
        id: btStyle
    }

    Rectangle {
        id: viewFileTitleBar
        color: Material.background
        width: parent.width
        height: btStyle.pixelsPerMillimeterY * 7

        Back {
            id: backTool

            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            text: "Debug"
            onClicked: {
                viewFile.visible = false;
                debugDialog.visible = true;
            }
        }
    }

    Flickable {

        anchors.left: parent.left
        anchors.leftMargin: btStyle.pixelsPerMillimeterX
        anchors.top: viewFileTitleBar.bottom
        anchors.right: parent.right
        anchors.bottom: viewerFooter.top
        clip: true
        contentHeight: fileViewer.height

        Text {
            id: fileViewer

            width: parent.width
            wrapMode: Text.Wrap
            font.pointSize: btStyle.uiFontPointSize -1
            color: Material.foreground
        }
    }

    Rectangle {
        id: viewerFooter

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

        Button {
            id: copyButton

            anchors.right: parent.right
            anchors.rightMargin: Screen.pixelDensity * 5
            anchors.bottom: parent.bottom
            anchors.bottomMargin: Screen.pixelDensity * 2
            text: qsTr("Copy")
            onClicked: {
                console.log("copying");
                logFileInterface.copyToClipboard(logFileInterface.contents);
            }
        }
    }

    Keys.onReleased: {
        if ((event.key === Qt.Key_Back || event.key === Qt.Key_Escape) && viewFile.visible === true) {
            viewFile.visible = false;
            debugDialog.visible = true;
            event.accepted = true;
        }
    }
}
