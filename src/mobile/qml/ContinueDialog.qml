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
//import QtQuick.Dialogs 1.2
import BibleTime 1.0

Dialog {
    id: continueDialog

    property alias text: continueText.text

    standardButtons: Dialog.Ok

    contentItem: Text {
        id: continueText
        width: parent.width
        wrapMode: Text.WordWrap
        font.pointSize: btStyle.uiFontPointSize
        color: Material.foreground
    }
}
