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
    signal searchResultsMenuRequested(var module, string reference);
    signal progressTextChanged(string text);
    signal progressValueChanged(int value);

    function getModule() {
        return btWindowInterface.moduleName;
    }

    function getReference() {
        return btWindowInterface.reference;
    }

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

    function modulesAreIndexed() {
        return btSearchInterface.modulesAreIndexed();
    }

    function indexModules() {
        indexingCancelled = false;
        return btSearchInterface.indexModules();
    }

    edge: Qt.RightEdge
    width: parent.width
    height: parent.height
    contentItem: Rectangle {
        id: content

        color: Material.background

        SplitView {
            id: searchResultsArea

            anchors.fill: parent
            orientation: Qt.Vertical
            handle: Rectangle {
                id: vHandle
                width: 1;
                implicitHeight: {
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
                        return btWindowInterface.moduleName + "   " +  btWindowInterface.reference;parent
                    }
                    color: Material.foreground
                    font.pointSize: btStyle.uiFontPointSize
                    anchors.centerIn: parent
                }
            }

            Rectangle {
                id: topArea

                SplitView.preferredHeight: parent.height * searchDrawer.topBottomSplit
                SplitView.minimumHeight: 80
                color: Material.background

                SearchResultsTitleBar {
                    id: searchResultsTitleBar

                    width: searchDrawer.width
                    height: btStyle.pixelsPerMillimeterY * 8
                    onBack: {
                        searchDrawer.close();
                    }
                    onSearchResultsMenuRequested: {
                        var module = searchDrawer.getModule();
                        var reference = searchDrawer.getReference();
                        searchDrawer.searchResultsMenuRequested(module, reference);
                    }
                }

                SplitView {
                    id: topSplitter

                    orientation: Qt.Horizontal

                    anchors.top: searchResultsTitleBar.bottom
                    anchors.bottom: parent.bottom
                    anchors.left: searchResultsTitleBar.left
                    anchors.right: searchResultsTitleBar.right
                    handle: Rectangle {
                        implicitWidth: handleWidth;
                        implicitHeight: 5;
                        color: Material.background
                        border.color: Material.accent
                        border.width: 1
                    }

                    SearchResultsModules {
                        id: searchResultsModules

                        SplitView.preferredWidth: parent.width * searchDrawer.leftRightSplit
                        onModuleNameChanged: {
                            btSearchInterface.selectReferences(currentIndex)
                        }
                    }

                    SearchResultsReferences {
                        id: searchResultsReferences

                        onReferenceChanged: {
                            searchResultsText.updateTextDisplay();
                        }
                    }
                }
            }

            SearchResultsText {
                id: searchResultsText

                moduleName: btSearchInterface.getModuleName(searchResultsModules.currentIndex);
                reference: btSearchInterface.getReference(searchResultsReferences.currentIndex);
            }
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
