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

import QtQuick 2.12
import QtQuick.Templates 2.12 as T
import QtQuick.Controls.Material 2.3

T.AbstractButton {
    id: control

    implicitWidth: Math.max(contentItem.implicitWidth + indicator.implicitWidth, background.implicitWidth)
    implicitHeight: Math.max(contentItem.implicitHeight, indicator.implicitHeight, background.implicitHeight)
    leftPadding: btStyle.pixelsPerMillimeterX * 4
    rightPadding: btStyle.pixelsPerMillimeterX * 4
    topPadding: btStyle.pixelsPerMillimeterX
    bottomPadding: btStyle.pixelsPerMillimeterX

    indicator: Rectangle {
            height: 3
            width: parent.width
            color: Material.accent
            anchors.bottom: control.bottom
            visible: control.checked
    }

    contentItem: Text {
        id: contentText

        text: control.text
        font.pointSize: btStyle.uiFontPointSize
        color: (control.checkable && ! control.checked) ? Material.foreground : Material.accent
        horizontalAlignment: Text.AlignHCenter
    }

    background: Rectangle {

        implicitWidth: contentText.contentWidth + leftPadding + rightPadding
        implicitHeight: 20 + topPadding + bottomPadding
        color: {
            if (Material.theme == Material.Light)
                return "#d7d7d7"
            return "#323232"
        }
    }
}
