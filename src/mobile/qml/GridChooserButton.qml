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
    id: button

    property int buttonWidth
    property int buttonHeight
    property int textHeight
    property alias text: buttonText.text
    property bool highlight: true
    property int borderWidth: 1

    signal clicked

    width: buttonWidth
    height: buttonHeight
    color: Material.background
    border.color: highlight ? Material.accent : Material.foreground
    border.width: button.borderWidth
    smooth: true

    border {
        width: 1
        color: Material.foreground
    }

    BtStyle {
        id: btStyle
    }

    Text {
        id: buttonText

        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: btStyle.pixelsPerMillimeterX * 2
        anchors.right: parent.right
        color: Material.foreground
        font.pointSize: parent.textHeight
        elide: Text.ElideRight
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        onClicked: button.clicked()
    }
}
