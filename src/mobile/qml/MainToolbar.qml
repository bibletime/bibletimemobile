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
import QtQuick.Controls.Material 2.3
import BibleTime 1.0

Rectangle {
    id: toolbar

    color: Material.primary
    z:0
    onEnabledChanged: {
        menuButton.visible = toolbar.enabled
        searchIconQml.visible = toolbar.enabled
    }

    signal buttonClicked
    signal searchClicked

    BtStyle {
        id: btStyle
    }

    Image {
        id: logo

        width: parent.height-10
        height: parent.height-10
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.topMargin: 5
        anchors.bottomMargin: 5
        anchors.leftMargin: 10
        source: "qrc:/share/bibletime/icons/bibletime.svg"
    }

    Text {
        id: title
        color: Material.accent
        font.pointSize: btStyle.uiFontPointSize * 1.1
        anchors.left: logo.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.leftMargin: 20
        verticalAlignment: Text.AlignVCenter
        text: qsTranslate("MainToolbar", "BibleTime Mobile")
    }

    MenuButton {
        id: menuButton

        width: parent.height * 1.1
        height: parent.height * 0.9
        anchors.right: parent.right

        // margin for searchDrawer dragging
        anchors.rightMargin: Qt.styleHints.startDragDistance *0.3

        anchors.top: parent.top
        foreground: Material.accent
        background: Material.primary
        onButtonClicked: {
            toolbar.buttonClicked()
        }
    }

    SearchIcon {
        id: searchIconQml

        width: parent.height * 1
        height: parent.height
        anchors.right: menuButton.left
        anchors.top: parent.top
        anchors.rightMargin: 0
        strokeStyle: Material.accent

        MouseArea {
            anchors.fill: parent
            onClicked: {
                toolbar.searchClicked()
            }
        }
    }
}
