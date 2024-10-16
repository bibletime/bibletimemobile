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

#include <QDirIterator>
#include <QDebug>
#include <QGuiApplication>
#include <QQuickItem>
#include <QQmlApplicationEngine>
#include <QQmlDebuggingEnabler>
#include <QQuickStyle>
#include <QMessageLogContext>
#include <QMetaType>
#include <QOperatingSystemVersion>
#include <QStandardPaths>
#include <QStyleHints>
#if defined Q_OS_ANDROID
#include <QtAndroid>
#endif
#include <QTranslator>
#include "bibletime.h"
#include "backend/config/btconfig.h"
#include "backend/managers/cswordbackend.h"
#include "backend/bookshelfmodel/btbookshelftreemodel.h"
#include "util/bticons.h"
#include "mobile/bibletimeapp.h"
#include "mobile/config/btmconfig.h"
#include "mobile/models/searchmodel.h"
#include "mobile/ui/btstyle.h"
#include "mobile/ui/btbookmarkinterface.h"
#include "mobile/ui/btsearchinterface.h"
#include "mobile/ui/btwindowinterface.h"
#include "mobile/ui/chooserinterface.h"
#include "mobile/ui/configinterface.h"
#include "mobile/ui/fileinterface.h"
#include "mobile/ui/installinterface.h"
#include "mobile/ui/moduleinterface.h"
#include "mobile/ui/sessioninterface.h"
#include "mobile/util/btmlog.h"
#include "util/btassert.h"
#include "util/directory.h"
#include <stdio.h>
#include <swlog.h>

static QObject* s_rootObject = nullptr;
static QFont* defaultFont;
static FILE* messageFile;

void register_qml_classes() {
    QQmlDebuggingEnabler enabler;

    qmlRegisterType<btm::BtBookmarkInterface>("BibleTime", 1, 0, "BtBookmarkInterface");
    qmlRegisterType<btm::BtWindowInterface>("BibleTime", 1, 0, "BtWindowInterface");
    qmlRegisterType<btm::BtStyle>("BibleTime", 1, 0, "BtStyle");
    qmlRegisterType<btm::BtmConfig>("BibleTime", 1, 0, "BtmConfig");
    qmlRegisterType<btm::InstallInterface>("BibleTime", 1, 0, "InstallInterface");
    qmlRegisterType<btm::ModuleInterface>("BibleTime", 1, 0, "ModuleInterface");
    qmlRegisterType<btm::ChooserInterface>("BibleTime", 1, 0, "ChooserInterface");
    qmlRegisterType<btm::SessionInterface>("BibleTime", 1, 0, "SessionInterface");
    qmlRegisterType<btm::SearchModel>("BibleTime", 1, 0, "SearchModel");
    qmlRegisterType<btm::BtSearchInterface>("BibleTime", 1, 0, "BtSearchInterface");
    qmlRegisterType<btm::ConfigInterface>("BibleTime", 1, 0, "ConfigInterface");
    qmlRegisterType<btm::FileInterface>("BibleTime", 1, 0, "FileInterface");
}

void saveSession() {
    QMetaObject::invokeMethod(s_rootObject, "saveSession");
}

QFont getDefaultFont() {
    return *defaultFont;
}

static bool copyRecursively(const QString &srcFilePath,
                            const QString &tgtFilePath)
{
    QFileInfo srcFileInfo(srcFilePath);
    if (srcFileInfo.isDir()) {
        QDir targetDir(tgtFilePath);
        targetDir.cdUp();
        if (! targetDir.exists(QFileInfo(tgtFilePath).fileName()))
            if (!targetDir.mkdir(QFileInfo(tgtFilePath).fileName()))
                return false;
        QDir sourceDir(srcFilePath);
        bool sourceExists = sourceDir.exists();
        QStringList fileNames = sourceDir.entryList(QDir::Files | QDir::Dirs | QDir::NoDotAndDotDot | QDir::Hidden);
        foreach (const QString &fileName, fileNames) {
            const QString newSrcFilePath
                    = srcFilePath + QLatin1Char('/') + fileName;
            const QString newTgtFilePath
                    = tgtFilePath + QLatin1Char('/') + fileName;
            if (!copyRecursively(newSrcFilePath, newTgtFilePath))
                return false;
        }
    } else {
        if (! QFile::exists(tgtFilePath)) {
            if (!QFile::copy(srcFilePath, tgtFilePath))
                return false;
        }
    }
    return true;
}

void migrateAndBibleToHome(const QString& finalDir) {
    QString src("/sdcard/Android/data/net.bible.android.activity/files");
    QString directory = src + "/" + finalDir;
    QDir srcDir(src);
    bool srcExists = srcDir.exists(directory);
    if (! srcExists)
        return;
    QFileInfo srcInfo(srcDir, directory);
    QString srcPath = srcInfo.absoluteFilePath();

    QString dst(QDir::homePath());
    dst += "/.sword";
    QDir dstDir(dst);
    QFileInfo dstInfo(dstDir, finalDir);
    QString dstPath = dstInfo.filePath();

    copyRecursively(srcPath, dstPath);
}

void migrateDataExternalToHome(const QString& directory) {
    QString src(qgetenv("EXTERNAL_STORAGE"));
    QDir srcDir(src);
    bool srcExists = srcDir.exists(directory);
    if (! srcExists)
        return;
    QFileInfo srcInfo(srcDir, directory);
    QString srcPath = srcInfo.absoluteFilePath();

    QString dst(QDir::homePath());
    QDir dstDir(dst);
    QFileInfo dstInfo(dstDir, directory);
    QString dstPath = dstInfo.filePath();

    if (srcExists) {
        copyRecursively(srcPath, dstPath);
    }
}

#if defined(Q_OS_WIN) || defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
// Copies locale.qrc files into home sword directory under locales.d directory
static void installSwordLocales(QDir& homeSword)
{
    QDir sourceSwordLocales(":/sword/locales.d");
    if (!sourceSwordLocales.exists())
        return;

    QStringList filters;
    filters << "*.conf";
    QFileInfoList fileInfoList = sourceSwordLocales.entryInfoList(filters);

    if (!homeSword.exists("locales.d"))
        homeSword.mkdir(("locales.d"));
    homeSword.cd("locales.d");

    for (auto sourceFileInfo : fileInfoList) {

        QString fileName = sourceFileInfo.fileName();
        QString sourceFilePath = sourceFileInfo.absoluteFilePath();
        QFile sourceFile(sourceFilePath);

        QFileInfo destinationFileInfo(homeSword, fileName);
        QString destinationFilePath = destinationFileInfo.absoluteFilePath();
        QFile destinationFile(destinationFileInfo.absoluteFilePath());

        destinationFile.remove();
        sourceFile.copy(destinationFilePath);
    }
}
#endif

/*******************************************************************************
  Handle Qt's meta type system.
*******************************************************************************/

void registerMetaTypes() {
    qRegisterMetaType<FilterOptions>("FilterOptions");
    qRegisterMetaType<DisplayOptions>("DisplayOptions");

    qRegisterMetaType<BtConfig::StringMap>("StringMap");

    qRegisterMetaType<QList<int> >("QList<int>");
}

void myMessageOutput(QtMsgType type, const QMessageLogContext&, const QString& message ) {
    QByteArray msg = message.toLatin1();
    if (btConfig().value<bool>("DEBUG/BibleTime", false)) {
        fprintf(messageFile, "%s\n", msg.data());
        fflush(messageFile);
    }
}

void setupMessageLog() {
    if (! btConfig().value<bool>("DEBUG/BibleTime", false))
        return;

    QString logDir = QStandardPaths::writableLocation(QStandardPaths::HomeLocation);

    QString prevLog = logDir + "/bibletime_prev.log";
    QFile prevFile(prevLog);
    if (prevFile.exists())
        prevFile.remove();

    QString currentLog = logDir + "/bibletime.log";
    QFile currentFile(currentLog);
    if (currentFile.exists())
        currentFile.rename(prevLog);

    const char * dir = currentLog.toUtf8().data();
    messageFile = fopen(dir, "w");

    qInstallMessageHandler(myMessageOutput);

    qDebug() << "----- Begin Log --------";
}

void setupSwordLog() {
    if (! btConfig().value<bool>("DEBUG/Sword", false)) {
        sword::SWLog::getSystemLog()->setLogLevel(sword::SWLog::LOG_ERROR);
        return;
    }

    btm::BtmLog * btmLog = new btm::BtmLog();
    sword::SWLog::setSystemLog(btmLog);
    sword::SWLog::getSystemLog()->setLogLevel(sword::SWLog::LOG_DEBUG);
}

int main(int argc, char *argv[]) {
    namespace DU = util::directory;

    BibleTimeApp app(argc, argv);

    QQuickStyle::setStyle("Material");

    btm::BtStyle::setCurrentStyle(btm::BtStyle::darkTheme);

    registerMetaTypes();

    defaultFont = new QFont();
    *defaultFont = app.font();
    defaultFont->setPointSize(18);

    if (QOperatingSystemVersion::current().majorVersion() <= 10) {
        migrateDataExternalToHome(".bibletime");
        migrateDataExternalToHome(".sword");
        migrateAndBibleToHome("mods.d");
        migrateAndBibleToHome("modules");
    }

    if (!DU::initDirectoryCache()) {
        qFatal("Error initializing directory cache!");
        return EXIT_FAILURE;
    }

    app.startInit();
    if (!app.initBtConfig()) {
        return EXIT_FAILURE;
    }

    setupMessageLog();
    setupSwordLog();

    qDebug() << "UserHomeDir: " << util::directory::getUserHomeDir().absolutePath();
    qDebug() << "UserBaseDir:      " << util::directory::getUserBaseDir().absolutePath();
    qDebug() << "UserHomeSwordDir: " << util::directory::getUserHomeSwordDir().absolutePath();

#if defined(Q_OS_WIN) || defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
    QDir dir(util::directory::getUserHomeSwordDir().absolutePath());
    if (btm::BtStyle::getAppVersion() > btConfig().value<QString>("btm/version")) {
        installSwordLocales(dir);
        btConfig().setValue<QString>("btm/version", btm::BtStyle::getAppVersion());
    }
    if (! dir.exists("locales.d"))
        installSwordLocales(dir);
#endif

    //first install QT's own translations
    QTranslator qtTranslator;
    QString locale = QLocale::system().name();
    qtTranslator.load("qt_" + locale);
    app.installTranslator(&qtTranslator);
    //then our own
    QTranslator bibleTimeTranslator;
    bibleTimeTranslator.load( QString("bibletime_ui_").append(locale), DU::getLocaleDir().canonicalPath());
    app.installTranslator(&bibleTimeTranslator);
    QTranslator mobileTranslator;
    mobileTranslator.load( QString("mobile_ui_").append(locale), DU::getLocaleDir().canonicalPath());
    app.installTranslator(&mobileTranslator);
    qDebug() << "Translation Initialized";

    // Initialize display template manager:
    if (!app.initDisplayTemplateManager()) {
        qFatal("Error initializing display template manager!");
        return EXIT_FAILURE;
    }

    BtIcons btIcons;

    register_qml_classes();
    qDebug() << "QML classes registered";

    btm::BibleTime btm;
    qDebug() << "BibleTime initialized";

    QQmlApplicationEngine engine;
    engine.addImportPath("qrc:/share/bibletime/qml");
    engine.load(QUrl(QStringLiteral("qrc:/share/bibletime/qml/main.qml")));
    s_rootObject = engine.rootObjects().at(0);

    int rtn = app.exec();
    saveSession();
    return rtn;
}
