// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.symbian 1.1
import QtWebKit 1.0
MyPage{
    property color text_color: night_mode?"#f0f0f0":"#282828"
    property real text_opacity: night_mode?brilliance_control:1
    tools: ToolBarLayout{
        id:settingTool
        //opacity: night_mode?brilliance_control:1
        ToolButton{
            iconSource: night_mode?"qrc:/Image/back2.svg":"qrc:/Image/back.svg"
            onClicked: {
                current_page="setting"
                pageStack.pop()
            }
        }
    }
    Image{
        id:header
        opacity: text_opacity
        source: "qrc:/Image/PageHeader.svg"
        Text{
            text:"关于"
            font.pixelSize: 22
            color: "white"
            x:10
            anchors.verticalCenter: parent.verticalCenter
        }
    }
    Flickable{
        anchors.top: header.bottom
        clip: true
        width: parent.width
        height: parent.height-header.height
        maximumFlickVelocity: 3000
        pressDelay:200
        flickableDirection:Flickable.VerticalFlick
        contentHeight: myhtml.height+100
        opacity: text_opacity
        WebView{
            id:myhtml
            anchors.verticalCenter: parent.verticalCenter
            url:"about"+String(screen.width)+".html"
            javaScriptWindowObjects: QtObject {
                WebView.windowObjectName: "qml"
                function openUrl(src){
                    console.log("open url:"+src)
                    Qt.openUrlExternally(src)
                }
            }
        }
    }
}
