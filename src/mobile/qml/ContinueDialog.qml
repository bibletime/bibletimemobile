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
    id: continueDialog

    property alias text: continueText.text
    property bool answer

    signal finished();

    anchors.left: parent.left
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    height: width * .35 + continueText.height
    color: Material.background
    visible: false

    function open() {
        continueDialog.visible = true;
    }

    Text {
        id: continueText

        width: parent.width
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: btStyle.pixelsPerMillimeterX * 8
        anchors.rightMargin: btStyle.pixelsPerMillimeterX * 8
        anchors.bottomMargin: parent.bottom - yesButton.top
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
        font.pointSize: btStyle.uiFontPointSize
        color: Material.foreground
    }

    Text {
        id: yesButton

        text: qsTr("OK")
        color: Material.accent
        font.pointSize: btStyle.uiFontPointSize
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.rightMargin: btStyle.pixelsPerMillimeterX * 8
        anchors.bottomMargin: btStyle.pixelsPerMillimeterX * 6

        MouseArea {
            anchors.fill: parent

            onClicked: {
                answer = true;
                continueDialog.visible = false;
                finished();
            }
        }
    }
}
