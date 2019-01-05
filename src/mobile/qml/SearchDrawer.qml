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
import QtQuick.Controls 1.2 as Controls1
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.3
import QtQuick.Layouts 1.3
import BibleTime 1.0

Drawer {
    id: searchDrawer


    property alias searchText: btSearchInterface.searchText
    property alias findChoice: btSearchInterface.findChoice
    property alias moduleList: btSearchInterface.moduleList
    property alias indexingFinished: btSearchInterface.indexingFinished

    property real leftRightSplit: 0.35
    property real topBottomSplit: 0.45
    property real handleWidth: btStyle.pixelsPerMillimeterX * 3
    property bool indexingCancelled;

    signal resultsFinished();
    signal resultsMenuRequested();
    signal progressTextChanged(string text);
    signal progressValueChanged(int value);

    function performSearch() {
        btWindowInterface.highlightWords = btSearchInterface.searchText;
        btSearchInterface.performSearch();
        open()
        searchResultsModules.currentIndex = 0
    }

    function cancel() {
        btSearchInterface.cancel();
        indexingCancelled = true;
    }

    function indexingWasCancelled() {
        return indexingCancelled;
    }

    Keys.onReleased: {
        if ((event.key === Qt.Key_Back || event.key === Qt.Key_Escape) &&
                screenView.currentIndex === screenModel.results) {
            resultsFinished();
            event.accepted = true;
        }
    }

    function modulesAreIndexed() {
        return btSearchInterface.modulesAreIndexed();
    }

    function indexModules() {
        indexingCancelled = false;
        return btSearchInterface.indexModules();
    }

    edge: Qt.RightEdge
    width: parent.width
    height: parent.height - y
    y: 1

    contentItem: Rectangle {
        id: content

        color: Material.background

        Controls1.SplitView {
            id: searchResultsArea

            orientation: Qt.Vertical
            handleDelegate: Rectangle {
                id: vHandle
                width: 1;
                height: {
                    var pixel = btStyle.pixelsPerMillimeterY * 7;
                    var uiFont = btStyle.uiFontPointSize * 3;
                    var mix = pixel * 0.7 + uiFont * 0.3;
                    return Math.max(pixel, mix);
                }

                color: Material.background
                border.color: Material.accent
                border.width: 1

                Text {
                    id: title
                    text: {
                        return btWindowInterface.moduleName + "   " +  btWindowInterface.reference;
                    }
                    color: Material.foreground
                    font.pointSize: btStyle.uiFontPointSize
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.right: searchMenuButton.left
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                MenuButton {
                    id: searchMenuButton

                    width: parent.height * 1.1
                    height: parent.height
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.margins: 2
                    foreground: Material.foreground
                    background: Material.background
                    visible: btSearchInterface.haveReferences

                    onButtonClicked: {
                        resultsMenuRequested();
                    }
                }
            }

            Rectangle {
                id: topArea

                width: searchDrawer.width
                height: searchDrawer.height * searchDrawer.topBottomSplit
                color: Material.background

                SearchResultsTitleBar {
                    id: searchResultsTitleBar

                    width: searchDrawer.width
                    height: btStyle.pixelsPerMillimeterY * 8
                    onBack: {
                        searchDrawer.close();
                    }
                }

                Controls1.SplitView {
                    id: topSplitter

                    orientation: Qt.Horizontal

                    anchors.top: searchResultsTitleBar.bottom
                    anchors.bottom: parent.bottom
                    anchors.left: searchResultsTitleBar.left
                    anchors.right: searchResultsTitleBar.right
                    handleDelegate: Rectangle {
                        width: handleWidth;
                        height: 2;
                        color: Material.background
                        border.color: Material.accent
                        border.width: 1
                    }

                    SearchResultsModules {
                        id: searchResultsModules

                        anchors.left: parent.left
                        anchors.top: parent.top
                        width: parent.width * searchDrawer.leftRightSplit
                        height: parent.height
                        onModuleNameChanged: {
                            btSearchInterface.selectReferences(currentIndex)
                        }

                    }

                    SearchResultsReferences {
                        id: searchResultsReferences

                        width: parent.width * searchDrawer.leftRightSplit
                        height: parent.height
                        onReferenceChanged: {
                            searchResultsText.updateTextDisplay();
                        }
                    }
                }
            }

            SearchResultsText {
                id: searchResultsText

                width: searchDrawer.width
                height: searchDrawer.height - topArea.height
                Layout.fillHeight: true
                moduleName: btSearchInterface.getModuleName(searchResultsModules.currentIndex);
                reference: btSearchInterface.getReference(searchResultsReferences.currentIndex);
            }

            BtWindowInterface {
                id: btWindowInterface
            }

            BtSearchInterface {
                id: btSearchInterface

                onProgressTextChanged: {
                    searchDrawer.progressTextChanged(btSearchInterface.progressText);
                }
                onProgressValueChanged: {
                    var value = btSearchInterface.progressValue
                    searchDrawer.progressValueChanged(btSearchInterface.progressValue)
                }
            }
        }
    }
}
