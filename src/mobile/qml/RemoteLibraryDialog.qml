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
import QtQuick.Layouts 1.3
import BibleTime 1.0

Dialog {
    id: remoteLibraryDialog

    property string searchText: ""
    property string findChoice: ""
    property string moduleList: ""
    property var modules
    property int orientation: Qt.Vertical

    signal searchRequest();

    function open() {
        remoteLibraryDialog.visible = true;
        nameInput.forceActiveFocus();
    }

    function close() {
        remoteLibraryDialog.visible = false
    }

    function addLibrary() {
        var i = typeInput.currentIndex;
        var v = typeInput.model.get(i).value;
        return installInterface.addRemoteLibrary(nameInput.text, v, serverInput.text, pathInput.text)
    }

    width: root.width
    height: root.height
    x: 0
    y: 0

    Rectangle {
        color: Material.background

        anchors.fill: parent
        border.width: 1
        border.color: "white"
    }

    GroupBox {
        id: remoteLibraryText

        title: qsTr("Add New Remote Library")
        anchors.left: parent.left
        anchors.leftMargin: btStyle.pixelsPerMillimeterX * 3
        anchors.top: parent.top
        anchors.topMargin: btStyle.pixelsPerMillimeterX * 4
        anchors.right: parent.right
        anchors.rightMargin: btStyle.pixelsPerMillimeterX * 3
        anchors.bottom: parent.bottom
        Layout.fillWidth: true

        Grid {
            id: grid

            property int col0width: grid.width * 0.1 + btStyle.uiFontPointSize * 7
            property int col1width: grid.width - col0width

            anchors.left: parent.left
            anchors.leftMargin: btStyle.pixelsPerMillimeterX * 3
            anchors.top: parent.top
            anchors.topMargin: btStyle.pixelsPerMillimeterX * 4
            anchors.right: parent.right
            anchors.rightMargin: btStyle.pixelsPerMillimeterX * 3
            spacing: btStyle.pixelsPerMillimeterX * 3

            columns: 2

            Text {
                id: nameText
                text: qsTr("Library Name")
                color: Material.foreground
                font.pointSize: btStyle.uiFontPointSize
                width: grid.col0width
                height: nameInput.height
                verticalAlignment: Text.AlignVCenter
            }
            TextField {
                id: nameInput
                width: grid.col1width
                font.pointSize: btStyle.uiFontPointSize
                verticalAlignment: Text.AlignTop
                focus: true
            }

            Text {
                text: qsTr("Type")
                color: Material.foreground
                font.pointSize: btStyle.uiFontPointSize
                width: grid.col0width
                height: typeInput.height
                verticalAlignment: Text.AlignVCenter
            }
            BtComboBox {
                id: typeInput
                Layout.fillWidth: true
                font.pointSize: btStyle.uiFontPointSize
                width: grid.col1width
                textRole: "key"
                model: ListModel {
                    ListElement { key: qsTr("ftp"); value: 1 }
                    ListElement { key: qsTr("sftp"); value: 2 }
                    ListElement { key: qsTr("http"); value: 3 }
                    ListElement { key: qsTr("https"); value: 4 }
                }
            }

            Text {
                text: qsTr("Server")
                color: Material.foreground
                font.pointSize: btStyle.uiFontPointSize
                width: grid.col0width
                height: serverInput.height
                verticalAlignment: Text.AlignVCenter
            }
            TextField {
                id: serverInput
                Layout.fillWidth: true
                font.pointSize: btStyle.uiFontPointSize
                width: grid.col1width
            }

            Text {
                text: qsTr("Path")
                color: Material.foreground
                font.pointSize: btStyle.uiFontPointSize
                width: grid.col0width
                height: pathInput.height
                verticalAlignment: Text.AlignVCenter
            }
            TextField {
                id: pathInput
                Layout.fillWidth: true
                font.pointSize: btStyle.uiFontPointSize
                width: grid.col1width
            }

        }
    }

    Text {
        id: message

        anchors.left: parent.left
        anchors.leftMargin: btStyle.pixelsPerMillimeterX * 6
        anchors.right: parent.right
        anchors.rightMargin: btStyle.pixelsPerMillimeterX * 6
        anchors.bottom: buttons.top
        anchors.bottomMargin: btStyle.pixelsPerMillimeterX * 8
        color: Material.foreground
        font.pointSize: btStyle.uiFontPointSize
        wrapMode: Text.Wrap
        text: ""
    }

    Grid {
        id: buttons

        spacing: btStyle.pixelsPerMillimeterY * 5
        columns: 2
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: btStyle.pixelsPerMillimeterX * 5

        BtmButton {
            id: okButtmon
            text: qsTr("OK")
            onClicked: {
                var msg =remoteLibraryDialog.addLibrary();
                if (msg === "") {
                    remoteLibraryDialog.close();
                    accept();
                } else {
                    message.text = msg;
                }
            }
        }

        BtmButton {
            id: cancelButton
            text: qsTr("CANCEL")
            onClicked: {
                remoteLibraryDialog.close();
            }
        }
    }

    BtStyle {
        id: btStyle
    }
}


