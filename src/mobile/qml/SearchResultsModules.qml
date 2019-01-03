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
import QtQuick.Controls.Material 2.3

Rectangle {
    id: modules

    property alias currentIndex: modulesView.currentIndex
    property string moduleName: ""

    color: Material.background

    TitleColorBar {
        id: titleBar1

        title: qsTr("Documents")
        width: parent.width
    }

    ListSelectView {
        id: modulesView

        model: btSearchInterface.modulesModel
        anchors.top: titleBar1.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        leftTextMargin: 30

        onItemSelected: {
            modules.moduleName = btSearchInterface.getModuleName(modulesView.currentIndex);
        }
    }
}

