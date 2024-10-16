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

#ifndef INSTALL_INTERFACE_H
#define INSTALL_INTERFACE_H

#include <QList>
#include <QObject>
#include <QSortFilterProxyModel>
#include <QString>
#include <QStringList>
#include <QMap>
#include <backend/managers/cswordbackend.h>
#include "mobile/models/roleitemmodel.h"
#include "mobile/models/workssortfiltermodel.h"
#include "backend/bookshelfmodel/btbookshelffiltermodel.h"
#include "mobile/models/documentmodel.h"
#include "mobile/models/worksmodel.h"
#include <optional>
#include <memory>

class BtInstallThread;
class CSwordBackend;
class CSwordModuleInfo;

namespace btm {

class InstallSources;

class InstallInterface : public QObject {
    Q_OBJECT

public:
    InstallInterface();



    // UpdatingLibrariesPage.qml   ************************
public:
    Q_PROPERTY(qreal progressMax    READ progressMax     NOTIFY progressMaxChanged)
    Q_PROPERTY(qreal progressMin    READ progressMin     NOTIFY progressMinChanged)
    Q_PROPERTY(QString progressText READ progressText    NOTIFY progressTextChanged)
    Q_PROPERTY(qreal progressValue  READ progressValue   NOTIFY progressValueChanged)

    Q_INVOKABLE void cancel();
    Q_INVOKABLE void refreshLists2();
    Q_INVOKABLE QString addRemoteLibrary(const QString& name, int type,
                                      const QString& server, const QString& path);

    qreal progressMax() const;
    qreal progressMin() const;
    QString progressText() const;
    qreal progressValue() const;
    void setProgressMin(qreal value);
    void setProgressMax(qreal value);
    void setProgressText(const QString& value);
    void setProgressValue(qreal value);
signals:
    void progressMaxChanged();
    void progressMinChanged();
    void progressTextChanged();
    void progressValueChanged();
    void finishedDownload();



    // ChooseSourcesPage.qml   ****************************
public:
    Q_PROPERTY(QVariant sourceModel2   READ sourceModel2   NOTIFY sourceModel2Changed)

    Q_INVOKABLE void initializeSourcesModel();
    Q_INVOKABLE void finishChoosingLibraries();

    QVariant sourceModel2();
signals:
    void sourceModel2Changed();



    // ChooseLanguagePage.qml   ***************************
public:
    Q_PROPERTY(QVariant indexOfFirstLanguageChecked READ indexOfFirstLanguageChecked NOTIFY indexOfFirstLanguageCheckedChanged)
    Q_PROPERTY(QVariant languageModel2 READ languageModel2 NOTIFY languageModel2Changed)

    Q_INVOKABLE void initializeLanguagesModel();
    Q_INVOKABLE void finishChoosingLanguages();

    QVariant indexOfFirstLanguageChecked();
    QVariant languageModel2();
signals:
    void indexOfFirstLanguageCheckedChanged();
    void languageModel2Changed();



    // ChooseDocumentsPage.qml   **************************
public:
    Q_PROPERTY(QVariant categoryModel READ categoryModel NOTIFY categoryModelChanged)
    Q_PROPERTY(QVariant documentsSortFilterModel READ documentsSortFilterModel NOTIFY documentsSortFilterModelChanged)

    Q_INVOKABLE void initializeCategoriesModel();
    Q_INVOKABLE void initializeDocumentsModel();
    Q_INVOKABLE QString categoryFromIndex(int i);
    Q_INVOKABLE void filterWorksByCategory(const QString& category);
    Q_INVOKABLE void filterWorksByText(const QString& text);
    Q_INVOKABLE void finishChoosingDocuments();

    QVariant categoryModel();
    QVariant documentsSortFilterModel();
    void initializeDocumentsItem(
            const CSwordModuleInfo * module,
            QStandardItem * item,
            const QString& sourceName);
signals:
    void categoryModelChanged();
    void documentsSortFilterModelChanged();



    // RemoveDocumentsPage.qml   **************************
public:
    Q_INVOKABLE void initializeRemoveDocumentsModel();
    Q_INVOKABLE void finishRemovingDocuments();



    // UpdateDocumentsPage.qml   **************************
public:
    Q_INVOKABLE void initializeUpdateDocumentsModel();





    // InstallPage.qml   **********************************
public:
    Q_INVOKABLE void installDocuments();
signals:



    // Other   ********************************************
public:
    Q_PROPERTY(QVariant worksModel    READ worksModel    NOTIFY worksModelChanged)
    Q_PROPERTY(bool progressVisible READ progressVisible NOTIFY progressVisibleChanged)
    Q_PROPERTY(bool wasCanceled READ getWasCanceled NOTIFY wasCanceledChanged)
    Q_PROPERTY(QVariant languageModel READ languageModel NOTIFY languageModelChanged)
    Q_INVOKABLE void updateWorksModel(
            const QString& sourceName,
            const QString& categoryName,
            const QString& languageName);
    Q_INVOKABLE int installedModulesCount();
    Q_INVOKABLE void clearModules();
    Q_INVOKABLE void addModule(const QString& sourceName, const QString& moduleName);
    Q_INVOKABLE void addSource(const QString& sourceName);
    Q_INVOKABLE void installModulesAuto();
    Q_INVOKABLE void refreshListsAutomatic(
            const QString& source,
            const QString& category,
            const QString& language);
    Q_INVOKABLE void updateCategoryModel();
    Q_INVOKABLE void updateLanguageModel(const QString& currentCategory);
    bool progressVisible() const;
    QVariant worksModel();
    void setProgressVisible(bool value);
    bool getWasCanceled();
    QVariant languageModel();
    void updateSwordBackend(const QString& sourceName);
signals:
    void progressVisibleChanged();
    void wasCanceledChanged();
    void worksModelChanged();
    void languageModelChanged();
    void progressFinished();
    void modulesDownloadFinished();
    void updateCurrentViews(
            const QString& source,
            const QString& category,
            const QString& language);
private slots:
    void slotInstallStarted(int moduleIndex);
    void slotDownloadStarted(int moduleIndex);
    void slotStatusUpdated(int moduleIndex, int status);
    void slotOneItemCompleted(int moduleIndex, bool status);
    void slotThreadFinished();
    void slotPercentComplete2(int percent, const QString& title);
    void slotPercentComplete(int percent, const QString& title);
private:
    QString getModuleName(int moduleIndex);
    QString getSourcePath();
    void installModules();
    void removeModules();
    void runThread2();
    void runThread();
    void setupSourceModel();

    BtInstallThread* m_thread;
    InstallSources* m_worker;
    int m_nextInstallIndex;
    bool m_progressVisible;
    bool m_wasCanceled;
    qreal m_progressMin;
    qreal m_progressMax;
    qreal m_progressValue;
    BtBookshelfTreeModel::Grouping m_groupingOrder;
    int m_indexOfFirstLanguageChecked;
    QString m_progressText;
    QString m_tempSource;
    QString m_tempCategory;
    QString m_tempLanguage;
    QStringList m_sourceList;
    QStringList m_categoryList;
    QStringList m_languageList;
    QStringList m_worksTitleList;
    QStringList m_worksDescList;
    QList<CSwordModuleInfo*> m_worksList;
    QList<int> m_worksInstalledList;
    RoleItemModel m_sourceModel2;
    RoleItemModel m_sourceModel;
    RoleItemModel m_categoryModel;
    RoleItemModel m_languageModel;
    RoleItemModel m_languageModel2;
    RoleItemModel m_worksModel;
    WorksModel m_worksModel3;
    WorksSortFilterModel m_documentsSortFilterModel;
    BtBookshelfFilterModel*  m_filterModel;
    DocumentModel * m_installPageModel;
    BtBookshelfModel * m_bookshelfModel;
    QStringList m_selectedSources;
    QStringList m_selectedLanguages;
    int m_firstSelectedLanguage;
    QMap<CSwordModuleInfo*, bool> m_modulesToInstallRemove;
    QList<CSwordModuleInfo*> m_modulesToRemove;
    QList<CSwordModuleInfo*> m_modulesToInstall;

    std::vector<std::unique_ptr<CSwordBackend const>> m_usedBackends;
};

}
#endif
