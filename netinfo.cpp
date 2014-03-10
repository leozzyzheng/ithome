#include "netinfo.h"
#include <QDebug>
NetInfo::NetInfo(QObject *parent) :
    QObject(parent)
{
    connect(&manager,SIGNAL(onlineStateChanged(bool)),this,SIGNAL(onlineStateChanged(bool)));

}
QString NetInfo::getNetInfo()
{
    qDebug()<<"netwoek state:"<<manager.isOnline()<<" "<<networkInfo.bearerTypeName()<<" "<<networkInfo.bearerName()<<" "<<networkInfo.bearerType();
    return networkInfo.bearerTypeName();
    /*switch(networkInfo.bearerTypeName())
    {
    case 0:
        return "Unknown";
    case 1:
        return "Ethernet";
    case 2:
        return "WLAN";
    case 3:
        return "2G";
    case 4:
        return "CDMA2000";
    case 5:
        return "WCDMA";
    case 6:
        return "HSPA";
    case 7:
        return "Bluetooth";
    case 8:
        return "WiMAX";
    default:
        return "NO";
    }*/
}
bool NetInfo::isOnline()
{
    qDebug()<<"netwoek state:"<<manager.isOnline()<<" "<<getNetInfo()<<" "<<networkInfo.bearerName()<<" "<<networkInfo.bearerType();
    return manager.isOnline();
}
