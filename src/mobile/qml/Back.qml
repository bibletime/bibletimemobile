
import QtQuick 2.11
import QtQuick.Controls.Material 2.3

Item {
    id: backTool

    property string text: ""

    signal clicked

    Left {
        id: leftSymbol

        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        textColor: Material.foreground
        width: parent.height * 0.50
        height: parent.height * 0.85
    }

    Text {
        id: backText
        color: Material.foreground
        font.pointSize: btStyle.uiFontPointSize
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.leftMargin: search.spacing
        anchors.left: leftSymbol.right
        verticalAlignment: Text.AlignVCenter
        text: backTool.text
    }

    MouseArea {
        anchors.left: parent.left
        anchors.right: backText.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        onClicked: {
            backTool.clicked();
        }
    }
}


