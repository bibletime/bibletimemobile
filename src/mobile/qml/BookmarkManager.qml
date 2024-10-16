

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
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts 1.3
import BibleTime 1.0

Rectangle {
    id: bookmarkManager

    property string module: ""
    property string reference: ""
    property int rowHeight: {
        var pixel = btStyle.pixelsPerMillimeterY * 7
        var uiFont = btStyle.uiFontPointSize * 2.0
        return Math.max(pixel, uiFont)
    }
    property alias contextMenuModel: bookmarkInterface.contextMenuModel
    property variant index

    signal bookmarkItemClicked
    signal openReference(string module, string reference)

    function doContextMenu(action) {
        bookmarkInterface.doContextMenu(action, index)
    }

    function setupContextMenuModel(index) {
        bookmarkInterface.setupContextMenuModel(index)
    }

    function addFolder(folderName) {
        bookmarkInterface.addFolder(folderName)
    }

    function addTheReference(reference, moduleName) {
        bookmarkInterface.addBookmark(reference, moduleName)
    }

    function expandAll() {
        var indexes = bookmarkInterface.getBookmarkModelExpandableIndexes()
        for (var i = 0; i <= indexes.length - 1; i++) {
            treeView.expand(indexes[i])
        }
    }

    function toggleExpand(row) {
        if (treeView.isExpanded(row))
            treeView.collapse(row)
        else
            treeView.expand(row)
    }

    color: Material.background
    anchors.fill: parent
    onVisibleChanged: {
        if (visible)
            treeView.expand(treeView.model.index(0, 0))
    }

    BtStyle {
        id: btStyle
    }

    BtBookmarkInterface {
        id: bookmarkInterface
    }

    Rectangle {
        id: bookmarkManagerTitleBar
        color: Material.background
        anchors.top: parent.top
        width: parent.width
        height: btStyle.pixelsPerMillimeterY * 7

        Back {
            id: backTool

            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            text: qsTranslate("Navigation", "Main")
            onClicked: {
                bookmarkManager.visible = false
            }
        }

        Text {
            id: title
            color: Material.foreground
            font.pointSize: btStyle.uiFontPointSize
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.leftMargin: btStyle.pixelsPerMillimeterX * 2.5
            verticalAlignment: Text.AlignVCenter
            text: qsTranslate("Bookmarks", "Bookmark Manager")
        }
    }

    TreeView {
        id: treeView

        model: bookmarkInterface.bookmarkModel
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: btStyle.pixelsPerMillimeterX * 3
        anchors.top: bookmarkManagerTitleBar.bottom
        clip: true
        selectionModel: ItemSelectionModel {
            id: selectionModel
            model: treeView.model
        }
        delegate: TreeViewDelegate {
            id: treeDelegate
            implicitHeight: bookmarkLabel.height * 4
            indentation: btStyle.pixelsPerMillimeterX *7

            background: Rectangle {
                id: bg
                color: Material.background
            }

            contentItem: Label {
                id: bookmarkLabel

                text: treeDelegate.model.display
                color: Material.foreground
                font.pointSize: btStyle.uiFontPointSize
                verticalAlignment: Text.AlignVCenter

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (row === 0)
                            return;
                        var modelIndex = treeDelegate.treeView.index(row, column)
                        var bookmark = (bookmarkInterface.isBookmark(modelIndex))

                        if (bookmark) {
                            var module = bookmarkInterface.getModule(modelIndex);
                            var reference = bookmarkInterface.getReference(modelIndex);
                            bookmarkManager.module = module
                            bookmarkManager.reference = reference
                        }
                        bookmarkManager.index = modelIndex
                        bookmarkManager.setupContextMenuModel(modelIndex)
                        bookmarkManager.bookmarkItemClicked()
                    }
                }
            }

            indicator: Item {
                readonly property real __indicatorIndent: treeDelegate.leftMargin + (treeDelegate.depth * treeDelegate.indentation)
                x: __indicatorIndent
                y: (treeDelegate.height - height) / 3
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
    }
}
