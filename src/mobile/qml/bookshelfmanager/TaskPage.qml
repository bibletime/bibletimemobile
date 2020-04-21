import QtQuick 2.0
import QtQuick.Controls.Material 2.3
import QtQuick.Controls 2.5

Item {
    id: taskPage

    property font font: Qt.font({ family: "Helvetica", pointSize: 10, weight: Font.Normal })

    property alias install: installRadioButton.checked
    property alias update: updateRadioButton.checked
    property alias remove: removeRadioButton.checked

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
            font: taskPage.font
        }

        RadioButton {
            id: updateRadioButton

            text: qsTr("Update installed documents (uses internet)")
            font: taskPage.font
        }

        RadioButton {
            id: removeRadioButton

            text: qsTr("Remove installed documents")
            font: taskPage.font
        }
    }

}
