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
    id: referenceDisplay

    property string reference: "John 3:16"

    signal clicked();

    border.color: Material.accent
    border.width: 1
    color: Material.background
    radius: btStyle.pixelsPerMillimeterX * 0.9;

    Text {
        id: referenceText
        anchors.fill: parent
        anchors.leftMargin: btStyle.pixelsPerMillimeterX * 1
        anchors.rightMargin: 4
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        font.pointSize: btStyle.uiFontPointSize
        elide: Text.ElideMiddle
        color: Material.foreground
        text: referenceDisplay.reference
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        onClicked: {
            referenceDisplay.clicked();
        }
    }

}
