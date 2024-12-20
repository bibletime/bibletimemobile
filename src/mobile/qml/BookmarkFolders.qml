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

import QtQml.Models 2.3
import QtQuick
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.3
import QtQuick.Layouts 1.3
import BibleTime 1.0

Rectangle {
    id: bookmarkFolders

    property string currentFolderName: "Bookmarks"
    property bool allowNewFolders: false
    property int rowHeight: {
        var pixel = btStyle.pixelsPerMillimeterY * 7;
        var uiFont = btStyle.uiFontPointSize * 2;
        return Math.max(pixel, uiFont);
    }

    // signal newFolder();

    // function addFolder(folderName) {
    //     bookmarkInterface.addFolder(folderName);
    // }

    // function addTheReference(reference, moduleName) {
    //     bookmarkInterface.addBookmark(reference, moduleName);
    // }

    function expandAll() {
        // treeView.expandRecursively(-1,-1)
        var indexes = bookmarkInterface.getFolderModelExpandableIndexes();
        for(var i = 0; i <= indexes.length - 1; i++) {
            treeView.expand(indexes[i]);
        }
    }

    color: Material.background
    anchors.fill: parent

    onVisibleChanged: {
        if (visible)
            expandAll();
        newFolderButton.visible = allowNewFolders;
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

        Text {
            id: titleText

            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin:btStyle.pixelsPerMillimeterX * 3
            text: qsTranslate("Bookmarks", "Choose Folder")
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: btStyle.uiFontPointSize + 4
            color: Material.foreground
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            console.log(mouseX, mouseY)
        }
    }

    TreeView {
        id: treeView

        model: bookmarkInterface.folderModel
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: newFolderButton.top
        anchors.bottomMargin: btStyle.pixelsPerMillimeterX * 3
        anchors.top: titleRect.bottom
        delegate: TreeViewDelegate {
            indentation:10
        }


//        alternatingRowColors: false
//        backgroundVisible: false
//        selectionMode: SelectionMode.SingleSelection

        // // See QTBUG-47243
        // selection: ItemSelectionModel {
        //     id: selModel
        //     model: treeView.model
        // }

        // onClicked: {
        //     // See QTBUG-47243
        //     selModel.clearCurrentIndex();
        //     selModel.setCurrentIndex(index, 0x0002 | 0x0010);

        //     bookmarkInterface.currentFolder = index;
        //     var folderName = bookmarkInterface.folderName(index);
        //     bookmarkFolders.currentFolderName = folderName;
        //     bookmarkFolders.visible = false;
        // }

        // headerDelegate: Rectangle {
        //     height: 0
        //     visible: false
        // }

        // rowDelegate: Rectangle {
        //     height: bookmarkFolders.rowHeight
        //     property color selectedColor: Material.primary
        //     color: styleData.selected ? selectedColor : Material.background
        // }

        // itemDelegate: Item {

        //     Folder {
        //         id: icon

        //         width: parent.height * 0.7
        //         height: parent.height * 0.7
        //         anchors.verticalCenter: parent.verticalCenter
        //         color: Material.foreground

        //     }

        //     Text {
        //         anchors.verticalCenter: parent.verticalCenter
        //         anchors.left: icon.right
        //         color: Material.foreground
        //         elide: styleData.elideMode
        //         text: {
        //             return styleData.value;
        //         }
        //         font.pointSize: btStyle.uiFontPointSize
        //     }
        }

        // style: ControlsStyle1.TreeViewStyle {
        //     indentation: bookmarkFolders.rowHeight
        // }

        // Controls1.TableViewColumn {
        //     role: "display"
        //     width: 200
        //     visible: true
        // }
    //    }

    BtmButton {
        id: newFolderButton

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: btStyle.pixelsPerMillimeterX * 3
        text: qsTr("NEW FOLDER")
        onClicked: {
            bookmarkFolders.newFolder();
            console.log(treeView.x, treeView.y, treeView.width, treeView.height)
            console.log(treeView.rows)


        }
    }
}
