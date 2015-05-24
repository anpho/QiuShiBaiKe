#include <bb/cascades/web/webpage.h>
#include <qobject.h>

class MyWebPage: public bb::cascades::WebPage
{
Q_OBJECT
public:
    MyWebPage(QObject* parent = 0) :
            bb::cascades::WebPage(parent)
    {
    }
    Q_INVOKABLE
    void download(bb::cascades::WebDownloadRequest* request)
    {
        bb::cascades::WebPage::download(request);
    }
};
