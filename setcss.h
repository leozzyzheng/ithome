#ifndef SETCSS_H
#define SETCSS_H

#include <QObject>

class SetCss : public QObject
{
    Q_OBJECT
public:
    explicit SetCss(QObject *parent = 0);
    
signals:
    
public slots:
    void setCss(QString string);

};

#endif // SETCSS_H
