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
import QtQuick.Controls
import QtQuick.Controls.Material 2.3
import QtQuick.Layouts 1.3
import BibleTime 1.0

FocusScope {
    id: magView

    property int magViewMargins: btStyle.pixelsPerMillimeterX * 0.75
    property real cornerRadius: btStyle.pixelsPerMillimeterX * 0.9;
    property bool promptVisible: true

    signal magFinished();

    function initialize() {
        btWindowInterface.updateDefaultModules();
        if (btWindowInterface.moduleName == "") {
            var moduleName = btWindowInterface.getDefaultSwordModuleByType("standardBible");
            if (moduleName !== "") {
                btWindowInterface.moduleName = moduleName;
            }
        }
        setPromptVisibility(true);
    }

    function setPromptVisibility(value) {
        promptText.height = value ? undefined : 0
        promptText.visible = value ? true: false;
    }

    function setModule(module) {
        btWindowInterface.moduleName = module;
        btWindowInterface2.moduleName = module;
    }

    function setReference(reference) {
        btWindowInterface.reference = reference;
    }

    function chooseModule() {
        moduleChooser.moduleSelected.connect(magView.moduleChoosenSlot);
        moduleChooser.backText = qsTr("View References");
        moduleChooser.visible = true;
        magDrawer.close();
    }

    function moduleChoosenSlot() {
        magDrawer.open();
        moduleChooser.moduleSelected.disconnect(magView.moduleChoosenSlot);
        var moduleName = moduleChooser.selectedModule;
        btWindowInterface.moduleName = moduleName;
    }

    function scrollDocumentViewToCurrentReference() {
        btWindowInterface.updateCurrentModelIndex();
    }

    function updateTextFont() {
        btWindowInterface.updateTextFonts();
        btWindowInterface2.updateTextFonts();
    }

    function referenceChoosen() {
        magDrawer.open();
        btWindowInterface.reference = chooseReference.reference;
        btWindowInterface.referenceChosen();
    }

    Rectangle {
        anchors.fill: parent
        color: Material.background
    }

    Rectangle {
        id: navigationBar

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: toolbar.height
        color: Material.primary
    }

    Back {
        id: backTool

        anchors.left: navigationBar.left
        anchors.top: navigationBar.top
        anchors.bottom: navigationBar.bottom
        anchors.bottomMargin: btStyle.pixelsPerMillimeterX *0.5
        text: qsTranslate("Navigation", "Main")
        z:1
        onClicked: {
            magView.magFinished();
        }
    }

    Text {
        id: pageTitle
        color: Material.foreground
        font.pointSize: btStyle.uiFontPointSize * 1.1
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: toolbar.height
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: qsTranslate("MagView", "View References")
        z: 1
    }

    Rectangle {
        id: toolbar

        height: {
            var pixel = btStyle.pixelsPerMillimeterY * 7;
            var uiFont = btStyle.uiFontPointSize * 3;
            var mix = pixel * 0.9 + uiFont * 0.3;
            return Math.max(pixel, mix);
        }
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: height * 0.8
        color: Material.background

        Rectangle {
            id: moduleDisplay

            width: text.width + 30
            radius: magView.cornerRadius
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.leftMargin: magView.magViewMargins
            anchors.topMargin: magView.magViewMargins
            anchors.bottomMargin: magView.magViewMargins
            color: Material.background
            border.color: Material.accent
            border.width: 1

            Text {
                id: text

                anchors.centerIn: parent
                anchors.leftMargin: 4
                anchors.rightMargin: 4
                font.pointSize: btStyle.uiFontPointSize
                elide: Text.ElideMiddle
                color: Material.foreground
                text: btWindowInterface.moduleName
            }

            MouseArea {
                id: moduleMouseArea

                anchors.fill: parent
                onClicked: {
                    magView.chooseModule();
                }
            }
        }

        Rectangle {
            id: referenceDisplay

            anchors.left: moduleDisplay.right
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.topMargin: magView.magViewMargins
            anchors.bottomMargin: magView.magViewMargins
            anchors.leftMargin:  magView.magViewMargins
            anchors.rightMargin: magView.magViewMargins
            border.color: Material.accent
            border.width: 1
            color: Material.background
            radius: magView.cornerRadius

            Text {
                id: referenceText
                anchors.fill: parent
                anchors.leftMargin: btStyle.pixelsPerMillimeterX *4.5
                anchors.rightMargin: 4
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                font.pointSize: btStyle.uiFontPointSize
                elide: Text.ElideMiddle
                color: Material.foreground
                text: btWindowInterface.reference
            }

            MouseArea {
                id: mouseArea

                anchors.fill: parent
                onClicked: {
                    chooseReference.finished.disconnect(magView.referenceChoosen)
                    chooseReference.finished.connect(magView.referenceChoosen)
                    magDrawer.close();
                    var module = btWindowInterface.moduleName
                    var ref = btWindowInterface.reference;
                    chooseReference.start(module, ref, qsTranslate("MagView", "View References"));
                }
            }
        }

    }

    SplitView {
        id: splitView

        property real ratio: 0.5

        function setOrientation() {
            if (width > height) {
                splitView.orientation = Qt.Horizontal;
            } else {
                splitView.orientation = Qt.Vertical;
            }
        }

        anchors.top: toolbar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.leftMargin: magView.magViewMargins
        anchors.rightMargin: magView.magViewMargins
        anchors.topMargin: magView.magViewMargins
        anchors.bottomMargin: magView.magViewMargins

        handle: Rectangle {
            id: handle

            implicitWidth: btStyle.pixelsPerMillimeterX * 1.6
            implicitHeight: btStyle.pixelsPerMillimeterX * 1.6
            color: Material.background
        }

        Component.onCompleted: {
            splitView.ratio = btmConfig.getReal("ui/MagViewRatio", 0.5);
            documentView.computeDocumentSize();
        }

        onHandleChanged: {
            splitView.ratio = (splitView.orientation == Qt.Horizontal) ?
                        documentView.width / width :
                        documentView.height / height;
            btmConfig.setReal("ui/MagViewRatio", splitView.ratio);
        }
        onWidthChanged: {
            setOrientation();
            documentView.computeDocumentSize();
        }
        onHeightChanged: {
            setOrientation();
            documentView.computeDocumentSize();
        }

        onVisibleChanged: {
            setOrientation();
            documentView.computeDocumentSize();
        }

        Rectangle {
            id: documentView

            function computeDocumentSize() {
                if (splitView.orientation == Qt.Horizontal) {
                    SplitView.preferredWidth = splitView.width * splitView.ratio;
                } else {
                    SplitView.preferredHeight = splitView.height * splitView.ratio;
                }
            }

            height: 100
            width: 100
            color: Material.background
            border.width: 1
            border.color: Material.foreground
            radius: magView.cornerRadius

            onWidthChanged: {
                if ( (splitView.orientation == Qt.Horizontal) && splitView.resizing )
                    splitView.handleChanged()
            }
            onHeightChanged: {
                if ( (splitView.orientation == Qt.Vertical) && splitView.resizing )
                    splitView.handleChanged()
            }

            ListView {
                id: documentListView

                clip: true
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: promptText.top
                anchors.leftMargin: magView.magViewMargins
                anchors.rightMargin: magView.magViewMargins
                anchors.topMargin: magView.magViewMargins
                anchors.bottomMargin: magView.magViewMargins
                model: btWindowInterface.textModel
                highlightFollowsCurrentItem: true
                currentIndex: btWindowInterface.currentModelIndex
                onCurrentIndexChanged: {
                    positionViewAtIndex(currentIndex,ListView.Beginning)
                }
                onMovementEnded: {
                    var index = indexAt(contentX,contentY+30);
                    btWindowInterface.updateKeyText(index);
                }

                delegate: Text {
                    text: line
                    textFormat: Text.RichText
                    width: documentListView.width
                    color: Material.foreground
                    font.family: btWindowInterface.fontName
                    font.pointSize: btWindowInterface.fontSize
                    wrapMode: Text.WordWrap
                    onLinkActivated: {
                        setPromptVisibility(false);
                        btWindowInterface2.setReferenceByUrl(link);
                        btWindowInterface2.updateCurrentModelIndex();
                    }
                }
            }

            Text {
                id: promptText

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.leftMargin: btStyle.pixelsPerMillimeterX
                font.pointSize: btStyle.uiFontPointSize
                color: Material.foreground
                elide: Text.ElideMiddle
                text: btWindowInterface2.prompt
                visible: promptVisible
            }
        }

        Rectangle {
            id: referencesView

            property int refMargins: btStyle.pixelsPerMillimeterX * 2
            color: Material.background
            Layout.fillWidth: (splitView.orientation == Qt.Horizontal) ? true : false
            Layout.fillHeight: (splitView.orientation == Qt.Vertical) ? true : false
            border.width: 1
            border.color: Material.foreground
            radius: magView.cornerRadius


            Text {
                id: referenceTitle

                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: btStyle.pixelsPerMillimeterY
                font.pointSize: btStyle.uiFontPointSize
                font.bold: true
                color: Material.foreground
                elide: Text.ElideMiddle
                text: btWindowInterface2.referencesViewTitle
            }

            Flickable {
                id: footnoteView

                anchors.top: referenceTitle.bottom
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: magView.magViewMargins
                anchors.rightMargin: magView.magViewMargins
                anchors.topMargin: magView.magViewMargins
                anchors.bottomMargin: magView.magViewMargins
                clip: true
                contentWidth: footnoteText.width
                contentHeight: footnoteText.height
                visible: btWindowInterface2.footnoteVisible
                z: 1
                Text {
                    id: footnoteText

                    color: Material.foreground
                    font.family: btWindowInterface2.fontName
                    font.pointSize: btWindowInterface2.fontSize
                    text: btWindowInterface2.footnoteText
                    textFormat: Text.RichText
                    width: footnoteView.width
                    wrapMode: Text.WordWrap
                }
            }

            ListView {
                id: referencesListView

                anchors.top: referenceTitle.bottom
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                clip: true
                width: parent.width
                anchors.leftMargin: magView.magViewMargins
                anchors.rightMargin: magView.magViewMargins
                anchors.topMargin: magView.magViewMargins
                anchors.bottomMargin: magView.magViewMargins
                model: btWindowInterface2.textModel
                highlightFollowsCurrentItem: true
                currentIndex: btWindowInterface2.currentModelIndex
                visible: !btWindowInterface2.footnoteVisible

                onCurrentIndexChanged: {
                    positionViewAtIndex(currentIndex,ListView.Beginning)
                }

                delegate: Text {
                    text: line
                    textFormat: Text.RichText
                    width: referencesListView.width - 8
                    color: Material.foreground
                    font.family: btWindowInterface2.fontName
                    font.pointSize: btWindowInterface2.fontSize
                    wrapMode: Text.WordWrap
                }
            }
        }
    }

    BtStyle {
        id: btStyle
    }

    BtmConfig {
        id: btmConfig
    }

    BtWindowInterface {
        id: btWindowInterface

        isMagView: true
        onModuleChanged: {
            btWindowInterface2.moduleName = btWindowInterface.moduleName
        }
    }

    BtWindowInterface {
        id: btWindowInterface2

        onReferenceChange: {
            btWindowInterface2.updateCurrentModelIndex();
        }
    }

}
