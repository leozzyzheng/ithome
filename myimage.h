#ifndef MYIMAGE_H
#define MYIMAGE_H

#include <QDeclarativeItem>
#include <QImage>
#include <QPixmap>
#include <QPainter>
#include <QString>
#include <QtNetwork>
#include <QByteArray>
#include <QFile>
#include <QFileInfo>
#include "settings.h"
class MyImage : public QDeclarativeItem
{
    Q_OBJECT
    Q_PROPERTY(QString source READ source WRITE setSource NOTIFY sourceChanged)
    Q_PROPERTY(QString sid READ sid WRITE setSid NOTIFY sidChanged)
public:
    explicit MyImage(QDeclarativeItem *parent = 0);
    ~MyImage();
    void paint(QPainter *new_painter, const QStyleOptionGraphicsItem *new_style, QWidget *new_widget=0);

private:
    QPixmap pixmap;
    QString m_source;
    QNetworkAccessManager *manager;
    QString source();
    void setSource(const QString string);
    void saveImageToLocal();
    QString m_sid,prefix;
    void setSid(QString newid);
    QString sid();
private slots:
    void replyFinished(QNetworkReply* replys);
signals:
    void sourceChanged();
    void sidChanged();
public slots:
    
};

#endif // MYIMAGE_H
