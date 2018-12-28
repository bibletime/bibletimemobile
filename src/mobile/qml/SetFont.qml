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
    id: setFont

    property string language: ""
    property bool ready: false

    signal textFontChanged

    height: languageRow.height + slider.height + buttons.height + buttons.anchors.bottomMargin + languageRow.anchors.bottomMargin
    width: {
        var width = Math.min(parent.width, parent.height);
        width = width - 2 * anchors.rightMargin
        return width;
    }
    color: Material.background
    border.width: 1
    border.color: Material.accent
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    anchors.bottomMargin: btStyle.pixelsPerMillimeterX * 2
    anchors.rightMargin: btStyle.pixelsPerMillimeterX * 2

    onVisibleChanged: {
        setFont.ready = false;
        if (visible) {
            updateLanguageCombo(setFont.language)
            var index = languageCombo.currentIndex;
            updateUiFontNameAndSize(index);
            moduleInterface.saveCurrentFonts();
            setFont.ready = true;
        }
    }

    Keys.onReleased: {
        if ((event.key === Qt.Key_Back || event.key === Qt.Key_Escape) && setFont.visible === true) {
            moduleInterface.restoreSavedFonts();
            setFont.textFontChanged();
            setFont.visible = false;
            event.accepted = true;
        }
    }

    function updateUiFontNameAndSize(index) {
        var language = languageCombo.textAt(index);
        var fontSize = moduleInterface.getFontSizeForLanguage(language);
        slider.value = fontSize;
        var fontName = moduleInterface.getFontNameForLanguage(language);
        updateFontNameCombo(fontName);
    }

    function updateLanguageCombo(language) {
        languageCombo.model = moduleInterface.installedModuleLanguages();
        var index = languageCombo.find(language);
        if (index >= 0)
            languageCombo.currentIndex = index;
    }

    function updateFontNameCombo(fontName) {
        var index = fontCombo.find(fontName);
        if (index >= 0)
            fontCombo.currentIndex = index;
    }

    function setFontForLanguage(fontName) {
        if (! setFont.ready)
            return;
        var language = languageCombo.currentText;
        var fontSize = slider.value;
        moduleInterface.setFontForLanguage(language, fontName, fontSize);
        setFont.textFontChanged();
    }

    ModuleInterface {
        id: moduleInterface
    }

    MouseArea {
        anchors.fill: parent
    }

    Grid {
        id: languageRow

        rows: 3
        columns: 2

        anchors.top: parent.top
        anchors.topMargin: btStyle.pixelsPerMillimeterX * 4
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: btStyle.pixelsPerMillimeterX * 4
        verticalItemAlignment: Grid.AlignVCenter

        Text {
            id: title
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
            text: qsTr("For Language")
            font.pointSize: btStyle.uiFontPointSize
            color: btStyle.textColor
        }

        BtComboBox {
            id: languageCombo

            width: {
                var width = setFont.width;
                width = width - Math.max(title.width, fontText.width, fontSize.width);
                width = width - languageRow.spacing * 3;
                return width;
            }
            currentIndex: 0
            onActivated: {
                updateUiFontNameAndSize(index);
            }
        }

        Text {
            id: fontText
            horizontalAlignment: Text.AlignHCenter
            elide: Text.ElideRight
            text: qsTr("Font")
            font.pointSize: btStyle.uiFontPointSize
            color: btStyle.textColor
        }

        BtComboBox {
            id: fontCombo

            model: Qt.fontFamilies()
            width: languageCombo.width
            onActivated: {
                var fontName = fontCombo.textAt(index);
                setFont.setFontForLanguage(fontName);
            }

            BtStyle {
                id: btStyle
            }
        }

        Text {
            id: fontSize
            horizontalAlignment: Text.AlignHCenter
            elide: Text.ElideRight
            text: qsTr("Font Size")
            font.pointSize: btStyle.uiFontPointSize
            color: btStyle.textColor
        }

        Slider {
            id: slider

            width: languageCombo.width
            from: 10
            to: 30
            onValueChanged: {
                var fontName = fontCombo.currentText
                setFont.setFontForLanguage(fontName);
            }
        }
    }


    Grid {
        id: buttons

        spacing: btStyle.pixelsPerMillimeterY * 5
        columns: 2
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: btStyle.pixelsPerMillimeterX * 5

        BtButton {
            id: okButton
            text: qsTr("Ok")
            onClicked: {
                setFont.visible = false;
            }
        }

        BtButton {
            id: cancelButton
            text: qsTr("Cancel")
            onClicked: {
                setFont.visible = false;
                moduleInterface.restoreSavedFonts();
                setFont.textFontChanged();
            }
        }
    }
}
