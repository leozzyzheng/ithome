#ifndef CACHECONTENT_H
#define CACHECONTENT_H

#include <QDeclarativeItem>
#include <QString>
#include <QFile>
#include <QFileInfo>
#include <QIODevice>
#include <QTextStream>
#include <QtNetwork>
#include <QByteArray>
#include <QImage>
#include <QClipboard>
#include <QInputContext>
#include "settings.h"
class CacheContent : public QDeclarativeItem
{
    Q_OBJECT
public:
    explicit CacheContent(Settings *new_set,QDeclarativeItem *parent = 0);
    ~CacheContent();
private:
    QFile file;
    QNetworkAccessManager *manager;
    QString imageName,content,m_sid,prefix,coding;
    QImage image;
    int count;
    Settings *setting;
    bool m_isChache;
    void disposeHref(QString &string,int i=0);
    void disposeLetvVideo(QString &string,int i=0);
    void disposeYoukuVideo(QString &string,int i=0);
    //void disposeSwfVideo(QString &string, int i=0);
    bool m_canclePost;
    QString queue[50];
    int queue_begin,queue_end;
private slots:
    void replyFinished(QNetworkReply* replys);
signals:
    void content_image(const QString string);

public slots:
    void editContent();
    void saveTitle(const QString sid,QString string);
    QString getTitle(const QString sid,const QString string);
    void saveContent(const QString sid,QString string);
    void getContent_image(const QString sid);
    QString getContent_noImage(const QString sid);
    void setClipboard(const QString string);
    void canclePost();
    bool inQueue(const QString sid);
    QString OutQueue();

#ifdef Q_OS_HARMATTAN
    bool clearCache(QString dirPath ="/home/user/ithome/cache", bool deleteSelf=false , bool deleteHidden= false);
#else
    bool clearCache(QString dirPath ="./cache", bool deleteSelf=false , bool deleteHidden= false);
#endif
    QString getContent_text(const QString sid);
};

#endif // CACHECONTENT_H
