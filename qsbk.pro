APP_NAME = qsbk

CONFIG += qt warn_on cascades10

include(config.pri)

LIBS += -lbb -lbbsystem -lbbplatform  -lbbdevice -lclipboard 
LIBS += -lbbcascadespickers
RESOURCES += assets.qrc
DEPENDPATH += assets