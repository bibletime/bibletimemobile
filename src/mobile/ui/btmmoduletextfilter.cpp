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

#include "btmmoduletextfilter.h"
namespace btm {

BtmModuleTextFilter::BtmModuleTextFilter() :
    m_showReferences(false) {
}

BtmModuleTextFilter::~BtmModuleTextFilter() {
}

QString BtmModuleTextFilter::processText(const QString &text) {
    if (text.isEmpty())
        return text;
    QString localText = fixNonRichText(text);
    splitText(localText);
    fixDoubleBR();
    if (m_showReferences) {

        int i = 0;
        int count = m_parts.count();
        do {
            QString part = m_parts.at(i);

            if (part.startsWith("<") && part.contains("class=\"footnote\"")) {
                i= i + rewriteFootnoteAsLink(i, part);

            } else if (part.startsWith("<") && (part.contains("href=\"") ) ) {
                i = i + rewriteHref(i, part);

            } else if (part.startsWith("<") && (
                           part.contains("lemma=\"") ||part.contains("morph=\"") ) ) {
                i= i+ rewriteLemmaOrMorphAsLink(i, part);

            } else {
                i++;
            }
        } while (i < count);

    }
    return m_parts.join("");
}

QString BtmModuleTextFilter::fixNonRichText(const QString& text) {
    // Fix !P tag which is not rich text
    QString localText = text;
    int index = 0;
    while ((index = localText.indexOf("<!P>")) >= 0)
        localText.remove(index,4);
    return localText;
}

void BtmModuleTextFilter::splitText(const QString& text) {
    m_parts.clear();
    int from = 0;
    while (from < text.length()) {

        // Get text before tag
        int end = text.indexOf("<", from);
        if (end == -1)
            end = text.length();
        m_parts.append(text.mid(from, end-from));
        from = end;

        //Get tag text
        end = text.indexOf(">", from);
        if (end == -1)
            end = text.length();
        m_parts.append(text.mid(from, end-from+1));
        from = end+1;
    }
}

void BtmModuleTextFilter::fixDoubleBR() {
    for (int index = 2; index < m_parts.count(); ++index) {
        QRegExp rx("<br\\s+/>");
        if (m_parts.at(index).contains(rx) && m_parts.at(index-2).contains(rx))
            m_parts[index] = "";
    }
}

// Typical input:  <span class="footnote" note="ESV2011/Luke 11:37/1">
// Output:         <span class="footnote" note="ESV2011/Luke 11:37/1">1</span>

int BtmModuleTextFilter::rewriteFootnoteAsLink(int i, const QString& part) {
    if (i+2 > m_parts.count())
        return 1;

    QRegExp rxlen("note=\"([^\"]*)");
    int pos = rxlen.indexIn(part);
    if (pos > -1) {
        QString noteValue = rxlen.cap(1);
        QString footnoteText = m_parts.at(i+1);
        QString url = "sword://footnote/" + noteValue + "=" + footnoteText;
        QString newEntry = "<a class=\"footnote\" href=\"" + url + "\">";
        m_parts[i] = newEntry;
        m_parts[i+1] = "(" + footnoteText + ")";
        m_parts[i+2] = "</a>";
        return 3;
    }
    return 1;
}

// Packs attribute part of href into the link
// Typical input: <a name="Luke11_29" href="sword://Bible/ESV2011/Luke 11:29">
// Output:        <a href="sword://Bible/ESV2011/Luke 11:29||name=Luke11_29">

int BtmModuleTextFilter::rewriteHref(int i, const QString& part) {
    QRegExp rx1("<a\\s(\\w+)=\"([\\s\\S]*)\"\\s(\\w+)=\"([\\s\\S]*)\"");
    rx1.setMinimal(false);
    int pos1 = rx1.indexIn(part);
    if (pos1 >= 0 && rx1.captureCount() == 4) {
        QString newEntry;
        if (rx1.cap(1) == "href")
            newEntry = "<a " + rx1.cap(1) + "=\"" + rx1.cap(2) + "||" + rx1.cap(3) + "=" + rx1.cap(4) + "\" name=\"crossref\">";
        else
            newEntry = "<a " + rx1.cap(3) + "=\"" + rx1.cap(4) + "||" + rx1.cap(1) + "=" + rx1.cap(2) + "\" name=\"crossref\">";

        m_parts[i] = newEntry;
    }
    return 1;
}

// Typical input: <span lemma="H07225">God</span>
// Output: "<a href="sword://lemmamorph/lemma=H0430||/God" style="color: black">"
int BtmModuleTextFilter::rewriteLemmaOrMorphAsLink(int i, const QString& part) {

    QString value;
    QRegExp rx1("lemma=\"([^\"]*)*");
    int pos1 = rx1.indexIn(part);
    if (pos1 > -1)
        value = "lemma=" + rx1.cap(1);

    QRegExp rx2("morph=\"([^\"]*)(\){0,1}");
    int pos2 = rx2.indexIn(part);
    if (pos2 > -1) {
        if (!value.isEmpty())
            value += "||";
        value += "morph=" + rx2.cap(1);
    }

    QString refText = m_parts.at(i+1);
    QString url = "sword://lemmamorph/" + value + "/" + refText;
    QString newEntry;
    newEntry = "<a href=\"" + url + "\">";
    m_parts[i] = newEntry;
    m_parts[i+2] = "</a>";
    return 3;
}

void BtmModuleTextFilter::setShowReferences(bool on) {
    m_showReferences = on;
}

} // end namespace
