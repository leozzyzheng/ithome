// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.1
MyPage{
    //onXChanged: console.log("XChanged")
    property string mysid: ""
    function close()
    {
        if(contentField.focus)
        {
            contentField.focus=false
            contentField.platformCloseSoftwareInputPanel()
        }else if(name.focus)
        {
            name.focus=false
            name.platformCloseSoftwareInputPanel()
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
            loading=true
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
    TextArea{
        id:contentField
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
        placeholderText: "匿名（您的昵称）"
        anchors.bottom: button1.top
        anchors.bottomMargin: 20
        anchors.right: contentField.right
        anchors.left: contentField.left
        KeyNavigation.up: contentField
        KeyNavigation.down: contentField
    }
    ToolButton{
        id:button1
        text:"返回"
        anchors.left: name.left
        anchors.leftMargin: 20
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        onClicked: close()
    }
    ToolButton{
        text:"发送"
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        anchors.right: name.right
        anchors.rightMargin: 20
        onClicked: {
            post()
        }
    }
    onStatusChanged: {
        if (status === PageStatus.Active){
            contentField.forceActiveFocus()
            contentField.platformOpenSoftwareInputPanel()
        }
    }
}
