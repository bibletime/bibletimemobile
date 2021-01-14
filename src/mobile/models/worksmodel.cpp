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

#include "mobile/models/worksmodel.h"
#include "backend/drivers/cswordmoduleinfo.h"
#include "backend/managers/cswordbackend.h"


WorksModel::WorksModel(QObject * parent)
    : QStandardItemModel(parent) {

    QHash<int, QByteArray> roleNames;
    roleNames[WorksRoles3::ModuleNameRole] =  "moduleName";
    roleNames[WorksRoles3::VersionRole] = "version";
    roleNames[WorksRoles3::DescriptionRole] = "description";
    roleNames[WorksRoles3::CheckedRole] = "installChecked";
    roleNames[WorksRoles3::SourceNameRole] = "sourceName";
    roleNames[WorksRoles3::CategoryRole] = "category";
    setItemRoleNames(roleNames);
}

QVariant WorksModel::data(QModelIndex const & i, int role) const {
    return QStandardItemModel::data(i,role);
}

bool WorksModel::setData(const QModelIndex &index, const QVariant &value, int role) {
    return QStandardItemModel::setData(index, value, role);
}
