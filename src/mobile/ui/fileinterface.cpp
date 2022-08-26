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

#include "fileinterface.h"
#include <QClipboard>
#include <QFile>
#include <QGuiApplication>
#include <QTextStream>
#include <QUrl>

namespace btm {

FileInterface::FileInterface(QObject *parent) :
    QObject(parent) {
}

void FileInterface::setSource(const QString& source) {
    m_source = source;
    m_fileContent.clear();
    if (m_source.isEmpty())
        return;

    QFile file(m_source);
    m_fileContent.clear();
    if ( file.open(QIODevice::ReadOnly) ) {
        QString line;
        QTextStream t( &file );
        do {
            line = t.readLine();
            m_fileContent += line + "\n";
        } while (!line.isNull());

        file.close();
    } else {
        return;
    }
}

QString FileInterface::read() {
    return m_fileContent;
}

bool FileInterface::write(const QString& data) {
    if (m_source.isEmpty())
        return false;

    QFile file(m_source);
    if (!file.open(QFile::WriteOnly | QFile::Truncate))
        return false;

    QTextStream out(&file);
    out << data;

    file.close();

    return true;
}

QString FileInterface::contents() const {
    return m_fileContent;
}

void FileInterface::copyToClipboard(const QString& text) {
    QClipboard *clipboard = QGuiApplication::clipboard();
    clipboard->setText(text);
}

}
