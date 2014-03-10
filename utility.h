#ifndef UTILITY_H
#define UTILITY_H

#include <QtDeclarative>
#include <QtNetwork>
#include <QString>
#include <QTextCodec>
#include <QByteArray>
#include <QFile>
#include <QTextStream>
#include <string>
class Utility : public QObject
{
    Q_OBJECT
public:
    // Not for qml
    explicit Utility(QObject *parent = 0);
    ~Utility();

//#ifdef Q_OS_SYMBIAN
    Q_INVOKABLE void launchPlayer(const QString &url);
//#endif

public:             // Other functions.
    Q_INVOKABLE void postHttp(const QString postMode,const QString postUrl,const QString postData);

private slots:
    void replyFinished(QNetworkReply* replys);

signals:
    void postOk(QString returnData);
private:
    QNetworkAccessManager *manager;

};

#endif // UTILITY_H
