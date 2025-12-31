cmake_minimum_required(VERSION 3.16)

project(SmartHome VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOMOC ON)

find_package(Qt6 REQUIRED COMPONENTS Quick Quick3D Quick3DAssetUtils Quick3DHelpers)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appSmartHome
    main.cpp
    Controllers/system.h
    Controllers/system.cpp
    Controllers/settings.cpp
    Controllers/settings.h
)

qt_add_qml_module(appSmartHome
    URI SmartHome
    VERSION 1.0
    QML_FILES
        Main.qml
        ui/BottomBar/BottomBar.qml
        ui/MainBackground/MainBackground.qml
        ui/LeftScreen/LeftScreen.qml
        ui/TopBar/TopBar.qml
        ui/FrontDoorIndicator/FrontDoorIndicator.qml
        ui/SecurityBubble/SecurityBubble.qml
        ui/Energy/Energy.qml
        ui/NotificationToast/NotificationToast.qml
        RESOURCES ui/assets/list.png
        RESOURCES ui/assets/menu-burger.png
        RESOURCES resources.qrc
        RESOURCES ui/assets/home.glb
        RESOURCES ui/assets/lock.png
        RESOURCES ui/assets/unlock.png
        RESOURCES ui/assets/cc.png
        QML_FILES ui/Database/Database.js
        SOURCES Controllers/settings.h
        SOURCES Controllers/settings.cpp
        RESOURCES ui/assets/weatherbutton.png
        RESOURCES ui/assets/users.png
        RESOURCES ui/assets/gohome.png
        RESOURCES ui/assets/historybutton.png
        RESOURCES ui/assets/goodnight.gif
        RESOURCES ui/assets/morning.gif
        RESOURCES ui/assets/weatherbutton.png
        RESOURCES ui/assets/information.png
        RESOURCES ui/assets/warning.png
        RESOURCES ui/assets/cloud.png
)

set_target_properties(appSmartHome PROPERTIES
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appSmartHome
    PRIVATE Qt6::Quick Qt6::Quick3D Qt6::Quick3DAssetUtils Qt6::Quick3DHelpers
)

include(GNUInstallDirs)
install(TARGETS appSmartHome
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
