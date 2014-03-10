#include "myimage.h"
#include <QDebug>
//#include <QtGlobal>
MyImage::MyImage(QDeclarativeItem *parent) :
    QDeclarativeItem(parent)
{
#ifdef Q_OS_HARMATTAN
    prefix="/home/user/ithome";
    QDir temp;
    QFileInfo info(prefix);
    if(!info.isDir()) temp.mkdir(prefix);

#else
    prefix=".";
#endif
    setFlag(QGraphicsItem::ItemHasNoContents,false);
    m_source="";
    m_sid="image";
    manager = new QNetworkAccessManager(this);
    connect(manager, SIGNAL(finished(QNetworkReply*)),this, SLOT(replyFinished(QNetworkReply*)));
    //connect(this,SIGNAL(widthChanged()),SLOT(setImageSize()));
    //connect(this,SIGNAL(heightChanged()),SLOT(setImageSize()));
}
QString MyImage::source(){
    return m_source;
}
void MyImage::setSource(const QString string)
{
    //qDebug()<<"iamge url:"<<string;
    if(string=="noImage")
    {
        m_source=string;
        QImage image;
        image.load(":/Image/it.png");
        pixmap=QPixmap::fromImage(image.scaled(this->width(),this->height()));
        this->update(0,0,this->width(),this->height());
        return;
    }
    if(string!=m_source){
        //qDebug()<<string;
        m_source=string;
        QFile file;
        file.setFileName(prefix+"/cache/"+m_sid+"/"+"title.jpg");
        if(file.exists())
        {
            QImage image;
            image.load(prefix+"/cache/"+m_sid+"/"+"title.jpg");
            pixmap=QPixmap::fromImage(image.scaled(this->width(),this->height()));
            this->update(0,0,this->width(),this->height());
        }else{
            //qDebug()<<"network xiazai";
            manager->get(QNetworkRequest(QUrl(string)));
        }
        emit sourceChanged();
    }
    else return;
}
void MyImage::paint(QPainter *new_painter, const QStyleOptionGraphicsItem *new_style, QWidget *new_widget)
{
    new_painter->drawPixmap(0,0,pixmap);
}
void MyImage::setSid(QString newid)
{
    if(newid!=m_sid){
        m_sid=newid;
        emit sidChanged();
    }
}
QString MyImage::sid()
{
    return m_sid;
}

void MyImage::replyFinished(QNetworkReply *replys)
{
    //qDebug()<<haha->errorString();
    if(replys->error() == QNetworkReply::NoError)
    {
        //qDebug()<<"image ok";
        //disconnect(manager, SIGNAL(finished(QNetworkReply*)),this, SLOT(replyFinished(QNetworkReply*)));
        QDir temp;
        QFileInfo info(prefix+"/cache");
        if(!info.isDir()) temp.mkdir(prefix+"/cache");
        QFileInfo fileinfo(prefix+"/cache/"+m_sid);
        if(!fileinfo.isDir())
            temp.mkdir(prefix+"/cache/"+m_sid);
        QImage image;
        QByteArray temp2=replys->readAll();
        //qDebug()<<"image2 size:"<<temp2.size();
        image.loadFromData(temp2);
        image.save(prefix+"/cache/"+m_sid+"/"+"title.jpg");
        pixmap=QPixmap::fromImage(image.scaled(this->width(),this->height()));//
        this->update(0,0,this->width(),this->height());
        Settings setting;
        setting.setValue("cache_size",setting.getValue("cache_size",0).toLongLong()+temp2.size());
    }
}

MyImage::~MyImage()
{
    manager->deleteLater();
}
