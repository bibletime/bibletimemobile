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

Item {
    id: search

    property int spacing: btStyle.pixelsPerMillimeterX * 2.5
    property string searchText: ""
    property string findChoice: ""
    property string moduleList: ""
    property var modules

    signal searchRequest();
    signal searchFinished();

    function initialize() {
        searchComboBox.updateWidth(modules);
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
    }

    onFocusChanged: {
        if (focus) {
            textInput.text = searchText;
        }
    }

    Rectangle {

        anchors.fill: parent
        color: Material.background
        Rectangle {
            id: searchTitleBar
            color: Material.primary
            width: parent.width
            height: btStyle.pixelsPerMillimeterY * 7

            Back {
                id: backTool

                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                text: qsTranslate("Navigation", "Main")
                onClicked: {
                    search.searchFinished();
                }
            }

            Text {
                id: title
                color: Material.foreground
                font.pointSize: btStyle.uiFontPointSize
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: search.spacing
                verticalAlignment: Text.AlignVCenter
                text: qsTranslate("Search", "Search")
            }
        }

        Row {
            id: searchInput

            anchors.left: parent.left
            anchors.top: searchTitleBar.bottom
            anchors.leftMargin: search.spacing
            anchors.topMargin: btStyle.pixelsPerMillimeterY*5
            spacing: search.spacing

            TextField {
                id: textInput

                width: search.width -searchButton.width - search.spacing * 3
                height: searchIn.height*1.4
                font.pointSize: btStyle.uiFontPointSize
                verticalAlignment: Text.AlignVCenter
                inputMethodHints: Qt.ImhNoAutoUppercase
                focus: true
                text: ""
                onAccepted: {
                    search.setupSearch();
                }
            }

            BtButton {
                id: searchButton
                text: qsTranslate("Search", "Search")
                onClicked: {
                    search.setupSearch();
                }
            }
        }

        Text {
            id: titleText

            anchors.left: parent.left
            anchors.top: searchInput.bottom
            anchors.leftMargin: search.spacing
            anchors.topMargin: btStyle.pixelsPerMillimeterY*5
            font.pointSize: btStyle.uiFontPointSize
            text: qsTr("Find")
            color: Material.foreground
        }

        ColumnLayout {
            id: findWords

            anchors.top: titleText.bottom
            anchors.left: parent.left
            anchors.leftMargin: search.spacing

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

        RowLayout {
            id: searchIn

            anchors.left: parent.left
            anchors.top: findWords.bottom
            anchors.topMargin: btStyle.pixelsPerMillimeterY*5
            anchors.leftMargin: search.spacing
            spacing: search.spacing

            Text {
                id: searchInLabel

                text: qsTranslate("Search", "Search in")
                font.pointSize: btStyle.uiFontPointSize
                color: Material.foreground
            }

            BtComboBox {
                id: searchComboBox
            }
        }

        BtStyle {
            id: btStyle
        }
    }

    Keys.onReleased: {
        if ((event.key === Qt.Key_Back || event.key === Qt.Key_Escape) && search.focus === true) {
            searchFinished();
            event.accepted = true;
        }
    }
}
