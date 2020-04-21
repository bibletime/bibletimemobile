import QtQuick.Controls 1.4 as Controls1
import QtQuick.Controls.Styles 1.4 as ControlsStyle1
import QtQuick 2.0
import QtQuick.Controls.Material 2.3
import QtQuick.Controls 2.5
import QtQuick.Window 2.12
import ".."

Item {
    id: documentsPage

    property font font: Qt.font({ family: "Helvetica", pointSize: 10, weight: Font.Normal })

    function initPage() {
        installInterface.updateCategoryModel3();
        categoryListView.currentIndex = 0;
        installInterface.updateWorksModel3();
        var category = installInterface.categoryFromIndex(categoryListView.currentIndex);
        installInterface.filterWorksByCategory(category);
    }

    function donePage() {
        installInterface.finishChoosingDocuments();
    }

    Text {
        id: text1

        anchors.left: parent.left
        anchors.leftMargin: Screen.pixelDensity * 4
        anchors.right: parent.right
        anchors.rightMargin: Screen.pixelDensity * 4
        anchors.top: parent.top
        anchors.topMargin: Screen.pixelDensity * 1
        text: qsTr("Choose a document category")
        wrapMode: Text.Wrap
        color: Material.foreground
        font: documentsPage.font
    }

    Controls1.SplitView {
        id: splitView

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: text1.bottom
        anchors.bottom: parent.bottom
        orientation: Qt.Vertical
        handleDelegate: Rectangle {
            id: vHandle
            width: 100;
            height: {
                var pixel = Screen.pixelDensity * 7;
                var uiFont = btStyle.uiFontPointSize * 3;
                var mix = pixel * 0.7 + uiFont * 0.3;
                return Math.max(pixel, mix);
            }

            color: Material.background
            border.color: Material.accent
            border.width: 1
        }

        ListView {
            id: categoryListView

            function selectItem(x, y) {
                var index = categoryListView.indexAt(x+contentX,y+contentY);
                currentIndex = index;
                var category = installInterface.categoryFromIndex(index);
                installInterface.filterWorksByCategory(category);
            }

            width: categoryListView.width
            height: documentsPage.height * 0.3
            clip: true
            highlightFollowsCurrentItem: true
            model: installInterface.categoryModel
            delegate: Text {
                id: entry

                property bool selected: ListView.isCurrentItem ? true : false

                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 50
                text: modelText
                color: (entry.selected) ? Material.accent : Material.foreground
                font: documentPage.font
                height: {
                    var pixel = btStyle.pixelsPerMillimeterY * 7;
                    var uiFont = btStyle.uiFontPointSize * 2;
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

        Item {
            id: bottemItem

            Text {
                id: text2

                anchors.left: parent.left
                anchors.leftMargin: Screen.pixelDensity * 4
                anchors.right: parent.right
                anchors.rightMargin: Screen.pixelDensity * 4
                anchors.top: parent.top
                anchors.topMargin: Screen.pixelDensity * 1
                text: qsTr("Choose documents to install")
                wrapMode: Text.Wrap
                color: Material.foreground
                font: documentsPage.font
            }

            ListView {
                id: worksListView

                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: text2.bottom
                anchors.bottom: parent.bottom
                clip: true
                model: installInterface.worksSortFilterModel
                delegate: Item {
                    id: iDelegate

                    height: Screen.pixelDensity * 12
                    width: worksListView.width

                    CheckDelegate {
                        id: checkDelegate

                        text: moduleName
                        anchors.left:  parent.left
                        anchors.leftMargin: Screen.pixelDensity * 1
                        anchors.right: parent.right
                        anchors.rightMargin: Screen.pixelDensity * 1
                        anchors.top: parent.top
                        font: documentPage.font
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
                        font: documentPage.font
                        elide: Text.ElideRight
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
                        font: documentPage.font
                        elide: Text.ElideRight
                    }
                }
            }
        }
    }
}
