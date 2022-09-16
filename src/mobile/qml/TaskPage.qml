import QtQuick 2.0
import QtQuick.Controls.Material 2.3
import QtQuick.Controls 2.5

Item {
    id: taskPage

    property real fontPointSize: btStyle.uiFontPointSize

    property alias install: installRadioButton.checked
    property alias update: updateRadioButton.checked
    property alias remove: removeRadioButton.checked

    function initPage() {
        console.log("taskPage.initPage")
        bookshelfManager.changeButton("next", true);
        bookshelfManager.changeButton("close", true);
    }

    function donePage() {

    }

    ButtonGroup {
        buttons: column.children
    }

    Column {
        id: column

        anchors.verticalCenter: parent.verticalCenter

        RadioButton {
            id: installRadioButton

            checked: true
            text: qsTr("Install additional documents (uses internet)")
            font.pointSize: taskPage.fontPointSize
        }

        RadioButton {
            id: updateRadioButton

            text: qsTr("Update installed documents (uses internet)")
            font.pointSize: taskPage.fontPointSize
        }

        RadioButton {
            id: removeRadioButton

            text: qsTr("Remove installed documents")
            font.pointSize: taskPage.fontPointSize
        }
    }

}
