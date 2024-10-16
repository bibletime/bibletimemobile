
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

#include "colormanagermobile.h"

#include <QApplication>
#include <QDir>
#include <QPalette>
#include <QSettings>
#include <utility>
#include "backend/managers/cdisplaytemplatemgr.h"
#include "btstyle.h"

namespace {

QString getColorByPattern(
        std::map<QString, std::map<QString, QString> > const & maps,
        QString const & pattern,
        QString const & style)
{
    QString activeTemplate;
    if (style.isEmpty())
        activeTemplate = CDisplayTemplateMgr::activeTemplateName();
    auto const mapIt(maps.find(activeTemplate));
    BT_ASSERT(mapIt != maps.end());
    auto const valueIt(mapIt->second.find(pattern));
    BT_ASSERT(valueIt != mapIt->second.end());
    BT_ASSERT(!valueIt->second.isEmpty());
    return valueIt->second;
}

} // anonymous namespace

ColorManagerMobile & ColorManagerMobile::instance() {
    static ColorManagerMobile r;
    return r;
}

ColorManagerMobile::ColorManagerMobile() = default;

QString ColorManagerMobile::replaceColors(QString content) {
    QString text = content;
    text.replace("#JESUS_WORDS_COLOR#", "red");
    text.replace("#HIGHLIGHT_COLOR#", btm::BtStyle::getTextBackgroundHighlightColor().name());
    text.replace("#LINK_COLOR#", btm::BtStyle::getLinkColor().name());
    return text;
}

QString ColorManagerMobile::getBackgroundColor(QString const & style)
{ return getColorByPattern(m_colorMaps, "BACKGROUND_COLOR", style); }

QString ColorManagerMobile::getBackgroundHighlightColor(QString const & style)
{ return getColorByPattern(m_colorMaps, "BACKGROUND_HIGHLIGHT", style); }

QString ColorManagerMobile::getForegroundColor(QString const & style)
{ return getColorByPattern(m_colorMaps, "FOREGROUND_COLOR", style); }

QString ColorManagerMobile::getCrossRefColor(QString const & style)
{ return getColorByPattern(m_colorMaps, "CROSSREF_COLOR", style); }
