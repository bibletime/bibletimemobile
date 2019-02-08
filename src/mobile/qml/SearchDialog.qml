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
    id: searchDialog


    property string searchText: ""
    property string findChoice: ""
    property string moduleList: ""
    property var modules
    property int orientation: Qt.Vertical

    signal searchRequest();

    function initialize(moduleNames) {
        searchText = "";
        findChoice = "";
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
        Qt.inputMethod.hide(); // hide keyboard
        searchText = textInput.displayText;
        if (radioAny.checked)
            findChoice = "or";
        if (radioAll.checked)
            findChoice = "and";
        if (radioPhrase.checked)
            findChoice = "regexpr";
        moduleList = searchComboBox.currentText;
        searchRequest();
        if (searchText === "")
            reject();
        else
            accept();
    }

    function openSearchDialog() {
        searchDialog.open();
    }

    spacing: btStyle.pixelsPerMillimeterX * 2
    width: root.width
    height: root.height
    x: 0
    y: 0
    contentItem: Rectangle {
        id: item

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

        ColumnLayout {

            anchors.top: aboutTitleBar.bottom
            anchors.topMargin: btStyle.pixelsPerMillimeterX * 3
            anchors.left: parent.left
            anchors.leftMargin: btStyle.pixelsPerMillimeterX *2
            width: parent.width
            spacing: searchDialog.spacing

            GridLayout {

                columns: searchDialog.orientation === Qt.Vertical ? 1 : 1
                columnSpacing: btStyle.pixelsPerMillimeterX * 10
                rowSpacing: btStyle.pixelsPerMillimeterX * 3

                id: searchInput

                RowLayout {

                    spacing: btStyle.pixelsPerMillimeterX * 3

                    Text {
                        id: searchForLabel

                        text: qsTranslate("Search", "Search for")
                        font.pointSize: btStyle.uiFontPointSize
                        color: Material.foreground
                    }

                    TextField {
                        id: textInput

                        bottomPadding: btStyle.pixelsPerMillimeterX * 1.5
                        font.pointSize: btStyle.uiFontPointSize
                        verticalAlignment: Text.AlignVCenter
                        inputMethodHints: Qt.ImhNoAutoUppercase
                        focus: true
                        text: ""
                    }

                    BtButton {
                        id: searchButton
                        text: qsTranslate("Search", "Search")
                        onClicked: {
                            searchDialog.setupSearch();
                        }
                    }
                }

                RowLayout {
                    id: searchIn

                    Text {
                        id: searchInLabel

                        text: qsTranslate("Search", "Search in")
                        font.pointSize: btStyle.uiFontPointSize
                        color: Material.foreground
                    }

                    BtComboBox {
                        id: searchComboBox

                        model: searchDialog.modules
                    }
                }
            }

            GroupBox {
                id: findWords
                title: qsTr("Find")


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
        }
    }

    BtStyle {
        id: btStyle
    }
}


