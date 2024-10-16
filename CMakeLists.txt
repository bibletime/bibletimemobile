cmake_minimum_required(VERSION 3.24)
project(btmobile VERSION 0.1 LANGUAGES CXX)

SET(BTM_LIBS_INSTALL_DIR "/home/gary/btm-libs/Desktop_Qt_6_7_2-Debug/install")

SET(BT_VERSION "bt ver")
SET(BTM_VERSION "btm ver")


SET(BTM_INC_DIR ${BTM_LIBS_INSTALL_DIR}/include)
SET(BTM_LIB_DIR ${BTM_LIBS_INSTALL_DIR}/lib)

SET(CMAKE_AUTOMOC ON)
SET(CMAKE_AUTOUIC ON)
SET(CMAKE_AUTORCC ON)

SET(CMAKE_CXX_STANDARD_REQUIRED ON)

FIND_PACKAGE(QT NAMES Qt6 VERSION 6.7 COMPONENTS Core)

set(CMAKE_INSTALL_PREFIX ${CMAKE_CURRENT_BINARY_DIR}/install)

LIST(PREPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

FIND_PACKAGE(QT NAMES Qt6 VERSION 6.7 COMPONENTS Core)
MESSAGE(STATUS "Found Qt ${QT_VERSION}")
FIND_PACKAGE(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS
    Core
    Svg
    Qml
    Quick
    Xml
    Gui
    QuickControls2
    Widgets
    LinguistTools
)

FIND_PACKAGE(Sword 1.9 REQUIRED CLucene_INCLUDE_DIR)


# BibleTime Backend

SET(CLucene_INCLUDE_DIR ${BTM_INC_DIR})
SET(CLucene_LIBRARY_DIR ${BTM_LIB_DIR})
SET(CLucene_LIBRARY ${BTM_LIB_DIR}/libclucene-core.so)
SET(CLucene_SHARED_LIBRARY ${BTM_LIB_DIR}/libclucene-shared.so)

SET(Sword_INCLUDE_DIR ${BTM_INC_DIR})
SET(Sword_LIBRARY_DIR ${BTM_LIB_DIR})
SET(Sword_LIBRARY ${BTM_LIB_DIR}/libsword.so)

SET(bibletime_BACKEND_SOURCES
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/bookshelfmodel/btbookshelffiltermodel.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/bookshelfmodel/btbookshelfmodel.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/bookshelfmodel/btbookshelftreemodel.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/bookshelfmodel/categoryitem.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/bookshelfmodel/indexingitem.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/bookshelfmodel/item.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/bookshelfmodel/languageitem.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/bookshelfmodel/moduleitem.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/btbookmarksmodel.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/btglobal.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/btinstallbackend.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/btinstallmgr.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/btinstallthread.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/btsignal.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/btsourcesthread.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/config/btconfigcore.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/config/btconfig.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/cswordmodulesearch.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/drivers/cswordbiblemoduleinfo.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/drivers/cswordbookmoduleinfo.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/drivers/cswordcommentarymoduleinfo.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/drivers/cswordlexiconmoduleinfo.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/drivers/cswordmoduleinfo.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/filters/gbftohtml.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/filters/osistohtml.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/filters/plaintohtml.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/filters/teitohtml.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/filters/thmltohtml.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/keys/cswordkey.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/keys/cswordldkey.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/keys/cswordtreekey.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/keys/cswordversekey.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/language.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/managers/btlocalemgr.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/managers/cdisplaytemplatemgr.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/managers/colormanager.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/managers/cswordbackend.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/managers/referencemanager.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/models/btmoduletextmodel.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/rendering/btinforendering.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/rendering/cdisplayrendering.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/rendering/cplaintextexportrendering.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/rendering/crossrefrendering.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/rendering/ctextrendering.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/bookshelfmodel/btbookshelffiltermodel.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/bookshelfmodel/btbookshelfmodel.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/bookshelfmodel/btbookshelftreemodel.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/bookshelfmodel/categoryitem.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/bookshelfmodel/indexingitem.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/bookshelfmodel/item.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/bookshelfmodel/languageitem.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/bookshelfmodel/moduleitem.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/btbookmarksmodel.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/btglobal.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/btinstallbackend.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/btinstallmgr.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/btinstallthread.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/btsignal.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/btsourcesthread.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/config/btconfigcore.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/config/btconfig.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/cswordmodulesearch.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/drivers/btconstmoduleset.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/drivers/btmodulelist.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/drivers/btmoduleset.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/drivers/cswordbiblemoduleinfo.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/drivers/cswordbookmoduleinfo.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/drivers/cswordcommentarymoduleinfo.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/drivers/cswordlexiconmoduleinfo.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/drivers/cswordmoduleinfo.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/filters/gbftohtml.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/filters/osistohtml.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/filters/plaintohtml.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/filters/teitohtml.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/filters/thmltohtml.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/keys/cswordkey.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/keys/cswordldkey.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/keys/cswordtreekey.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/keys/cswordversekey.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/language.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/managers/btlocalemgr.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/managers/cdisplaytemplatemgr.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/managers/colormanager.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/managers/cswordbackend.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/managers/referencemanager.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/models/btmoduletextmodel.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/rendering/btinforendering.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/rendering/cdisplayrendering.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/rendering/cplaintextexportrendering.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/rendering/crossrefrendering.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/backend/rendering/ctextrendering.h"
)

SET(bibletime_UTILS
"${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/util/btassert.h"
"${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/util/btdebugonly.h"
"${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/util/bticons.h"
"${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/util/btmodules.h"
"${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/util/cp1252.h"
"${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/util/cresmgr.h"
"${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/util/tool.cpp"
"${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/util/btconnect.h"
"${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/util/bticons.cpp"
"${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/util/btmodules.cpp"
"${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/util/cp1252.cpp"
"${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/util/cresmgr.cpp"
"${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/util/macros.h"
"${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src/util/tool.h"
)


# BibleTime Mobile frontend

FILE(GLOB_RECURSE bibletime_FRONTEND_SOURCES CONFIGURE_DEPENDS
    "${CMAKE_CURRENT_SOURCE_DIR}/src/mobile/*.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/mobile/*.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/mobile/*.qrc"
)

SET(bibletime_TS_FILES
    "${CMAKE_CURRENT_SOURCE_DIR}/i18n/messages/mobile_ui_ar.ts"
    "${CMAKE_CURRENT_SOURCE_DIR}/i18n/messages/mobile_ui_cs.ts"
    "${CMAKE_CURRENT_SOURCE_DIR}/i18n/messages/mobile_ui_C.ts"
    "${CMAKE_CURRENT_SOURCE_DIR}/i18n/messages/mobile_ui_da.ts"
    "${CMAKE_CURRENT_SOURCE_DIR}/i18n/messages/mobile_ui_de.ts"
    "${CMAKE_CURRENT_SOURCE_DIR}/i18n/messages/mobile_ui_en_GB.ts"
    "${CMAKE_CURRENT_SOURCE_DIR}/i18n/messages/mobile_ui_es.ts"
    "${CMAKE_CURRENT_SOURCE_DIR}/i18n/messages/mobile_ui_et.ts"
    "${CMAKE_CURRENT_SOURCE_DIR}/i18n/messages/mobile_ui_fi.ts"
    "${CMAKE_CURRENT_SOURCE_DIR}/i18n/messages/mobile_ui_fr.ts"
    "${CMAKE_CURRENT_SOURCE_DIR}/i18n/messages/mobile_ui_hu.ts"
    "${CMAKE_CURRENT_SOURCE_DIR}/i18n/messages/mobile_ui_it.ts"
    "${CMAKE_CURRENT_SOURCE_DIR}/i18n/messages/mobile_ui_ja.ts"
    "${CMAKE_CURRENT_SOURCE_DIR}/i18n/messages/mobile_ui_ko.ts"
    "${CMAKE_CURRENT_SOURCE_DIR}/i18n/messages/mobile_ui_lt.ts"
    "${CMAKE_CURRENT_SOURCE_DIR}/i18n/messages/mobile_ui_pl.ts"
    "${CMAKE_CURRENT_SOURCE_DIR}/i18n/messages/mobile_ui_pl_BR.ts"
    "${CMAKE_CURRENT_SOURCE_DIR}/i18n/messages/mobile_ui_pt.ts"
    "${CMAKE_CURRENT_SOURCE_DIR}/i18n/messages/mobile_ui_ru.ts"
    "${CMAKE_CURRENT_SOURCE_DIR}/i18n/messages/mobile_ui_sk.ts"
    "${CMAKE_CURRENT_SOURCE_DIR}/i18n/messages/mobile_ui_.ts"
    "${CMAKE_CURRENT_SOURCE_DIR}/i18n/messages/mobile_ui_zh_TW.ts"
)

QT_ADD_TRANSLATIONS(bibletime_FRONTEND
    TS_FILES ${bibletime_TS_FILES}
    RESOURCE_PREFIX "/share/bibletime/locale"
)

QT_ADD_EXECUTABLE(bibletime_FRONTEND
    ${bibletime_BACKEND_SOURCES}
    ${bibletime_UTILS}
    ${bibletime_FRONTEND_SOURCES}
)

TARGET_COMPILE_DEFINITIONS(bibletime_FRONTEND PRIVATE cxx_std_17 -DBT_VERSION="${BT_VERSION}" -DBTM_VERSION="${BTM_VERSION}")

TARGET_LINK_LIBRARIES(bibletime_FRONTEND
    PUBLIC
        Qt::Widgets
        Qt::Xml
        Qt::Qml
        Qt::Quick
        Qt::QuickControls2
        ${Sword_LIBRARY}
        ${CLucene_LIBRARY}
        ${CLucene_SHARED_LIBRARY}
)

TARGET_INCLUDE_DIRECTORIES(bibletime_FRONTEND
    PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src
    ${CMAKE_CURRENT_SOURCE_DIR}/src
    ${BTM_INC_DIR}
    ${BTM_INC_DIR}/sword
    ${CLucene_INCLUDE_DIR}            #CLucene headers
    ${CLucene_LIBRARY_DIR}            #CLucene/clucene-config.h
    ${Sword_INCLUDE_DIR}
)









