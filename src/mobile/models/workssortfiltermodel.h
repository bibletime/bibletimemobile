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

#ifndef WORKSSORTFILTERMODEL_H
#define WORKSSORTFILTERMODEL_H

#include <QSortFilterProxyModel>

class WorksSortFilterModel: public QSortFilterProxyModel {

    Q_OBJECT

public:

    WorksSortFilterModel(QObject * parent = nullptr);

    void setCategoryFilter(const QString& category);
    void setTextFilter(const QString& text);

protected:

    bool filterAcceptsRow(int row, const QModelIndex & parent) const override;


private:

    QString m_categoryFilter;
    QString m_textFilter;

};

#endif // WORKSSORTFILTERMODEL_H
