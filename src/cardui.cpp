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

#include "cardui.hpp"

#include <bb/cascades/Application>
#include <bb/cascades/QmlDocument>
#include <bb/cascades/AbstractPane>
#include <bb/system/CardDoneMessage>

using namespace bb::cascades;
using namespace bb::system;

CardUI::CardUI(bb::system::InvokeManager* invokeManager) :
                ApplicationUIBase(invokeManager)
{
    // 加载card.qml
    QmlDocument *qml = QmlDocument::create("qrc:/assets/card.qml").parent(this);

    // 注入
    qml->setContextProperty("_app", this);

    AbstractPane *root = qml->createRootObject<AbstractPane>();
    if (root) {
        // 连接 "invoked" 信号来接收invoke请求
        connect(m_pInvokeManager, SIGNAL(invoked(const bb::system::InvokeRequest&)),
                this, SLOT(onInvoked(const bb::system::InvokeRequest&)));

        // 连接 "cardPooled" 信号来接收进入缓存池的请求
        connect(m_pInvokeManager, SIGNAL(cardPooled(const bb::system::CardDoneMessage&)),
                this, SLOT(cardPooled(const bb::system::CardDoneMessage&)));

        // 显示场景
        Application::instance()->setScene(root);
    }
}

void CardUI::cardPooled(const bb::system::CardDoneMessage& doneMessage)
{
    /*
     * 卡片已经不再显示，进入缓存池。卡片进程仍然在运行，但已进入后台缓存池，以优化未来调用。
     * 因此，如果卡片收到了这个消息，应该立即将状态恢复到初始状态，准备再次被调用。
     * 比如，如果是个编写类的卡片，此时应将所有输入清空。
     */
    qDebug() << "cardPooled: " << doneMessage.reason();

    // TODO: 清理释放所有可能占用的资源
}

void CardUI::onInvoked(const bb::system::InvokeRequest& request)
{
    // 被invoke
    qDebug() << "onInvoked request:";

    bb::system::InvokeSource source = request.source();

    QString memo = QString::fromUtf8(request.data());

    qDebug() << "Source: (groupid: " << source.groupId() << ",installid: " << source.installId() << ")";
    qDebug() << "Target:" << request.target();
    qDebug() << "Action:" << request.action();
    qDebug() << "Mime:" << request.mimeType();
    qDebug() << "Url:" << request.uri();
    qDebug() << "Data:" << memo;

    emit memoChanged(memo);
}

