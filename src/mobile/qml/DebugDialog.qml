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
import QtQuick.Layouts 1.12
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
        id: flick

        anchors.left: parent.left
        anchors.leftMargin: btStyle.pixelsPerMillimeterX * 2
        anchors.right: parent.right
        anchors.rightMargin: btStyle.pixelsPerMillimeterX * 2
        anchors.top: aboutTitleBar.bottom
        anchors.bottom: parent.bottom
        anchors.topMargin: btStyle.pixelsPerMillimeterY * 2
        contentWidth: width
        contentHeight: column.height * 1.1

        ColumnLayout {
            id: column

            spacing: btStyle.pixelsPerMillimeterY * 2

            Image {
                id: logo

                width:  debugDialog.width/12
                height: width
                source: "qrc:/share/bibletime/icons/bibletime.svg"
            }

            Rectangle {
                id: bibletimeDebugMode

                Layout.maximumWidth: flick.contentWidth
                Layout.preferredWidth: flick.contentWidth
                color: Material.background
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

                Layout.maximumWidth: flick.contentWidth
                Layout.preferredWidth: flick.contentWidth
                color: Material.background
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
                id: usrBaseDirRect

                Layout.maximumWidth: flick.contentWidth
                Layout.preferredWidth: flick.contentWidth
                Layout.preferredHeight: usrBaseDirLabel.contentHeight + usrBaseDir.contentHeight
                color: Material.background
                height:btStyle.pixelsPerMillimeterX * 12

                Text {
                    id: usrBaseDirLabel

                    anchors.left: parent.left
                    anchors.top: parent.top
                    color: Material.foreground
                    text: "UserBaseDir:"
                    font.pointSize: btStyle.uiFontPointSize
                }

                Text {
                    id: usrBaseDir

                    anchors.left: parent.left
                    anchors.top: usrBaseDirLabel.bottom
                    width: usrBaseDirRect.width
                    color: Material.foreground
                    text: configInterface.getUserBaseDir();
                    font.pointSize: btStyle.uiFontPointSize
                    wrapMode: Text.Wrap
                }
            }

            Rectangle {
                id: homeSwordDirRect

                Layout.maximumWidth: flick.contentWidth
                Layout.preferredWidth: flick.contentWidth
                Layout.preferredHeight: homeSwordDirLabel.contentHeight + homeSwordDir.contentHeight
                color: Material.background
                height:btStyle.pixelsPerMillimeterX * 12

                Text {
                    id: homeSwordDirLabel

                    anchors.left: parent.left
                    anchors.top: parent.top
                    color: Material.foreground
                    text: "Home Sword Dir: "
                    font.pointSize: btStyle.uiFontPointSize
                }

                Text {
                    id: homeSwordDir

                    anchors.left: parent.left
                    anchors.top: homeSwordDirLabel.bottom
                    width: homeSwordDirRect.width
                    color: Material.foreground
                    text: configInterface.getUserHomeSwordDir()
                    font.pointSize: btStyle.uiFontPointSize
                    wrapMode: Text.Wrap
                }
            }

            Rectangle {
                id: writeableTmpDirRect

                Layout.maximumWidth: flick.contentWidth
                Layout.preferredWidth: flick.contentWidth
                Layout.preferredHeight: writableTmpDirLabel.contentHeight + writableTempDir.contentHeight
                color: Material.background
                height:btStyle.pixelsPerMillimeterX * 12

                Text {
                    id: writableTmpDirLabel

                    anchors.left: parent.left
                    anchors.top: parent.top
                    color: Material.foreground
                    text: "Writable Tmp Dir: "
                    font.pointSize: btStyle.uiFontPointSize
                }

                Text {
                    id: writableTempDir

                    anchors.left: parent.left
                    anchors.top: writableTmpDirLabel.bottom
                    width: writeableTmpDirRect.width
                    color: Material.foreground
                    text: configInterface.getWritableTmpDir();
                    font.pointSize: btStyle.uiFontPointSize
                    wrapMode: Text.Wrap
                }
            }

            Rectangle {
                id: fileBrowserRect

                color: Material.background
                width: debugDialog.width
                height:btStyle.pixelsPerMillimeterX * 5

                BtmButton {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    text: "File Browser"
                    onClicked: {
                        debugDialog.visible = false;
                        viewFile.open();
                    }
                }
            }

            Rectangle {
                color: Material.background
                width: debugDialog.width
                height:btStyle.pixelsPerMillimeterX * 5

                BtmButton {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Add Source"
                    onClicked: {
                        installInterface.addSource("holmlund.info");
                    }
                }
            }
        }
    }

    Keys.onReleased: {
        if ((event.key === Qt.Key_Back || event.key === Qt.Key_Escape) && debugDialog.visible == true) {
            debugDialog.visible = false;
            event.accepted = true;
        }
    }
}
