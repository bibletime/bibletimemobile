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

#include <QRegularExpression>
#include "btmmoduletextfilter.h"
#include "colormanagermobile.h"

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
    localText = ColorManagerMobile::instance().replaceColors(localText);
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
// TODO test
void BtmModuleTextFilter::fixDoubleBR() {
    static QRegularExpression const rx(R"regex(<br\s*/>)regex");
    for (int index = 2; index < m_parts.count(); ++index) {
        if (m_parts.at(index).contains(rx) && m_parts.at(index-2).contains(rx))
            m_parts[index] = "";
    }
}

// Typical input:  <span class="footnote" note="ESV2011/Luke 11:37/1">
// Output:         <span class="footnote" note="ESV2011/Luke 11:37/1">1</span>

int BtmModuleTextFilter::rewriteFootnoteAsLink(int i, QString const & part) {
    if (i + 2 >= m_parts.count())
        return 1;

    static QRegularExpression const rx(R"regex(note="([^"]*))regex");
    if (auto const match = rx.match(part); match.hasMatch()) {
        auto const & footnoteText = m_parts.at(i + 1);
        m_parts[i] =
            QStringLiteral(
                R"HTML(<a class="footnote" href="sword://footnote/%1=%2">)HTML")
                .arg(match.captured(1)).arg(footnoteText);
        m_parts[i+1] = QStringLiteral("(%1)").arg(footnoteText);
        m_parts[i+2] = QStringLiteral("</a>");
        return 3;
    }
    return 1;
}

// Packs attribute part of href into the link
// Typical input: <a name="Luke11_29" href="sword://Bible/ESV2011/Luke 11:29">
// Output:        <a href="sword://Bible/ESV2011/Luke 11:29||name=Luke11_29">

int BtmModuleTextFilter::rewriteHref(int i, const QString & part) {
    static QRegularExpression const rx(
        R"regex(<a\s+(\w+)="([^"]*)"\s+(\w+)="([^"]*)")regex");
    if (auto const match = rx.match(part); match.hasMatch())
        m_parts[i] =
            ((match.captured(1) == QStringLiteral("href"))
                 ? QStringLiteral(R"HTML(<a %1="%2||%3=%4" name="crossref">)HTML")
                 : QStringLiteral(R"HTML(<a %3="%4||%1=%2" name="crossref">)HTML"))
                .arg(match.captured(1),
                     match.captured(2),
                     match.captured(3),
                     match.captured(4));
    return 1;
}

// Typical input: <span lemma="H07225">God</span>
// Output: "<a href="sword://lemmamorph/lemma=H0430||/God" style="color: black">"

int BtmModuleTextFilter::rewriteLemmaOrMorphAsLink(int i, QString const & part)
{
    if (i + 2 >= m_parts.count())
        return 1;

    QString value;
    {
        static QRegularExpression const rx(R"regex(lemma="([^"]*)")regex");
        if (auto const match = rx.match(part); match.hasMatch())
            value = QStringLiteral("lemma=") + match.captured(1);
    }{
        static QRegularExpression const rx(R"regex(morph="([^"]*)")regex");
        if (auto const match = rx.match(part); match.hasMatch()) {
            if (value.isEmpty()) {
                value = QStringLiteral("morph=") + match.captured(1);
            } else {
                value = QStringLiteral("%1||morph=%2")
                .arg(value, match.captured(1));
            }
        }
    }

    auto const & refText = m_parts.at(i + 1);
    m_parts[i] =
        QStringLiteral(
            R"HTM(<a id="lemmamorph" href="sword://lemmamorph/%1/%2">)HTM")
            .arg(value, refText);
    m_parts[i + 2] = QStringLiteral("</a>");
    return 3;
}

void BtmModuleTextFilter::setShowReferences(bool on) {
    m_showReferences = on;
}

} // end namespace
