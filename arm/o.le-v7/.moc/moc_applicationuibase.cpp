/****************************************************************************
** Meta object code from reading C++ file 'applicationuibase.hpp'
**
** Created by: The Qt Meta Object Compiler version 63 (Qt 4.8.5)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../src/applicationuibase.hpp"
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'applicationuibase.hpp' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 63
#error "This file was generated using the moc from 4.8.5. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
static const uint qt_meta_data_ApplicationUIBase[] = {

 // content:
       6,       // revision
       0,       // classname
       0,    0, // classinfo
       9,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       1,       // signalCount

 // signals: signature, parameters, type, tag, flags
      32,   19,   18,   18, 0x06,

 // slots: signature, parameters, type, tag, flags
      53,   18,   18,   18, 0x08,
      79,   18,   18,   18, 0x08,
     104,   98,   18,   18, 0x08,

 // methods: signature, parameters, type, tag, flags
     158,  148,   18,   18, 0x02,
     209,  187,   18,   18, 0x02,
     263,  239,  231,   18, 0x02,
     302,  285,   18,   18, 0x02,
     328,  324,  231,   18, 0x02,

       0        // eod
};

static const char qt_meta_stringdata_ApplicationUIBase[] = {
    "ApplicationUIBase\0\0success,resp\0"
    "posted(bool,QString)\0onSystemLanguageChanged()\0"
    "onArticleCreated()\0error\0"
    "onErrorOcurred(QNetworkReply::NetworkError)\0"
    "title,url\0invokeVideo(QString,QString)\0"
    "objectName,inputValue\0setv(QString,QString)\0"
    "QString\0objectName,defaultValue\0"
    "getv(QString,QString)\0endpoint,content\0"
    "post(QString,QString)\0key\0"
    "genCodeByKey(QString)\0"
};

void ApplicationUIBase::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        Q_ASSERT(staticMetaObject.cast(_o));
        ApplicationUIBase *_t = static_cast<ApplicationUIBase *>(_o);
        switch (_id) {
        case 0: _t->posted((*reinterpret_cast< bool(*)>(_a[1])),(*reinterpret_cast< QString(*)>(_a[2]))); break;
        case 1: _t->onSystemLanguageChanged(); break;
        case 2: _t->onArticleCreated(); break;
        case 3: _t->onErrorOcurred((*reinterpret_cast< QNetworkReply::NetworkError(*)>(_a[1]))); break;
        case 4: _t->invokeVideo((*reinterpret_cast< const QString(*)>(_a[1])),(*reinterpret_cast< const QString(*)>(_a[2]))); break;
        case 5: _t->setv((*reinterpret_cast< const QString(*)>(_a[1])),(*reinterpret_cast< const QString(*)>(_a[2]))); break;
        case 6: { QString _r = _t->getv((*reinterpret_cast< const QString(*)>(_a[1])),(*reinterpret_cast< const QString(*)>(_a[2])));
            if (_a[0]) *reinterpret_cast< QString*>(_a[0]) = _r; }  break;
        case 7: _t->post((*reinterpret_cast< const QString(*)>(_a[1])),(*reinterpret_cast< const QString(*)>(_a[2]))); break;
        case 8: { QString _r = _t->genCodeByKey((*reinterpret_cast< const QString(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< QString*>(_a[0]) = _r; }  break;
        default: ;
        }
    }
}

const QMetaObjectExtraData ApplicationUIBase::staticMetaObjectExtraData = {
    0,  qt_static_metacall 
};

const QMetaObject ApplicationUIBase::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_ApplicationUIBase,
      qt_meta_data_ApplicationUIBase, &staticMetaObjectExtraData }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &ApplicationUIBase::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *ApplicationUIBase::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *ApplicationUIBase::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_ApplicationUIBase))
        return static_cast<void*>(const_cast< ApplicationUIBase*>(this));
    return QObject::qt_metacast(_clname);
}

int ApplicationUIBase::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 9)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 9;
    }
    return _id;
}

// SIGNAL 0
void ApplicationUIBase::posted(bool _t1, QString _t2)
{
    void *_a[] = { 0, const_cast<void*>(reinterpret_cast<const void*>(&_t1)), const_cast<void*>(reinterpret_cast<const void*>(&_t2)) };
    QMetaObject::activate(this, &staticMetaObject, 0, _a);
}
QT_END_MOC_NAMESPACE
