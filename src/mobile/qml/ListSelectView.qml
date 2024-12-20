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
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.3

Rectangle {
    id: top

    property alias model: listView.model
    property alias currentIndex: listView.currentIndex
    property real leftTextMargin: 2
    property bool highlight: true

    signal itemSelected(int index)

    color: Material.background

    ListView {
        id: listView

        anchors.fill: parent
        anchors.leftMargin: 1
        anchors.rightMargin: 1
        anchors.bottomMargin: 1
        clip: true
        highlightFollowsCurrentItem: true
        currentIndex: 2
        ScrollBar.vertical: ScrollBar {
            width: btStyle.pixelsPerMillimeterX * 6
        }

        function selectItem(x, y) {
            var index = listView.indexAt(x+contentX,y+contentY);
            var item  = listView.itemAt(x+contentX,y+contentY);
            currentIndex = index;
            top.itemSelected(index);
        }

        delegate: Rectangle {
            id: entry

            property bool selected: ListView.isCurrentItem ? true : false
            objectName: "entry"

            color: Material.background
            width: listView.width
            height: {
                var pixel = btStyle.pixelsPerMillimeterY * 7;
                var uiFont = btStyle.uiFontPointSize * 2;
                return Math.max(pixel, uiFont);
            }

            Text {
                id: entryText

                anchors.fill: parent
                anchors.leftMargin: leftTextMargin
                anchors.rightMargin: 10
                anchors.topMargin: 10
                verticalAlignment: Text.AlignVCenter
                text: model.text
                font.pointSize: btStyle.uiFontPointSize
                font.bold: highlight && entry.selected
                color: (highlight && entry.selected) ? Material.accent : Material.foreground
            }
        }

        MouseArea {
            id: buttonMouseArea

            anchors.fill: listView
            onPressed: {

            }

            onClicked: itemWasSelected()

            function itemWasSelected() {
                listView.selectItem(mouseX, mouseY);
                itemSelected(currentIndex);
            }
        }
    }
}
