/*********
*
* In the name of the Father, and of the Son, and of the Holy Spirit.
*
* This file is part of BibleTime's source code, http://www.bibletime.info/.
*
* Copyright 1999-2018 by the BibleTime developers.
* The BibleTime source code is licensed under the GNU General Public License
* version 2.0.
*
**********/

#include "sessioninterface.h"

#include "backend/managers/cswordbackend.h"
#include "backend/config/btconfig.h"
#include "mobile/ui/btstyle.h"

namespace btm {

SessionInterface::SessionInterface() :
    QObject() {
}

int SessionInterface::getColorTheme() {
    auto sessionConf = btConfig().session();
    return sessionConf.value<int>("ColorTheme", BtStyle::darkTheme);
}

int SessionInterface::getWindowArrangementMode() {
    auto sessionConf = btConfig().session();
    return sessionConf.value<int>("MainWindow/MDIArrangementMode");
}

QStringList SessionInterface::getWindowList() {

    auto const sessionConf = btConfig().session();
    auto w = sessionConf.value<QStringList>(QStringLiteral("windowsList"));
    return w;
}

QStringList SessionInterface::getInstalledModuleList(const QStringList& names) {
    QStringList installed;
    for (int i=0; i < names.count(); ++i) {
        QString moduleName = names.at(i);
        CSwordModuleInfo * module = CSwordBackend::instance().findModuleByName(moduleName);
        if (module != nullptr)
            installed.append(moduleName);
    }
    return installed;
}

QStringList SessionInterface::getWindowModuleList(const QString& win) {
    auto const sessionConf = btConfig().session();
    const QString windowGroup = "window/" + win + '/';
    QStringList moduleNames = sessionConf.value<QStringList>(windowGroup + "modules");
    QStringList installed = getInstalledModuleList(moduleNames);
    return installed;
}

QString SessionInterface::getWindowKey(const QString& win) {
    auto sessionConf = btConfig().session();
    const QString windowGroup = "window/" + win + '/';
    const QString key = sessionConf.value<QString>(windowGroup + "key");
    return key;
}

void SessionInterface::setColorTheme(const QString& color) {
    auto sessionConf = btConfig().session();
    sessionConf.setValue("ColorTheme",color);
}

void SessionInterface::setWindowArrangementMode(int mode) {
    auto sessionConf = btConfig().session();
    sessionConf.setValue("MainWindow/MDIArrangementMode", mode);
}

void SessionInterface::setWindowList(const QStringList& list) {
    auto sessionConf = btConfig().session();
    sessionConf.setValue(QStringLiteral("windowsList"), list);
}

void SessionInterface::setWindowModuleList(int index, const QStringList& modules) {
    const QString windowKey = QString::number(index);
    const QString windowGroup = "window/" + windowKey + '/';

    auto conf = btConfig().session().group(windowGroup);
    conf.setValue(QStringLiteral("modules"), modules);
}

void SessionInterface::setWindowKey(int index, const QString& key) {
    const QString windowKey = QString::number(index);
    const QString windowGroup = "window/" + windowKey + '/';

    auto conf = btConfig().session().group(windowGroup);
    conf.setValue(QStringLiteral("key"), key);
}

}
