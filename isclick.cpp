#include "isclick.h"

IsClick::IsClick(QObject *parent) :
    QObject(parent)
{
    string="";
}
bool IsClick::imageIsShow(const QString name)
{
    if(string.indexOf(name)!=-1)
        return true;
    else
        return false;
}
void IsClick::imageToShow(const QString name)
{
    string.append(name+",");
}
