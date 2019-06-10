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
    id: progressDialog

    property alias minimumValue: progressBar.from
    property alias value: progressBar.value
    property alias maximumValue: progressBar.to
    property alias text: label.text

    signal finish();
    signal canceled();

    anchors.left: parent.left
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    height: width * .4 + label.height
    color: Material.background
    visible: false

    BtStyle {
        id: btStyle
    }

    Text {
        id: label

        font.pointSize: btStyle.uiFontPointSize
        color: Material.foreground
        anchors.bottom: progressBar.top
        anchors.horizontalCenter: parent.horizontalCenter
    }

    ProgressBar {
        id: progressBar

        width: parent.width * 0.9
        height: btStyle.pixelsPerMillimeterX * 8
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Text {
        id: cancelButton

        text: qsTr("CANCEL")
        color: Material.accent
        font.pointSize: btStyle.uiFontPointSize
        anchors.right: parent.right
        anchors.rightMargin: btStyle.pixelsPerMillimeterX * 6
        anchors.bottom: parent.bottom
        anchors.bottomMargin: btStyle.pixelsPerMillimeterX * 8

        MouseArea {
            anchors.fill: parent

            onClicked: {
                progressDialog.visible = false;
                canceled();
            }
        }
    }
}
