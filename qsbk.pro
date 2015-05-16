APP_NAME = qsbk

CONFIG += qt warn_on cascades10

include(config.pri)

LIBS += -lbb -lbbsystem -lbbplatform 
RESOURCES += assets.qrc
DEPENDPATH += assets