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

Rectangle {
    id: searchDialog


    property string searchText: ""
    property string findChoice: ""
    property string moduleList: ""
    property var modules
    property int orientation: Qt.Vertical

    signal searchRequest();

    function open() {
        searchDialog.visible = true
    }

    function close() {
        searchDialog.visible = false
    }

    function initialize(moduleNames) {
        searchText = "";
        findChoice = "";
        console.log("xxxx")
        appendModuleChoices(moduleNames);
    }

    function appendModuleChoices(moduleNames) {
        var modules = [];
        var firstChoice = "";
        for (var j=0; j<moduleNames.length; ++j) {
            var choice = moduleNames[j];
            if (j>0)
                firstChoice += ", ";
            firstChoice += choice;
        }
        modules.push(firstChoice);

        if (moduleNames.length > 1) {
            for (var k=0; k<moduleNames.length; ++k) {
                var choice2 = moduleNames[k];
                modules.push(choice2);
            }
        }
        searchComboBox.updateWidth(modules)
        searchDialog.modules = modules;
    }

    function setupSearch() {
        searchText = textInput.displayText;
        if (searchText === "")
            return;
        searchDialog.close();
        Qt.inputMethod.hide(); // hide keyboard
        if (radioAny.checked)
            findChoice = "or";
        if (radioAll.checked)
            findChoice = "and";
        if (radioPhrase.checked)
            findChoice = "regexpr";
        moduleList = searchComboBox.currentText;
        searchRequest();
    }

    function openSearchDialog() {
        searchDialog.open();
    }

    width: root.width
    height: root.height
    x: 0
    y: 0
    color: Material.background

    border.width: 1
    border.color: "white"

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
                searchDialog.close();
            }
        }
    }

    Rectangle {
        id: inputRow

        width: parent.width
        height: btStyle.pixelsPerMillimeterX * 8
        color: Material.background
        anchors.top: aboutTitleBar.bottom
        anchors.topMargin: btStyle.pixelsPerMillimeterX * 3
        anchors.left: parent.left
        anchors.leftMargin: btStyle.pixelsPerMillimeterX * 3

        Text {
            id: searchForLabel

            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            text: qsTranslate("Search", "Search for")
            font.pointSize: btStyle.uiFontPointSize
            color: Material.foreground
        }

        TextField {
            id: textInput

            anchors.left: searchForLabel.right
            anchors.leftMargin: btStyle.pixelsPerMillimeterX * 2
            anchors.bottom: parent.bottom
            bottomPadding: btStyle.pixelsPerMillimeterX * 1.5
            font.pointSize: btStyle.uiFontPointSize
            verticalAlignment: Text.AlignVCenter
            inputMethodHints: Qt.ImhNoAutoUppercase
            focus: true
            text: ""
            width: searchForLabel.width * 2
        }

        BtButton {
            id: searchButton

            anchors.left: textInput.right
            anchors.leftMargin: btStyle.pixelsPerMillimeterX * 4
            anchors.verticalCenter: parent.verticalCenter
            text: qsTranslate("Search", "Search")
            onClicked: {
                searchDialog.setupSearch();
            }
        }
    }

    Rectangle {
        id: searchInRow

        color: Material.background
        anchors.left: parent.left
        anchors.leftMargin: btStyle.pixelsPerMillimeterX * 3
        anchors.top: inputRow.bottom
        anchors.topMargin: btStyle.pixelsPerMillimeterX * 4
        width: parent.width
        height: btStyle.pixelsPerMillimeterY * 9

        Text {
            id: searchInLabel

            anchors.verticalCenter: parent.verticalCenter
            text: qsTranslate("Search", "Search in")
            font.pointSize: btStyle.uiFontPointSize
            color: Material.foreground
        }

        BtComboBox {
            id: searchComboBox

            anchors.left: searchInLabel.right
            anchors.leftMargin: btStyle.pixelsPerMillimeterX * 2
            anchors.verticalCenter: parent.verticalCenter
            model: searchDialog.modules
        }
    }

    GroupBox {
        id: findWords
        title: qsTr("Find")

        anchors.left: parent.left
        anchors.leftMargin: btStyle.pixelsPerMillimeterX * 3
        anchors.top: searchInRow.bottom
        anchors.topMargin: btStyle.pixelsPerMillimeterX * 4

        GridLayout {

            columns: searchDialog.orientation === Qt.Vertical ? 1 : 3

            RadioButton {
                id: radioAll

                text: qsTr("All Words")
                font.pointSize: btStyle.uiFontPointSize
                checked: true
            }

            RadioButton {
                id: radioAny

                text: qsTr("Any Word")
                font.pointSize: btStyle.uiFontPointSize
            }

            RadioButton {
                id: radioPhrase

                text: qsTr("Regular Expression")
                font.pointSize: btStyle.uiFontPointSize
            }
        }
    }

    Keys.onReleased: {
        if ((event.key === Qt.Key_Back || event.key === Qt.Key_Escape) && searchDialog.visible === true) {
            searchDialog.visible = false;
            event.accepted = true;
        }
    }

    BtStyle {
        id: btStyle
    }
}


