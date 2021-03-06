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
    id: installManager

    property alias sourceModel: sourceView.model
    property alias categoryModel: categoryView.model
    property alias languageModel: languageView.model
    property alias worksModel: worksView.model
    property alias sourceIndex: sourceView.currentIndex
    property alias categoryIndex: categoryView.currentIndex
    property alias languageIndex: languageView.currentIndex
    property int spacing: btStyle.pixelsPerMillimeterX
    property bool refreshOnOpen: false

    signal canceled

    function open() {
        var currentSource = installInterface.getSourceSetting();
        if (currentSource === "")
            currentSource = "CrossWire";

        var currentCategory = installInterface.getCategorySetting();
        if (currentCategory === "")
            currentCategory = "Bibles";

        var currentLanguage = installInterface.getLanguageSetting();
        if (currentLanguage === "")
            currentLanguage = "English";

        installInterface.setup();
        var sIndex = installInterface.searchSource(currentSource);
        installManager.sourceIndex = sIndex;

        var cIndex = installInterface.searchCategory(currentCategory);
        installManager.categoryIndex = cIndex;

        var lIndex = installInterface.searchLanguage(currentLanguage);
        installManager.languageIndex = lIndex;

        visible = true;
    }

    function cancel() {
        installInterface.cancel();
    }

    function refreshSources() {
        var source = installInterface.getSource(sourceView.currentIndex);
        var category = installInterface.getCategory(categoryView.currentIndex);
        var language = installInterface.getLanguage(languageView.currentIndex);
        installInterface.refreshLists(source, category, language);
    }

    objectName: "installManager"
    color: Material.background

    signal sourceChanged(int index);
    signal categoryChanged(int index);
    signal languageChanged(int index);

    onVisibleChanged: {
        if (refreshOnOpen) {
            refreshOnOpen =false;
            refreshSources();
        }
    }

    Keys.onReleased: {
        if ((event.key === Qt.Key_Back || event.key === Qt.Key_Escape) && installManager.visible === true) {
            event.accepted = true;
            installManager.visible = false;
        }
    }

    Rectangle {
        id: installTitleBar
        color: Material.primary
        border.color: Material.foreground
        border.width: 1
        width: parent.width
        height: btStyle.pixelsPerMillimeterY * 8

        Back {
            id: backTool

            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            text: qsTranslate("Navigation", "Main")
            onClicked: {
                installManager.canceled();
            }
        }

        Text {
            id: title
            color: Material.foreground
            font.pointSize: btStyle.uiFontPointSize
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.leftMargin: btStyle.pixelsPerMillimeterX * 2.5
            verticalAlignment: Text.AlignVCenter
            text: qsTranslate("Title", "Install Manager")
        }
    }

    Grid {
        id:  grid
        columns: 3
        rows: 1
        spacing: installManager.spacing
        width: parent.width - installManager.spacing
        height: installManager.height/3
        anchors.left: parent.left
        anchors.top: installTitleBar.bottom
        anchors.margins: installManager.spacing

        ListTextView {
            id: sourceView

            objectName: "sourceView"
            onItemSelected: {
                sourceChanged(currentIndex);
            }

            model: installInterface.sourceModel
            title: qsTranslate("InstallManagerChooser","Source")
            width: parent.width/3 - grid.spacing
            height: installManager.height/3
            onCurrentIndexChanged: {
                var newSource = installInterface.getSource(sourceView.currentIndex);
                var currentCategory = installInterface.getCategory(categoryView.currentIndex);
                var currentLanguage = installInterface.getLanguage(languageView.currentIndex);
                installInterface.updateSwordBackend(newSource);
                installInterface.updateCategoryModel();
                var cIndex = installInterface.searchCategory(currentCategory);
                installManager.categoryIndex = cIndex;
                installInterface.updateLanguageModel(currentCategory);
                var lIndex = installInterface.searchLanguage(currentLanguage);
                installManager.languageIndex = lIndex;
            }
        }

        ListTextView {
            id: categoryView

            objectName: "categoryView"
            model: installInterface.categoryModel
            title: qsTranslate("InstallManagerChooser","Category")
            width: parent.width/3 - grid.spacing
            height: installManager.height/3
            onItemSelected: {
                categoryChanged(currentIndex)
            }
            onCurrentIndexChanged: {
                var currentCategory = installInterface.getCategory(categoryView.currentIndex);
                var currentLanguage = installInterface.getLanguage(languageView.currentIndex);
                installInterface.updateLanguageModel(currentCategory);
                var lIndex = installInterface.searchLanguage(currentLanguage);
                installManager.languageIndex = lIndex;

            }
        }

        ListTextView {
            id: languageView

            objectName: "languageView"
            model: installInterface.languageModel
            title: qsTranslate("InstallManagerChooser","Language")
            width: parent.width/3 - grid.spacing
            height: installManager.height/3
            onItemSelected: {
                languageChanged(currentIndex)
            }
            onCurrentIndexChanged: {
                var source = installInterface.getSource(sourceView.currentIndex);
                var category = installInterface.getCategory(categoryView.currentIndex);
                var language = installInterface.getLanguage(languageView.currentIndex);
                installInterface.updateWorksModel(source, category, language);
            }
        }
    }

    Rectangle {
        anchors.top: worksView.top
        width: grid.width
        color: "gray"
        height: 1
        z: 2
    }

    ListWorksView {
        id: worksView

        model: installInterface.worksModel
        title: qsTranslate("InstallManagerChooser","Document")
        width: parent.width - 2 * installManager.spacing
        anchors.top: grid.bottom
        anchors.left: parent.left
        anchors.bottom: buttonRow.top
        anchors.margins: installManager.spacing

        onItemSelected: {
            installInterface.workSelected(index)
        }
    }

    Text {
        id: dummyTextForHeight
        text: "x"
        font.pointSize: btStyle.uiFontPointSize
        visible: false
    }


    Row {
        id: buttonRow

        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.bottomMargin: 30
        spacing: (parent.width - refreshButton.width - installRemoveButton.width) / 3
        anchors.leftMargin: (parent.width - refreshButton.width - installRemoveButton.width) / 3

        BtmButton {
            id: refreshButton

            text: qsTranslate("InstallManagerChooser", "Refresh Sources")
            onClicked: refreshSources();
        }

        BtmButton {
            id: installRemoveButton
            text: qsTranslate("InstallManagerChooser", "Install / Remove")
            onClicked: {
                var source = installInterface.getSource(sourceView.currentIndex);
                var category = installInterface.getCategory(categoryView.currentIndex);
                var language = installInterface.getLanguage(languageView.currentIndex);
                installInterface.setSourceSetting(source);
                installInterface.setCategorySetting(category);
                installInterface.setLanguageSetting(language);
                installManagerChooser.visible = false;
                installInterface.installRemove();
            }
        }
    }
}
