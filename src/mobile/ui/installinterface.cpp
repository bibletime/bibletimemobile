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

#include "installinterface.h"

#include "backend/btinstallbackend.h"
#include "backend/btinstallthread.h"
#include "backend/config/btconfig.h"
#include "mobile/bookshelfmanager/installsources.h"
#include <QThread>
#include <QDebug>

namespace btm {

enum WizardTaskType {
    installWorks,
    updateWorks,
    removeWorks
};

enum TextRoles {
    TextRole = Qt::UserRole + 1,
    CheckedRole = Qt::UserRole + 2
};

enum WorksRoles1 {
    ModuleNameRole = Qt::UserRole + 1,
    DescriptionRole = Qt::UserRole + 2,
    SelectedRole = Qt::UserRole + 3,
    InstalledRole = Qt::UserRole + 4,
    SourceNameRole = Qt::UserRole + 5
};

QString const SourceKey = "GUI/InstallManager/source";
QString const CategoryKey = "GUI/InstallManager/category";
QString const LanguageKey = "GUI/InstallManager/language";

QString const SourcesKey = "GUI/BookshelfWizard/sources";
QString const LanguagesKey = "GUI/BookshelfWizard/languages";

QString const groupingOrderKey("GUI/BookshelfWizard/InstallPage/grouping");

InstallInterface::InstallInterface() :
    QObject(),
    m_backend(0),
    m_thread(0),
    m_worker(0),
    m_nextInstallIndex(0),
    m_progressVisible(false),
    m_wasCanceled(false),
    m_progressMin(0),
    m_progressMax(0),
    m_progressValue(0),
    m_groupingOrder(groupingOrderKey) {

    // Setup models:
    m_bookshelfModel = new BtBookshelfModel(this);
    m_installPageModel = new DocumentModel(m_groupingOrder, this);
    m_installPageModel->setSourceModel(m_bookshelfModel);
    m_filterModel = new BtBookshelfFilterModel(this);
    m_filterModel->setSourceModel(m_installPageModel);
    m_documentsSortFilterModel.setSourceModel(&m_worksModel3);
    m_documentsSortFilterModel.setSortRole(WorksRoles3::ModuleNameRole);
}

// *******************************************************

void InstallInterface::refreshLists2() {
    m_wasCanceled = false;
    emit wasCanceledChanged();
    m_tempSource.clear();
    m_tempCategory.clear();
    m_tempLanguage.clear();
    setProgressMin(0);
    setProgressMax(100);
    setProgressValue(0);
    setProgressText(tr("Getting document lists from remote libraries"));
    setProgressVisible(true);
    runThread2();
}

void InstallInterface::cancel() {
    m_wasCanceled = true;
    emit wasCanceledChanged();
    if (m_thread) {
        m_thread->stopInstall();
        while (!m_thread->wait()) /* join */;
    }
    if (m_worker)
        m_worker->cancel();
    setProgressVisible(false);
}

qreal InstallInterface::progressMin() const {
    return m_progressMin;
}

qreal InstallInterface::progressMax() const {
    return m_progressMax;
}

qreal InstallInterface::progressValue() const {
    return m_progressValue;
}

QString InstallInterface::progressText() const {
    return m_progressText;
}

void InstallInterface::setProgressMin(qreal value) {
    m_progressMin = value;
    emit progressMinChanged();
}

void InstallInterface::setProgressMax(qreal value) {
    m_progressMax = value;
    emit progressMaxChanged();
}

void InstallInterface::setProgressValue(qreal value) {
    if (m_progressValue != value) {
        m_progressValue = value;
        emit progressValueChanged();
    }
}

void InstallInterface::setProgressText(const QString& value) {
    m_progressText = value;
    emit progressTextChanged();
}

// ****************************************************

static int setupCheckedModel2(const QStringList& modelList,
                              const QStringList& selectedList,
                              RoleItemModel* model) {
    QHash<int, QByteArray> roleNames;
    roleNames[TextRole] =  "modelText";
    roleNames[CheckedRole] = "checked2";
    model->setRoleNames(roleNames);

    int firstChecked = 0;
    model->clear();
    for (int i=0; i< modelList.count(); ++i) {
        QString source = modelList.at(i);
        bool selected = selectedList.contains(source);
        if (selected && firstChecked == 0)
            firstChecked = i;
        QStandardItem* item = new QStandardItem();
        item->setCheckable(true);
        item->setCheckState(Qt::Unchecked);
        item->setData(selected, CheckedRole);
        item->setData(source, TextRoles::TextRole);
        model->appendRow(item);
    }
    return firstChecked;
}

void InstallInterface::initializeSourcesModel() {
    m_sourceList = BtInstallBackend::sourceNameList();
    m_selectedSources = btConfig().value<QStringList>(SourcesKey, QStringList{});
    setupCheckedModel2(m_sourceList, m_selectedSources, &m_sourceModel2);
    emit sourceModel2Changed();
}

void InstallInterface::finishChoosingLibraries() {
    m_selectedSources.clear();
    for (int row=0; row<m_sourceModel2.rowCount(); ++row) {
        QModelIndex index = m_sourceModel2.index(row,0);
        QStandardItem * item = m_sourceModel2.itemFromIndex(index);
        bool checked = item->data(CheckedRole).toBool();
        if (checked) {
            QString library = item->data(TextRole).toString();
            m_selectedSources.append(library);
        }
    }
    btConfig().setValue(SourcesKey, m_selectedSources);
}

QVariant InstallInterface::sourceModel2() {
    QVariant var;
    var.setValue(&m_sourceModel2);
    return var;
}


// ***********************************************

void InstallInterface::initializeLanguagesModel() {
    QSet<QString> languageSet;
    for (auto const & sourceName : m_selectedSources)
        for (auto const * module :
             BtInstallBackend::backend(
                 BtInstallBackend::source(sourceName))->moduleList())
            languageSet.insert(module->language()->translatedName());
    QStringList languages = languageSet.values();
    languages.sort(Qt::CaseInsensitive);
    m_selectedLanguages = btConfig().value<QStringList>(LanguagesKey, QStringList{});
    m_indexOfFirstLanguageChecked = setupCheckedModel2(languages, m_selectedLanguages, &m_languageModel2);
    emit languageModel2Changed();
    emit indexOfFirstLanguageCheckedChanged();
}

void InstallInterface::finishChoosingLanguages() {
    m_selectedLanguages.clear();
    for (int row=0; row<m_languageModel2.rowCount(); ++row) {
        QModelIndex index = m_languageModel2.index(row,0);
        QStandardItem * item = m_languageModel2.itemFromIndex(index);
        bool checked = item->data(CheckedRole).toBool();
        if (checked) {
            QString language = item->data(TextRole).toString();
            m_selectedLanguages.append(language);
        }
    }
    btConfig().setValue(LanguagesKey, m_selectedLanguages);
}

QVariant InstallInterface::indexOfFirstLanguageChecked() {
    QVariant var;
    var.setValue(m_indexOfFirstLanguageChecked);
    return var;
}

QVariant InstallInterface::languageModel2() {
    QVariant var;
    var.setValue(&m_languageModel2);
    return var;
}




//  **************************************************** DocumentsPage

static void setupTextModel(const QStringList& modelList, RoleItemModel* model) {
    QHash<int, QByteArray> roleNames;
    roleNames[TextRole] =  "modelText";
    model->setRoleNames(roleNames);

    model->clear();
    for (int i=0; i< modelList.count(); ++i) {
        QString source = modelList.at(i);
        QStandardItem* item = new QStandardItem();
        item->setData(source, TextRole);
        model->appendRow(item);
    }
}

void InstallInterface::initializeCategoriesModel() {
    QSet<QString> categories;
    for (auto const & sourceName : m_selectedSources) {
        for (auto const * module :
             BtInstallBackend::backend(
                 BtInstallBackend::source(sourceName))->moduleList()) {

            QString lang = module->language()->translatedName();
            if (m_selectedLanguages.contains(lang)) {
                CSwordModuleInfo::Category category = module->category();
                QString categoryName = module->categoryName(category);
                categories.insert(categoryName);
            }
        }
    }
    m_categoryList = categories.values();
    m_categoryList.sort();
    setupTextModel(m_categoryList, &m_categoryModel);
}

void InstallInterface::initializeDocumentsItem(
        const CSwordModuleInfo * module,
        QStandardItem * item,
        const QString& sourceName) {

    CSwordModuleInfo::Category category = module->category();
    QString categoryName = module->categoryName(category);

    QString version = module->config(CSwordModuleInfo::ModuleVersion);
    QString description = module->config(CSwordModuleInfo::Description);

    item->setData(module->name(), WorksRoles3::ModuleNameRole);
    item->setData(version, WorksRoles3::VersionRole);
    item->setData(description, WorksRoles3::DescriptionRole);
    item->setData(false, WorksRoles3::CheckedRole);
    item->setData(sourceName, WorksRoles3::SourceNameRole);
    item->setData(categoryName, WorksRoles3::CategoryRole);
    item->setCheckable(true);
    item->setCheckState(Qt::Unchecked);
}

void InstallInterface::initializeDocumentsModel() {

    QSet<QString> installedModules;
    const QList<CSwordModuleInfo*> modules = CSwordBackend::instance()->moduleList();
    for (int moduleIndex=0; moduleIndex<modules.count(); ++moduleIndex) {
        CSwordModuleInfo* module = modules.at(moduleIndex);
        QString name = module->name();
        installedModules.insert(name);
    }
    m_worksModel3.clear();
    if (m_categoryModel.rowCount() == 0)
        return;
    for (auto const & sourceName : m_selectedSources) {
        for (auto const * module :
             BtInstallBackend::backend(
                 BtInstallBackend::source(sourceName))->moduleList()) {
            QString lang = module->language()->translatedName();
            if (! m_selectedLanguages.contains(lang))
                continue;
            QString moduleName = module->name();
            if (installedModules.contains(moduleName))
                continue;
            QStandardItem * item = new QStandardItem();

            initializeDocumentsItem(module, item, sourceName);

            m_worksModel3.appendRow(item);
        }
    }
    m_documentsSortFilterModel.setTextFilter("");
    m_documentsSortFilterModel.sort(0);
}

QString InstallInterface::categoryFromIndex(int i) {
    QModelIndex index = m_categoryModel.index(i,0);
    QVariant v = index.data(TextRoles::TextRole);
    return v.toString();
}

void InstallInterface::filterWorksByCategory(const QString& category) {
    m_documentsSortFilterModel.setCategoryFilter(category);
}

void InstallInterface::filterWorksByText(const QString& text) {
    m_documentsSortFilterModel.setTextFilter(text);
}

void InstallInterface::finishChoosingDocuments() {
    m_modulesToInstall.clear();
    for (int row=0; row<m_worksModel3.rowCount(); ++row) {
        QModelIndex index = m_worksModel3.index(row,0);
        QStandardItem * item = m_worksModel3.itemFromIndex(index);
        bool checked = item->data(WorksRoles3::CheckedRole).toBool();
        if (checked) {
            QString moduleName = item->data(WorksRoles3::ModuleNameRole).toString();
            QString sourceName = item->data(WorksRoles3::SourceNameRole).toString();
            sword::InstallSource const source = BtInstallBackend::source(sourceName);
            CSwordBackend * const backend = BtInstallBackend::backend(source);
            CSwordModuleInfo * module = backend->findModuleByName(moduleName);
            module->setProperty("installSourceName", sourceName);
            m_modulesToInstall.append(module);
        }
    }
}

QVariant InstallInterface::categoryModel() {
    QVariant var;
    var.setValue(&m_categoryModel);
    return var;
}

QVariant InstallInterface::documentsSortFilterModel() {
    QVariant var;
    var.setValue(&m_documentsSortFilterModel);
    return var;
}



//  **************************************************** Remove Documents Page

void InstallInterface::initializeRemoveDocumentsModel() {

    m_worksModel3.clear();
    m_documentsSortFilterModel.setTextFilter("");

    auto moduleList = CSwordBackend::instance()->moduleList();
    for (auto module : moduleList) {

        QStandardItem * item = new QStandardItem();
        initializeDocumentsItem(module, item, "");
        m_worksModel3.appendRow(item);
    }
    m_documentsSortFilterModel.setTextFilter("");
    m_documentsSortFilterModel.sort(0);
}

void InstallInterface::finishRemovingDocuments() {

    m_modulesToRemove.clear();
    for (int row=0; row<m_worksModel3.rowCount(); ++row) {
        QModelIndex index = m_worksModel3.index(row,0);
        QStandardItem * item = m_worksModel3.itemFromIndex(index);
        bool checked = item->data(WorksRoles3::CheckedRole).toBool();
        if (checked) {
            QString moduleName = item->data(WorksRoles3::ModuleNameRole).toString();
            CSwordModuleInfo * module = CSwordBackend::instance()->findModuleByName(moduleName);
            if (module)
                m_modulesToRemove.append(module);
        }
    }
    QSet<CSwordModuleInfo*> modulesSet(m_modulesToRemove.begin(), m_modulesToRemove.end());
    CSwordBackend::instance()->uninstallModules(modulesSet);
}


//  **************************************************** Update Documents Page

void InstallInterface::initializeUpdateDocumentsModel() {

    m_documentsSortFilterModel.setTextFilter("");
    QSet<QString> installedModules;
    const QList<CSwordModuleInfo*> modules = CSwordBackend::instance()->moduleList();
    for (int moduleIndex=0; moduleIndex<modules.count(); ++moduleIndex) {
        CSwordModuleInfo* module = modules.at(moduleIndex);
        QString name = module->name();
        installedModules.insert(name);
    }
    m_worksModel3.clear();
    QStringList sourceNames = BtInstallBackend::sourceNameList();
    for (auto const & sourceName : sourceNames) {
        for (auto const * module :
             BtInstallBackend::backend(
                 BtInstallBackend::source(sourceName))->moduleList()) {
            QString moduleName = module->name();
            if (! installedModules.contains(moduleName))
                continue;

            using CSMI = CSwordModuleInfo;
            using CSV = sword::SWVersion const;
            CSMI const * const installedModule =
                    CSwordBackend::instance()->findModuleByName(module->name());
            CSV localVersion = CSV(installedModule->config(CSMI::ModuleVersion).toLatin1());
            CSV remoteVersion = CSV(module->config(CSMI::ModuleVersion).toLatin1());
            bool update = localVersion < remoteVersion;
            if (update) {
                QStandardItem * item = new QStandardItem();
                initializeDocumentsItem(module, item, sourceName);

                QString versionInfo = QString(localVersion.getText()) +
                        " => " + QString(remoteVersion.getText());
                item->setData(versionInfo, WorksRoles3::VersionRole);

                //item->setData(module,WorksRoles3::ModuleRole);

                m_worksModel3.appendRow(item);
            }
        }
    }
    m_documentsSortFilterModel.sort(0);
}



//  **************************************************** Install Page


void InstallInterface::installDocuments() {
    installModules();
}

void InstallInterface::installModules() {
    if (m_modulesToInstall.count() == 0) {
        emit modulesDownloadFinished();
        return;
    }
    m_nextInstallIndex = 0;
    QString destination = getSourcePath();
    if (destination.isEmpty())
        return;
    m_wasCanceled = false;
    emit wasCanceledChanged();
    setProgressVisible(true);
    setProgressMin(0.0);
    setProgressMax(100.0);
    setProgressValue(0.0);

    m_thread = new BtInstallThread(m_modulesToInstall, destination, this);
    // Connect the signals between the dialog, items and threads
    BT_CONNECT(m_thread, SIGNAL(preparingInstall(int)),
               this,     SLOT(slotInstallStarted(int)),
               Qt::QueuedConnection);
    BT_CONNECT(m_thread, SIGNAL(downloadStarted(int)),
               this,     SLOT(slotDownloadStarted(int)),
               Qt::QueuedConnection);
    BT_CONNECT(m_thread, SIGNAL(statusUpdated(int, int)),
               this,     SLOT(slotStatusUpdated(int, int)),
               Qt::QueuedConnection);
    BT_CONNECT(m_thread, SIGNAL(installCompleted(int, bool)),
               this,     SLOT(slotOneItemCompleted(int, bool)),
               Qt::QueuedConnection);
    BT_CONNECT(m_thread, SIGNAL(finished()),
               this,     SLOT(slotThreadFinished()),
               Qt::QueuedConnection);
    m_thread->start();
}


// Other **************************************************

static CSwordModuleInfo* moduleInstalled(const CSwordModuleInfo& moduleInfo) {
    CSwordModuleInfo *installedModule = CSwordBackend::instance()->findModuleByName(moduleInfo.name());
    return installedModule;
}

static void setupWorksModel(const QStringList& titleList,
                            const QStringList& descriptionList,
                            const QList<int>& installedList,
                            RoleItemModel* model) {
    BT_ASSERT(titleList.count() == descriptionList.count());
    BT_ASSERT(titleList.count() == installedList.count());

    QHash<int, QByteArray> roleNames;
    roleNames[WorksRoles1::ModuleNameRole] =  "moduleName";
    roleNames[WorksRoles1::DescriptionRole] = "description";
    roleNames[WorksRoles1::SelectedRole] = "selected";
    roleNames[WorksRoles1::InstalledRole] = "installed";
    roleNames[WorksRoles1::SourceNameRole] = "sourceName";
    model->setRoleNames(roleNames);

    model->clear();
    for (int i=0; i< titleList.count(); ++i) {
        QStandardItem* item = new QStandardItem();
        QString title = titleList.at(i);
        item->setData(title, ModuleNameRole);
        QString description = descriptionList.at(i);
        item->setData(description, DescriptionRole);
        int installed = installedList.at(i);
        item->setData(installed, InstalledRole);
        item->setData(0, SelectedRole);
        model->appendRow(item);
    }
}

void InstallInterface::updateWorksModel(
        const QString& sourceName,
        const QString& categoryName,
        const QString& languageName)
{
    if (m_backend == nullptr)
        return;
    const QList<CSwordModuleInfo*> modules = m_backend->moduleList();

    m_worksTitleList.clear();
    m_worksDescList.clear();
    m_worksList.clear();
    m_worksInstalledList.clear();

    for (int moduleIndex=0; moduleIndex<modules.count(); ++moduleIndex) {
        CSwordModuleInfo* module = modules.at(moduleIndex);
        module->setProperty("installSourceName", sourceName);
        CSwordModuleInfo::Category category = module->category();
        QString moduleCategoryName = module->categoryName(category);
        const CLanguageMgr::Language* language = module->language();
        QString moduleLanguageName = language->translatedName();
        if (moduleCategoryName == categoryName &&
                moduleLanguageName == languageName ) {
            QString name = module->name();
            QString description = module->config(CSwordModuleInfo::Description);
            QString version = module->config(CSwordModuleInfo::ModuleVersion);
            QString info = description + ": " + version;\
            int installed = moduleInstalled(*module) ? 1 : 0;
            m_worksTitleList.append(name);
            m_worksDescList.append(info);
            m_worksList.append(module);
            m_worksInstalledList.append(installed);
        }
    }
    setupWorksModel(m_worksTitleList, m_worksDescList, m_worksInstalledList, &m_worksModel);
}


int InstallInterface::installedModulesCount() {
    return CSwordBackend::instance()->moduleList().count();
}

void InstallInterface::clearModules() {
    m_modulesToInstall.clear();
    m_modulesToInstallRemove.clear();
}

void InstallInterface::addModule(const QString& sourceName, const QString& moduleName) {
    updateSwordBackend(sourceName);
    const QList<CSwordModuleInfo*> modules = m_backend->moduleList();
    for (int moduleIndex=0; moduleIndex<modules.count(); ++moduleIndex) {
        CSwordModuleInfo* module = modules.at(moduleIndex);
        module->setProperty("installSourceName", sourceName);
        QString name = module->name();
        if (name == moduleName) {
            m_modulesToInstall.append(module);
        }
    }
}

void InstallInterface::addSource(const QString& sourceName) {
    sword::InstallSource newSource(""); //empty, invalid Source
    newSource.type = "FTP";
    newSource.source = sourceName.toUtf8();
    newSource.caption = sourceName.toUtf8();
    newSource.directory = "/pub/sword";
    newSource.uid = "20191111111111";
    BtInstallBackend::addSource(newSource);
}

void InstallInterface::installModulesAuto() {
    installModules();
}

bool InstallInterface::progressVisible() const {
    return m_progressVisible;
}

void InstallInterface::setProgressVisible(bool value) {
    m_progressVisible = value;
    emit progressVisibleChanged();
}

bool InstallInterface::getWasCanceled() {
    return m_wasCanceled;
}

QVariant InstallInterface::languageModel() {
    QVariant var;
    var.setValue(&m_languageModel);
    return var;
}

void InstallInterface::slotInstallStarted(int moduleIndex) {
    BT_ASSERT(moduleIndex == m_nextInstallIndex);
    m_nextInstallIndex++;
    setProgressText(tr("Installing %1").arg(getModuleName(moduleIndex)));
}

void InstallInterface::slotDownloadStarted(int moduleIndex) {
    setProgressValue(0);
    setProgressText(tr("Downloading %1").arg(getModuleName(moduleIndex)));
}

void InstallInterface::slotStatusUpdated(int /*moduleIndex*/, int status) {
    setProgressValue(status);
}

void InstallInterface::slotOneItemCompleted(int /* moduleIndex */, bool /* successful */) {
    // TODO show failed status
}

void InstallInterface::slotThreadFinished() {
    setProgressVisible(false);
    CSwordBackend::instance()->reloadModules(CSwordBackend::AddedModules);
    if (m_wasCanceled) {
        return;
    }
    emit modulesDownloadFinished();
}

void InstallInterface::slotPercentComplete2(int percent, const QString& title) {
    setProgressValue(percent);
    setProgressText(title);
    if (percent == 100) {
        setProgressVisible(false);
        setupSourceModel();
        updateSwordBackend(m_tempSource);
        updateCategoryModel();
        emit finishedDownload();
    }
}

QString InstallInterface::getModuleName(int moduleIndex) {
    BT_ASSERT(moduleIndex < m_modulesToInstall.count());
    CSwordModuleInfo * module = m_modulesToInstall.at(moduleIndex);
    return module->name();
}

QString InstallInterface::getSourcePath() {
    QStringList targets = BtInstallBackend::targetList();
    for (QStringList::iterator it = targets.begin(); it != targets.end(); ++it)  {
        // Add the path only if it's writable
        QString sourcePath = *it;
        if (sourcePath.isEmpty())
            continue;
        QDir dir(sourcePath);
        if (!dir.exists())
            continue;
        if (!dir.isReadable())
            continue;
        QFileInfo fi( dir.canonicalPath());
        if (!fi.isWritable())
            continue;
        return sourcePath;
    }
    return QString();
}

void InstallInterface::removeModules() {
    CSwordBackend::instance()->uninstallModules(m_modulesToRemove.toSet());
}

void InstallInterface::runThread2() {
    QThread* thread = new QThread;
    m_worker = new InstallSources();
    m_worker->moveToThread(thread);
    BT_CONNECT(thread, SIGNAL(started()), m_worker, SLOT(process()));
    BT_CONNECT(m_worker, SIGNAL(finished()), thread, SLOT(quit()));
    BT_CONNECT(m_worker, SIGNAL(finished()), m_worker, SLOT(deleteLater()));
    BT_CONNECT(thread, SIGNAL(finished()), thread, SLOT(deleteLater()));
    BT_CONNECT(thread, SIGNAL(finished()), this, SIGNAL(progressFinished()));
    BT_CONNECT(m_worker, SIGNAL(percentComplete(int, QString const &)),
               this,     SLOT(slotPercentComplete2(int, QString const &)));
    thread->start();
}

void InstallInterface::updateSwordBackend(const QString& sourceName) {
    if (sourceName.isEmpty())
        return;
    sword::InstallSource source = BtInstallBackend::source(sourceName);
    m_backend = BtInstallBackend::backend(source);
}

QVariant InstallInterface::worksModel() {
    QVariant var;
    var.setValue(&m_worksModel);
    return var;
}

void InstallInterface::refreshListsAutomatic(
        const QString& source,
        const QString& category,
        const QString& language) {
    m_wasCanceled = false;
    emit wasCanceledChanged();
    m_tempSource = source;
    m_tempCategory = category;
    m_tempLanguage = language;
    setProgressMin(0);
    setProgressMax(100);
    setProgressValue(0);
    setProgressText(tr("Refreshing Source List"));
    setProgressVisible(true);
    runThread();
}

void InstallInterface::runThread() {
    QThread* thread = new QThread;
    m_worker = new InstallSources();
    m_worker->moveToThread(thread);
    BT_CONNECT(thread, SIGNAL(started()), m_worker, SLOT(process()));
    BT_CONNECT(m_worker, SIGNAL(finished()), thread, SLOT(quit()));
    BT_CONNECT(m_worker, SIGNAL(finished()), m_worker, SLOT(deleteLater()));
    BT_CONNECT(thread, SIGNAL(finished()), thread, SLOT(deleteLater()));
    BT_CONNECT(thread, SIGNAL(finished()), this, SIGNAL(progressFinished()));
    BT_CONNECT(m_worker, SIGNAL(percentComplete(int, QString const &)),
               this,     SLOT(slotPercentComplete(int, QString const &)));
    thread->start();
}

void InstallInterface::slotPercentComplete(int percent, const QString& title) {
    setProgressValue(percent);
    setProgressText(title);
    if (percent == 100) {
        setProgressVisible(false);
        setupSourceModel();
        updateSwordBackend(m_tempSource);
        updateCategoryModel();        // TODO
        updateLanguageModel("");
        updateWorksModel(m_tempSource, "", "");
        emit updateCurrentViews(m_tempSource, m_tempCategory, m_tempLanguage);
    }
}

void InstallInterface::setupSourceModel() {
    m_sourceList = BtInstallBackend::sourceNameList();
    setupTextModel(m_sourceList, &m_sourceModel);
}

void InstallInterface::updateCategoryModel() {
    if (m_backend == nullptr)
        return;
    const QList<CSwordModuleInfo*> modules = CSwordBackend::instance()->moduleList();
    QSet<QString> categories;
    for (int moduleIndex=0; moduleIndex<modules.count(); ++moduleIndex) {
        CSwordModuleInfo* module = modules.at(moduleIndex);
        CSwordModuleInfo::Category category = module->category();
        QString categoryName = module->categoryName(category);
        categories.insert(categoryName);
    }
    m_categoryList = categories.values();
    m_categoryList.sort();
    setupTextModel(m_categoryList, &m_categoryModel);
}

void InstallInterface::updateLanguageModel(const QString& currentCategory) {
    if (m_backend == nullptr)
        return;
    const QList<CSwordModuleInfo*> modules = m_backend->moduleList();
    QSet<QString> languages;
    for (int moduleIndex=0; moduleIndex<modules.count(); ++moduleIndex) {
        CSwordModuleInfo* module = modules.at(moduleIndex);
        CSwordModuleInfo::Category category = module->category();
        QString categoryName = module->categoryName(category);
        if (!currentCategory.isEmpty() && currentCategory != categoryName)
            continue;
        const CLanguageMgr::Language* language = module->language();
        QString languageName = language->translatedName();
        languages.insert(languageName);
    }
    m_languageList = languages.values();
    m_languageList.sort();
    setupTextModel(m_languageList, &m_languageModel);
}

}

