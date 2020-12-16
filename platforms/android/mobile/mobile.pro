

BTMVER=323

DEFINES += BTM_VERSION=\\\"$$BTMVER\\\"

include(../../common/mobile/mobile.pro)

android:QT += androidextras

contains(ANDROID_TARGET_ARCH, armeabi-v7a) {
    X=$$system($$PWD/version.sh $$BTMVER 0 android android/arm32)
    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android/arm32
    OTHER_FILES += android/arm32/AndroidManifest.xml
}

contains(ANDROID_TARGET_ARCH, arm64-v8a) {
    X=$$system($$PWD/version.sh $$BTMVER 1 android android/arm64)
    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android/arm64
    OTHER_FILES += android/arm64/AndroidManifest.xml
}

DISTFILES += \
    ../../../../../../../../../mnt/data/shared/sw/btm/bibletimemobile/platforms/android/mobile/android/arm32/AndroidManifest.xml \
    ../../../../../../../../../mnt/data/shared/sw/btm/bibletimemobile/platforms/android/mobile/android/arm32/build.gradle \
    ../../../../../../../../../mnt/data/shared/sw/btm/bibletimemobile/platforms/android/mobile/android/arm32/gradle.properties \
    ../../../../../../../../../mnt/data/shared/sw/btm/bibletimemobile/platforms/android/mobile/android/arm32/gradle/wrapper/gradle-wrapper.jar \
    ../../../../../../../../../mnt/data/shared/sw/btm/bibletimemobile/platforms/android/mobile/android/arm32/gradle/wrapper/gradle-wrapper.properties \
    ../../../../../../../../../mnt/data/shared/sw/btm/bibletimemobile/platforms/android/mobile/android/arm32/gradlew \
    ../../../../../../../../../mnt/data/shared/sw/btm/bibletimemobile/platforms/android/mobile/android/arm32/gradlew.bat \
    ../../../../../../../../../mnt/data/shared/sw/btm/bibletimemobile/platforms/android/mobile/android/arm32/res/values/libs.xml

ANDROID_ABIS = armeabi-v7a arm64-v8a

