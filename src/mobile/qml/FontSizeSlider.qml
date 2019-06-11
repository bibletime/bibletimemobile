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
import QtQuick.Controls 2.4

Rectangle {
    id: fontPointSize

    property string title: ""
    property int min: 10
    property int max: 40
    property int current: 20
    property int previous: 20
    property bool ready: false

    signal accepted(int pointSize);

    color: Material.background
    border.color: Material.accent
    border.width: 1
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    anchors.topMargin: btStyle.pixelsPerMillimeterX * 2
    anchors.bottomMargin: btStyle.pixelsPerMillimeterX * 2
    anchors.rightMargin: btStyle.pixelsPerMillimeterX * 2
    height: {
        var height = titleText.contentHeight + slider.height + buttons.height;
        height = height + titleText.anchors.topMargin;
        height = height + buttons.anchors.bottomMargin + buttons.anchors.topMargin;
        height = height + btStyle.pixelsPerMillimeterX * 2
        return height;
    }
    width: {
        var width = Math.min(parent.width, parent.height);
        width = width - 2 * anchors.rightMargin
        return width;
    }
    onVisibleChanged: {
        fontPointSize.ready = false;
        if (visible) {
            var uiTextSize = btStyle.uiFontPointSize;
            slider.value = uiTextSize;
            fontPointSize.ready = true;
        }
    }
    Keys.onReleased: {
        if ((event.key == Qt.Key_Back || event.key == Qt.Key_Escape) && fontPointSize.visible == true) {
            accepted(previous);
            fontPointSize.visible = false;
            event.accepted = true;
        }
    }

    MouseArea {
        anchors.fill: parent
    }

    Text {
        id: titleText

        text: qsTranslate("main", title)
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: btStyle.pixelsPerMillimeterX * 4
        font.pointSize: btStyle.uiFontPointSize
        color: Material.foreground
    }

    Slider {
        id: slider
        anchors.top: titleText.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width - 60
        anchors.topMargin: btStyle.pixelsPerMillimeterX * 2
        from: fontPointSize.min
        to: fontPointSize.max
        onMoved: {
            if (fontPointSize.ready)
                accepted(slider.value);
        }
    }

    Grid {
        id: buttons

        spacing: btStyle.pixelsPerMillimeterY * 4
        columns: 2
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: btStyle.pixelsPerMillimeterX * 4
        anchors.topMargin: btStyle.pixelsPerMillimeterX * 3

        BtmButton {

            text: qsTr("OK")
            onClicked: {
                fontPointSize.visible = false;
            }
        }

        BtmButton {

            text: qsTr("CANCEL")
            onClicked: {
                accepted(previous);
                fontPointSize.visible = false;
            }
        }
    }
}
