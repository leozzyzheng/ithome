# Add more folders to ship with the application, here
TARGET = ithome
VERSION = 1.0.0

QT += network webkit
CONFIG += mobility
MOBILITY += systeminfo
folder_01.source = qml/meego
folder_01.target = qml
folder_02.source = qml/symbian
folder_02.target = qml
folder_03.source = qml/general
folder_03.target = qml
folder_04.source = ./data
folder_04.target = ./
DEPLOYMENTFOLDERS = folder_03


simulator {
    DEPLOYMENTFOLDERS += folder_01 folder_02 folder_04
}

contains(MEEGO_EDITION, harmattan){
    DEPLOYMENTFOLDERS += folder_01
    DEFINES += Q_OS_HARMATTAN

    splash.files = Image/MeeGo.png
    splash.path = /opt/ithome/data

    iconsvg.files += $${TARGET}meego.svg
    iconsvg.path = /usr/share/themes/base/meegotouch/$${TARGET}



    export(splash.files)
    export(splash.path)


    export(iconsvg.files)
    export(iconsvg.path)


    INSTALLS += splash iconsvg
}


# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

symbian:{
    DEPLOYMENTFOLDERS += folder_02
    TARGET.UID3 = 0xE274BCB6
    TARGET.CAPABILITY += NetworkServices
}



# Smart Installer package's UID
# This UID is from the protected range and therefore the package will
# fail to install if self-signed. By default qmake uses the unprotected
# range value if unprotected UID is defined for the application and
# 0x2002CCCF value if protected UID is given to the application
#symbian:DEPLOYMENT.installer_header = 0x2002CCCF

# Allow network access on Symbian

# If your application uses the Qt Mobility libraries, uncomment the following
# lines and add the respective components to the MOBILITY variable.
# CONFIG += mobility
# MOBILITY +=

# Speed up launching on MeeGo/Harmattan when using applauncherd daemon
CONFIG += qdeclarative-boostable

# Add dependency to Symbian components
# CONFIG += qt-components

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp \
    setcss.cpp \
    myimage.cpp \
    cachecontent.cpp \
    settings.cpp \
    netinfo.cpp \
    isclick.cpp \
    utility.cpp

# Please do not modify the following two lines. Required for deployment.
include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()

OTHER_FILES += \
    qtc_packaging/debian_harmattan/rules \
    qtc_packaging/debian_harmattan/README \
    qtc_packaging/debian_harmattan/manifest.aegis \
    qtc_packaging/debian_harmattan/copyright \
    qtc_packaging/debian_harmattan/control \
    qtc_packaging/debian_harmattan/compat \
    qtc_packaging/debian_harmattan/changelog \
    qml/meego/MySwitch.qml \
    qml/symbian/MySlider.qml

RESOURCES += \
    image.qrc

HEADERS += \
    setcss.h \
    myimage.h \
    cachecontent.h \
    settings.h \
    netinfo.h \
    isclick.h \
    utility.h
