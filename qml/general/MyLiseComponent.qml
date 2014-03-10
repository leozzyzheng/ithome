// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import MyImages 1.0
Component{
    id:delegate
    Rectangle {
        height: isHighlight?40:100
        width: page.width
        color: isHighlight?"#ba1427":(night_mode?index%2?"#000000":"#191919":index%2?"#EBEBEB":"#F5F5F5")
        Connections{
            target: isHighlight?null:listview
            onFlickStarted:{
                showImage=0
                titleimage.opacity=0
            }
            onMovementEnded:{
                if(main.night_mode)
                    titleimage.opacity=brilliance_control
                else titleimage.opacity=1
            }
        }
        Connections{
            target: isHighlight?null:main
            onBrilliance_controlChanged:{
                if(main.night_mode)
                    titleimage.opacity=brilliance_control
            }
        }
        Text{
            x:main.sysIsSymbian?10:20
            anchors.verticalCenter: parent.verticalCenter
            visible: isHighlight?true:false
            text:m_text
            verticalAlignment: Text.AlignVCenter
            color: main.night_mode?"#f0f0f0":"#282828"
            font.pixelSize: main.sysIsSymbian?20:26
        }

        MyImage{
            id:titleimage
            sid:newsid
            visible: isHighlight?false:true
            opacity: showImage
            anchors.verticalCenter: parent.verticalCenter
            x:main.sysIsSymbian?10:20
            width: parent.height-10
            height:width
            clip:true
            source: (no_show_image|isWifi&wifiState==="No Network Available")&!isClick.imageIsShow("titleImage"+String(newsid))?"noImage":image
            Behavior on opacity{
                     NumberAnimation { duration: 500 }
            }
            MouseArea{
                anchors.fill: parent
                enabled: allowMouse
                onClicked: {
                    if(titleimage.source==="noImage"&(no_show_image|isWifi&wifiState==="No Network Available")){
                        titleimage.source=image
                        isClick.imageToShow("titleImage"+String(newsid))
                    }
                }
            }
            onSourceChanged: indicator.visible=false
        }
        Text {
            id:titletext
            visible: isHighlight?false:true
            anchors.top: titleimage.top
            anchors.left: titleimage.right
            anchors.leftMargin: 10
            anchors.right: parent.right
            anchors.rightMargin: main.sysIsSymbian?10:20
            opacity: night_mode?brilliance_control:1
            text: title
            font.family: fonts.name
            font.pixelSize: main.sysIsSymbian?20:26
            wrapMode: Text.WordWrap
            color: settings.getValue("titleTextClock"+String(newsid),false)?(night_mode?"#e81de8":"#551a8b"):(main.night_mode?"#f0f0f0":"#282828")
        }
        Text{
            id:data
            visible: isHighlight?false:true
            anchors.left: titletext.left
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 5
            font.pixelSize: main.sysIsSymbian?11:18
            text:postdate
            color: main.night_mode?"#f0f0f0":"#282828"
            opacity: night_mode?brilliance_control:1
        }
        Text{
            visible: isHighlight?false:true
            anchors.top: data.top
            anchors.right: comment_count.left
            anchors.left: data.right
            text:"人气："+hitcount
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: main.sysIsSymbian?11:18
            color: main.night_mode?"#f0f0f0":"#282828"
            opacity: night_mode?brilliance_control:1
        }
        Text{
            id:comment_count
            visible: isHighlight?false:true
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.top: data.top
            font.pixelSize: main.sysIsSymbian?11:18
            text:"评论："+commentcount
            color: main.night_mode?"#f0f0f0":"#282828"
            opacity: night_mode?brilliance_control:1
        }

        MouseArea{
            enabled: allowMouse&!isHighlight
            //anchors.left:titletext.left
            //anchors.right: parent.right
            //anchors.rightMargin: main.sysIsSymbian?10:20
            //height: 110
            anchors.fill: parent
            onClicked: {
                if(cacheContent.getContent_noImage(newsid)==="-1"){
                    cacheContent.saveTitle(newsid,title)
                    cacheContent.saveContent(newsid,detail)
                }

                main.current_page="content"
                content.visible=true
                content.mysid=newsid
                content.title=title
                content.myurl=m_url
                content.postdate=postdate
                content.newsauthor=newsauthor
                content.newssource=newssource
                if((no_show_image|isWifi&wifiState==="No Network Available")&!isClick.imageIsShow("contentImage"+String(newsid))){
                    content.autoLoadImage=false
                    content.allowDoubleClick=true
                    content.url=cacheContent.getContent_noImage(newsid)
                }
                else{
                    loading=true
                    cacheContent.getContent_image(newsid)
                }

                titletext.color=night_mode?"#e81de8":"#551a8b"
                settings.setValue("titleTextClock"+String(newsid),true)
                page.pushContent()
            }
        }
    }
}
