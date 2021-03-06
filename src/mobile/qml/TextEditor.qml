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
import BibleTime 1.0

Rectangle {
    id: textEditor

    color: Material.background
    function open(text) {
        visible = true;
        textArea.text = text;
    }

    signal editFinished(string newText)

    TextArea {
        id: textArea

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: okButton.top
        anchors.margins: btStyle.pixelsPerMillimeterX * 1
        font.pointSize: btStyle.uiFontPointSize + 2
        textFormat: TextEdit.PlainText
        wrapMode: TextEdit.WordWrap
        Keys.forwardTo: [textEditor]
    }

    BtmButton {
        id: okButton

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: btStyle.pixelsPerMillimeterX * 0.5
        anchors.topMargin: btStyle.pixelsPerMillimeterX
        text: qsTr("OK")
        onClicked: {
            textEditor.visible = false;
            editFinished(textArea.text);
        }
    }
}
