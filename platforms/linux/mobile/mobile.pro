BTMVER=330

DEFINES += BTM_VERSION=\\\"$$BTMVER\\\"

include(../../common/mobile/mobile.pro)

TARGET = bibletime-mobile
target.path = /usr/bin

desktop.files = $${TARGET}.desktop
desktop.path = /usr/share/applications

icon.files = ../../../pics/icons/bibletime.svg
icon.path = /usr/share/icons/hicolor/scalable/apps

OTHER_FILES += $${TARGET}.desktop

INSTALLS += target desktop icon
