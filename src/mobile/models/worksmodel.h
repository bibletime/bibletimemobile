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

#ifndef WORKSMODEL_H
#define WORKSMODEL_H

#include <QStandardItemModel>
#include <QVariant>

enum WorksRoles3 {
    ModuleNameRole = Qt::UserRole + 21,
    VersionRole = Qt::UserRole + 22,
    DescriptionRole = Qt::UserRole + 23,
    CheckedRole = Qt::UserRole + 24,
    SourceNameRole = Qt::UserRole + 25,
    CategoryRole = Qt::UserRole + 26
};


class WorksModel : public QStandardItemModel {
public:
    WorksModel(QObject * parent = nullptr);

    QVariant data(QModelIndex const & index,
                  int role = Qt::DisplayRole) const final override;

    virtual bool setData(const QModelIndex &index, const QVariant &value, int role = Qt::EditRole) final override;

};

#endif // WORKSMODEL_H
