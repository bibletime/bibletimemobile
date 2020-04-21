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

//    QString sourceName = QStandardItemModel::data(i, WorksRoles3::SourceNameRole).toString();
//    QString moduleName = QStandardItemModel::data(i, WorksRoles3::ModuleNameRole).toString();
//    CSwordModuleInfo * module = CSwordBackend::instance()->findModuleByName(moduleName);

//    switch (role) {
//    case WorksRoles3::ModuleNameRole:
//        return moduleName;

//    case WorksRoles3::VersionRole:
//        if (module)
//            return module->config(CSwordModuleInfo::ModuleVersion);
//        return "";

//    case WorksRoles3::DescriptionRole:
//        if (module)
//            return module->config(CSwordModuleInfo::Description);
//        return "";

//    case WorksRoles3::CheckedRole:
//        return "4";

//    default:
//        return "";
//    }

//    return QVariant();
    return QStandardItemModel::data(i,role);
}

bool WorksModel::setData(const QModelIndex &index, const QVariant &value, int role) {
    return QStandardItemModel::setData(index, value, role);
}
