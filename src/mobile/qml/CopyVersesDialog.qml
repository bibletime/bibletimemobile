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
        copyVerses.close();
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
        console.log("reference: ", reference1)
        reference2 = reference1;
        btWinIfc.moduleName = theWindow.getModule();
        btWinIfc.reference = theWindow.getReference();
        open();
    }

    onAccepted: {
        btWinIfc.copy(moduleName, reference1, reference2);
    }
    title: qsTr("Copy")
    standardButtons: Dialog.Ok
    contentItem:
        Item {
        id: contentItem

        implicitHeight: {
            var h = copyVerses.rowHeight * 3 + message.height
            return h
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

            anchors.fill: parent
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
                    copyVerses.close();
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
            anchors.horizontalCenter: parent.horizontalCenter
            color: Material.foreground
            height: 40
            font.pointSize: btStyle.uiFontPointSize
            text: qsTranslate("Copy", "Copy size to large.")
            visible: copyVerses.showError
        }

        BtWindowInterface {
            id: btWinIfc
        }
    }
}

