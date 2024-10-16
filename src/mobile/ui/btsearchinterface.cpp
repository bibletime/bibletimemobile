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

#include "btsearchinterface.h"

#include <QDebug>
#include <QRegularExpression>
#include "backend/drivers/cswordmoduleinfo.h"
#include "backend/managers/cswordbackend.h"
#include "mobile/ui/indexthread.h"
#include "util/btconnect.h"


namespace btm {
using CSMI = QList<CSwordModuleInfo const *>;

BtSearchInterface::BtSearchInterface(QObject* parent) :
    QObject(parent),
    m_searchType(AndType),
    m_wasCancelled(false) {
}

BtSearchInterface::~BtSearchInterface() {
}

static const CSwordModuleInfo* getModuleFromResults(const CSwordModuleSearch::Results& results, int index) {

    int moduleIndex = 0;
    for (auto const & result : results) {
        if (moduleIndex == index)
            return result.module;
        ++moduleIndex;
    }
    return nullptr;
}

bool BtSearchInterface::modulesAreIndexed() {
    QStringList moduleList =  m_moduleList.split(", ");
    CSMI modules = CSwordBackend::instance().getConstPointerList(moduleList);
    QList<CSwordModuleInfo*> unindexedModules;
    for (auto const * const m : modules)
        if (!m->hasIndex())
            unindexedModules.append(const_cast<CSwordModuleInfo*>(m));
    if (unindexedModules.size() > 0)
        return false;
    return true;
}

void BtSearchInterface::slotModuleProgress(int value) {
    m_progressValue = value;
    emit progressValueChanged();
}

void BtSearchInterface::slotBeginModuleIndexing(const QString& moduleName) {
    m_progressText = tr("Indexing %1").arg(moduleName);
    emit progressTextChanged();
}
void BtSearchInterface::slotIndexingFinished() {
    emit indexingFinished();
}

void BtSearchInterface::cancel() {
    m_thread->stopIndex();
    m_wasCancelled = true;
}

bool BtSearchInterface::wasCanceled() {
    return m_wasCancelled;
}

enum TextRoles {
    TextRole = Qt::UserRole + 1,
    ValueRole = Qt::UserRole + 2
};

bool BtSearchInterface::indexModules() {
    QStringList moduleList =  m_moduleList.split(", ");
    CSMI modules = CSwordBackend::instance().getConstPointerList(moduleList);
    bool success = true;
    m_wasCancelled = false;

    QList<CSwordModuleInfo *> nonIndexedModules;
    Q_FOREACH(CSwordModuleInfo const * const cm, modules) {
        if (cm->hasIndex())
            continue;
        CSwordModuleInfo *m = const_cast<CSwordModuleInfo*>(cm);
        nonIndexedModules.append(m);
    }
    m_thread = new IndexThread(nonIndexedModules);
    BT_CONNECT(m_thread, SIGNAL(indexingProgress(int)),
               this,      SLOT(slotModuleProgress(int)));
    BT_CONNECT(m_thread, SIGNAL(beginIndexingModule(QString)),
               this,     SLOT(slotBeginModuleIndexing(QString)));
    BT_CONNECT(m_thread, SIGNAL(indexingFinished()),
               this, SLOT(slotIndexingFinished()));

    m_thread->start();
    return success;
}

bool BtSearchInterface::performSearch() {

    setupSearchType();
    QString searchText = prepareSearchText(m_searchText);

    // Check that we have the indices we need for searching
    QStringList moduleList =  m_moduleList.split(", ");
    CSMI modules = CSwordBackend::instance().getConstPointerList(moduleList);

    // Execute search:
    try {
        m_results =
            CSwordModuleSearch::search(searchText,
                                       modules,
                                       sword::ListKey()  // Scope not suppoted
                                       );
    } catch (...) {
        QString msg;
        try {
            throw;
        } catch (std::exception const & e) {
            msg = e.what();
        } catch (...) {
            msg = tr("<UNKNOWN EXCEPTION>");
        }
        // message::showWarning(this,
        //                      tr("Search aborted"),
        //                      tr("An internal error occurred while executing "
        //                         "your search:<br/><br/>%1").arg(msg));
        return false;
    }

    setupModuleModel(m_results);
    const CSwordModuleInfo* module = getModuleFromResults(m_results,0);
    auto & moduleSearchResult = m_results.front();
    auto resultsList = moduleSearchResult.results;
    setupReferenceModel(module, resultsList);
    return true;
}

bool BtSearchInterface::haveReferences() {
    return m_referencesModel.rowCount() != 0;
}

void BtSearchInterface::setupSearchType() {
    if (m_findChoice == "and")
        m_searchType = AndType;
    else if (m_findChoice == "or")
        m_searchType = OrType;
    else
        m_searchType = FullType;
}

QString BtSearchInterface::prepareSearchText(const QString& orig) {
    static const QRegularExpression syntaxCharacters("[+\\-()!\"~]");
    static const QRegularExpression andWords("\\band\\b", QRegularExpression::CaseInsensitiveOption);
    static const QRegularExpression orWords("\\bor\\b", QRegularExpression::CaseInsensitiveOption);
    QString text("");
    if (m_searchType == AndType) {
        text = orig.simplified();
        text.remove(syntaxCharacters);
        text.replace(andWords, "\"and\"");
        text.replace(orWords, "\"or\"");
        text.replace(" ", " AND ");
    }
    if (m_searchType == OrType) {
        text = orig.simplified();
        text.remove(syntaxCharacters);
        text.replace(andWords, "\"and\"");
        text.replace(orWords, "\"or\"");
    }
    if (m_searchType == FullType) {
        text = orig;
    }
    return text;
}

void BtSearchInterface::setupModuleModel(const CSwordModuleSearch::Results & results) {
    QHash<int, QByteArray> roleNames;
    roleNames[TextRole] =  "text";
    roleNames[ValueRole] = "value";
    m_modulesModel.setRoleNames(roleNames);
    m_modulesModel.clear();
    for (auto const & result : results) {
        auto module = result.module;
        auto results = result.results;
        const int count = results.size();
        QString moduleName = module->name();
        QString moduleEntry = moduleName + "(" +QString::number(count) + ")";
        QStandardItem* item = new QStandardItem();
        item->setData(moduleEntry, TextRole);
        item->setData(moduleName, ValueRole);
        m_modulesModel.appendRow(item);
    }
    emit modulesModelChanged();
}

/** Setups the list with the given module. */


void BtSearchInterface::setupReferenceModel(const CSwordModuleInfo *m,
                                            const CSwordModuleSearch::ModuleResultList & resultList)
{
    QHash<int, QByteArray> roleNames;
    roleNames[TextRole] =  "text";
    roleNames[ValueRole] = "value";
    m_referencesModel.setRoleNames(roleNames);

    m_referencesModel.clear();
    if (!m) {
        emit haveReferencesChanged();
        return;
    }

    const int count = resultList.size();
    if (!count)
        return;

    for (int index = 0; index < count; index++) {
        auto result = resultList.at(index);
        QString reference = QString::fromUtf8(result->getText());
        QStandardItem* item = new QStandardItem();
        item->setData(reference, TextRole);
        item->setData(reference, ValueRole);
        m_referencesModel.appendRow(item);
    }

    emit referencesModelChanged();
    emit haveReferencesChanged();
}

QString BtSearchInterface::getSearchText() const {
    return m_searchText;
}

QString BtSearchInterface::getFindChoice() const {
    return m_findChoice;
}

QString BtSearchInterface::getModuleList() const {
    return m_moduleList;
}

void BtSearchInterface::setSearchText(const QString& searchText) {
    m_searchText = searchText;
}

void BtSearchInterface::setFindChoice(const QString& findChoice) {
    m_findChoice = findChoice;
}

void BtSearchInterface::setModuleList(const QString& moduleList) {
    m_moduleList = moduleList;
}

QVariant BtSearchInterface::getModulesModel() {
    QVariant var;
    var.setValue(&m_modulesModel);
    return var;
}

QVariant BtSearchInterface::getReferencesModel() {
    QVariant var;
    var.setValue(&m_referencesModel);
    return var;
}

void BtSearchInterface::selectReferences(int moduleIndex) {
    const int count = m_results.size();
    if ( moduleIndex < 0 || moduleIndex >= count) {
        m_referencesModel.clear();
        emit haveReferencesChanged();
        return;
    }
    const CSwordModuleInfo* module = getModuleFromResults(m_results, moduleIndex);
    auto & moduleSearchResult = m_results.at(moduleIndex);
    auto resultsList = moduleSearchResult.results;
    setupReferenceModel(module, resultsList);
}

QString BtSearchInterface::getReference(int index) {
    const int count = m_referencesModel.rowCount();
    if ( index < 0 || index >= count)
        return QString();
    QString value = m_referencesModel.item(index,0)->data(ValueRole).toString();
    return value;
}

QString BtSearchInterface::getModuleName(int index) {
    const int count = m_modulesModel.rowCount();
    if ( index < 0 || index >= count)
        return QString();
    QString value = m_modulesModel.item(index,0)->data(ValueRole).toString();
    return value;
}

void BtSearchInterface::setSearchType(int searchType) {
    m_searchType = searchType;
}

qreal BtSearchInterface::progressValue() const {
    return m_progressValue;
}

QString BtSearchInterface::progressText() const {
    return m_progressText;
}


} // end namespace
