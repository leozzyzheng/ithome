// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.symbian 1.1
import QtMobility.systeminfo 1.2
import com.nokia.extras 1.1
import "../general"
PageStackWindow {
    id:main
    platformSoftwareInputPanelEnabled :true
    property bool night_mode: settings.getValue("night_mode",false)//夜间模式
    property bool no_show_image: settings.getValue("show_image_off_on",false)//无图模式
    property bool isWifi: settings.getValue("wifi_load_image",true)//wifi下显示图片
    property bool full: settings.getValue("full_screen",false)//浏览文章全屏
    property int content_font_size: settings.getValue("fontSize",20)//正文字体大小
    property real brilliance_control: settings.getValue("intensity_control",0.60)//夜间模式亮度
    property string current_page: "page"//当前显示的界面
    property bool online: true//网络连接状态
    property bool sysIsSymbian: true
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
    onWifiStateChanged: console.log("wifi state:"+wifiState)

    function showBanner(string)
    {
        banner.text=string
        banner.open()
    }

    InfoBanner {
         id: banner
         timeout: 2000
         platformInverted: main.platformInverted
    }
    NetworkInfo {
             id: wlaninfo
             mode:NetworkInfo.WlanMode
             monitorNameChanges: true
             monitorModeChanges: true
             monitorStatusChanges: true
             monitorSignalStrengthChanges: true//wifi信号强度
             monitorCurrentMobileNetworkCodeChanges: true
             onModeChanged: {
                 console.log("mode:"+mode)
                 console.log(wlaninfo.networkStatus+" "+wlaninfo.NoNetworkAvailable)
             }

             onSignalStrengthChanged: console.log("SignalStrength:"+wlaninfo.networkSignalStrength)
             onNetworkNameChanged: console.log("network name:"+wlaninfo.networkName)
             onCurrentMobileNetworkCodeChanged: console.log("CurrentMobileNetworkCode"+wlaninfo.currentMobileNetworkCode)
         }
    platformInverted: !night_mode
    onNight_modeChanged: {
        console.log(night_mode)
        if(night_mode) setCss.setCss("./qml/symbian/theme_black"+String(width)+".css")
        else setCss.setCss("./qml/symbian/theme_white"+String(width)+".css")
    }
    initialPage:MainPage{
        id:page

    }
    BusyIndicator{
        id: indicator
        running: visible
        //onRunningChanged: console.log("mian size:"+main.width+" "+main.height)
        platformInverted:main.platformInverted
        width: 50
        height: 50
        anchors.centerIn: parent
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
