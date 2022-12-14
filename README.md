
**BibleTime Mobile** is a Bible study app based on the Sword library. It is designed to be used on a touch display.

#### Build requirements and known good versions.
- C++11 compiler
- Qt - 5.15.2
- Qt Creator - version 7-9 (latest version for building on Android)
- OpenJdk - version 11 or lower. (version 8 is known to work)
- BibleTime Mobile - https://github.com/bibletime/bibletimemobile
- BibleTime - https://github.com/bibletime/bibletime commit 1a8467dc72ff9fdcc79d671e582f17261b10c836
- Sword - 1.8.1
- CLucene - https://github.com/kalemas/clucene (master branch)
#### Recommended build process for android.
##### Example Android build
It is highly recommended you build a Hello World type program and run it on Android before proceeding to build and run BibleTime Mobile. Use QtCreator menu "File/New Project" to create a "Qt Quick Application".
See [Qt for Android - Building from source (https://doc.qt.io/qt-5/android-building.html)] for more information.

##### BibleTime Mobile Android build
1. Choose and make a build directory.
2. In the build directory place the source code using the following names: bibletimemobile, bibletime, sword, and clucene.
3. Using QtCreator open bibletimemobile/platforms/android/mobile/mobile.pro
4. Using the icon near the lower left, choose the Android kit and either Debug or Release.
5. Use the menu "Build/Run qmake" and insure there are no errors.
6. Use the menu "Build/Build All Projects" to compile the source. This should produce a file like <builddir>/bibletimemobile/platforms/android/build-mobile-Android_Qt_5_15_2_Clang_Multi_Abi-Release/android-build/build/outputs/apk/release/android-build-release-unsigned.apk
7. Use the menu "Build/Run". Assuming you have either a emulator or a usb connected android device, this should open BibleTime  Mobile on that device.
Note: If you get a strange error when installing and you are changing build types (Release or Debug), uninstall the old app from the android device and try again.


#### Recommended build process for linux desktop.
1. Choose and make a build directory.
2. In the build directory place the source code using the following names: bibletimemobile, bibletime, sword, and clucene.
3. Using QtCreator open bibletimemobile/platforms/linux/mobile/mobile.pro
4. Using the icon near the lower left, choose the desired Qt kit and either Debug or Release.
5. Use the menu "Build/Run qmake" and insure there are no errors.
6. Use the menu "Build/Build All Projects" to compile the source. This should produce a file like <builddir>/bibletimemobile/platforms/android/build-mobile-Desktop_Qt_5_15_2_GCC_64bit-Debug/bibletime-mobile.
7. Use the menu "Build/Run" to start the app.




