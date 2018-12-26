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
import BibleTime 1.0

Rectangle {
    id: top
    property alias model: listView.model
    property alias title: title.text

    border.color: "black"
    border.width: 2

    signal itemSelected(int index)

    Rectangle {
        id: titleRect

        border.color: "black"
        border.width: 1
        height: btStyle.uiFontPointSize * 4;
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.leftMargin: 3
        anchors.rightMargin: 3
        anchors.topMargin: 3
        color: btStyle.textBackgroundColor

        Text {
            id: title
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.centerIn: parent
            anchors.topMargin: 5
            horizontalAlignment: Text.AlignCenter
            verticalAlignment: Text.AlignBottom
            style: Text.Sunken
            font.pointSize: btStyle.uiFontPointSize
            color: btStyle.textColor
        }
    }

    ListView {
        id: listView
        clip: true
        anchors.top: titleRect.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 3
        ScrollBar.vertical: ScrollBar {
            width: btStyle.pixelsPerMillimeterX * 6
        }

        function itemSelected(index) {
            top.itemSelected(index);
        }

        Rectangle {
            id: background

            color: btStyle.textBackgroundColor
            anchors.fill: parent
            z: -1
        }

        delegate: Rectangle {
            id: entry

            color: btStyle.textBackgroundColor
            border.width: 1
            border.color: ListView.isCurrentItem ? "#c0c0c0" : "#a0a0a0"
            width: parent.width
            height: {
                var pixel = btStyle.pixelsPerMillimeterY * 7;
                var uiFont = titleText.contentHeight;
                var uiHeight = Math.max(pixel, uiFont);
                return uiHeight * 1.25;
            }

            Text {
                id: dummyTextForHeight
                text: qsTranslate("Install Documents", "Install")
                font.pointSize: btStyle.uiFontPointSize
                visible: false
            }

            BtButton{
                id: manageButton

                text: {
                 if (installed)
                    return qsTranslate("Install Documents", "Remove");
                 else
                     return qsTranslate("Install Documents", "Install");
                }
                onClicked: {
                    listView.itemSelected(index);
                }
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 10

                checkable: true;
            }

            Text {
                id: titleText

                anchors.verticalCenter: entry.verticalCenter
                anchors.left: manageButton.right
                anchors.right: entry.right
                height: entry.height
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                anchors.leftMargin: btStyle.pixelsPerMillimeterX
                anchors.rightMargin: 10
                anchors.topMargin: 5
                verticalAlignment: Text.AlignVCenter
                text: "<b>" + title + "</b> - " + desc
                font.pointSize: btStyle.uiFontPointSize
                color: btStyle.textColor
            }
        }

        BtStyle {
            id: btStyle
        }
    }
}

