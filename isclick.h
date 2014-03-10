#ifndef ISCLICK_H
#define ISCLICK_H
//用了记录列表内哪个文章的标题图片被点击过，或者哪篇文章的图片被用户要求显示（都是在无图模式或者蜂窝网络用户不允许显示图片的情况下）
#include <QObject>
#include <QString>
class IsClick : public QObject
{
    Q_OBJECT
public:
    explicit IsClick(QObject *parent = 0);
private:
    QString string;
signals:
    
public slots:
    bool imageIsShow(const QString name);//name=图片类型（标题图片还是文章图）+文章id
    void imageToShow(const QString name);//记录用户点击过的每一个标题图片或者文章图片，以方便下次打开时在显示这个图片
};

#endif // ISCLICK_H
