
DEFINES += BT_VERSION=\\\"$${BT_VERSION}\\\"

isEmpty(BIBLETIME_PATH):BIBLETIME_PATH = ../../../../bibletime


BTGIT_VERSION = $$system(git -C  \""$$BIBLETIME_PATH"\" rev-parse HEAD)
DEFINES += BT_GIT_VERSION=\\\"$$BTGIT_VERSION\\\"
`
# Useless warnings
gcc:QMAKE_CXXFLAGS_DEBUG += -Wno-switch -Wno-unused-parameter -Wno-unused-variable -Wno-reorder -Wno-missing-field-initializers

INCLUDEPATH += ../../../../bibletime/src

SOURCES += \
    $${BIBLETIME_PATH}/src/backend/bookshelfmodel/btbookshelffiltermodel.cpp \
    $${BIBLETIME_PATH}/src/backend/bookshelfmodel/btbookshelfmodel.cpp \
    $${BIBLETIME_PATH}/src/backend/bookshelfmodel/btbookshelftreemodel.cpp \
    $${BIBLETIME_PATH}/src/backend/bookshelfmodel/moduleitem.cpp \
    $${BIBLETIME_PATH}/src/backend/bookshelfmodel/languageitem.cpp \
    $${BIBLETIME_PATH}/src/backend/bookshelfmodel/item.cpp \
    $${BIBLETIME_PATH}/src/backend/bookshelfmodel/categoryitem.cpp \
    $${BIBLETIME_PATH}/src/backend/bookshelfmodel/indexingitem.cpp \
    $${BIBLETIME_PATH}/src/backend/btbookmarksmodel.cpp \
    $${BIBLETIME_PATH}/src/backend/btglobal.cpp \
    $${BIBLETIME_PATH}/src/backend/btinstallbackend.cpp \
    $${BIBLETIME_PATH}/src/backend/btinstallmgr.cpp \
    $${BIBLETIME_PATH}/src/backend/btinstallthread.cpp \
    $${BIBLETIME_PATH}/src/backend/config/btconfig.cpp \
    $${BIBLETIME_PATH}/src/backend/config/btconfigcore.cpp \
    $${BIBLETIME_PATH}/src/backend/cswordmodulesearch.cpp \
    $${BIBLETIME_PATH}/src/backend/drivers/cswordbiblemoduleinfo.cpp \
    $${BIBLETIME_PATH}/src/backend/drivers/cswordbookmoduleinfo.cpp \
    $${BIBLETIME_PATH}/src/backend/drivers/cswordcommentarymoduleinfo.cpp \
    $${BIBLETIME_PATH}/src/backend/drivers/cswordlexiconmoduleinfo.cpp \
    $${BIBLETIME_PATH}/src/backend/drivers/cswordmoduleinfo.cpp \
    $${BIBLETIME_PATH}/src/backend/filters/gbftohtml.cpp \
    $${BIBLETIME_PATH}/src/backend/filters/osistohtml.cpp \
    $${BIBLETIME_PATH}/src/backend/filters/plaintohtml.cpp \
    $${BIBLETIME_PATH}/src/backend/filters/teitohtml.cpp \
    $${BIBLETIME_PATH}/src/backend/filters/thmltohtml.cpp \
    $${BIBLETIME_PATH}/src/backend/keys/cswordkey.cpp \
    $${BIBLETIME_PATH}/src/backend/keys/cswordldkey.cpp \
    $${BIBLETIME_PATH}/src/backend/keys/cswordtreekey.cpp \
    $${BIBLETIME_PATH}/src/backend/keys/cswordversekey.cpp \
    $${BIBLETIME_PATH}/src/backend/managers/btstringmgr.cpp \
    $${BIBLETIME_PATH}/src/backend/managers/cdisplaytemplatemgr.cpp \
    $${BIBLETIME_PATH}/src/backend/managers/clanguagemgr.cpp \
    $${BIBLETIME_PATH}/src/backend/managers/cswordbackend.cpp \
    $${BIBLETIME_PATH}/src/backend/managers/referencemanager.cpp \
    $${BIBLETIME_PATH}/src/backend/models/btmoduletextmodel.cpp \
    $${BIBLETIME_PATH}/src/backend/rendering/btinforendering.cpp \
    $${BIBLETIME_PATH}/src/backend/rendering/cbookdisplay.cpp \
    $${BIBLETIME_PATH}/src/backend/rendering/cchapterdisplay.cpp \
    $${BIBLETIME_PATH}/src/backend/rendering/cdisplayrendering.cpp \
    $${BIBLETIME_PATH}/src/backend/rendering/centrydisplay.cpp \
    $${BIBLETIME_PATH}/src/backend/rendering/chtmlexportrendering.cpp \
    $${BIBLETIME_PATH}/src/backend/rendering/cplaintextexportrendering.cpp \
    $${BIBLETIME_PATH}/src/backend/rendering/ctextrendering.cpp \
    $${BIBLETIME_PATH}/src/backend/btsignal.cpp \
    $${BIBLETIME_PATH}/src/util/cresmgr.cpp \
    $${BIBLETIME_PATH}/src/util/bticons.cpp \
    $${BIBLETIME_PATH}/src/util/btmodules.cpp \
    $${BIBLETIME_PATH}/src/util/tool.cpp \


HEADERS += \
    $${BIBLETIME_PATH}/src/backend/bookshelfmodel/btbookshelffiltermodel.h \
    $${BIBLETIME_PATH}/src/backend/bookshelfmodel/btbookshelfmodel.h \
    $${BIBLETIME_PATH}/src/backend/bookshelfmodel/btbookshelftreemodel.h \
    $${BIBLETIME_PATH}/src/backend/bookshelfmodel/categoryitem.h \
    $${BIBLETIME_PATH}/src/backend/bookshelfmodel/indexingitem.h \
    $${BIBLETIME_PATH}/src/backend/bookshelfmodel/item.h \
    $${BIBLETIME_PATH}/src/backend/bookshelfmodel/languageitem.h \
    $${BIBLETIME_PATH}/src/backend/bookshelfmodel/moduleitem.h \
    $${BIBLETIME_PATH}/src/backend/btbookmarksmodel.h \
    $${BIBLETIME_PATH}/src/backend/btglobal.h \
    $${BIBLETIME_PATH}/src/backend/btinstallbackend.h \
    $${BIBLETIME_PATH}/src/backend/btinstallmgr.h \
    $${BIBLETIME_PATH}/src/backend/btinstallthread.h \
    $${BIBLETIME_PATH}/src/backend/btsignal.h \
    $${BIBLETIME_PATH}/src/backend/config/btconfig.h \
    $${BIBLETIME_PATH}/src/backend/config/btconfigcore.h \
    $${BIBLETIME_PATH}/src/backend/cswordmodulesearch.h \
    $${BIBLETIME_PATH}/src/backend/drivers/cswordbiblemoduleinfo.h \
    $${BIBLETIME_PATH}/src/backend/drivers/cswordbookmoduleinfo.h \
    $${BIBLETIME_PATH}/src/backend/drivers/cswordcommentarymoduleinfo.h \
    $${BIBLETIME_PATH}/src/backend/drivers/cswordlexiconmoduleinfo.h \
    $${BIBLETIME_PATH}/src/backend/drivers/cswordmoduleinfo.h \
    $${BIBLETIME_PATH}/src/backend/filters/gbftohtml.h \
    $${BIBLETIME_PATH}/src/backend/filters/osistohtml.h \
    $${BIBLETIME_PATH}/src/backend/filters/plaintohtml.h \
    $${BIBLETIME_PATH}/src/backend/filters/teitohtml.h \
    $${BIBLETIME_PATH}/src/backend/filters/thmltohtml.h \
    $${BIBLETIME_PATH}/src/backend/managers/btstringmgr.h \
    $${BIBLETIME_PATH}/src/backend/managers/cdisplaytemplatemgr.h \
    $${BIBLETIME_PATH}/src/backend/managers/clanguagemgr.h \
    $${BIBLETIME_PATH}/src/backend/managers/cswordbackend.h \
    $${BIBLETIME_PATH}/src/backend/managers/referencemanager.h \
    $${BIBLETIME_PATH}/src/backend/keys/cswordkey.h \
    $${BIBLETIME_PATH}/src/backend/keys/cswordldkey.h \
    $${BIBLETIME_PATH}/src/backend/keys/cswordtreekey.h \
    $${BIBLETIME_PATH}/src/backend/keys/cswordversekey.h \
    $${BIBLETIME_PATH}/src/backend/models/btmoduletextmodel.h \
    $${BIBLETIME_PATH}/src/backend/rendering/cbookdisplay.h \
    $${BIBLETIME_PATH}/src/backend/rendering/cchapterdisplay.h \
    $${BIBLETIME_PATH}/src/backend/rendering/cdisplayrendering.h \
    $${BIBLETIME_PATH}/src/backend/rendering/centrydisplay.h \
    $${BIBLETIME_PATH}/src/backend/rendering/chtmlexportrendering.h \
    $${BIBLETIME_PATH}/src/backend/rendering/cplaintextexportrendering.h \
    $${BIBLETIME_PATH}/src/backend/rendering/ctextrendering.h \
    $${BIBLETIME_PATH}/src/util/cresmgr.h \
    $${BIBLETIME_PATH}/src/util/directory.h \
    $${BIBLETIME_PATH}/src/util/bticons.h \
    $${BIBLETIME_PATH}/src/util/btmodules.h \
    $${BIBLETIME_PATH}/src/util/tool.h \

TRANSLATIONS += \
    $${BIBLETIME_PATH}/i18n/messages/bibletime_ui_ar.ts \
    $${BIBLETIME_PATH}/i18n/messages/bibletime_ui_cs.ts \
    $${BIBLETIME_PATH}/i18n/messages/bibletime_ui_da.ts \
    $${BIBLETIME_PATH}/i18n/messages/bibletime_ui_de.ts \
    $${BIBLETIME_PATH}/i18n/messages/bibletime_ui_en_GB.ts \
    $${BIBLETIME_PATH}/i18n/messages/bibletime_ui_es.ts \
    $${BIBLETIME_PATH}/i18n/messages/bibletime_ui_et.ts \
    $${BIBLETIME_PATH}/i18n/messages/bibletime_ui_fi.ts \
    $${BIBLETIME_PATH}/i18n/messages/bibletime_ui_hu.ts \
    $${BIBLETIME_PATH}/i18n/messages/bibletime_ui_it.ts \
    $${BIBLETIME_PATH}/i18n/messages/bibletime_ui_ko.ts \
    $${BIBLETIME_PATH}/i18n/messages/bibletime_ui_lt.ts \
    $${BIBLETIME_PATH}/i18n/messages/bibletime_ui_pl.ts \
    $${BIBLETIME_PATH}/i18n/messages/bibletime_ui_pt_BR.ts \
    $${BIBLETIME_PATH}/i18n/messages/bibletime_ui_pt.ts \
    $${BIBLETIME_PATH}/i18n/messages/bibletime_ui_ru.ts \
    $${BIBLETIME_PATH}/i18n/messages/bibletime_ui_sk.ts \
    $${BIBLETIME_PATH}/i18n/messages/bibletime_ui.ts \
    $${BIBLETIME_PATH}/i18n/messages/bibletime_ui_zh_TW.ts 

lupdate_only {
    SOURCES = $${BIBLETIME_PATH}/src/backend/drivers/cswordmoduleinfo.cpp \
}


RESOURCES += $${BIBLETIME_PATH}/i18n/messages/bibletime_translate.qrc

# Core Platform Section

# iOS Platform
mac:CONFIG -= webkit
mac:DEFINES += unix
mac:DEFINES += __unix__

# Android platform
android {
DEFINES += STDC_HEADERS
}

# Symbian platform
# on S60 webkit not works, maybe wrong packaging?
symbian {
DEFINES -= BT_VERSION=\\\"$${BT_VERSION}\\\"
greaterThan(S60_VERSION, 5.0) {
DEFINES += BT_VERSION=\"$${BT_VERSION}\"
}
else {
DEFINES += BT_VERSION=\"\\\"$${BT_VERSION}\\\"\"
CONFIG -= webkit
}
}

# BlackBerry10 Platform
blackberry {
CONFIG -= webkit
DEFINES += unix
LIBS += -lsocket
}

# Core Configuration Section

# Clucene
include(../../common/clucene/clucene.pro)

# CURL
# optional
curl:include(../../common/curl/curl.pro)

# ICU
# optional
icu:include(../../common/icu/icu.pro)

# Sword
include(../../common/sword/sword.pro)

