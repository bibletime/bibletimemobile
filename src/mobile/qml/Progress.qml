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
    id: installProgress

    property alias minimumValue: progressBar.from
    property alias value: progressBar.value
    property alias maximumValue: progressBar.to
    property alias text: label.text

    color: Material.background
    border.color: Material.foreground
    border.width: 5
    radius: btStyle.pixelsPerMillimeterX * 3

    signal cancel()

    BtStyle {
        id: btStyle
    }

    Text {
        id: label

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: progressBar.top
        anchors.bottomMargin: parent.height / 8
        font.pointSize: btStyle.uiFontPointSize
        color: Material.foreground
    }

    ProgressBar {
        id: progressBar

        anchors.centerIn: parent
        width: parent.width - 100
        height: parent.height /10
    }


    BtmButton {
        text: qsTranslate("Progress", "CANCEL")
        anchors.top: progressBar.bottom
        anchors.topMargin: parent.height / 10
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: {
            cancel();
        }
    }
}
