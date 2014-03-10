#include <QtGui/QApplication>
#include <QSplashScreen>
#include <QPixmap>
#include <QString>
#include <QDeclarativeContext>
#include <QDeclarativeComponent>
#include "setcss.h"
#include "qmlapplicationviewer.h"
#include "myimage.h"
#include "cachecontent.h"
#include "settings.h"
#include "netinfo.h"
#include "isclick.h"
#include "utility.h"
Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));

#if defined(Q_OS_SYMBIAN)||defined(Q_WS_SIMULATOR)
    QPixmap pixmap(":/Image/Symbian.png");
    QSplashScreen *splash = new QSplashScreen(pixmap);
    splash->show();
    splash->raise();
#endif

    //int width=QApplication::desktop()->width();
    //int height=QApplication::desktop()->height();
    app->setApplicationName ("ithome");
    app->setOrganizationName ("Stars");
    app->setApplicationVersion ("1.0.0");
    SetCss *setcss=new SetCss;
    Settings *setting=new Settings;
    CacheContent *cacheContent=new CacheContent(setting);
    qmlRegisterType<MyImage>("MyImages",1,0,"MyImage");

    QmlApplicationViewer viewer;
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationLockPortrait);
    viewer.rootContext ()->setContextProperty ("setCss",setcss);
    viewer.rootContext ()->setContextProperty ("cacheContent",cacheContent);
    viewer.rootContext()->setContextProperty("settings",setting);
    viewer.rootContext()->setContextProperty("netInfo",new NetInfo);
    viewer.rootContext()->setContextProperty("isClick",new IsClick);
    viewer.rootContext()->setContextProperty("utility",new Utility);
#if defined(Q_OS_SYMBIAN)||defined(Q_WS_SIMULATOR)
    viewer.setMainQmlFile(QLatin1String("qml/symbian/main.qml"));
    QString temp;
    if(setting->getValue("night_mode",false).toBool())
        setcss->setCss("./qml/symbian/theme_black"+temp.setNum(viewer.width())+".css");//设置默认的css
    else
        setcss->setCss("./qml/symbian/theme_white"+temp.setNum(viewer.width())+".css");
    viewer.showExpanded();
    splash->finish(&viewer);
    splash->deleteLater();
#elif defined(Q_OS_HARMATTAN)
    if(setting->getValue("night_mode",false).toBool())
        setcss->setCss("/opt/ithome/qml/meego/theme_black.css");//设置默认的css
    else
        setcss->setCss("/opt/ithome/qml/meego/theme_white.css");
    viewer.setMainQmlFile(QLatin1String("qml/meego/main.qml"));
    viewer.showExpanded();
#endif

    return app->exec();
}
