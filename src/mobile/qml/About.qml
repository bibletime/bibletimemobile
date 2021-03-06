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
    id: aboutDialog

    color: Material.background
    anchors.fill: parent

    BtStyle {
        id: btStyle
    }

    Rectangle {
        id: aboutTitleBar
        color: Material.primary
        border.color: Material.foreground
        border.width: 1
        width: parent.width
        height: btStyle.pixelsPerMillimeterY * 9

        Back {
            id: backTool

            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            text: qsTranslate("Navigation", "Main")
            onClicked: {
                aboutDialog.visible = false;
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
            spacing: btStyle.pixelsPerMillimeterY * 2

            Image {
                id: logo

                width:  aboutDialog.width/8
                height: width
                anchors.horizontalCenter: parent.horizontalCenter
                source: "qrc:/share/bibletime/icons/bibletime.svg"

                MouseArea {
                    anchors.fill: parent
                    onDoubleClicked: {
                        aboutDialog.visible = false;
                        debugDialog.visible = true;
                    }
                }
            }

            Text {
                id: titleText

                text: qsTranslate("About", "BibleTime Mobile")
                width: aboutDialog.width
                horizontalAlignment: Text.AlignHCenter
                font.pointSize: btStyle.uiFontPointSize + 4
                color: Material.foreground
            }

            Text {
                id: versionText

                wrapMode: Text.WordWrap
                width: aboutDialog.width
                horizontalAlignment: Text.AlignHCenter
                textFormat: Text.RichText
                text: formatText();
                font.pointSize: btStyle.uiFontPointSize
                color: Material.foreground
                onLinkActivated: {
                    Qt.openUrlExternally(link);
                }

                function formatText() {
                    var btstr = qsTranslate("About", "Brought to you by the") + " <a href=\"http://www.bibletime.info\">BibleTime Team</a><br><br>";
                    var appstr = qsTranslate("About", "Version") + "<br>"
                    appstr += btStyle.appVersion;
                    appstr += "<br><br>";

                    var cpustr = qsTranslate("About", "Cpu") + "<br>"
                    cpustr += btStyle.buildArch;
                    cpustr += "<br><br>";

                    var qtstr = qsTranslate("About", "Qt version") + "<br>"
                    qtstr += btStyle.qtVersion;
                    qtstr += "<br><br>";

                    var swordstr = qsTranslate("About", "Sword version") + "<br>"
                    swordstr += btStyle.swordVersion;
                    swordstr += "<br><br>";

                    var gplstr = qsTranslate("About", "Licensed Under the") + "<br><a href=\"http://www.gnu.org/licenses/gpl-2.0.html\">GNU General Public License Version 2</a><br><br>"

                    var btmgitstr = "";
                    var btmgitversion = btStyle.gitVersion;
                    var len = btmgitversion.length;
                    if (len !== 0) {
                        btmgitstr = "<a href=\"https://github.com/bibletime/bibletimemobile\">BibleTime Mobile Git version</a><br>";
                        btmgitstr += btmgitversion.substring(0, len/2-1);
                        btmgitstr += "<br>";
                        btmgitstr += btmgitversion.substring(len/2, len);
                        btmgitstr += "<br><br>";
                    }

                    var btgitstr = "";
                    var btgitversion = btStyle.gitBibleTimeVersion;
                    len = btgitversion.length;
                    if (len !== 0) {
                        btgitstr = "<a href=\"https://github.com/bibletime/bibletime\">BibleTime Git version</a><br>";
                        btgitstr += btgitversion.substring(0, len/2-1);
                        btgitstr += "<br>";
                        btgitstr += btgitversion.substring(len/2, len);
                        btgitstr += "<br><br>";
                    }

                    return  btstr + appstr + cpustr + qtstr + swordstr + gplstr + btmgitstr + btgitstr;
                }
            }
        }
    }

    Keys.onReleased: {
        if ((event.key === Qt.Key_Back || event.key === Qt.Key_Escape) && aboutDialog.visible === true) {
            aboutDialog.visible = false;
            event.accepted = true;
        }
    }
}
