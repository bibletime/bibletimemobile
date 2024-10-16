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
import QtQuick.Layouts 1.3

Rectangle {
    id: searchResultsText

    property string moduleName: ""
    property string reference: ""

    function updateTextDisplay() {
        btWindowInterface.moduleName = moduleName;
        btWindowInterface.reference = reference;
        btWindowInterface.updateCurrentModelIndex();
    }

    width: parent.width
    color: Material.background

    ListView {
        id: listView

        clip: true
        width: parent.width
        anchors.fill: parent
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        model: btWindowInterface.textModel
        highlightFollowsCurrentItem: true
        currentIndex: btWindowInterface.currentModelIndex
        onCurrentIndexChanged: {
            positionViewAtIndex(currentIndex,ListView.Beginning)
        }
        onMovementEnded: {
            var index = indexAt(contentX,contentY+30);
            btWindowInterface.updateKeyText(index);
        }

        delegate: Text {
            text: line
            textFormat: Text.RichText
            width: listView.width
            color: Material.foreground
            font.family: btWindowInterface.fontName
            font.pointSize: btWindowInterface.fontSize
            wrapMode: Text.WordWrap
        }
    }
}
