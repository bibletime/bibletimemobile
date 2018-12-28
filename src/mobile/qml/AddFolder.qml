/*********
*
* In the name of the Father, and of the Son, and of the Holy Spirit.
*
* This file is part of BibleTime's source code, http://www.bibletime.info/.
*
* Copyright 1999-2014 by the BibleTime developers.
* The BibleTime source code is licensed under the GNU General Public License
* version 2.0.
*
**********/

import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import BibleTime 1.0

Rectangle {
    id: addFolder

    property string parentFolderName: ""

    signal showFolders()
    signal folderAdd(string folderName)
    signal folderWasAdded()

    color: btStyle.textBackgroundColor
    anchors.fill: parent

    onVisibleChanged: {
        keyReceiver.forceActiveFocus();
    }

    BtStyle {
        id: btStyle
    }

    Rectangle {
        id: titleRect

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: titleText.contentHeight * 1.4
        color: btStyle.toolbarColor
        border.color: btStyle.toolbarTextColor
        border.width: 2

        Text {
            id: titleText

            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin:btStyle.pixelsPerMillimeterX * 3
            text: qsTranslate("Bookmarks", "New Folder")
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: btStyle.uiFontPointSize + 4
            color: btStyle.toolbarTextColor
        }
    }

    Text {
        id: folderLabel

        text: qsTranslate("Bookmarks", "Folder Name") +  ":"
        anchors.bottom: folderRect.top
        anchors.bottomMargin: btStyle.pixelsPerMillimeterX * 2
        anchors.left: parent.left
        anchors.leftMargin: btStyle.pixelsPerMillimeterX *2
        height: btStyle.pixelsPerMillimeterY * 6
        verticalAlignment: TextEdit.AlignVCenter
        font.pointSize: btStyle.uiFontPointSize
        color: btStyle.textColor
    }

    Rectangle {
        id: folderRect

        height: folderLabel.contentHeight * 2.8
        anchors.bottom: parentFolderLabel.top
        anchors.bottomMargin: btStyle.pixelsPerMillimeterX * 10
        anchors.left: parent.left
        anchors.leftMargin: btStyle.pixelsPerMillimeterX * 8
        anchors.right: parent.right
        anchors.rightMargin: btStyle.pixelsPerMillimeterX * 5
        color: btStyle.textBackgroundColor
        border.color: btStyle.textColor
        border.width: 2

        TextField {
            id: textEdit

            text: ""
            anchors.top: parent.top
            anchors.topMargin: btStyle.pixelsPerMillimeterX * 2
            anchors.left: parent.left
            anchors.leftMargin: btStyle.pixelsPerMillimeterX * 2
            anchors.right: parent.right
            inputMethodHints: Qt.ImhNoPredictiveText
            verticalAlignment: Text.AlignVCenter
            font.pointSize: btStyle.uiFontPointSize
            focus: true
        }
    }

    Text {
        id: parentFolderLabel

        anchors.left: parent.left
        anchors.leftMargin:btStyle.pixelsPerMillimeterX * 2
        anchors.bottom: parentFolderRect.top
        anchors.bottomMargin: btStyle.pixelsPerMillimeterX * 2
        text: qsTranslate("Bookmarks", "Parent folder") + ":"
        horizontalAlignment: Text.AlignHCenter
        font.pointSize: btStyle.uiFontPointSize
        color: btStyle.textColor
    }

    Rectangle {
        id: parentFolderRect

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        height: folderRect.height
        anchors.leftMargin:btStyle.pixelsPerMillimeterX * 8
        anchors.rightMargin:btStyle.pixelsPerMillimeterX * 5
        anchors.topMargin: 10
        border.color: btStyle.textColor
        border.width: 2
        color: btStyle.textBackgroundColor

        Text {
            id: parentFolder

            text: addFolder.parentFolderName
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 10
            font.pointSize: btStyle.uiFontPointSize
            color: btStyle.textColor
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                showFolders();
            }
        }
    }

    Grid {
        id: buttons

        spacing: btStyle.pixelsPerMillimeterY * 4
        columns: 2
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parentFolderRect.bottom
        anchors.topMargin: btStyle.pixelsPerMillimeterX * 12

        BtButton {
            text: qsTr("Ok")
            onClicked: {
                addFolder.visible = false;
                addFolder.folderAdd(textEdit.text);
                addFolder.folderWasAdded();
            }
        }

        BtButton {
            text: qsTr("Cancel")
            onClicked: {
                addFolder.visible = false;
            }
        }
    }
}
