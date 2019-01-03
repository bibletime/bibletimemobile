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
    id: progressDialog

    property alias minimumValue: progressBar.from
    property alias value: progressBar.value
    property alias maximumValue: progressBar.to
    property alias text: label.text

    standardButtons: Dialog.Cancel
    contentItem: Item {

        BtStyle {
            id: btStyle
        }

        ColumnLayout {
            id: columnLayout

            spacing: btStyle.pixelsPerMillimeterX * 3
            width: parent.width

            Text {
                id: label

                font.pointSize: btStyle.uiFontPointSize
                color: Material.foreground
                Layout.preferredWidth: progressDialog.width * 0.9
                horizontalAlignment: Text.AlignHCenter
            }

            ProgressBar {
                id: progressBar

                Layout.preferredWidth: progressDialog.width * 0.9
            }
        }
    }
}
