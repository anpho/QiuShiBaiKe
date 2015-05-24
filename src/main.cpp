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
#include <unistd.h>
#include "cardui.hpp"
#include <bb/cascades/Application>
#include <bb/cascades/LocaleHandler>
#include <bb/system/InvokeManager>
#include <bb/cascades/web/webdownloadrequest.h>
#include <Qt/qdeclarativedebug.h>
#include "WebImageView.h"
#include "WebPage.hpp"
#include <bb/device/DisplayInfo.hpp>
using namespace bb::cascades;
using namespace bb::system;

Q_DECL_EXPORT int main(int argc, char **argv)
{
    QString theme = ApplicationUIBase::getv("use_dark_theme", "");
    if (theme.length() > 0) {
        qputenv("CASCADES_THEME", theme.toUtf8());
    }
    sleep(1.3);

    Application app(argc, argv);

    InvokeManager invokeManager;
    qmlRegisterType<WebImageView>("org.labsquare", 1, 0, "WebImageView");
    qmlRegisterType<bb::device::DisplayInfo>("anpho.bb", 1, 0, "DisplayInfo");
    qmlRegisterType<MyWebPage>("WebPageComponent", 1, 0, "WebPage");
    qmlRegisterType<bb::cascades::WebDownloadRequest>("WebPageComponent", 1, 0,
            "WebDownloadRequest");
    QObject *appui = 0;
    if (invokeManager.startupMode() == ApplicationStartupMode::InvokeCard) {
        // Create the Card UI object
        appui = new CardUI(&invokeManager);
    } else {
        // Create the Application UI object, this is where the main.qml file
        // is loaded and the application scene is set.
        appui = new ApplicationUI(&invokeManager);
    }

    // Enter the application main event loop.
    int ret = Application::exec();

    invokeManager.closeChildCard();
    delete appui;

    return ret;
}
