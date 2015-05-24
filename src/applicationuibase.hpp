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

#ifndef APPLICATIONUIBASE_H_
#define APPLICATIONUIBASE_H_

#include <QObject>
#include <QNetworkReply>
#include <QString>
#include <QSettings>
#include <bb/cascades/InvokeQuery>
#include <bb/cascades/Invocation>
#include "clipboard/clipboard.h"
namespace bb {
    namespace system {
      class InvokeManager;
    }
    namespace cascades {
      class LocaleHandler;
    }
}
class QTranslator;

class ApplicationUIBase : public QObject
{
    Q_OBJECT
public:
    ApplicationUIBase(bb::system::InvokeManager* invokeManager);
    virtual ~ApplicationUIBase();
    Q_INVOKABLE void invokeVideo(const QString &title, const QString &url);
    Q_INVOKABLE static void setv(const QString &objectName, const QString &inputValue);
    Q_INVOKABLE static QString getv(const QString &objectName, const QString &defaultValue);
    Q_SIGNAL void posted(bool success,QString resp);
    Q_INVOKABLE void post(const QString endpoint, const QString content);
    Q_INVOKABLE void postImage(const QString endpoint, const QString content, const QString picpath);
    Q_INVOKABLE QString genCodeByKey(const QString key);
    Q_INVOKABLE void viewimage(QString path);
    Q_INVOKABLE void sharetext(QString text);
    Q_INVOKABLE void setClipboard(QString text);
private slots:
    void onSystemLanguageChanged();
    void onArticleCreated();
    void onErrorOcurred(QNetworkReply::NetworkError error);
    Q_INVOKABLE void onFinished();
    Q_INVOKABLE void onTEXTArmed();
    Q_INVOKABLE void onViewArmed();

protected:
    bb::system::InvokeManager* m_pInvokeManager;
private:
    QTranslator* m_translator;
    bb::cascades::LocaleHandler* m_pLocaleHandler;
    QNetworkReply *reply;
    QNetworkAccessManager *networkmgr;
    QString md5(const QString key);
};

#endif /* APPLICATIONUIBASE_H_ */
