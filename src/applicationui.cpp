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

#include "applicationui.hpp"

#include <bb/cascades/Application>
#include <bb/cascades/QmlDocument>
#include <bb/cascades/AbstractPane>
#include <bb/system/CardDoneMessage>
#include <bb/system/InvokeManager>

using namespace bb::cascades;
using namespace bb::system;

ApplicationUI::ApplicationUI(InvokeManager *invokeManager) :
        ApplicationUIBase(invokeManager)
{
    bool res = connect(m_pInvokeManager, SIGNAL(childCardDone(const bb::system::CardDoneMessage&)),
                  this, SLOT(cardDone(const bb::system::CardDoneMessage&)));
    Q_ASSERT(res);

    // 注明res未被使用
    Q_UNUSED(res);

    // 加载main.qml
    QmlDocument *qml = QmlDocument::create("asset:///main.qml").parent(this);
    // 注入
    qml->setContextProperty("ApplicationUI", this);

    // 显示场景
    AbstractPane *root = qml->createRootObject<AbstractPane>();
    Application::instance()->setScene(root);
}

void ApplicationUI::invokeCard(const QString &memo)
{
    InvokeRequest cardRequest;
    cardRequest.setTarget("anpho.qiushibaike");
    cardRequest.setAction("bb.action.SHARE");
    cardRequest.setMimeType("text/plain");
    cardRequest.setData(memo.toUtf8());
    m_pInvokeManager->invoke(cardRequest);
}

void ApplicationUI::cardDone(const bb::system::CardDoneMessage &doneMessage)
{
    qDebug() << "cardDone: " << doneMessage.reason();
}
