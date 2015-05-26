#include "WebImageView.h"

#include <QtGui/QDesktopServices>
#include <QNetworkReply>
#include <bb/cascades/Image>
#include <QCryptographicHash>
#include <QFile>
#include <QDir>
#include <QFileInfo>

using namespace bb::cascades;

QNetworkAccessManager * WebImageView::mNetManager = new QNetworkAccessManager();
QNetworkDiskCache * WebImageView::mNetworkDiskCache = new QNetworkDiskCache();

WebImageView::WebImageView()
{
    // Creates the folder if it doesn't exist
    QFileInfo imageDir(QDir::homePath() + "/images/");
    if (!imageDir.exists()) {
        QDir().mkdir(imageDir.path());
    }
    connect(this,SIGNAL(creationCompleted()),this,SLOT(resetControl()));
    // Initialize network cache
    mNetworkDiskCache->setCacheDirectory(QDir::homePath() + "/cache/");
    mNetworkDiskCache->setMaximumCacheSize(100 * 1024 * 1024);
    // Set cache in manager
    mNetManager->setCache(mNetworkDiskCache);
    // Set defaults
    mLoading = 0;
}

const QUrl& WebImageView::url() const
{
    return mUrl;
}

void WebImageView::setUrl(QUrl url)
{
    if (url.scheme() == "") {
        return;
    }
    if (url.scheme() != "http") {
        resetImage();
        setImageSource(url);
        return;
    }
    // Variables
    mUrl = url;
    mLoading = 0;

    // Reset the image
    resetImage();

//    QString fileName = md5(url.toString());
//    QFileInfo imageFile(QDir::homePath() + "/images/" + fileName + ".jpg");
    // If image doesn' exists, download it, otherwise reuse the image saved
//    if (!imageFile.exists()) {
    // Create request
    QNetworkRequest request;
    request.setAttribute(QNetworkRequest::CacheLoadControlAttribute, QNetworkRequest::PreferCache);
    request.setUrl(url);
    // Create reply
    QNetworkReply * reply = mNetManager->get(request);

    // Connect to signals
    QObject::connect(reply, SIGNAL(finished()), this, SLOT(imageLoaded()));
    QObject::connect(reply, SIGNAL(downloadProgress(qint64, qint64)), this,
            SLOT(dowloadProgressed(qint64,qint64)));
//    } else {
//        loadFromFile(imageFile.filePath());
//    }

    emit urlChanged();
}
QString WebImageView::md5(const QString key)
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
void WebImageView::loadFromFile(QString filePath)
{
    qDebug() << "[CACHE]" << filePath;
    QFile imageFile(filePath);
    if (imageFile.open(QIODevice::ReadOnly)) {
        QByteArray imageData = imageFile.readAll();
        setImage(Image(imageData));
        mLoading = 1;
        emit loadingChanged();
    }
}

double WebImageView::loading() const
{
    return mLoading;
}

void WebImageView::imageLoaded()
{
    emit loadComplete();
    // Get reply
    QNetworkReply * reply = qobject_cast<QNetworkReply*>(sender());
    QVariant fromCache = reply->attribute(QNetworkRequest::SourceIsFromCacheAttribute);
    qDebug() << "page from cache?" << fromCache.toBool();
    if (reply->error() == QNetworkReply::NoError) {
        if (isARedirectedUrl(reply)) {
            setURLToRedirectedUrl(reply);
            return;
        } else {
//            QString fileName = md5(reply->url().toString());
            imageData = reply->readAll();
            setImage(Image(imageData));
//            QFile imageFile(QDir::homePath() + "/images/" + fileName + ".jpg");
//            if (imageFile.open(QIODevice::WriteOnly)) {
//                imageFile.write(imageData);
//                imageFile.close();
//                setImage(Image(imageData));
//
//                releaseSomeCache(MAX_NUMBER_OF_IMAGES_SAVED);
//            }
        }
    }

    // Memory management
    reply->deleteLater();
}

bool WebImageView::isARedirectedUrl(QNetworkReply *reply)
{
    QUrl redirection = reply->attribute(QNetworkRequest::RedirectionTargetAttribute).toUrl();
    return !redirection.isEmpty();
}

void WebImageView::setURLToRedirectedUrl(QNetworkReply *reply)
{
    QUrl redirectionUrl = reply->attribute(QNetworkRequest::RedirectionTargetAttribute).toUrl();
    QUrl baseUrl = reply->url();
    QUrl resolvedUrl = baseUrl.resolved(redirectionUrl);

    setUrl(resolvedUrl.toString());
}

void WebImageView::clearCache()
{
    mNetworkDiskCache->clear();

    QDir imageDir(QDir::homePath() + "/images");
    imageDir.setFilter(QDir::NoDotAndDotDot | QDir::Files);
    foreach(const QString& file, imageDir.entryList()){
    imageDir.remove(file);
}
}

void WebImageView::releaseSomeCache(const int& maxNumberOfImagesSaved)
{
    if (maxNumberOfImagesSaved < 0)
        return;

    QDir imageDir(QDir::homePath() + "/images");
    imageDir.setFilter(QDir::NoDotAndDotDot | QDir::Files);
    imageDir.setSorting(QDir::Time); // | QDir::Reversed

    QStringList entryList = imageDir.entryList();
    for (int i = maxNumberOfImagesSaved; i < entryList.size(); i++) {
        imageDir.remove(entryList[i]);
    }
}
QString WebImageView::getCachedPath()
{
    if (imageData.isEmpty()) {
        qDebug()<<"imageData is empty.";
        return "";
    } else {
        QString fileName = md5(mUrl.toString());
        QString filepath = QDir::homePath() + "/images/" + fileName + ".jpg";
        QFile imageFile(filepath);
        if (imageFile.open(QIODevice::WriteOnly)) {
            imageFile.write(imageData);
            imageFile.close();
            return "file://" + filepath;
        } else {
            qDebug()<<"Can't open file to write.";
            return "";
        }
    }
}
void WebImageView::dowloadProgressed(qint64 bytes, qint64 total)
{
    mLoading = double(bytes) / double(total);

    emit loadingChanged();
}

void WebImageView::resetControl()
{
    resetImage();
    resetImageSource();
    mUrl=NULL;
    mLoading =0;
    imageData.clear();

}
