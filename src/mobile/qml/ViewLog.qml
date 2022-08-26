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
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.3
import QtQuick.Dialogs 1.2
import BibleTime 1.0

Rectangle {
    id: viewLog

    color: Material.background
    anchors.fill: parent

    function open() {
        console.log("viewLog")
        visible = true;
    }

    BtStyle {
        id: btStyle
    }

    Rectangle {
        id: viewLogTitleBar
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
                viewLog.visible = false;
                debugDialog.visible = true;
            }
        }
    }

    ScrollView {
        id: view
        anchors.left: parent.left
        anchors.leftMargin: Screen.pixelDensity * 3
        anchors.right: parent.right
        anchors.rightMargin: Screen.pixelDensity * 1
        anchors.bottom: parent.bottom
        anchors.top: viewLogTitleBar.bottom
        contentWidth: width

        TextArea {
            text: "\n...\n...\nTextArea\n...\n...\n...\n...\n...\n...\n"
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
