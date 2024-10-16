/*********
*
* In the name of the Father, and of the Son, and of the Holy Spirit.
*
* This file is part of BibleTime's source code, http://www.bibletime.info/
*
* Copyright 1999-2020 by the BibleTime developers.
* The BibleTime source code is licensed under the GNU General Public License
* version 2.0.
*
**********/

#ifndef COLORMANAGER_H
#define COLORMANAGER_H

#include <map>
#include <QString>


class ColorManagerMobile {

public: /* Methods: */

    static ColorManagerMobile & instance();

    QString replaceColors(QString content);
    QString getBackgroundColor(QString const & style = QString());
    QString getBackgroundHighlightColor(QString const & style = QString());
    QString getForegroundColor(QString const & style = QString());
    QString getCrossRefColor(QString const & style = QString());

private: /* Methods: */

    ColorManagerMobile();

private: /* Fields: */

    std::map<QString, std::map<QString, QString> > m_colorMaps;

}; /* class ColorManagerMobile */

#endif
