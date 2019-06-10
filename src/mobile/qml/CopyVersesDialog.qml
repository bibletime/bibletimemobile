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
import QtQuick.Controls.Material 2.3
import BibleTime 1.0

Rectangle {
    id: copyVerses

    property variant theWindow
    property string moduleName: ""
    property string reference1: ""
    property string reference2: ""
    property int activeReference: 0
    property bool showError: false
    property real rowHeight: {
        var pixel = btStyle.pixelsPerMillimeterY * 5;
        var uiFont = btStyle.uiFontPointSize * 3;
        var mix = pixel * 0.7 + uiFont * 0.3;
        return Math.max(pixel, mix);
    }

    signal loadReferences();

    function open() {
        copyVerses.visible = true;
    }

    function close() {
        copyVerses.visible = false;
    }

    function moduleChoosen() {
        moduleChooser.moduleSelected.disconnect(moduleChoosen);
        copyVerses.moduleName = moduleChooser.selectedModule;
        btWinIfc.moduleName = copyVerses.moduleName;
        open();
    }

    function chooseRef() {
        chooseReference.finished.disconnect(copyVerses.referenceChoosen);
        chooseReference.finished.connect(copyVerses.referenceChoosen);
        var module = btWinIfc.moduleName;
        var ref = btWinIfc.reference;
        chooseReference.start(module, ref, qsTranslate("Navigation", "Main"));
    }

    function referenceChoosen() {
        copyVerses.open()
        if (activeReference == 1)
            copyVerses.reference1 = chooseReference.reference;
        else if (activeReference == 2)
            copyVerses.reference2 = chooseReference.reference;
        copyVerses.showError = btWinIfc.isCopyToLarge(
                    copyVerses.reference1, copyVerses.reference2);
    }

    function openDialog() {
        copyVerses.showError = false;
        loadReferences();
        reference1 = theWindow.getReference();
        reference2 = reference1;
        btWinIfc.moduleName = theWindow.getModule();
        btWinIfc.reference = theWindow.getReference();
        open();
    }

    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    anchors.bottomMargin: btStyle.pixelsPerMillimeterX *6
    color: Material.background
    height: copyVerses.rowHeight * 7 + message.height
    visible: false

    Text {
        id: title

        anchors.left: parent.left
        anchors.leftMargin: btStyle.pixelsPerMillimeterX * 2
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: btStyle.pixelsPerMillimeterX * 3
        color: Material.foreground
        font.pointSize: btStyle.uiFontPointSize
        text: qsTranslate("copy", "Copy")

    }

    Grid {
        id: grid

        property real referenceWidth: {
            //var w = grid.width * 0.5
            var w = contentItem.width - widestText - btStyle.pixelsPerMillimeterX * 9 //-spacing;
            return w;
        }
        property real widestText: {
            var w1 = text1.contentWidth;
            var w2 = text2.contentWidth;
            var w3 = text3.contentWidth;
            return Math.max(w1,w2,w3);
        }

        anchors.left: parent.left
        anchors.leftMargin: btStyle.pixelsPerMillimeterX * 2
        anchors.right: parent.right
        anchors.top: title.bottom
        anchors.topMargin: btStyle.pixelsPerMillimeterX * 4
        columns: 2
        rowSpacing: btStyle.pixelsPerMillimeterX * 3
        columnSpacing: btStyle.pixelsPerMillimeterX * 2

        Text {
            id: text1

            color: Material.foreground
            font.pointSize: btStyle.uiFontPointSize
            text: qsTranslate("copy", "Document") + ":"
            verticalAlignment: Text.AlignVCenter
        }

        ModuleDisplay {
            id: moduleDisplay

            height: copyVerses.rowHeight
            moduleText: copyVerses.moduleName
            onActivated: {
                moduleChooser.bibleCommentaryOnly = true;
                moduleChooser.moduleSelected.connect(copyVerses.moduleChoosen);
                moduleChooser.backText = qsTranslate("Navigation", "Main");
                moduleChooser.visible = true;
            }
            width: grid.referenceWidth
        }

        Text {
            id: text2

            text: qsTranslate("copy", "First") +":"
            font.pointSize: btStyle.uiFontPointSize
            color: Material.foreground
            verticalAlignment: Text.AlignVCenter
        }

        ReferenceDisplay {
            id: referenceDisplay1

            reference: copyVerses.reference1
            width: grid.referenceWidth
            height: copyVerses.rowHeight
            onClicked: {
                copyVerses.activeReference = 1;
                chooseRef();
            }
        }

        Text {
            id: text3

            text: qsTranslate("copy", "Last") +":"
            font.pointSize: btStyle.uiFontPointSize
            color: Material.foreground
            width: grid.widestText
            height: copyVerses.rowHeight
            verticalAlignment: Text.AlignVCenter
        }

        ReferenceDisplay {
            id: referenceDisplay2

            reference: copyVerses.reference2
            width: grid.referenceWidth
            height: copyVerses.rowHeight
            onClicked: {
                copyVerses.activeReference = 2;
                chooseRef();
            }
        }
    }

    Text {
        id: message

        anchors.top: grid.bottom
        anchors.topMargin: btStyle.pixelsPerMillimeterX * 2
        anchors.horizontalCenter: parent.horizontalCenter
        color: Material.foreground
        height: 40
        font.pointSize: btStyle.uiFontPointSize
        text: qsTranslate("Copy", "Copy size to large.")
        visible: copyVerses.showError
    }

    Text {
        id: copyButton

        text: qsTr("COPY")
        color: Material.accent
        font.pointSize: btStyle.uiFontPointSize
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.rightMargin: btStyle.pixelsPerMillimeterX * 10
        anchors.bottomMargin: btStyle.pixelsPerMillimeterX * 4

        MouseArea {
            anchors.fill: parent

            onClicked: {
                copyVerses.visible = false;
                btWinIfc.copy(moduleName, reference1, reference2);
            }
        }
    }

    BtWindowInterface {
        id: btWinIfc
    }

    Keys.onReleased: {
        if ((event.key === Qt.Key_Back || event.key === Qt.Key_Escape) && copyVersesDialog.visible === true) {
            copyVersesDialog.visible = false;
            event.accepted = true;
        }
    }

}

