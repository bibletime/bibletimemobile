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
import QtQuick.Controls.Material 2.3
import QtQuick.Layouts 1.3
import BibleTime 1.0

Rectangle {
    id: addBookmark

    property string moduleReference: ""
    property string moduleName: ""
    property string reference: ""
    property string folderName: ""

    signal bookmarkFolders();
    signal addTheBookmark();

    color: Material.background
    anchors.fill: parent

    Keys.onReleased: {
        if ((event.key === Qt.Key_Back || event.key === Qt.Key_Escape) && addBookmark.visible === true) {
            addBookmark.visible = false;
            keyReceiver.forceActiveFocus();
            event.accepted = true;
        }
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
        color: Material.background
        border.color: Material.foreground
        border.width: 2

        Rectangle {
            id: addBookmarkTitleBar
            color: Material.background
            width: parent.width
            height: btStyle.pixelsPerMillimeterY * 7

            Back {
                id: backTool

                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                text: qsTranslate("Navigation", "Main")
                onClicked: addBookmark.visible = false;
            }

            Text {
                id: titleText
                color: Material.foreground
                font.pointSize: btStyle.uiFontPointSize
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: btStyle.pixelsPerMillimeterX * 2.5
                verticalAlignment: Text.AlignVCenter
                text: qsTranslate("Bookmarks", "Add Bookmark")
            }
        }
    }

    Text {
        id: referenceLabel

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin:btStyle.pixelsPerMillimeterX * 2
        anchors.rightMargin:btStyle.pixelsPerMillimeterX * 2
        anchors.bottom: referenceText.top
        anchors.bottomMargin: btStyle.pixelsPerMillimeterX * 2
        text: qsTranslate("Bookmarks", "Bookmark") + ":"
        elide: Text.ElideMiddle
        font.pointSize: btStyle.uiFontPointSize + 1
        color: Material.foreground
    }

    Text {
        id: referenceText

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin:btStyle.pixelsPerMillimeterX * 8
        anchors.rightMargin:btStyle.pixelsPerMillimeterX * 2
        anchors.bottom: folderLabel.top
        anchors.bottomMargin: btStyle.pixelsPerMillimeterX * 10
        text: reference + " (" + moduleName + ")"
        elide: Text.ElideMiddle
        font.pointSize: btStyle.uiFontPointSize + 1
        color: Material.foreground
    }

    Text {
        id: folderLabel

        anchors.left: parent.left
        anchors.leftMargin:btStyle.pixelsPerMillimeterX * 2
        anchors.bottom: folderRect.top
        anchors.bottomMargin: btStyle.pixelsPerMillimeterX * 2
        text: qsTranslate("Bookmarks", "Folder") + ":"
        horizontalAlignment: Text.AlignHCenter
        font.pointSize: btStyle.uiFontPointSize + 1
        color: Material.foreground

        Action {
            id: chooseAction
            text: qsTr("Choose")
            onTriggered: {
                bookmarkFolders();
            }
        }
    }

    Rectangle {
        id: folderRect

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        height: buttons.height* 1.5
        anchors.leftMargin:btStyle.pixelsPerMillimeterX * 8
        anchors.rightMargin:btStyle.pixelsPerMillimeterX * 5
        anchors.topMargin: 10
        border.color: Material.foreground
        border.width: 2
        color: Material.background

        Text {
            id: folder

            text: addBookmark.folderName
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 10
            font.pointSize: btStyle.uiFontPointSize + 1
            color: Material.foreground
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                bookmarkFolders();
            }
        }
    }

    Grid {
        id: buttons

        spacing: btStyle.pixelsPerMillimeterY * 4
        columns: 2
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: folderRect.bottom
        anchors.topMargin: btStyle.pixelsPerMillimeterX * 12

        BtButton {
            text: qsTr("Ok")
            onClicked: {
                addBookmark.visible = false;
                addBookmark.addTheBookmark();
            }
        }

        BtButton {
            text: qsTr("Cancel")
            onClicked: {
                addBookmark.visible = false;
            }
        }
    }
}
