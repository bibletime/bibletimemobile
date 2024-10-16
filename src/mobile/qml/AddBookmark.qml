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


import QtQuick
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.3
import QtQuick.Layouts 1.3
import BibleTime 1.0

Rectangle {
    id: addBookmark

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

    BtBookmarkInterface {
        id: bookmarkInterface
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
                font.pointSize: btStyle.uiFontPointSize + 1
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
        anchors.top: titleRect.bottom
        anchors.topMargin: btStyle.pixelsPerMillimeterX * 4
        text: qsTranslate("Bookmarks", "Bookmark") + ":"
        elide: Text.ElideMiddle
        font.pointSize: btStyle.uiFontPointSize
        color: Material.foreground
    }

    Text {
        id: referenceText

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin:btStyle.pixelsPerMillimeterX * 6
        anchors.rightMargin:btStyle.pixelsPerMillimeterX * 2
        anchors.top: referenceLabel.bottom
        anchors.topMargin: btStyle.pixelsPerMillimeterX * 3
        text: reference + " (" + moduleName + ")"
        elide: Text.ElideMiddle
        font.pointSize: btStyle.uiFontPointSize
        color: Material.foreground
    }

    Text {
        id: folderLabel

        anchors.left: parent.left
        anchors.leftMargin:btStyle.pixelsPerMillimeterX * 2
        anchors.top: referenceText.bottom
        anchors.topMargin: btStyle.pixelsPerMillimeterX * 4
        text: qsTranslate("Bookmarks", "Folder") + ":"
        font.pointSize: btStyle.uiFontPointSize
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
        anchors.bottom: newFolderButton.top
        anchors.top: folderLabel.bottom
        anchors.leftMargin:btStyle.pixelsPerMillimeterX * 2
        anchors.rightMargin:btStyle.pixelsPerMillimeterX * 2
        anchors.topMargin: btStyle.pixelsPerMillimeterX * 4
        anchors.bottomMargin: btStyle.pixelsPerMillimeterX * 4
        border.color: Material.foreground
        border.width: 2
        color: Material.background

        TreeView {
            id: treeView

            property bool mySelected: false
            property var myIndex: []

            model: bookmarkInterface.folderModel
            anchors.fill: parent
            anchors.margins: 3
            clip: true
            selectionModel: ItemSelectionModel {
                id: selectionModel
                model: treeView.model
                onCurrentChanged: {
                    if (currentIndex.valid) {
                        treeView.mySelected = true
                        treeView.myIndex = currentIndex
                    }
                    else {
                        treeView.mySelected = false
                        treeView.myIndex = []
                    }
                }
            }

            delegate: TreeViewDelegate {
                id: treeDelegate

                implicitHeight: bookmarkLabel.height * 3
                indentation: btStyle.pixelsPerMillimeterX * 5

                background: Rectangle {
                    color: Material.background
                    width: treeView.width
                }

                contentItem: Label {
                    id: bookmarkLabel

                    text: treeDelegate.model.display
                    color: current ? Material.accent : Material.foreground
                    font.pointSize: btStyle.uiFontPointSize
                    verticalAlignment: Text.AlignBottom
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            var modelIndex = treeDelegate.treeView.index(row, column)
                            selectionModel.setCurrentIndex(modelIndex, selectionModel.Current)
                        }
                    }
                }

                indicator: Item {
                    readonly property real __indicatorIndent: treeDelegate.leftMargin + (treeDelegate.depth * treeDelegate.indentation)
                    x: __indicatorIndent
                    y: (treeDelegate.height - height) / 2.5
                    implicitWidth: implicitHeight
                    implicitHeight: {
                        var pixel = btStyle.pixelsPerMillimeterY * 8;
                        var uiFont = btStyle.uiFontPointSize * 4.5;
                        return Math.max(pixel, uiFont);
                    }
                    rotation: treeDelegate.expanded ? 90 : 0

                    RightArrow {
                        id: rightArrow

                        height: parent.height / 2
                        width:  height
                        anchors.left: parent.left
                        anchors.leftMargin: height/2
                        anchors.verticalCenter: parent.verticalCenter
                        color: Material.foreground
                        visible: true
                    }
                }

            }
            onVisibleChanged: {
                if (visible) {
                    expandRecursively(-1,-1)
                }
            }
        }
    }

    BtmButton {
        id: newFolderButton

        anchors.left: parent.left
        anchors.leftMargin: btStyle.pixelsPerMillimeterX * 4
        anchors.bottom: okButton.top
        anchors.bottomMargin: btStyle.pixelsPerMillimeterX * 4
        visible: treeView.mySelected
        text: qsTr("NEW FOLDER")
        onClicked: {
            folderNameDialog.open()
        }
    }

    BtmButton {
        id: okButton

        text: qsTr("OK")
        anchors.right: cancelButton.left
        anchors.rightMargin: btStyle.pixelsPerMillimeterX * 4
        anchors.bottom: parent.bottom
        anchors.bottomMargin: btStyle.pixelsPerMillimeterX * 4
        visible: treeView.mySelected
        onClicked: {
            bookmarkInterface.addBookmark(addBookmark.reference,addBookmark.moduleName, treeView.myIndex)
            addBookmark.visible = false;
        }
    }

    BtmButton {
        id: cancelButton

        text: qsTr("CANCEL")
        anchors.bottom: parent.bottom
        anchors.bottomMargin: btStyle.pixelsPerMillimeterX * 4
        anchors.right: parent.right
        anchors.rightMargin: btStyle.pixelsPerMillimeterX * 4
        onClicked: {
            addBookmark.visible = false;
        }
    }

    Popup {
        id: folderNameDialog

        width: Math.min(parent.width, parent.height) * 0.9
        height: btStyle.pixelsPerMillimeterX * 45
        anchors.centerIn: addBookmark
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

        contentItem: Rectangle {

            anchors.verticalCenter: parent.verticalCenter
            border.color: Material.foreground
            border.width: 2
            color: Material.background

            Text {
                id: title

                anchors.left: parent.left
                anchors.leftMargin: btStyle.pixelsPerMillimeterX * 4
                anchors.top: parent.top
                anchors.topMargin: btStyle.pixelsPerMillimeterX * 4
                color: Material.foreground
                font.pointSize: btStyle.uiFontPointSize
                text: qsTranslate("Bookmarks", "New Folder")

            }

            TextField {
                id: myFolderName

                anchors.left: parent.left
                anchors.leftMargin: btStyle.pixelsPerMillimeterX * 4
                anchors.right: parent.right
                anchors.rightMargin: btStyle.pixelsPerMillimeterX * 4
                anchors .top: title.bottom
                anchors.topMargin: btStyle.pixelsPerMillimeterX * 4
                text: ""
                implicitHeight: btStyle.pixelsPerMillimeterX * 8
                font.pointSize: btStyle.uiFontPointSize
                verticalAlignment: Text.AlignVCenter
                inputMethodHints: Qt.ImhNoAutoUppercase
                focus: true
            }

            BtmButton {
                id: okButton2

                text: qsTr("OK")
                anchors.right: cancelButton2.left
                anchors.rightMargin: btStyle.pixelsPerMillimeterX * 4
                anchors.bottom: parent.bottom
                anchors.bottomMargin: btStyle.pixelsPerMillimeterX * 4
                onClicked: {
                    bookmarkInterface.addFolder(myFolderName.text, treeView.myIndex)
                    folderNameDialog.close()
                }
            }

            BtmButton {
                id: cancelButton2

                text: qsTr("CANCEL")
                anchors.bottom: parent.bottom
                anchors.bottomMargin: btStyle.pixelsPerMillimeterX * 4
                anchors.right: parent.right
                anchors.rightMargin: btStyle.pixelsPerMillimeterX * 4
                onClicked: {
                    folderNameDialog.close()
                }
            }
        }
    }
}
