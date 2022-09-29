QT += quick
CONFIG += c++11
QT += multimedia
QT += widgets
CONFIG += link_pkgconfig
PKGCONFIG += opencv
QT += concurrent

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

INCLUDEPATH +=/usr/include/gstreamer-1.0
INCLUDEPATH +=/usr/include/glib-2.0
INCLUDEPATH +=/usr/lib/x86_64-linux-gnu/glib-2.0/include

SOURCES += \
    imagepro.cpp \
    imageprovider.cpp \
    main.cpp \
    anaglyphVideo.cpp \
    grabOpenCV.cpp \
    camfinder.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    imagepro.h \
    imageprovider.h \
    anaglyphVideo.h \
    grabOpenCV.h \
    camfinder.h

unix|win32: LIBS += -lgstreamer-1.0

unix|win32: LIBS += -lglib-2.0

unix|win32: LIBS += -lgobject-2.0

unix|win32: LIBS += -lgstapp-1.0

DISTFILES +=


