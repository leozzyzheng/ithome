#include "setcss.h"
#include <QWebSettings>
#include <QUrl>
#include <QDebug>
SetCss::SetCss(QObject *parent) :
    QObject(parent)
{
}
void SetCss::setCss(QString string)
{
    qDebug()<<"css url:"<<string;
    QWebSettings::globalSettings()->setUserStyleSheetUrl(QUrl::fromLocalFile(string));
}

