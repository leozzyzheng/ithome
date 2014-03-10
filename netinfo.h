#ifndef NETINFO_H
#define NETINFO_H

#include <QObject>
#include <QNetworkConfiguration>
#include <QNetworkConfigurationManager>
#include <QString>
class NetInfo : public QObject
{
    Q_OBJECT
public:
    explicit NetInfo(QObject *parent = 0);
private:
    QNetworkConfiguration networkInfo;
    QNetworkConfigurationManager manager;

signals:
    void onlineStateChanged(bool isOnline);
public slots:
    QString getNetInfo();
    bool isOnline();
};

#endif // NETINFO_H
