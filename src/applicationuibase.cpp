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
