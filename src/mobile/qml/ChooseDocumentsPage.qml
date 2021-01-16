import QtQuick.Controls 1.4 as Controls1
import QtQuick.Controls.Styles 1.4 as ControlsStyle1
import QtQuick 2.0
import QtQuick.Controls.Material 2.3
import QtQuick.Controls 2.5
import QtQuick.Window 2.12

Item {
    id: chooseDocumentsPage

    property real fontPointSize: btStyle.uiFontPointSize

    function initPage() {
        installInterface.initializeCategoriesModel();
        categoryListView.currentIndex = 0;
        installInterface.initializeDocumentsModel();
        var category = installInterface.categoryFromIndex(categoryListView.currentIndex);
        installInterface.filterWorksByCategory(category);
        filterInput.clear();
        bookshelfManager.changeButton("back", true);
        bookshelfManager.changeButton("next", false);
        bookshelfManager.changeButton("install", true);
        bookshelfManager.changeButton("finish", false);
        bookshelfManager.changeButton("close", false);
        bookshelfManager.changeButton("cancel", true);
    }

    function donePage() {
        installInterface.finishChoosingDocuments();
    }

    Controls1.SplitView {
        id: splitView

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        orientation: Qt.Vertical
        handleDelegate: Item {

            width: 100;
            height: Screen.pixelDensity * 3

            Rectangle {
                id: vHandle

                anchors.left: parent.left
                anchors.leftMargin: Screen.pixelDensity * 2.0
                anchors.right: parent.right
                anchors.rightMargin: Screen.pixelDensity * 2.0
                anchors.top: parent.top
                anchors.bottom: parent.bottom

                color: Material.background
            }
        }

        Item {
            id: topItem

            height: chooseDocumentsPage.height * 0.3
            width: categoryListView.width

            Rectangle {
                id: topRect
                anchors.fill: parent
                anchors.topMargin: Screen.pixelDensity * 2.0
                anchors.leftMargin: Screen.pixelDensity * 2.0
                anchors.rightMargin: Screen.pixelDensity * 2.0
                border.color: Material.accent
                border.width: 1
                color: Material.background
            }

            Text {
                id: text1

                anchors.left: topRect.left
                anchors.leftMargin: Screen.pixelDensity * 3.0
                anchors.right: topRect.right
                anchors.rightMargin: Screen.pixelDensity * 2.0
                anchors.top: topRect.top
                anchors.topMargin: Screen.pixelDensity * 1
                text: qsTr("Choose a document category")
                wrapMode: Text.Wrap
                color: Material.foreground
                font.pointSize: chooseDocumentsPage.fontPointSize
            }

            Rectangle {
                id: spacer1

                anchors.left: topItem.left
                anchors.leftMargin: Screen.pixelDensity * 5.0
                anchors.top: text1.bottom
                anchors.topMargin: Screen.pixelDensity * 1.0
                width: topItem.width / 6.0
                height: 1
                color: Material.foreground
            }

            ListView {
                id: categoryListView

                function selectItem(x, y) {
                    var index = categoryListView.indexAt(x+contentX,y+contentY);
                    currentIndex = index;
                    var category = installInterface.categoryFromIndex(index);
                    installInterface.filterWorksByCategory(category);
                }

                anchors.left: topRect.left
                anchors.leftMargin: Screen.pixelDensity * 3.0
                anchors.top: spacer1.bottom
                anchors.topMargin: Screen.pixelDensity * 3.0
                anchors.bottom: topRect.bottom
                anchors.bottomMargin: Screen.pixelDensity * 1.0
                width: topItem.width
                clip: true
                highlightFollowsCurrentItem: true
                model: installInterface.categoryModel
                delegate: Text {
                    id: entry

                    property bool selected: ListView.isCurrentItem ? true : false

                    text: modelText
                    color: (entry.selected) ? Material.accent : Material.foreground
                    font.pointSize: chooseDocumentsPage.fontPointSize
                    height: {
                        var pixel = btStyle.pixelsPerMillimeterY * 7;
                        var uiFont = chooseDocumentPage.fontPointSize * 2;
                        return Math.max(pixel, uiFont);
                    }
                }

                MouseArea {
                    id: buttonMouseArea

                    anchors.fill: categoryListView
                    onClicked: itemWasSelected()

                    function itemWasSelected() {
                        categoryListView.selectItem(mouseX, mouseY);
                    }
                }
            }
        }

        Item {
            id: bottomItem

            width: categoryListView.width

            Rectangle {
                id: bottomRect
                anchors.fill: parent
                anchors.bottomMargin: Screen.pixelDensity * 2.0
                anchors.leftMargin: Screen.pixelDensity * 2.0
                anchors.rightMargin: Screen.pixelDensity * 2.0
                border.color: Material.accent
                border.width: 1
                color: Material.background
            }

            Text {
                id: text2

                anchors.left: bottomRect.left
                anchors.leftMargin: Screen.pixelDensity * 3.0
                anchors.right: bottomRect.right
                anchors.rightMargin: Screen.pixelDensity * 2
                anchors.top: bottomRect.top
                anchors.topMargin: Screen.pixelDensity * 1
                text: qsTr("Choose documents to install")
                wrapMode: Text.Wrap
                color: Material.foreground
                font.pointSize: chooseDocumentsPage.fontPointSize
            }

            Rectangle {
                id: spacer2

                anchors.left: bottomItem.left
                anchors.leftMargin: Screen.pixelDensity * 5.0
                anchors.top: text2.bottom
                anchors.topMargin: Screen.pixelDensity * 1.0
                width: bottomItem.width / 6.0
                height: 1
                color: Material.foreground
            }

            ListView {
                id: worksListView

                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: spacer2.bottom
                anchors.topMargin: Screen.pixelDensity * 1.0
                anchors.bottom: searchFilter.top
                anchors.bottomMargin: Screen.pixelDensity * 1.0
                clip: true
                model: installInterface.documentsSortFilterModel
                delegate: Item {
                    id: iDelegate

                    height: {
                        var pixel = btStyle.pixelsPerMillimeterY * 11;
                        var uiFont = chooseDocumentPage.fontPointSize * 3;
                        var uiText = checkDelegate.height + info.contentHeight;
                        return Math.max(pixel, uiFont, uiText);
                    }
                    width: worksListView.width

                    CheckDelegate {
                        id: checkDelegate

                        text: moduleName
                        anchors.left:  parent.left
                        anchors.leftMargin: Screen.pixelDensity * 1
                        anchors.right: parent.right
                        anchors.rightMargin: Screen.pixelDensity * 1
                        anchors.top: parent.top
                        font.pointSize: chooseDocumentPage.fontPointSize
                        checked: installChecked
                        onCheckedChanged: {
                            installChecked = checked;
                        }
                    }

                    Text {
                        id: info
                        anchors.left:  parent.left
                        anchors.leftMargin: Screen.pixelDensity * 6
                        anchors.right: parent.right
                        anchors.rightMargin: Screen.pixelDensity * 3
                        anchors.top: checkDelegate.bottom
                        anchors.topMargin: -Screen.pixelDensity * 2
                        color: Material.foreground
                        text: description
                        wrapMode: Text.Wrap
                        width: checkDelegate.width
                        font.pointSize: chooseDocumentPage.fontPointSize
                        //elide: Text.ElideRight
                    }

                    Text {
                        id: versionText
                        anchors.left:  parent.left
                        anchors.leftMargin: worksListView.width * 0.65
                        anchors.right: parent.right
                        anchors.rightMargin: Screen.pixelDensity * 3
                        anchors.verticalCenter: checkDelegate.verticalCenter
                        anchors.topMargin: -Screen.pixelDensity * 2
                        color: Material.foreground
                        text: version
                        font.pointSize: chooseDocumentPage.fontPointSize
                        elide: Text.ElideRight
                    }
                }
            }

            Rectangle {
                id: searchFilter

                anchors.left: bottomRect.left
                anchors.leftMargin: Screen.pixelDensity * 2.0
                anchors.right: bottomRect.right
                anchors.rightMargin: Screen.pixelDensity * 2.0
                anchors.bottom: bottomRect.bottom
                anchors.bottomMargin: Screen.pixelDensity * 2.0

                color: Material.background
                border.color: Material.foreground
                border.width: 1
                height: {
                    var pixel = Screen.pixelDensity * 9;
                    var uiFont = chooseDocumentPage.fontPointSize * 3;
                    var mix = pixel * 0.7 + uiFont * 0.3;
                    return Math.max(pixel, mix);
                }

                Text {
                    id: filterText
                    anchors.left: parent.left
                    anchors.leftMargin: Screen.pixelDensity * 2.0
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("Search" + ": ")
                    color: Material.foreground
                    font.pointSize: chooseDocumentPage.fontPointSize
                }

                TextField {
                    id: filterInput

                    anchors.left: filterText.right
                    anchors.leftMargin: Screen.pixelDensity * 2.0
                    anchors.right: searchFilter.right
                    anchors.rightMargin: Screen.pixelDensity * 4.0
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: chooseDocumentsPage.fontPointSize
                    onTextChanged: {
                        installInterface.filterWorksByText(text);
                    }
                }
            }

        }
    }
}
