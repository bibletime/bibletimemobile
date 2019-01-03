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
import QtQuick.Controls 1.2 as Controls1
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.3
import QtQuick.Layouts 1.3
import BibleTime 1.0

Rectangle {
    id: references

    property alias currentIndex: referencesView.currentIndex
    property string reference: ""

    color: Material.background
    anchors.top: parent.top
    Layout.fillWidth: true

    TitleColorBar {
        id: titleBar2
        title: qsTr("References")
        width: parent.width
    }

    ListSelectView {
        id: referencesView

        model: btSearchInterface.referencesModel
        anchors.top: titleBar2.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        leftTextMargin: 30

        onItemSelected: {
            reference = btSearchInterface.getReference(currentIndex);
        }

    }
}
