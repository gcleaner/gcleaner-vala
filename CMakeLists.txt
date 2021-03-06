#Name of project
project (gcleaner)

#The oldest stable cmake version we support
cmake_minimum_required (VERSION 2.6)

#Cmake version to use
cmake_policy (VERSION 2.8)

#Tell Cmake where its modules can be found in our project directory
list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)
enable_testing ()

#Where we install data directory (if we have any)
set (DATADIR "${CMAKE_INSTALL_PREFIX}/share")

#What to call that directory where we install data too
set (PKGDATADIR "${DATADIR}/gcleaner")
set (GETTEXT_PACKAGE ${CMAKE_PROJECT_NAME})
add_definitions("-DGETTEXT_PACKAGE=\"${GETTEXT_PACKAGE}\"")
project(${GETTEXT_PACKAGE} C)
set (EXEC_NAME "gcleaner")
set (RELEASE_NAME "GCleaner")
set (VERSION "0.01.134")
set (VERSION_INFO "Release")
set (APP_LAUNCHER "gcleaner.desktop")

#We're about to use pkgconfig to make sure dependencies are installed so let's find pkgconfig first
find_package(PkgConfig)

#Hide redundant and logic warnings of C language
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wno-unused-but-set-variable -Wno-unused-variable -ffast-math -march=native")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -Wno-unused-but-set-variable -Wno-unused-variable -ffast-math -march=native")

#Now let's actually check for the required dependencies
pkg_check_modules(DEPS REQUIRED gtk+-3.0>=3.10.0 gio-2.0 glib-2.0 json-glib-1.0)

add_definitions(${DEPS_CFLAGS})
link_libraries(${DEPS_LIBRARIES} -lm)
link_directories(${DEPS_LIBRARY_DIRS})

#Make sure we have vala
find_package(Vala REQUIRED)
#Make sure we use vala
include(ValaVersion)
#Make sure it's the desired version of vala
ensure_vala_version("0.16" MINIMUM)

#Files we want to compile:
include(ValaPrecompile)
vala_precompile(VALA_C ${EXEC_NAME}
    src/Library/graphics.vala
    src/Library/specs.vala
    src/Library/streep.vala
    src/Library/utils.vala
    src/Tools/Actions.vala
    src/Tools/Cleaner.vala
    src/Tools/FileUtilities.vala
    src/Tools/InfoClean.vala
    src/Tools/Inventory.vala
    src/Tools/JsonUtils.vala
    src/Tools/Tasks.vala
    src/Widgets/About.vala
    src/Widgets/CleanerButtons.vala
    src/Widgets/HeaderBar.vala
    src/Widgets/Preferences.vala
    src/Widgets/ResultsArea.vala
    src/Widgets/Sidebar.vala
    src/Widgets/Toolbar.vala
    src/GCleaner.vala
    src/Resources.vala
#Tell what libraries to use when compiling
PACKAGES
    gio-2.0
    gtk+-3.0
    glib-2.0
    json-glib-1.0
    posix
#Compiler options
OPTIONS
    -g --save-temps
    --target-glib=2.36
    --thread
)

#Add another subdirectory for compile source (for example: gschemas)
add_subdirectory (data)
add_subdirectory (po)

#Tell cmake what to call the executable we just made
add_executable(${EXEC_NAME} ${VALA_C})

#Install the binaries we just made
install (TARGETS ${EXEC_NAME} RUNTIME DESTINATION bin)

#Install our .desktop file so the Applications menu will see it
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/resources-gcleaner.json DESTINATION ${DATADIR}/gcleaner/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/gtk-widgets-gcleaner.css DESTINATION ${DATADIR}/gcleaner/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/gcleaner.desktop DESTINATION ${DATADIR}/applications/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/icons/24/gcleaner.svg DESTINATION ${DATADIR}/icons/hicolor/24x24/apps)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/icons/32/gcleaner.svg DESTINATION ${DATADIR}/icons/hicolor/32x32/apps)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/icons/48/gcleaner.svg DESTINATION ${DATADIR}/icons/hicolor/48x48/apps)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/icons/64/gcleaner.svg DESTINATION ${DATADIR}/icons/hicolor/64x64/apps)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/icons/128/gcleaner.svg DESTINATION ${DATADIR}/icons/hicolor/128x128/apps)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/icons/gcleanertb.svg DESTINATION ${DATADIR}/pixmaps)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/icons/gcleanerhb.svg DESTINATION ${DATADIR}/pixmaps)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/media/apps/amsn.png DESTINATION ${DATADIR}/gcleaner/media/apps/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/media/apps/amule.png DESTINATION ${DATADIR}/gcleaner/media/apps/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/media/apps/audacious.png DESTINATION ${DATADIR}/gcleaner/media/apps/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/media/apps/chromium-browser.png DESTINATION ${DATADIR}/gcleaner/media/apps/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/media/apps/emesene.png DESTINATION ${DATADIR}/gcleaner/media/apps/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/media/apps/epiphany.png DESTINATION ${DATADIR}/gcleaner/media/apps/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/media/apps/evolution.png DESTINATION ${DATADIR}/gcleaner/media/apps/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/media/apps/exaile.png DESTINATION ${DATADIR}/gcleaner/media/apps/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/media/apps/firefox.png DESTINATION ${DATADIR}/gcleaner/media/apps/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/media/apps/flash.png DESTINATION ${DATADIR}/gcleaner/media/apps/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/media/apps/gftp.png DESTINATION ${DATADIR}/gcleaner/media/apps/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/media/apps/gimp.png DESTINATION ${DATADIR}/gcleaner/media/apps/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/media/apps/google-chrome.png DESTINATION ${DATADIR}/gcleaner/media/apps/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/media/apps/google-earth-pro.png DESTINATION ${DATADIR}/gcleaner/media/apps/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/media/apps/gpodder.png DESTINATION ${DATADIR}/gcleaner/media/apps/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/media/apps/java.png DESTINATION ${DATADIR}/gcleaner/media/apps/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/media/apps/kde.png DESTINATION ${DATADIR}/gcleaner/media/apps/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/media/apps/konqueror.png DESTINATION ${DATADIR}/gcleaner/media/apps/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/media/apps/libreoffice.png DESTINATION ${DATADIR}/gcleaner/media/apps/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/media/apps/liferea.png DESTINATION ${DATADIR}/gcleaner/media/apps/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/media/apps/midori.png DESTINATION ${DATADIR}/gcleaner/media/apps/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/media/apps/miro.png DESTINATION ${DATADIR}/gcleaner/media/apps/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/media/apps/nexuiz.png DESTINATION ${DATADIR}/gcleaner/media/apps/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/media/apps/opera.png DESTINATION ${DATADIR}/gcleaner/media/apps/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/media/apps/pidgin.png DESTINATION ${DATADIR}/gcleaner/media/apps/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/media/apps/rhythmbox.png DESTINATION ${DATADIR}/gcleaner/media/apps/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/media/apps/seamonkey.png DESTINATION ${DATADIR}/gcleaner/media/apps/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/media/apps/skype.png DESTINATION ${DATADIR}/gcleaner/media/apps/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/media/apps/thunderbird.png DESTINATION ${DATADIR}/gcleaner/media/apps/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/media/apps/tremulous.png DESTINATION ${DATADIR}/gcleaner/media/apps/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/media/apps/vuze.png DESTINATION ${DATADIR}/gcleaner/media/apps/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/media/apps/warzone2100.png DESTINATION ${DATADIR}/gcleaner/media/apps/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/media/apps/wine.png DESTINATION ${DATADIR}/gcleaner/media/apps/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/media/apps/xine.png DESTINATION ${DATADIR}/gcleaner/media/apps/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/media/info-system/applications-system.png DESTINATION ${DATADIR}/gcleaner/media/info-system/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/media/info-system/dialog-close.png DESTINATION ${DATADIR}/gcleaner/media/info-system/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/media/info-system/dialog-ok.png DESTINATION ${DATADIR}/gcleaner/media/info-system/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/media/info-system/image-x-generic.svg DESTINATION ${DATADIR}/gcleaner/media/info-system/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/media/info-system/package-x-generic.svg DESTINATION ${DATADIR}/gcleaner/media/info-system/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/media/info-system/recent-documents.svg DESTINATION ${DATADIR}/gcleaner/media/info-system/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/media/info-system/user-trash.svg DESTINATION ${DATADIR}/gcleaner/media/info-system/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/media/info-system/utilities-terminal.svg DESTINATION ${DATADIR}/gcleaner/media/info-system/)

#Uninstall target
configure_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/cmake_uninstall.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake"
    IMMEDIATE @ONLY)

add_custom_target(uninstall
    COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake)
