/*
 * Copyright (c) 2013-2014 BlackBerry Limited.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "applicationuibase.hpp"

#include <bb/cascades/LocaleHandler>
#include <bb/system/InvokeManager>
#include <bb/PpsObject>
#include <bb/system/SystemToast>
#include <QCryptographicHash>
#include "qnamespace.h"
using namespace bb::cascades;
using namespace bb::system;
using namespace bb;

ApplicationUIBase::ApplicationUIBase(InvokeManager *invokeManager) :
        m_pInvokeManager(invokeManager)
{
    networkmgr = new QNetworkAccessManager();
    m_translator = new QTranslator(this);
    m_pLocaleHandler = new LocaleHandler(this);

    connect(m_pLocaleHandler, SIGNAL(systemLanguageChanged()), this,
            SLOT(onSystemLanguageChanged()));

    // 初始化语言环境
    onSystemLanguageChanged();
}

ApplicationUIBase::~ApplicationUIBase()
{
    // TODO Auto-generated destructor stub
}

void ApplicationUIBase::onSystemLanguageChanged()
{
    QCoreApplication::instance()->removeTranslator(m_translator);
    // Initiate, load and install the application translation files.
    QString locale_string = QLocale().name();
    QString file_name = QString("qsbk_%1").arg(locale_string);
    if (m_translator->load(file_name, "app/native/qm")) {
        QCoreApplication::instance()->installTranslator(m_translator);
    } else {
        qWarning() << tr("cannot load language file '%1").arg(file_name);
    }
}

void ApplicationUIBase::invokeVideo(const QString &title, const QString &url)
{
    InvokeRequest cardRequest;
    cardRequest.setTarget("sys.mediaplayer.previewer");
    cardRequest.setAction("bb.action.VIEW");

    QVariantMap map;
    map.insert("contentTitle", title);
    map.insert("imageUri", "asset:///res/default_no_content_grey.png");
    QByteArray requestData = PpsObject::encode(map, NULL);

    cardRequest.setData(requestData);
    cardRequest.setUri(url);

    m_pInvokeManager->invoke(cardRequest);
}

QString ApplicationUIBase::getv(const QString &objectName, const QString &defaultValue)
{
    QSettings settings;

// If no value has been saved, return the default value.
    if (settings.value(objectName).isNull()) {
        return defaultValue;
    }

// Otherwise, return the value stored in the settings object.
    return settings.value(objectName).toString();
}

void ApplicationUIBase::setv(const QString &objectName, const QString &inputValue)
{
// A new value is saved to the application settings object.
    QSettings settings;
    settings.setValue(objectName, QVariant(inputValue));
}

void ApplicationUIBase::post(const QString endpoint, const QString content)
{
    qDebug() << "C++ part post: " << endpoint << "\n" << content;
    QUrl edp(endpoint);
    QNetworkRequest req(edp);
    req.setRawHeader(QString("Qbtoken").toLatin1(), QString(getv("token", "")).toLatin1());
    req.setRawHeader(QString("Model").toLatin1(), QString("BLACKBERRY 10 DEVICES").toLatin1());
    req.setRawHeader(QString("Source").toLatin1(), QString("blackberry_2.0.15").toLatin1());

    QHttpMultiPart *multipart = new QHttpMultiPart(QHttpMultiPart::FormDataType);
    QHttpPart contentPart;
    contentPart.setHeader(QNetworkRequest::ContentDispositionHeader,
            QVariant("form-data; name=json"));
    contentPart.setHeader(QNetworkRequest::ContentTypeHeader,
            QVariant("text/plain; charset=unicode"));
    contentPart.setBody(content.toUtf8());
    multipart->append(contentPart);

    reply = networkmgr->post(req, multipart);
    multipart->setParent(reply);

    connect(reply, SIGNAL(finished()), this, SLOT(onArticleCreated()));
    connect(reply, SIGNAL(error(QNetworkReply::NetworkError)), this,
            SLOT(onErrorOcurred(QNetworkReply::NetworkError)));
}
void ApplicationUIBase::postImage(const QString endpoint, const QString content,
        const QString picpath)
{
    qDebug() << "C++ part post with image: " << endpoint << "\n" << content << "\n" << picpath;
    QUrl edp(endpoint);
    QNetworkRequest req(edp);
    req.setRawHeader(QString("Qbtoken").toLatin1(), QString(getv("token", "")).toLatin1());
    req.setRawHeader(QString("Model").toLatin1(), QString("BLACKBERRY 10 DEVICES").toLatin1());
    req.setRawHeader(QString("User-Agent").toLatin1(),QString("qiushibalke_6.7.1_WIFI_auto_21").toLatin1());
    req.setRawHeader(QString("Source").toLatin1(), QString("android_6.7.1").toLatin1());
    req.setRawHeader(QString("Uuid").toLatin1(),QString("IMEI_825573f985212e0a7944ed61d07644e1").toLatin1());
//    req.setRawHeader(QString("Source").toLatin1(), QString("blackberry_2.0.15").toLatin1());

    QHttpMultiPart *multipart = new QHttpMultiPart(QHttpMultiPart::FormDataType);

    QHttpPart contentPart;
    contentPart.setHeader(QNetworkRequest::ContentDispositionHeader,
            QVariant("form-data; name=json"));
    contentPart.setHeader(QNetworkRequest::ContentTypeHeader,
            QVariant("text/plain; charset=unicode"));
    contentPart.setBody(content.toUtf8());
    multipart->append(contentPart);

    //image part

    QHttpPart imagePart;
    imagePart.setHeader(QNetworkRequest::ContentDispositionHeader,
            QVariant("form-data; name=\"image\";filename=\"sendpic.jpg\""));
//    imagePart.setHeader(QNetworkRequest::ContentTypeHeader, QVariant("image/jpeg"));
    imagePart.setHeader(QNetworkRequest::ContentTypeHeader,
            QVariant("text/plain; charset=unicode"));
    // pack the new file
    QFile *file = new QFile(picpath);
    qDebug() << file->fileName();
    file->open(QIODevice::ReadOnly);
    imagePart.setBodyDevice(file);
    file->setParent(multipart); // we cannot delete the file now, so delete it with the multiPart
    multipart->append(imagePart);

    //image part end

    reply = networkmgr->post(req, multipart);
    multipart->setParent(reply);

    connect(reply, SIGNAL(finished()), this, SLOT(onArticleCreated()));
    connect(reply, SIGNAL(error(QNetworkReply::NetworkError)), this,
            SLOT(onErrorOcurred(QNetworkReply::NetworkError)));
}
void ApplicationUIBase::onArticleCreated()
{
    QString data = (QString) reply->readAll();
    qDebug() << data;
    if (data.indexOf("article") > 0) {
        emit posted(true, data);
    } else {
        emit posted(false, data);
    }
    disconnect(reply);
    reply->deleteLater();
}

void ApplicationUIBase::onErrorOcurred(QNetworkReply::NetworkError error)
{
    qDebug() << error;
    emit posted(false, QString(error));
}

QString ApplicationUIBase::genCodeByKey(const QString key)
{
    QString source = md5(key);
    QString result = source.mid(19, 8) + source.mid(19, 5);
    QString code = md5(result).mid(5, 4);
    return code.toLower();
}
QString ApplicationUIBase::md5(const QString key)
{
    QString md5;
    QByteArray ba, bb;
    QCryptographicHash md(QCryptographicHash::Md5);
    ba.append(key);
    md.addData(ba);
    bb = md.result();
    md5.append(bb.toHex());
    return md5;
}

void ApplicationUIBase::sharetext(QString text)
{
    InvokeQuery *query = InvokeQuery::create().mimeType("text/plain").data(text.toUtf8());
    Invocation *invocation = Invocation::create(query);
    query->setParent(invocation); // destroy query with invocation
    invocation->setParent(this); // app can be destroyed before onFinished() is called

    connect(invocation, SIGNAL(armed()), this, SLOT(onTEXTArmed()));
    connect(invocation, SIGNAL(finished()), this, SLOT(onFinished()));
}

void ApplicationUIBase::onTEXTArmed()
{
    Invocation *invocation = qobject_cast<Invocation *>(sender());
    invocation->trigger("bb.action.SHARE");
}

void ApplicationUIBase::viewimage(QString path)
{
    InvokeManager invokeManageronImage;
    InvokeRequest request;

    // Set the URI
    request.setUri(path);
    request.setTarget("sys.pictures.card.previewer");
    request.setAction("bb.action.VIEW");
    // Send the invocation request
    InvokeTargetReply *cardreply = invokeManageronImage.invoke(request);
    Q_UNUSED(cardreply);
}

void ApplicationUIBase::onViewArmed()
{
    Invocation *invocation = qobject_cast<Invocation *>(sender());
    invocation->trigger("bb.action.VIEW");
}

void ApplicationUIBase::onFinished()
{
    Invocation *invocation = qobject_cast<Invocation *>(sender());
    invocation->deleteLater();
}

void ApplicationUIBase::setClipboard(QString text)
{
    QByteArray ba = text.toLocal8Bit();

    if (get_clipboard_can_write() == 0) {
        empty_clipboard();
        int ret = set_clipboard_data("text/plain", ba.length(), ba.data());
        if (ret > 0) {
            SystemToast *toast = new SystemToast(this);
            QString message = trUtf8("Copied to clipboard.");
            toast->setBody(message);
            toast->setIcon(QUrl("asset:///icon/ic_done.png"));
            toast->setPosition(SystemUiPosition::MiddleCenter);
            toast->show();
        }
    }
}
