#include "cachecontent.h"
#include <QDebug>
#include <QVariant>
#include <QApplication>
CacheContent::CacheContent(Settings *new_set,QDeclarativeItem *parent) :
    QDeclarativeItem(parent)
{
    setting=new_set;
    m_canclePost=false;
    queue_begin=queue_end=0;
#ifdef Q_OS_HARMATTAN
    prefix="/home/user/ithome";
    QDir temp;
    QFileInfo info(prefix);
    if(!info.isDir()) temp.mkdir(prefix);
    coding="utf-8";
#else
    prefix=".";
    coding="gbk";
#endif
    count=0;
    manager = new QNetworkAccessManager(this);
    connect(manager, SIGNAL(finished(QNetworkReply*)),this, SLOT(replyFinished(QNetworkReply*)));
}
void CacheContent::saveTitle(const QString sid, QString string)
{
    QFileInfo fileinfo(prefix+"/cache/"+sid);
    QDir temp;
    QFileInfo info(prefix+"/cache");
    if(!info.isDir()) temp.mkdir(prefix+"/cache");
    if(!fileinfo.isDir())
    {
        //qDebug()<<temp.exists();
        temp.mkdir(prefix+"/cache/"+sid);
    }
    file.setFileName(prefix+"/cache/"+sid+"/title.txt");
    if(!file.exists())
    {
        file.open(QIODevice::WriteOnly);
        QTextStream text(&file);
#ifdef Q_OS_HARMATTAN
        text.setCodec("utf-8");
#endif
        setting->setValue("cache_size",setting->getValue("cache_size",0).toLongLong()+string.size());
        text<<string;
        file.close();
    }
}
void CacheContent::saveContent(const QString sid,QString string)
{
    //qDebug()<<sid<<"  :\n"<<string<<"\n\n\n\n\n";
    QFileInfo fileinfo(prefix+"/cache/"+sid);
    QDir temp;
    QFileInfo info(prefix+"/cache");
    if(!info.isDir()) temp.mkdir(prefix+"/cache");
    if(!fileinfo.isDir())
    {
        //qDebug()<<temp.exists();
        temp.mkdir(prefix+"/cache/"+sid);
    }
    file.setFileName(prefix+"/cache/"+sid+"/content_noImage.html");
    if(!file.exists())
    {
        file.open(QIODevice::WriteOnly);
        QTextStream text(&file);

#ifdef Q_OS_HARMATTAN
        text.setCodec("utf-8");
#endif
        disposeHref(string);//修改超链接
        disposeLetvVideo(string);//解析乐视视频
        disposeYoukuVideo(string);//解析优酷视频
        //disposeSwfVideo(string);//解析swf视频
        if(sid=="75117")
            qDebug()<<"save "<<sid<<" content:"<<string;
        text<<"<meta http-equiv=\"Content-Type\" content=\"text/html; charset="+coding+"\" />"<<string;
        //qDebug()<<"file size:"<<string.size();
        file.close();
        setting->setValue("cache_size",setting->getValue("cache_size",0).toLongLong()+string.size()+80);
    }
}

QString CacheContent::getTitle(const QString sid,const QString string)
{
    file.setFileName(prefix+"/cache/"+sid+"/title.txt");
    if(file.exists())
    {
        file.open(QIODevice::ReadOnly);
        QTextStream text(&file);

        QString string=text.readAll();
        //qDebug()<<string;
        file.close();
        return string;

    }else return string;
}

QString CacheContent::getContent_text(const QString sid)
{
    file.setFileName(prefix+"/cache/"+sid+"/content_noImage.html");
    if(file.exists())
    {
        file.open(QIODevice::ReadOnly);
        QTextStream text(&file);
        QString temp=text.readAll();
        int m=temp.indexOf("<");
        while(m!=-1)
        {
            int n=temp.indexOf(">",m);
            if(n!=-1)
            {
                temp.replace(m,n-m+1,"");
            }
            m=temp.indexOf("<",m);
        }
        return temp;
    }else return "-1";
}

QString CacheContent::getContent_noImage(const QString sid)
{
    file.setFileName(prefix+"/cache/"+sid+"/content_noImage.html");
    if(file.exists())
    {
#ifdef Q_OS_HARMATTAN
        return prefix+"/cache/"+sid+"/content_noImage.html";
#else
        return "../../cache/"+sid+"/content_noImage.html";
#endif
    }else return "-1";
}
void CacheContent::getContent_image(const QString sid)
{
    //qDebug()<<sid;
    m_sid=sid;
    file.setFileName(prefix+"/cache/"+sid+"/content_image.html");
    if(!file.exists())
    {
        //qDebug()<<sid<<"is no-exists";
        file.setFileName(prefix+"/cache/"+sid+"/content_noImage.html");
        if(file.exists())
        {
            file.open(QIODevice::ReadOnly);
            QTextStream text(&file);
            content=text.readAll();
            file.close();
            //qDebug()<<content;
            editContent();
        }else emit content_image("-1");
    }else{
        qDebug()<<sid<<"is exists";
#ifdef Q_OS_HARMATTAN
        emit content_image(prefix+"/cache/"+sid+"/content_image.html");
#else
        emit content_image("../../cache/"+sid+"/content_image.html");
#endif
    }
}
void CacheContent::disposeHref(QString &string,int i)
{
    int begin=string.indexOf("href=",i);
    if(begin==-1) return;
    int end=string.indexOf("\"",begin+10);
    string.insert(end+2,"onclick=\"window.qml.openUrl(this.href)\" ");
    disposeHref(string,end);
}
void CacheContent::disposeLetvVideo(QString &string, int i)
{
    int begin=string.indexOf("<div",i);
    if(begin==-1) return;
    string.insert(begin+5,"onclick='window.qml.openVideoUrl(\"letv\")' ");
    disposeLetvVideo(string,begin+20);
}
void CacheContent::disposeYoukuVideo(QString &string, int i)
{
    int begin=string.indexOf("<video",i);
    if(begin==-1) return;
    string.insert(begin+7,"onclick=\"window.qml.openVideoUrl(this.src)\" ");
    disposeYoukuVideo(string,begin+20);
}
/*void CacheContent::disposeSwfVideo(QString &string, int i)
{
    int begin=string.indexOf("swf",i);
    if(begin==-1) return;
    string.insert(begin+5,"onclick=\"window.qml.openVideoUrl(\"letv\")\" ");
    disposeSwfVideo(string,begin+10);
}*/
void CacheContent::editContent()
{
    //qDebug()<<m_sid<<":\n"<<content;
    int begin=content.indexOf("<img",count);
    count=begin+1;
    if(begin!=-1){
        content.insert(begin+5,"onclick=\"window.qml.enlargeImage(this.src)\" ");
        int temp=content.indexOf("\" />",begin);
        int temp2=content.indexOf("http",begin);
        //int temp3=content.indexOf("_",begin)+1;
        QString temp_string=content.mid(temp2,temp-temp2);
        if(temp_string.indexOf("jpg")==-1)
            if(temp_string.indexOf("png")==-1)
            {
                editContent();
                return;
            }
        int temp3=temp_string.lastIndexOf("/")+1;
        //qDebug()<<"temp:"<<temp<<";temp3:"<<temp3<<";"<<content.count();
        QString image_src=temp_string.mid(temp3,temp_string.size()-temp3);
        imageName=prefix+"/cache/"+m_sid+"/"+image_src;
        //qDebug()<<content;
        //qDebug()<<"sss\n"<<temp_string<<"\nsss";
        if(m_canclePost){//判断用户是否停止了请求
            m_canclePost=false;
            return;
        }
        file.setFileName(imageName);
        if(!file.exists())//如果文件不存在就下载
        {
            qDebug()<<"post url:"<<temp_string;
            manager->get(QNetworkRequest(QUrl(temp_string)));
        }
        //count=temp;
        //qDebug()<<count<<"is 2";
        content.replace(temp2,temp-temp2,"./"+image_src);//"file:///
    }else{
        file.setFileName(prefix+"/cache/"+m_sid+"/content_image.html");
        file.open(QIODevice::WriteOnly);
        QTextStream text(&file);

#ifdef Q_OS_HARMATTAN
        text.setCodec("utf-8");
#endif
        text<<content;
        file.close();
        setting->setValue("cache_size",setting->getValue("cache_size",0).toLongLong()+content.size()+80);
        //qDebug()<<content;
        if(m_canclePost){
            m_canclePost=false;
            return;
        }
#ifdef Q_OS_HARMATTAN
        emit content_image(prefix+"/cache/"+m_sid+"/content_image.html");
#else
        emit content_image("../../cache/"+m_sid+"/content_image.html");
#endif
        //count=0;
    }
}
void CacheContent::replyFinished(QNetworkReply *replys)
{
    //qDebug()<<haha->errorString();
    if(replys->error() == QNetworkReply::NoError)
    {
        QByteArray temp=replys->readAll();
        //qDebug()<<"image size:"<<temp.size();
        image.loadFromData(temp);
        file.setFileName(imageName);
        if(!file.exists())
        image.save(imageName);
        setting->setValue("cache_size",setting->getValue("cache_size",0).toLongLong()+temp.size());
        editContent();//再次调用解析下一个图片地址
    }
}
bool CacheContent::clearCache(QString dirPath , bool deleteSelf , bool deleteHidden /*= false*/)
{
    QDir entry (dirPath);

    if(!entry.exists()||!entry.isReadable())
    {
        return false;
    }
    entry.setFilter(QDir::Files | QDir::Dirs | QDir::NoDotAndDotDot | QDir::Hidden);
    QFileInfoList dirList = entry.entryInfoList();
    bool bHaveHiddenFile = false;

    if(!dirList.isEmpty())
    {
        for( int i = 0; i < dirList.size() ; ++i)
        {
            QFileInfo info = dirList.at(i);

            if(info.isHidden() && !deleteHidden)
            {
                bHaveHiddenFile = true;
                continue;
            }

            QString path = info.absoluteFilePath();

            if(info.isDir())
            {
                if(!clearCache(path, true, deleteHidden))
                {
                    return false;
                }
            }
            else if(info.isFile())
            {
                if(!QFile::remove(path))
                {
                    return false;
                }
            }
            else
            {
                return false;
            }
        }
    }

    if(deleteSelf && !bHaveHiddenFile)
    {
        if(!entry.rmdir(dirPath))
        {
            return false;
        }
    }
    return true;
}
void CacheContent::setClipboard(const QString string)
{

    QClipboard *board = QApplication::clipboard();
    qDebug()<<"Clipboard content is:"<<board->text();
    board->setText(string);
    qDebug()<<"copy content ok";
}
void CacheContent::canclePost()
{
    m_canclePost=true;
}
bool CacheContent::inQueue(const QString sid)
{
    //qDebug()<<"in queue data:"<<sid<<"end is:"<<queue_end;
    if(queue_end==queue_begin&&queue[queue_begin]!="") return false;
    else{
        queue[queue_end]=sid;
        queue_end=(queue_end+1)%50;
    }
}
QString CacheContent::OutQueue()
{
    int temp=(queue_begin+1)%50;
    if(temp==queue_end+1){
        //queue_begin=queue_end=0;
        return "null";
    }
    else{
        QString string=queue[queue_begin];
        queue[queue_begin]="";
        //qDebug()<<"out queue data:"<<string<<"begin is:"<<queue_begin;
        queue_begin=temp;
        return string;
    }
}

CacheContent::~CacheContent()
{
    manager->deleteLater();
}
