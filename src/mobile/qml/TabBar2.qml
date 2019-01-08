import QtQuick 2.11
import QtQuick.Controls.Material 2.3

ListView {
    id: listView

    property int elideWidth: 50
    property real pointSize: 10

    anchors.top: parent.top
    anchors.left: parent.left
    highlightFollowsCurrentItem: true
    width: parent.width
    height: btStyle.pixelsPerMillimeterX * 9
    orientation: ListView.Horizontal
    snapMode: ListView.SnapOneItem
    spacing: btStyle.pixelsPerMillimeterX * 3
    delegate: Item {
        id: item

        height: fontMetrics.height + topMargin + bottomMargin
        width: listView.maxWidth();


        Text {
            id: titleText

            color: (item.ListView.isCurrentItem) ? Material.accent : Material.foreground
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: listView.bottomMargin * 2
            text: {
                var t = listView.getTitle(index)
                var t2 = btStyle.elideLeft(t, listView.elideWidth);
                return t2;
            }
            font.pointSize: fontMetrics.font.pointSize
            horizontalAlignment: Text.AlignHCenter
        }

        Rectangle {
            id: titleUnderline

            anchors.left: parent.left
            anchors.leftMargin: 5
            anchors.right: parent.right
            anchors.rightMargin: 5
            anchors.bottom: parent.bottom
            visible: item.ListView.isCurrentItem
            color: Material.accent
            height: 2
        }
    }

    MouseArea {
        id: mouseArea

        anchors.fill: listView
        onClicked: itemWasSelected()

        function itemWasSelected() {
            listView.currentIndex = listView.indexAt(
                        mouseX+listView.contentX, mouseY+listView.contentY);
        }
    }

    FontMetrics {
        id: fontMetrics

        font.pointSize: listView.pointSize
    }
}
