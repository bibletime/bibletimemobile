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

#include "documentmodel.h"

#include "backend/drivers/cswordmoduleinfo.h"
#include "backend/managers/cswordbackend.h"


enum TextRoles {
    TextRole = Qt::UserRole + 1,
    CheckedRole = Qt::UserRole + 2
};

DocumentModel::DocumentModel(QObject * parent)
    : BtBookshelfTreeModel(parent)
{
    setDefaultChecked(BtBookshelfTreeModel::UNCHECKED);
    setCheckable(true);
}

QVariant DocumentModel::data(QModelIndex const & i, int role) const {
    QString textList;

    switch (role) {
        case Qt::DisplayRole:
            switch (i.column()) {
                case 0:
                    textList = BtBookshelfTreeModel::data(i, role).toString();
                    if (CSwordModuleInfo * const m =
                            module(index(i.row(), 0, i.parent())))
                    {
                        if (CSwordModuleInfo * imodule =
                                CSwordBackend::instance().findModuleByName(m->name()))
                            textList = "," + imodule->config(
                                        CSwordModuleInfo::ModuleVersion)
                                   + " => "
                                   + m->config(CSwordModuleInfo::ModuleVersion);
                        else
                            textList += "," + m->config(CSwordModuleInfo::ModuleVersion);
                    }
                    if (CSwordModuleInfo * const m =
                            module(index(i.row(), 0, i.parent())))
                        textList  += "," + m->config(CSwordModuleInfo::Description);
                    return textList;
                default:
                    break;
            }
            return textList ;

        default:
            if (i.column() == 0)
                return BtBookshelfTreeModel::data(i, role);
            break;
    }

    return QVariant();
}

int DocumentModel::columnCount(QModelIndex const & parent) const {
    Q_UNUSED(parent);
    return 3;
}

QVariant DocumentModel::headerData(int section,
                                        Qt::Orientation orientation,
                                        int role) const
{
    if (role == Qt::DisplayRole && orientation == Qt::Horizontal) {
        switch (section) {
            case 0: return tr("Work");
            case 1: return tr("Version");
            case 2: return tr("Description");
            default: break;
        }
    }
    return QVariant();
}

QHash<int, QByteArray> DocumentModel::roleNames() const {
    QHash<int, QByteArray> roleNames;
    roleNames = BtBookshelfTreeModel::roleNames();
    roleNames[CheckedRole] = "checked2";
    return roleNames;
}
