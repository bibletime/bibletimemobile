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
import QtQml.Models 2.3
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.3
import QtQuick.Window 2.11
import BibleTime 1.0
import "bookshelfmanager"

Window {
    id: root

    property int opacitypopup: 0
    property QtObject component: null;
    property Item window: null;
    property int orientation: Qt.Vertical

    function setOrientation() {
        if (width > height) {
            orientation = Qt.Horizontal;
        } else {
            orientation = Qt.Vertical;
        }
    }

    function installModules2() {
        bookshelfManager.open();
    }

    function startSearch() {
        var moduleNames = windowManager.getUniqueModuleNames();
        searchDialog.initialize(moduleNames);
        searchDialog.open();
    }

    function viewReferencesScreen(moduleName, reference) {
        magViewDrawer.initialize();
        magViewDrawer.setModule(moduleName);
        magViewDrawer.setReference(reference);
        magViewDrawer.scrollDocumentViewToCurrentReference();
        magDrawer.open();
    }
    function saveSession() {
        sessionInterface.saveDefaultSession();
    }

    function setMaterialStyle(style) {
        if (style === 1) {
            Material.background = "#000000"
            Material.foreground = "white"
            Material.primary = "#111e6c"
            Material.accent = Material.Amber
            Material.accent = "#ffd700"
            Material.theme = Material.Dark
            gridChooser.buttonBorderWidth = 2
        } else if (style === 2) {
            Material.background = "white"
            Material.foreground = "black"
            Material.primary = Material.color(Material.Yellow, Material.Shade50)
            Material.accent = Material.Indigo
            Material.theme = Material.Light
            gridChooser.buttonBorderWidth = 4
        } else {
            Material.background = "white"
            Material.foreground = "black"
            Material.primary = Material.color(Material.Yellow, Material.Shade50)
            Material.accent = "#990000"
            Material.theme = Material.Light
            gridChooser.buttonBorderWidth = 4
        }

    }

    color: Material.background
    height: btStyle.height
    visible: true
    width:  btStyle.width

    onWidthChanged: {
        setOrientation();
        btStyle.width = width;
    }

    onHeightChanged: {
        setOrientation();
        btStyle.height = height;
    }

    Component.onCompleted: {
        setFontDialog.textFontChanged.connect(windowManager.updateTextFont)
        sessionInterface.loadDefaultSession();
        if (installInterface.installedModulesCount() === 0)
            installManagerStartup.visible = true;
        else
            informationDialog.openAtStartup();
    }

    Item {
        id: keyReceiver

        objectName: "keyReceiver"
        focus: true
        Keys.forwardTo: [
            searchResultsMenu,
            windowArrangementMenus,
            viewWindowsMenus,
            windowMenus,
            mainMenus,
            settingsMenus,
            bookmarkManagerMenus,
            colorThemeMenus,
            scrollBarMenus,
            informationDialog,
            gridChooser,
            moduleChooser,
            textEditor,
            defaultDoc,
            keyNameChooser,
            treeChooser,
            viewFile,
            aboutDialog,
            debugDialog,
            uiFontPointSize,
            setFontDialog,
            copyVersesDialog,
            searchDialog,
            bookmarkFoldersParent,
            addFolder1,
            bookmarkFolders,
            bookmarkManager,
            addBookmark
        ]

        Keys.onReleased: {
            if (event.key === Qt.Key_Back || event.key === Qt.Key_Escape) {
                event.accepted = true;
                quitQuestion.visible = true;
                quitQuestion.open();
            }
        }

        Keys.onMenuPressed: {
            event.accepted = true;
            mainMenus.visible = ! mainMenus.visible
        }
    }

    About {
        id: aboutDialog

        visible: false
        z: 1
    }

    AddBookmark {
        id: addBookmark

        visible: false
        folderName: bookmarkFolders.currentFolderName
        z: 4
        onBookmarkFolders: {
            bookmarkFolders.visible = true;
        }
        onAddTheBookmark: {
            bookmarkFolders.addTheReference(addBookmark.reference, addBookmark.moduleName);
        }
    }

    AddFolder {
        id: addFolder1

        z: 6
        visible: false
        parentFolderName: bookmarkFoldersParent.currentFolderName
        Keys.onReleased: {
            if ((event.key === Qt.Key_Back || event.key === Qt.Key_Escape) && addFolder1.visible === true) {
                addFolder1.visible = false;
                keyReceiver.forceActiveFocus();
                event.accepted = true;
            }
        }
        onShowFolders: {
            bookmarkFoldersParent.visible = true;
        }
        onFolderAdd: {
            bookmarkFoldersParent.addFolder(folderName);
        }
        onFolderWasAdded: {
            bookmarkFolders.expandAll();
        }
    }

    BookmarkFolders {
        id: bookmarkFolders
        visible: false
        allowNewFolders: true
        z:5
        onNewFolder: {
            addFolder1.visible = true;
        }

        Keys.onReleased: {
            if ((event.key === Qt.Key_Back || event.key === Qt.Key_Escape) && bookmarkFolders.visible === true) {
                bookmarkFolders.visible = false;
                keyReceiver.forceActiveFocus();
                event.accepted = true;
            }
        }
    }

    BookmarkFolders {
        id: bookmarkFoldersParent

        visible: false
        allowNewFolders: false
        z:7
        Keys.onReleased: {
            if ((event.key === Qt.Key_Back || event.key === Qt.Key_Escape) && bookmarkFoldersParent.visible === true) {
                bookmarkFoldersParent.visible = false;
                keyReceiver.forceActiveFocus();
                event.accepted = true;
            }
        }
    }

    BookmarkManager {
        id: bookmarkManager

        visible: false
        z: 3
        Keys.onReleased: {
            if ((event.key === Qt.Key_Back || event.key === Qt.Key_Escape) && bookmarkManager.visible === true) {
                bookmarkManager.visible = false;
                event.accepted = true;
            }
        }
        onBookmarkItemClicked: {
            bookmarkManagerMenus.visible = true;
        }
        onOpenReference: {
            windowMenus.theWindow.setModule(module);
            windowMenus.theWindow.setKey(reference);
            windowMenus.theWindow.setHistoryPoint();
            bookmarkManager.visible = false;
        }
    }

    Menus {
        id: bookmarkManagerMenus

        property variant theWindow

        function doAction(action) {
            bookmarkManagerMenus.visible = false;
            if (action === "open") {
                windowMenus.theWindow.setModule(bookmarkManager.module);
                windowMenus.theWindow.setKey(bookmarkManager.reference);
                bookmarkManager.visible = false;
                return;
            }
            bookmarkManager.doContextMenu(action);
        }

        model: bookmarkManager.contextMenuModel
        z:4
        Keys.onReleased: {
            if ((event.key === Qt.Key_Back || event.key === Qt.Key_Escape)  && bookmarkManagerMenus.visible === true) {
                event.accepted = true;
                bookmarkManagerMenus.visible = false;
            }
        }

        Component.onCompleted: menuSelected.connect(bookmarkManagerMenus.doAction)
    }

    BookshelfManager {
        id: bookshelfManager
        visible: false;
        font: btStyle.uiFont
    }

    BtStyle {
        id: btStyle
    }

    ChooseReference {
        id: chooseReference
    }

    DebugDialog {
        id: debugDialog

        visible: false
        z: 1
    }

    Menus {
        id: colorThemeMenus

        function doAction(action) {
            colorThemeMenus.visible = false;
            if (action === "dark") {
                btStyle.setStyle(1);
                root.setMaterialStyle(1);
                sessionInterface.setColorTheme(1);
            }
            else if (action === "lightblue") {
                btStyle.setStyle(2);
                root.setMaterialStyle(2);
                sessionInterface.setColorTheme(2);
            }
            else if (action === "crimson") {
                btStyle.setStyle(3);
                root.setMaterialStyle(3);
                sessionInterface.setColorTheme(3);
            }
        }
        onVisibleChanged: {
            if (visible) {
                var theme = sessionInterface.getColorTheme();
                index = theme - 1;
            }
        }

        model: colorThemeModel
        z: 1
        Keys.onReleased: {
            if ((event.key === Qt.Key_Back || event.key === Qt.Key_Escape)  && colorThemeMenus.visible === true) {
                event.accepted = true;
                colorThemeMenus.visible = false;
            }
        }


        Component.onCompleted: menuSelected.connect(colorThemeMenus.doAction)
    }

    ListModel {
        id: colorThemeModel

        ListElement { title: QT_TR_NOOP("Dark");                  action: "dark" }
        ListElement { title: QT_TR_NOOP("Light Blue");            action: "lightblue" }
        ListElement { title: QT_TR_NOOP("Crimson");               action: "crimson" }
    }

    ConfigInterface {
        id: configInterface
    }

    CopyVersesDialog {
        id: copyVersesDialog

        onLoadReferences: {
            var moduleNames = windowMenus.theWindow.getModuleNames();
            moduleName = moduleNames[0];
            theWindow = windowMenus.theWindow;
            mainToolbar.enabled = ! copyVersesDialog.visible
            windowManager.toolbarsEnabled = ! copyVersesDialog.visible
        }

        width: parent.width * 0.95
        x: (parent.width - width) / 2
        y: (parent.height - height) - btStyle.pixelsPerMillimeterX * 3
        z: 2
    }

    DefaultDoc {
        id: defaultDoc
        visible: false
        z: 1
    }

    GridChooser {
        id: gridChooser

        width: parent.width
        height: parent.height
        visible: false
        z: 3
    }

    QuestionDialog {
        id: indexQuestion

        text: qsTr("Some of the modules you want to search need to be indexed. Do you want to index them now?")
        width: Math.min(parent.width, parent.height) * 0.9
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        z: 4
        onFinished: {
            indexQuestion.visible = false;

            if (answer == true) {
                indexProgress.visible = true;
            }
        }
    }

    ProgressDialog {
        id: indexProgress

        value: 0
        text: ""
        minimumValue: 0
        maximumValue: 100
        implicitWidth:parent.width * 0.9
        visible: false
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        z: 4
        onVisibleChanged: {
            if (visible == true) {
                searchDrawer.indexModules();
            }
        }
        onCanceled: {
            searchDrawer.cancel();
        }
    }

    InformationDialog {
        id: informationDialog

        property string configKey: "GUI/showNewFeatureAtStartup"

        function openAtStartup() {
            var value = configInterface.boolValue(configKey, true);
            if (value)
                open();
        }

        function open() {
            informationDialog.visible = true;
        }

        visible: false
        anchors.fill: parent
        text: {
            var t = qsTr("You can write your own comments about Bible verses.");
            t += " " + qsTr("Install the Personal commentary from Crosswire.");
            t += " " + qsTr("Then open the Personal commentary and select a verse.");
            t += " " + qsTr("You can then enter your text.");
            t += "<br><br>";
            t += qsTr("The Personal Commentary can be one of your Parallel Documents.");
            return t;
        }
        onVisibleChanged: {
            mainToolbar.enabled = ! informationDialog.visible
            windowManager.toolbarsEnabled = ! informationDialog.visible
            if (!informationDialog.visible)
                configInterface.setBoolValue(configKey, false);
        }
        z: 3
    }

    InstallInterface {
        id: installInterface
    }

    QuestionDialog {
        id: installManagerStartup

        text: qsTr("BibleTime views documents such as Bibles and commentaries. These documents are downloaded and stored locally." +
                   "There are currently no documents. Do you want to download documents now?")
        visible: false
        width: Math.min(parent.width, parent.height) * 0.9
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        z: 4
        onFinished: {
            installManagerStartup.visible = false;
            if (answer == true) {
                basicWorks.visible = true;
            }
        }
    }

    QuestionDialog {
        id: basicWorks

        width: Math.min(parent.width, parent.height) * 0.9
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        text: {
            var lang = btStyle.systemLocale;
            var names = installAutomatic.getAutoInstallDocumentNames(lang);

            var message;
            if (names.length === 1) {
                message = qsTr("A suggested document to download is") + " " + names[0] + ".";
                message += "<br><br>" + qsTr("Would you like to automatically download this document?");
            } else {
                message = qsTr("Suggested documents to download are:");
                for (var i = 0; i < names.length; i++ ) {
                    message += "<br>" + names[i];
                }
                message += "<br><br>" + qsTr("Would you like to automatically download these documents?");
            }
            return message;
        }
        visible: false
        z: 4
        onFinished: {
            basicWorks.visible = false;
            if (answer == true) {
                installAutomatic.visible = true;
            } else {
                continueDialog.visible = true;
            }
        }
    }

    ContinueDialog {
        id: continueDialog

        text: qsTr("The \"Manage Installed Documents\" window will now be opened. You can open it later from the menus at the upper right of the Main view.")
        z:4
        onFinished: {
            installModules2();
        }
    }

    InstallAutomatic {
        id: installAutomatic

        visible: false
        z: 1
        onFinished: {
            var lang = btStyle.systemLocale;
            var reference = installAutomatic.getAutoInstallReference(lang);
            windowManager.newWindowWithReference(reference[0], reference[1]);
        }
    }

    ProgressDialog {
        id: installProgress

        value: installInterface.progressValue
        minimumValue: installInterface.progressMin
        maximumValue: installInterface.progressMax
        implicitWidth:parent.width * 0.9
        text: installInterface.progressText
        visible: installInterface.progressVisible
//        onCanceled: installManagerChooser.cancel();
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        z: 1
    }

    KeyNameChooser {
        id: keyNameChooser

        width: parent.width
        height: parent.height
        anchors.top: parent.top
        z: 3
        visible: false
    }

    Drawer {
        id: magDrawer

        y: 1
        width: parent.width
        height: parent.height - y
        dragMargin: Qt.styleHints.startDragDistance
        onClosed: {
            keyReceiver.forceActiveFocus();
        }

        MagView {
            id: magViewDrawer

            width: parent.width
            height: parent.height
            onMagFinished: {
                magDrawer.close();
            }
        }
    }

    ListModel {
        id: mainMenusModel

        ListElement { title: QT_TR_NOOP("New Window");                action: "newWindow" }
        ListElement { title: QT_TR_NOOP("View Window");               action: "view window" }
        ListElement { title: QT_TR_NOOP("Manage Installed Documents");action: "install" }
        ListElement { title: QT_TR_NOOP("Settings");                  action: "settings" }
        ListElement { title: QT_TR_NOOP("New Features");              action: "new features" }
        ListElement { title: QT_TR_NOOP("About");                     action: "about" }
    }

    Menus {
        id: mainMenus

        Component.onCompleted: menuSelected.connect(mainMenus.doAction)

        function doAction(action) {
            mainMenus.visible = false;
            if (action === "newWindow") {
                windowManager.newWindow();
            }
            else if (action === "view window") {
                windowManager.createWindowMenus(viewWindowsModel);
                viewWindowsMenus.visible = true;
            }
            else if (action === "install") {
                installModules2();
            }
            else if (action === "about") {
                aboutDialog.visible = true;
            }
            else if (action === "new features") {
                informationDialog.open();
            }
            else if (action === "settings") {
                settingsMenus.visible = true;
            }
        }

        model: mainMenusModel
        topMenuMargin: 100
        z: 5

        Keys.onReleased: {
            if ((event.key === Qt.Key_Back || event.key === Qt.Key_Escape)  && mainMenus.visible === true) {
                event.accepted = true;
                mainMenus.visible = false;
            }
        }

    }

    Rectangle {
        id: mainScreen

        objectName: "mainScreen"
        width: parent.width
        height: parent.height
        Keys.forwardTo: [keyReceiver]
        MainToolbar {
            id: mainToolbar

            anchors.left: parent.left
            anchors.top: parent.top
            anchors.right: parent.right
            height: {
                var pixel = btStyle.pixelsPerMillimeterY * 7.5;
                var uiFont = btStyle.uiFontPointSize * 4.4;
                var mix = pixel * 0.7 + uiFont * 0.3;
                return Math.max(pixel, mix);
            }
            onButtonClicked: {
                mainMenus.visible = ! mainMenus.visible;
            }
            onSearchClicked: {
                startSearch();
            }
        }

        Rectangle {
            id: spacer

            anchors.top: mainToolbar.bottom
            height:1
            width: parent.width
            color: Material.foreground
            z:11
        }

        SessionInterface {
            id: sessionInterface

            function loadDefaultSession() {
                var windowList = getWindowList();
                var count = windowList.length
                if (installInterface.installedModulesCount() > 0) {
                    for (var i=0; i < count; ++i) {
                        var window = windowList[i];
                        var modules = getWindowModuleList(window);
                        if (modules.length === 0)
                            continue;
                        var key = getWindowKey(window);
                        windowManager.openWindow("", modules, key);
                    }
                }
                var color = getColorTheme();
                btStyle.setStyle(color);
                root.setMaterialStyle(color);
                var winMode = getWindowArrangementMode();
                windowManager.windowArrangement = winMode;
            }

            function saveDefaultSession() {
                var color = btStyle.getStyle();
                setColorTheme(color);
                var winMode = windowManager.windowArrangement;
                setWindowArrangementMode(winMode);
                var windowList = [];
                var count = windowManager.getWindowCount();
                for (var i=0; i<count; ++i) {
                    var win = i.toString();
                    windowList[i] = win;
                    var window = windowManager.getWindow(i);
                    var moduleList = window.getModuleNames();
                    sessionInterface.setWindowModuleList(i, moduleList);
                    var key = window.getReference();
                    sessionInterface.setWindowKey(i, key);
                }
                sessionInterface.setWindowList(windowList);
            }
        }

        WindowManager {
            id: windowManager

            anchors.top: spacer.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            color: Material.background
            visible: true
            onWindowMenus: {
                windowMenus.theWindow = window
                window.createMenus(windowMenusModel)
                windowMenus.visible = true;
            }
        }
    }

    ModuleChooser {
        id: moduleChooser

        visible: false
        width: Math.min(parent.height, parent.width);
        height: parent.height
        anchors.centerIn: parent
        z: 4
        Keys.onReleased: {
            if ((event.key === Qt.Key_Back || event.key === Qt.Key_Escape)  && moduleChooser.visible === true) {
                event.accepted = true;
                moduleChooser.visible = false;
            }
        }
        onCanceled: moduleChooser.visible = false;
    }

    QuestionDialog {
        id: quitQuestion

        text: qsTranslate("Quit", "Are you sure you want to quit?")
        width: Math.min(parent.width, parent.height) * 0.9
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        z: 2
        onFinished: {
            if (answer == true)
                Qt.quit();
            keyReceiver.forceActiveFocus();
        }
    }

    Menus {
        id: scrollBarMenus

        function doAction(action) {
            scrollBarMenus.visible = false;
            if (action === "off") {
                windowManager.setScrollBarPosition(0);
            }
            else if (action === "left") {
                windowManager.setScrollBarPosition(1);
            }
            else if (action === "right") {
                windowManager.setScrollBarPosition(2);
            }
        }
        onVisibleChanged: {
            if (visible === true) {
                var pos = configInterface.intValue("ui/scrollBarPosition", 2);
                scrollBarMenus.index = pos;
            }
        }

        model: scrollBarModel
        z: 1
        Keys.onReleased: {
            if ((event.key === Qt.Key_Back || event.key === Qt.Key_Escape)  && scrollBarMenus.visible === true) {
                event.accepted = true;
                scrollBarMenus.visible = false;
            }
        }


        Component.onCompleted: menuSelected.connect(scrollBarMenus.doAction)
    }

    ListModel {
        id: scrollBarModel

        ListElement { title: QT_TR_NOOP("Off");             action: "off" }
        ListElement { title: QT_TR_NOOP("Left");            action: "left" }
        ListElement { title: QT_TR_NOOP("Right");           action: "right" }
    }

    SearchDialog {
        id: searchDialog

        visible: false
        orientation: root.orientation
        onSearchRequest: {
            searchDrawer.moduleList = searchDialog.moduleList;
            if ( ! searchDrawer.modulesAreIndexed()) {
                indexQuestion.visible = true;
                return;
            }
            searchDrawer.openSearchResults();
        }
    }

    SearchDrawer {
        id: searchDrawer

        dragMargin: Qt.styleHints.startDragDistance

        function openSearchResults() {
            if (searchDialog.searchText === "")
                return;
            searchDrawer.searchText = searchDialog.searchText;
            searchDrawer.findChoice = searchDialog.findChoice;
            searchDrawer.moduleList = searchDialog.moduleList;
            searchDrawer.performSearch();
        }

        onResultsMenuRequested: {
            searchDrawer.close();
            searchResultsMenu.visible = true;
        }

        onIndexingFinishedChanged: {
            indexProgress.visible = false;
            if ( ! searchDrawer.indexingWasCancelled()) {
                searchDrawer.openSearchResults();
            }
        }
        onProgressTextChanged: {
            indexProgress.text = text;
        }
        onProgressValueChanged: {
            indexProgress.value = value;
        }
        onClosed: {
            keyReceiver.forceActiveFocus();
        }
    }


    Menus {
        id: searchResultsMenu

        function doAction(action) {
            searchResultsMenu.visible = false;
            var module = searchDrawer.getModule();
            var reference = searchDrawer.getReference();
            if (action === "newWindow") {
                windowManager.newWindowWithReference(module, reference);
            } else if (action === "viewReferences") {
                viewReferencesScreen(module, reference);
            }
        }

        model: searchResultsMenuModel
        z: 2
        Keys.onReleased: {
            if ((event.key === Qt.Key_Back || event.key === Qt.Key_Escape)  && searchResultsMenu.visible === true) {
                event.accepted = true;
                searchResultsMenu.visible = false;
            }
        }

        Component.onCompleted: menuSelected.connect(searchResultsMenu.doAction)
    }

    ListModel {
        id: searchResultsMenuModel

        ListElement { title: QT_TR_NOOP("New Window");                action: "newWindow" }
        ListElement { title: QT_TR_NOOP("View References");           action: "viewReferences" }
    }

    SetFont {
        id: setFontDialog

        function open() {
            var index = windowManager.getTopWindowIndex();
            language = windowManager.getLanguageForWindow(index);
            setFontDialog.visible = true;
        }

        visible: false
        onVisibleChanged: {
            mainToolbar.enabled = ! setFontDialog.visible
            windowManager.toolbarsEnabled = ! setFontDialog.visible
        }
    }

    Menus {
        id: settingsMenus

        function doAction(action) {
            settingsMenus.visible = false;
            if (action === "colortheme") {
                colorThemeMenus.visible = true;
            }
            else if (action === "textFontSize") {
                setFontDialog.open();
            }
            else if (action === "uiFontSize") {
                uiFontPointSize.visible = true;
            }
            else if (action === "windowArrangement") {
                windowArrangementMenus.visible = true;
            }
            else if (action === "defaultDoc") {
                defaultDoc.visible = true;
            }
            else if (action === "scrollBarPosition") {
                scrollBarMenus.visible = true;
            }
        }

        model: settingsModel
        Keys.onReleased: {
            if ((event.key === Qt.Key_Back || event.key === Qt.Key_Escape)  && settingsMenus.visible === true) {
                event.accepted = true;
                settingsMenus.visible = false;
            }
        }
        Component.onCompleted: menuSelected.connect(settingsMenus.doAction)
    }

    ListModel {
        id: settingsModel

        ListElement { title: QT_TR_NOOP("Text Font");                 action: "textFontSize" }
        ListElement { title: QT_TR_NOOP("User Interface Font Size");  action: "uiFontSize" }
        ListElement { title: QT_TR_NOOP("Window Arrangement");        action: "windowArrangement" }
        ListElement { title: QT_TR_NOOP("Color Theme");               action: "colortheme" }
        ListElement { title: QT_TR_NOOP("Default Documents");         action: "defaultDoc" }
        ListElement { title: QT_TR_NOOP("ScrollBar Position");        action: "scrollBarPosition" }
    }

    TextEditor {
        id: textEditor

        anchors.left: root.left
        anchors.top: root.top
        height: root.height
        width: root.width
        visible: false
        Keys.onReleased: {
            if ((event.key === Qt.Key_Back || event.key === Qt.Key_Escape)  && textEditor.visible === true) {
                event.accepted = true;
                textEditor.visible = false;
            }
        }
        onVisibleChanged: {
            if (!visible)
                keyReceiver.forceActiveFocus();
        }
    }

    TreeChooser {
        id: treeChooser

        width:parent.width
        height: parent.height
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        path: ""
        visible: false
        z: 100
        onNext: {
            chooseReference.next(childText);
        }
        onBack: {
            chooseReference.back();
        }
    }

    FontSizeSlider {
        id: uiFontPointSize

        visible: false
        title: QT_TR_NOOP("User Interface Font Size")
        onVisibleChanged: {
            mainToolbar.enabled = ! uiFontPointSize.visible
            if (visible)
            {
                uiFontPointSize.current = btStyle.uiFontPointSize;
                uiFontPointSize.previous = btStyle.uiFontPointSize;
            } else {
                keyReceiver.forceActiveFocus();
            }
        }
        onAccepted: {
            btStyle.uiFontPointSize = pointSize
            windowManager.doTabLayout();
        }
    }

    VerseChooser {
        id: verseChooser
    }

    ViewFile{
        id: viewFile

        visible: false
        z: 1
    }

    Menus {
        id: viewWindowsMenus

        function doAction(action) {
            viewWindowsMenus.visible = false;
            var index = Number(action)
            windowManager.setCurrentTabbedWindow(index);
        }

        model: viewWindowsModel
        visible: false
        Keys.onReleased: {
            if ((event.key === Qt.Key_Back || event.key === Qt.Key_Escape)  && viewWindowsMenus.visible === true) {
                event.accepted = true;
                viewWindowsMenus.visible = false;
            }
        }

        Component.onCompleted: menuSelected.connect(viewWindowsMenus.doAction)
    }

    ListModel {
        id: viewWindowsModel

        ListElement { title: ""; action: "" }
    }

    Menus {
        id: windowArrangementMenus

        function doAction(action) {
            windowArrangementMenus.visible = false;
            if (action === "single") {
                windowManager.setWindowArrangement(windowManager.single);
            }
            else if (action === "tabbed") {
                windowManager.setWindowArrangement(windowManager.tabLayout);
            }
            else if (action === "autoTile") {
                windowManager.setWindowArrangement(windowManager.autoTile);
            }
            else if (action === "autoTileHor") {
                windowManager.setWindowArrangement(windowManager.autoTileHor);
            }
            else if (action === "autoTileVer") {
                windowManager.setWindowArrangement(windowManager.autoTileVer);
            }
        }
        onVisibleChanged: {
            if (visible) {
                var arrangement = windowManager.getWindowArrangement();
                if (arrangement === windowManager.single)
                    index = 0;
                else if (arrangement === windowManager.tabLayout)
                    index = 1;
                else if (arrangement === windowManager.autoTile)
                    index = 2;
                else if (arrangement === windowManager.autoTileHor)
                    index = 3;
                else if (arrangement === windowManager.autoTileVer)
                    index = 4;
            }
        }

        model: windowArrangementModel
        Keys.onReleased: {
            if ((event.key === Qt.Key_Back || event.key === Qt.Key_Escape)  && windowArrangementMenus.visible === true) {
                event.accepted = true;
                windowArrangementMenus.visible = false;
            }
        }


        Component.onCompleted: menuSelected.connect(windowArrangementMenus.doAction)
    }

    ListModel {
        id: windowArrangementModel

        ListElement { title: QT_TR_NOOP("Single");                  action: "single" }
        ListElement { title: QT_TR_NOOP("Tabbed");                  action: "tabbed" }
        ListElement { title: QT_TR_NOOP("Auto-tile");               action: "autoTile" }
        ListElement { title: QT_TR_NOOP("Auto-tile horizontally");  action: "autoTileHor" }
        ListElement { title: QT_TR_NOOP("Auto-tile vertically");    action: "autoTileVer" }
    }

    Menus {
        id: windowMenus

        property variant theWindow

        function doAction(action) {
            windowMenus.visible = false;
            if (action === "addBookmark") {
                var moduleName = theWindow.getModule();
                var reference = theWindow.getReference();
                addBookmark.reference = reference
                addBookmark.moduleName = moduleName
                addBookmark.visible = true;
            }
            else if (action === "bookmarks") {
                bookmarkManager.visible = true;
            }
            else if (action === "viewReferences") {
                var moduleName = theWindow.getModule();
                var reference = theWindow.getReference();
                viewReferencesScreen(moduleName, reference)
            }
            else if (action === "close window") {
                var index = windowManager.findIndexOfWindow(theWindow);
                windowManager.closeWindow(index);
            }
            else if (action === "copy") {
                copyVersesDialog.openDialog();
            }
            else if (action === "addParallel") {
                theWindow.addParallelModule();
            }
            else if (action === "removeParallel") {
                theWindow.removeParallelModule();
            }
            else if (action === "debugData") {
                theWindow.debugData();
            }
        }

        model: windowMenusModel
        z:2
        Keys.onReleased: {
            if ((event.key === Qt.Key_Back || event.key === Qt.Key_Escape)  && windowMenus.visible === true) {
                event.accepted = true;
                windowMenus.visible = false;
            }
        }

        Component.onCompleted: menuSelected.connect(windowMenus.doAction)

    }

    ListModel {
        id: windowMenusModel

        ListElement { title: ""; action: "" }
    }
}
