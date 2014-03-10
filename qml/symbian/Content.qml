// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import QtWebKit 1.0
import com.nokia.symbian 1.1
import "../general"
MyPage{
    property string url: ""
    property string myurl: ""
    property bool autoLoadImage: true
    property bool allowDoubleClick: false
    property string title: ""
    property string postdate: ""
    property string newssource: ""
    property string newsauthor: ""
    property int mysid: 0
    tools: CustomToolBarLayout{
        id:contentTool
        backImage.source: night_mode?"qrc:/Image/toolbar.svg":""
        ToolButton{
            iconSource: night_mode?"qrc:/Image/back2.svg":"qrc:/Image/back.svg"
            //opacity: night_mode?brilliance_control:1
            onClicked: {
                if(loading){
                    cacheContent.canclePost()//如果正在加载就取消加载
                    loading=false
                }
                current_page="page"
                web.url=""
                web.visible=false
                pageStack.pop()
            }
        }
        ToolButton{
            iconSource: night_mode?"qrc:/Image/edit2.svg":"qrc:/Image/edit.svg"
            //opacity: night_mode?brilliance_control:1
            onClicked: {
                page.pageStack.push(Qt.resolvedUrl("MyComment.qml"), {mysid: String(mysid)})
            }
        }
        ToolButton{
            iconSource: night_mode?"qrc:/Image/comment2.svg":"qrc:/Image/comment.svg"
            //opacity: night_mode?brilliance_control:1
            onClicked: {
                current_page="comment"
                page.pageStack.push(Qt.resolvedUrl("CommentPage.qml"), {mysid: String(mysid)})
            }

        }
        ToolButton{
            iconSource: night_mode?"qrc:/Image/share2.svg":"qrc:/Image/share.svg"
            //opacity: night_mode?brilliance_control:1
            onClicked: {
                myshare.open()
            }
        }
    }
    Connections{
        target: cacheContent
        onContent_image:{
            url=string
            autoLoadImage=true
            allowDoubleClick=false
            //console.log(string+" "+url)
        }
    }
    QueryDialog {
        id:dialog
        acceptButtonText: "确认"
        rejectButtonText: "取消"
        onAccepted: {
            utility.launchPlayer(web.videoUrl)
            dialog.close()
        }
        onRejected: {
            dialog.close()
        }

    }
    function showDialog(name){
        dialog.titleText=name
        dialog.open()
    }
    Flickable{
        id:flick1
        anchors.fill: parent
        maximumFlickVelocity: 2000
        pressDelay:50
        interactive: allowMouse
        flickableDirection:Flickable.VerticalFlick
        contentHeight: web.height+title_main.height+30
        NumberAnimation on contentY{ id:flickYto0; from:10;to:0;duration: 100;running: false}
        NumberAnimation on contentY{
            id:contnetToHead
            to:0
            duration: 300
            running: false
            easing.type: Easing.OutQuart
        }
        Rectangle{
            id:title_main
            color:main.night_mode?"#191919":"#EBEBEB"
            width: parent.width
            height: title_string.height+info_string.height+30
            Text{
                id:title_string
                y:15
                opacity: night_mode?brilliance_control:1
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.right: parent.right
                anchors.rightMargin: 10
                text:title
                font.bold: true
                font.pixelSize:24
                wrapMode:Text.WordWrap
                color:main.night_mode?"#f0f0f0":"#282828"

            }
            Text{
                id:info_string
                anchors.top: title_string.bottom
                anchors.topMargin: 5
                anchors.left: parent.left
                anchors.leftMargin: 10
                text:postdate+"    "+newssource+"("+newsauthor+")"
                font.pixelSize:15
                color:main.night_mode?"#969696":"#646464"
            }
        }

        WebView{
            id:web
            visible:false
            anchors.top: title_main.bottom
            property string videoUrl
            opacity: night_mode?brilliance_control:1
            width: parent.width
            preferredHeight:1
            settings.autoLoadImages:autoLoadImage
            settings.javascriptEnabled :true
            javaScriptWindowObjects: QtObject {
                WebView.windowObjectName: "qml"
                function enlargeImage(src){
                    if(flick1.interactive)
                    {
                        main.showToolBar=false
                        allowDoubleClick=false
                        image.imageUrl=src
                        image.opacity=1
                    }
                }
                function openUrl(src){
                    console.log("open url:"+src)
                    Qt.openUrlExternally(src)
                }
                function openVideoUrl(src){
                    console.log("open video url:"+src)
                    if(src==="letv"){
                        showBanner("抱歉，此地址视频不可播放，等待官方技术支持")
                    }else{
                        web.videoUrl=src
                        showDialog("确认播放此视频？")
                    }
                }
            }
            settings.minimumFontSize: content_font_size

            onLoadFinished: {
                flickYto0.start()
                loading=false
                web.visible=true
                up.visible=true
                console.log("loadImage:"+loadImage.enabled)
                //console.log(web.preferredHeigh)
                //console.log("height:"+web.height+title_main.height+"  "+web.preferredHeight)
            }
            onUrlChanged: {
                console.log("web url changed"+web.url)
            }
        }
        Connections{
            target: full?flick1:null
            onMovementStarted: {
                  main.showToolBar=false
            }
            onMovementEnded: {
                main.showToolBar=true
            }
        }
        MouseArea{
            id:loadImage
            enabled: allowDoubleClick
            anchors.fill: parent
            onDoubleClicked: {
                loading=true
                allowDoubleClick=false
                isClick.imageToShow("contentImage"+String(mysid))
                console.log("double clicked ok,be about to reload web url")
                cacheContent.getContent_image(mysid)
            }
        }
    }
    Image{
        id:up
        visible: false
        source: "qrc:/Image/upmeego.svg"
        anchors.right: parent.right
        anchors.rightMargin: -10
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
        scale: 0.6
        smooth: true
        MouseArea{
            anchors.fill: parent
            onClicked: {
                contnetToHead.start()
            }
        }
    }
    ImageViewr{
        id:image
        onClose: {
            allowMouse=true
            main.showToolBar=true
        }
    }
    MyShare{
        id:myshare
        onClose:{
            allowMouse=true
            main.showToolBar=true
        }
        onCopyContent: {
            cacheContent.setClipboard(title+"\n"+cacheContent.getContent_text(mysid))
            showBanner("复制成功了")
        }
        onOpenUrl: {
            console.log("http://wap.ithome.com"+myurl)
            Qt.openUrlExternally("http://wap.ithome.com/html/"+mysid+".htm")
        }
    }
    onStatusChanged: {
        if(status===PageStatus.Active)
            web.url=url
    }
}
