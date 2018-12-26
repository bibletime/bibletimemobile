
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


ComboBox {
    id: control

    property bool sizeToContents: true
    property int modelWidth

    function updateWidth(modules) {
        control.model = modules
        textMetrics.font = control.font

        for (var i = 0; i < modules.length; i++) {
            textMetrics.text = modules[i];
            modelWidth = Math.max(textMetrics.width, modelWidth)
        }
    }

    font.pointSize: btStyle.uiFontPointSize
    width: (sizeToContents) ? modelWidth + 2*leftPadding + 2*rightPadding : implicitWidth
    delegate: ItemDelegate {
        width: control.width
        text: control.textRole ? (Array.isArray(control.model) ? modelData[control.textRole] : model[control.textRole]) : modelData
        font.weight: control.currentIndex === index ? Font.DemiBold : Font.Normal
        font.family: control.font.family
        font.pointSize: btStyle.uiFontPointSize
        highlighted: control.highlightedIndex === index
        hoverEnabled: control.hoverEnabled
    }

    TextMetrics {
        id: textMetrics
    }

}
