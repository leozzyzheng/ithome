// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.symbian 1.1
MyPage{
    //onXChanged: console.log("XChanged")
    id:comment
    property string mysid: ""
    function close()
    {
        if(contentField.activeFocus)
        {
            contentField.focus=false
            contentField.closeSoftwareInputPanel()
        }else if(name.activeFocus)
        {
            name.focus=false
            name.closeSoftwareInputPanel()
        }
        contentField.text=""
        name.text=""
        if(loading)
            loading=false
        pageStack.pop()
    }


    function post()
    {
        if(contentField.text!=""){
            var url="http://www.ithome.com/ithome/postComment.aspx"
            var data="newsid="+mysid+"&commentNick="+(name.text===""?"匿名":name.text)+"&commentContent="+contentField.text+settings.getValue("signature","----我的小尾巴")
            var other="&parentCommentID=0&type=comment&client="+settings.getValue("client","1")+"&device="+settings.getValue("device","RM-821")
            utility.postHttp("POST",url,data+other)
        }
    }
    Connections{
        target: utility
        onPostOk:{
            loading=false
            showBanner(returnData)
            if(returnData==="评论成功")
                close()
        }
    }

    tools: CustomToolBarLayout{

        id:commentTool
        backImage.source: night_mode?"qrc:/Image/toolbar.svg":""
        //opacity: night_mode?brilliance_control:1
        ToolButton{
            platformInverted: main.platformInverted
            iconSource: night_mode?"qrc:/Image/back2.svg":"qrc:/Image/back.svg"
            onClicked: {
                close()
            }
        }
        ToolButton{
            platformInverted: main.platformInverted
            iconSource: night_mode?"message_send.svg":"message_send_inverted.svg"
            onClicked: {
                post()
            }
        }
    }
    TextArea{
        id:contentField
        platformInverted: main.platformInverted
        placeholderText: "请输入评论内容"
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.bottom:name.top
        anchors.top:parent.top
        anchors.margins: 20
        KeyNavigation.up: name
        KeyNavigation.down: name
    }
    TextField{
        id:name
        platformInverted: main.platformInverted
        placeholderText: "匿名（您的昵称）"
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        anchors.right: contentField.right
        anchors.left: contentField.left
        KeyNavigation.up: contentField
        KeyNavigation.down: contentField
    }
    onStatusChanged: {
        if (status === PageStatus.Active){
            contentField.forceActiveFocus()
            contentField.openSoftwareInputPanel()
        }
    }
}
