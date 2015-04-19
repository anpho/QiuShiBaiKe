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

#ifndef CardUI_HPP_
#define CardUI_HPP_

#include "applicationuibase.hpp"

#include <bb/system/InvokeManager>

namespace bb {
    namespace system {
        class InvokeManager;
        class InvokeRequest;
    }
}

class CardUI: public ApplicationUIBase
{
    Q_OBJECT
public:
    CardUI(bb::system::InvokeManager* invokeManager);
    virtual ~CardUI() {}
signals:
    void memoChanged(const QString &memo);
private slots:
    void onInvoked(const bb::system::InvokeRequest& request);
    void cardPooled(const bb::system::CardDoneMessage& doneMessage);
};

#endif /* CardUI_HPP_ */
