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
    id: debugDialog

    color: Material.background
    anchors.fill: parent

    BtStyle {
        id: btStyle
    }

    Rectangle {
        id: aboutTitleBar
        color: Material.background
        width: parent.width
        height: btStyle.pixelsPerMillimeterY * 7

        Back {
            id: backTool

            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            text: qsTranslate("Navigation", "Main")
            onClicked: {
                debugDialog.visible = false;
            }
        }
    }

    Flickable {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: aboutTitleBar.bottom
        anchors.bottom: parent.bottom
        anchors.topMargin: btStyle.pixelsPerMillimeterY * 2
        contentWidth: width
        contentHeight: column.height * 1.1

        Column {
            id: column
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.margins: btStyle.pixelsPerMillimeterX
            spacing: btStyle.pixelsPerMillimeterY * 2

            Image {
                id: logo

                width:  debugDialog.width/12
                height: width
                anchors.horizontalCenter: parent.horizontalCenter
                source: "qrc:/share/bibletime/icons/bibletime.svg"
            }

            Rectangle {
                id: bibletimeDebugMode

                color: Material.background
                width: debugDialog.width
                height:btStyle.pixelsPerMillimeterX * 5

                Text {
                    id: debugModeText

                    anchors.left: parent.left
                    anchors.leftMargin: btStyle.pixelsPerMillimeterX * 2
                    anchors.verticalCenter: bibletimeDebugMode.verticalCenter
                    color: Material.foreground
                    text: "BibleTime Debug Mode"
                    font.pointSize: btStyle.uiFontPointSize
                }

                Switch {
                    anchors.right: parent.right
                    anchors.rightMargin: btStyle.pixelsPerMillimeterX * 2
                    anchors.verticalCenter: debugModeText.verticalCenter
                    checked: configInterface.boolValue("DEBUG/BibleTime", false)
                    height: debugModeText.height
                    onCheckedChanged: {
                        configInterface.setBoolValue("DEBUG/BibleTime", checked);
                    }
                }
            }

            Rectangle {
                id: swordDebugMode

                color: Material.background
                width: debugDialog.width
                height:btStyle.pixelsPerMillimeterX * 5

                Text {
                    id: swordDebugModeText

                    anchors.left: parent.left
                    anchors.leftMargin: btStyle.pixelsPerMillimeterX * 2
                    anchors.verticalCenter: swordDebugMode.verticalCenter
                    color: Material.foreground
                    text: "Sword Debug Mode"
                    font.pointSize: btStyle.uiFontPointSize
                }

                Switch {
                    anchors.right: parent.right
                    anchors.rightMargin: btStyle.pixelsPerMillimeterX * 2
                    anchors.verticalCenter: swordDebugModeText.verticalCenter
                    checked: configInterface.boolValue("DEBUG/Sword", false)
                    height: swordDebugModeText.height
                    onCheckedChanged: {
                        configInterface.setBoolValue("DEBUG/Sword", checked);
                    }
                }
            }

            Rectangle {
                color: Material.background
                width: debugDialog.width
                height:btStyle.pixelsPerMillimeterX * 5

                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: btStyle.pixelsPerMillimeterX * 2
                    anchors.verticalCenter: parent.verticalCenter
                    color: Material.foreground
                    text: {
                        var path = "UserBaseDir: " + configInterface.getUserBaseDir();
                        return path;
                    }
                }
            }

            Rectangle {
                color: Material.background
                width: debugDialog.width
                height:btStyle.pixelsPerMillimeterX * 5

                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: btStyle.pixelsPerMillimeterX * 2
                    anchors.verticalCenter: parent.verticalCenter
                    color: Material.foreground
                    text: {
                        var path = "Home Sword Dir: " + configInterface.getUserHomeSwordDir();
                        return path;
                    }
                }
            }

            Rectangle {
                color: Material.background
                width: debugDialog.width
                height:btStyle.pixelsPerMillimeterX * 5

                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: btStyle.pixelsPerMillimeterX * 2
                    anchors.verticalCenter: parent.verticalCenter
                    color: Material.foreground
                    text: {
                        var path = "Writable Tmp Dir: " + configInterface.getWritableTmpDir();
                        return path;
                    }
                }
            }

            Rectangle {
                color: Material.background
                width: debugDialog.width
                height:btStyle.pixelsPerMillimeterX * 5

                BtmButton {
                    anchors.left: parent.left
                    anchors.leftMargin: btStyle.pixelsPerMillimeterX * 2
                    anchors.verticalCenter: parent.verticalCenter
                    text: "File Browser"
                    onClicked: {
                        debugDialog.visible = false;
                        viewFile.open();
                    }
                }
            }
        }
    }

    Keys.onReleased: {
        if ((event.key == Qt.Key_Back || event.key == Qt.Key_Escape) && debugDialog.visible == true) {
            debugDialog.visible = false;
            event.accepted = true;
        }
    }
}
