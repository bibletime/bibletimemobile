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

#include "workssortfiltermodel.h"
#include "mobile/models/worksmodel.h"


WorksSortFilterModel::WorksSortFilterModel(QObject * parent)
    : QSortFilterProxyModel(parent) {
}

bool WorksSortFilterModel::filterAcceptsRow(int row,
                                            const QModelIndex & parent) const {
    QModelIndex child = sourceModel()->index(row, 0, parent);
    QString category = child.data(WorksRoles3::CategoryRole).toString();
    QString moduleName = child.data(WorksRoles3::ModuleNameRole).toString();
    QString description = child.data(WorksRoles3::DescriptionRole).toString();
    bool nameMatch = moduleName.contains(m_textFilter, Qt::CaseInsensitive);
    bool descriptionMatch = description.contains(m_textFilter, Qt::CaseInsensitive);

    if ( ! m_categoryFilter.isEmpty() && category != m_categoryFilter)
        return false;

    if (nameMatch || descriptionMatch)
        return true;
    return false;
}

void WorksSortFilterModel::setCategoryFilter(const QString& category) {
    m_categoryFilter = category;
    invalidateFilter();
}

void WorksSortFilterModel::setTextFilter(const QString& text) {
    m_textFilter = text;
    invalidateFilter();
}
