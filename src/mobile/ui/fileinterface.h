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

#ifndef FILEINTERFACE_H
#define FILEINTERFACE_H

#include <QObject>

namespace btm  {

class FileInterface : public QObject
{
    Q_OBJECT

public:
    explicit FileInterface(QObject *parent = nullptr);

    Q_PROPERTY(QString source READ source WRITE setSource NOTIFY sourceChanged)
    Q_PROPERTY(QString contents READ contents NOTIFY contentsChanged)

    Q_INVOKABLE QString read();
    Q_INVOKABLE bool write(const QString& data);
    Q_INVOKABLE void copyToClipboard(const QString& text);

    QString source() { return m_source; }
    QString contents() const;

public slots:
    void setSource(const QString& source);

signals:
    void contentsChanged();
    void sourceChanged(const QString& source);
    void error(const QString& msg);

private:
    QString m_source;
    QString m_fileContent;
};

}
#endif

