// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.1
import QtMobility.systeminfo 1.2
import com.nokia.extras 1.1
PageStackWindow {
    id:main
    property bool night_mode: settings.getValue("night_mode",false)//夜间模式
    property bool no_show_image: settings.getValue("show_image_off_on",false)//无图模式
    property bool isWifi: settings.getValue("wifi_load_image",true)//wifi下显示图片
    property bool full: settings.getValue("full_screen",false)//浏览文章全屏
    property int content_font_size: settings.getValue("fontSize",20)//正文字体大小
    property real brilliance_control: settings.getValue("intensity_control",0.60)//夜间模式亮度
    property string current_page: "page"//当前显示的界面
    property bool online: netInfo.isOnline()//网络连接状态
    property bool sysIsSymbian: false
    property string wifiState: wlaninfo.networkStatus
    property bool loading: false
    onLoadingChanged:{
        indicator.visible=loading
        if(loading)
            netTimer.start()
        else netTimer.stop()
    }
    Timer{
        id:netTimer
        running: false
        interval: 15000
        onTriggered: {
            if(loading===true){
                loading=false
                showBanner("网络忒差了，联网超时了，一会在试试吧")
            }
        }
    }
    function showBanner(string)
    {
        banner.text=string
        banner.show()
    }

    InfoBanner{
        y:35
        id: banner
    }

    NetworkInfo {
             id: wlaninfo
             mode:NetworkInfo.WlanMode
             monitorNameChanges: true
             monitorModeChanges: true
             monitorStatusChanges: true
             monitorSignalStrengthChanges: true//wifi信号强度
             monitorCurrentMobileNetworkCodeChanges: true
             onModeChanged: console.log("mode"+mode)
             onSignalStrengthChanged: console.log("SignalStrength:"+wlaninfo.networkSignalStrength)
             onNetworkNameChanged: console.log("network name:"+wlaninfo.networkName)
             onCurrentMobileNetworkCodeChanged: console.log("CurrentMobileNetworkCode"+wlaninfo.currentMobileNetworkCode)
         }
    Connections{
        target: netInfo
        onOnlineStateChanged:{
            if(!isOnline)
                showBanner("亲，貌似断网了")
            console.log("online state:"+isOnline)
            console.log("wifi state:"+wifiState)
            online=isOnline
        }
    }
    onNight_modeChanged: {
        //console.log(night_mode+" "+settings.getValue("night_mode",false))
        if(night_mode){
            setCss.setCss("/opt/ithome/qml/meego/theme_black.css")
            theme.inverted=true
        }
        else {
            setCss.setCss("/opt/ithome/qml/meego/theme_white.css")
            theme.inverted=false
        }
    }
    Binding {
        target: theme;
        property: "inverted"
        value: night_mode
    }
    initialPage:MainPage{
        id:page
        //height: screen.displayHeight-mainBar.height
    }
    BusyIndicator{
        id: indicator
        running: visible
        platformStyle: BusyIndicatorStyle {
                 period: 800
                 size: "large"
             }
        //onRunningChanged: console.log("mian size:"+main.width+" "+main.height)
        width: 100
        height: 100
        x:190
        y:347
        Component.onCompleted:
            console.log("indicator size:"+indicator.width+" "+indicator.height)
    }
    Image{
        source: "qrc:/Image/01.png"
        anchors.left: parent.left
        anchors.top: parent.top
        z:3
    }
    Image{
        source: "qrc:/Image/02.png"
        anchors.right: parent.right
        anchors.top: parent.top
        z:3
    }
    Image{
        source: "qrc:/Image/03.png"
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        z:3
    }
    Image{
        source: "qrc:/Image/04.png"
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        z:3
    }
}
