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
    id: searchResultsTitleBar

    signal back();

    color: Material.primary

    Back {
        id: backTool

        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        text: qsTranslate("Navigation", "Main")
        onClicked: {
            back();
        }
    }

    Text {
        id: title2
        color: Material.foreground
        font.pointSize: btStyle.uiFontPointSize
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.leftMargin: btStyle.pixelsPerMillimeterX * 2.5
        verticalAlignment: Text.AlignVCenter
        text: qsTranslate("SearchResults", "Search Results")
    }
}
