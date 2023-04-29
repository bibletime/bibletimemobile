BTMVER=328

DEFINES += BTM_VERSION=\\\"$$BTMVER\\\"

include(../../common/mobile/mobile.pro)

equals(SAILFISHOS, 1) {
    TARGET = harbour-bibletime
} else {
    TARGET = bibletime-mobile
}
target.path = /usr/bin

desktop.files = $${TARGET}.desktop
desktop.path = /usr/share/applications

icon.files = ../../../pics/icons/bibletime.svg
icon.path = /usr/share/icons/hicolor/scalable/apps

icon_128.files = ../../../pics/icons/128x128/bibletime.png
icon_128.path = /usr/share/icons/hicolor/128x128/apps

OTHER_FILES += $${TARGET}.desktop

INSTALLS += target desktop icon icon_128
