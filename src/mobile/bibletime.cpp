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

#include "bibletime.h"

#include "backend/config/btconfig.h"
#include "backend/managers/btstringmgr.h"
#include "backend/managers/clanguagemgr.h"
#include "backend/managers/cswordbackend.h"
#include "bibletimeapp.h"
#include "util/directory.h"
#include <QLocale>
#include <QTextStream>
#include <stringmgr.h>
#include <swlog.h>
#include <QDebug>

namespace btm {

BibleTime::BibleTime(QObject* parent)
    : QObject(parent) {
    initBackends();
}


/** Initializes the backend */
void BibleTime::initBackends() {
    initSwordConfigFile();

    sword::StringMgr::setSystemStringMgr( new BtStringMgr() );

#ifdef Q_OS_MACOS
    // set a LocaleMgr with a fixed path to the locales.d of the DMG image on MacOS
    // note: this must be done after setting the BTStringMgr, because this will reset the LocaleMgr
    qDebug() << "Using sword locales dir: " << util::directory::getSwordLocalesDir().absolutePath().toUtf8();
    sword::LocaleMgr::setSystemLocaleMgr(new sword::LocaleMgr(util::directory::getSwordLocalesDir().absolutePath().toUtf8()));
#endif

    CSwordBackend *backend = CSwordBackend::createInstance();
    QString systemName = QLocale::system().name();
    QString language = btConfig().value<QString>("language", systemName);
    backend->booknameLanguage(language);

    const CSwordBackend::LoadError errorCode = CSwordBackend::instance()->initModules(CSwordBackend::OtherChange);
    if (errorCode != CSwordBackend::NoError) {
        ; // TODO
    }
}

void BibleTime::initSwordConfigFile() {

    // Remove sword.config from sword home because it is now created in user home.
    QString removeStr = util::directory::getUserHomeSwordDir().filePath("sword.conf");
    QFile removeFile(removeStr);
    if (removeFile.exists())
        removeFile.remove();

    QString configFile = util::directory::getUserHomeDir().filePath("sword.conf");
    QFile file(configFile);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        return;
    }
    QTextStream out(&file);
    out << "\n";
    out << "[Install]\n";
    out << "DataPath="   << util::directory::convertDirSeparators( util::directory::getUserHomeDir().absolutePath()) << "\n";
    out << "LocalePath="   << util::directory::convertDirSeparators( util::directory::getUserHomeSwordDir().absolutePath()) << "\n";
    out << "\n";
    file.close();

}

}
