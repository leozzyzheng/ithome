// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.1
import QtWebKit 1.0
MyPage {
    id:commentpage
    property string mysid: ""
    tools:ToolBarLayout{
        id:commentTool
        opacity: night_mode?brilliance_control:1
        visible: false
        //backImage.source: night_mode?"qrc:/Image/toolbar.svg":""
        ToolIcon{
            iconId: "toolbar-back"
            onClicked: {
                current_page="content"
                web.visible=false
                if(night_mode){
                    setCss.setCss("/opt/ithome/qml/meego/theme_black.css")
                }
                else {
                    setCss.setCss("/opt/ithome/qml/meego/theme_white.css")
                }
                if(loading)
                    loading=false
                pageStack.pop()
            }
        }
        ToolIcon{
            iconSource: night_mode?"qrc:/Image/pull_down.svg":"qrc:/Image/pull_down_inverse.svg"
            rotation: 180
            //opacity: night_mode?brilliance_control:1
            onClicked: {
                flick1.contentY=0
            }
        }
        ToolIcon{
            iconSource: night_mode?"qrc:/Image/pull_down.svg":"qrc:/Image/pull_down_inverse.svg"
            //opacity: night_mode?brilliance_control:1
            onClicked: {
                flick1.contentY=web.height-commentpage.height
            }
        }
        ToolIcon{
            iconId: "toolbar-edit"
            onClicked: page.pageStack.push(Qt.resolvedUrl("MyComment.qml"), {mysid: String(mysid)})
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
            smooth: true
            visible: false
            opacity: night_mode?brilliance_control:1
            settings.minimumFontSize: content_font_size
            onLoadStarted: loading=true
            onLoadFinished: {
                if(night_mode){
                    shade1.visible=true
                    setCss.setCss("/opt/ithome/qml/meego/comment_black.css")
                }

                else {
                    shade2.visible=true
                    setCss.setCss("/opt/ithome/qml/meego/comment_white.css")
                }
                web.visible=true
                flickYto0.start()
                loading=false
            }
        }
        Rectangle{
            id:shade1
            width: parent.width
            y:-300
            height: 300
            color: "#000000"
            visible: false
        }
        Image{
            id:shade2
            width: parent.width
            y:-300
            height: 300
            source: "meegoBackground.png"
            visible: false
        }
    }
    onStatusChanged: {
        if(status===PageStatus.Active)
            web.url="http://www.ithome.com/rss/onlycomment_"+mysid+".html"
    }
}
