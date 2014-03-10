#include "utility.h"
#include <QDebug>
#include <QSystemDeviceInfo>
#ifdef Q_OS_SYMBIAN
#include <akndiscreetpopup.h>       //for discreet popup
#include <avkon.hrh>                //..
#include <apgcli.h>                 //for launch apps
#include <apgtask.h>                //..
#include <w32std.h>                 //..
#include <mgfetch.h>                //for selecting picture
//#include <NewFileServiceClient.h>   //for camera
#include <AiwServiceHandler.h>      //..
#include <AiwCommon.hrh>            //..
#include <AiwGenericParam.hrh>      //..
#endif


Utility::Utility(QObject *parent) :
    QObject(parent)
{
    manager = new QNetworkAccessManager(this);
    connect(manager, SIGNAL(finished(QNetworkReply*)),this, SLOT(replyFinished(QNetworkReply*)));
}

Utility::~Utility()
{
    manager->deleteLater();
}

void Utility::postHttp(const QString postMode,const QString postUrl,const QString postData)
{
//#ifdef Q_OS_SYMBIAN
    //QTextCodec *codec = QTextCodec::codecForName("gbk");
//#else
    QTextCodec *codec = QTextCodec::codecForName("gb2312");
//#endif
    QByteArray array=codec->fromUnicode(postData);
    QNetworkRequest request;
    request.setUrl(QUrl(postUrl));
    //request.setUrl(QUrl("http://www.9smart.cn"));
    request.setRawHeader("User-Agent","Mozilla/5.0 (Nokia;Qt;MeeGo)");
    if(postMode=="POST")
    {
        manager->post(request,array);
    }else if(postMode=="GET"){
        manager->get(request);
    }else qDebug()<<"暂时没有支持其他种类的http请求";
}
void Utility::replyFinished(QNetworkReply *replys)
{
    //qDebug()<<haha->errorString();
    if(replys->error() == QNetworkReply::NoError)
    {
        QTextCodec *codec = QTextCodec::codecForName("gb2312");
        QString string=codec->toUnicode(replys->readAll());
        qDebug()<<"post return data:"<<string;
        emit postOk(string);
    }
}
//#ifdef Q_OS_SYMBIAN
void Utility::launchPlayer(const QString &url)
{
     QDesktopServices::openUrl(QUrl(url));
}
//#endif
