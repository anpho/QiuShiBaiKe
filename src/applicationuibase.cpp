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
