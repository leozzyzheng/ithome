// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.symbian 1.1
import QtWebKit 1.0
MyPage {
    id:commentpage
    property string mysid: ""
    tools: CustomToolBarLayout{
        id:commentTool
        backImage.source: night_mode?"qrc:/Image/toolbar.svg":""
        ToolButton{
            iconSource: night_mode?"qrc:/Image/back2.svg":"qrc:/Image/back.svg"
            //opacity: night_mode?brilliance_control:1
            onClicked: {
                current_page="content"
                web.visible=false
                if(night_mode) setCss.setCss("./qml/symbian/theme_black"+String(commentpage.width)+".css")
                else setCss.setCss("./qml/symbian/theme_white"+String(commentpage.width)+".css")
                if(loading)
                    loading=false
                pageStack.pop()
            }
        }
        ToolButton{
            iconSource: night_mode?"qrc:/Image/pull_down.svg":"qrc:/Image/pull_down_inverse.svg"
            rotation: 180
            //opacity: night_mode?brilliance_control:1
            onClicked: {
                flick1.contentY=0
            }
        }
        ToolButton{
            iconSource: night_mode?"qrc:/Image/pull_down.svg":"qrc:/Image/pull_down_inverse.svg"
            //opacity: night_mode?brilliance_control:1
            onClicked: {
                flick1.contentY=web.height-commentpage.height
            }
        }
        ToolButton{
            iconSource: night_mode?"qrc:/Image/edit2.svg":"qrc:/Image/edit.svg"
            //opacity: night_mode?brilliance_control:1
            onClicked: {
                page.pageStack.push(Qt.resolvedUrl("MyComment.qml"), {mysid: String(mysid)})
            }
        }
    }
    Flickable{
        id:flick1
        anchors.fill: parent
        maximumFlickVelocity: 2000
        pressDelay:50
        flickableDirection:Flickable.VerticalFlick
        clip: true
        contentHeight: web.height-200
        contentWidth: web.width
        NumberAnimation on contentY{ id:flickYto0; from:10;to:0;duration: 100;running: false}
        Behavior on contentY{
            NumberAnimation{
                duration: 300
                easing.type: Easing.OutQuart
            }
        }
        WebView{
            id:web
            y:-300
            visible: false
            smooth: true
            opacity: night_mode?brilliance_control:1
            settings.minimumFontSize: content_font_size
            onLoadStarted: loading=true
            onLoadFinished: {
                if(night_mode) setCss.setCss("./qml/symbian/comment_black"+String(commentpage.width)+".css")
                else setCss.setCss("./qml/symbian/comment_white"+String(commentpage.width)+".css")
                web.visible=true
                flickYto0.start()
                loading=false
            }
        }
        Rectangle{
            width: parent.width
            y:-300
            height: 300
            color: night_mode?"#000000":"#f1f1f1"
        }
    }
    onStatusChanged: {
        if(status===PageStatus.Active)
            web.url="http://www.ithome.com/rss/onlycomment_"+mysid+".html"
    }
}
