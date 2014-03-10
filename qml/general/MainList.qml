// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import "post_http.js" as PostHttp
Item {//
    id:mainlist
    anchors.fill: parent
    property int maxnewsidData: 0
    property int minnewsidData: 99999999
    property bool isOneStart: true
    property double showImage: night_mode?settings.getValue("intensity_control",0.60):1
    property string url:" "
    property string zone: "news"
    property string doubleDayRank:"/rss/channel48rank/item"
    property string weekRank:"/rss/channelweekhotrank/item"
    property string weekCommentRank:"/rss/channelweekcommentrank/item"
    property string monthRank:"/rss/channelmonthrank/item"
    property string ranktype: doubleDayRank
    focus:true

    function headerHide(){
        page.pushContent()
    }

    function postOk(maxsid)
    {
        //console.log("maxsid:"+maxsid+" "+maxnewsidData)
        if(maxsid>maxnewsidData)
        {
            if(maxsid-maxnewsidData>23)
            {
                isOneStart=true
                maxnewsidData=0
                minnewsidData=99999999
                listmodel.clear()
                xmlModel.beginPost("http://www.ithome.com/rss/news.xml",zone)//获取最新资讯
            }
            else{
                for(var i=maxnewsidData+1;i<=maxsid;++i){
                    cacheContent.inQueue(i)
                }
                addonemodel.addone(0,"news")
                //xmlModel.source="http://www.ithome.com/rss/"+zone+".xml"//如果有新的新闻就刷新
            }
        }else loading=false
    }
    function reModel(){
        console.log("is refresh zone is:"+zone)
        if(online){
            if(loading) return
            switch (zone)
            {
            case "news":
                loading=true
                PostHttp.postBegin(mainlist,"GET","http://www.ithome.com/rss/maxnewsid.xml","")
                break
            case "rank":
                zone=""
                addRankZone()
                break
            case "wp":
                zone=""
                addWPZone()
                break
            case "win8":
                zone=""
                addWIN8Zone()
                break
            case "ios":
                zone=""
                addIOSZone()
                break
            case "android":
                zone=""
                addAndroidZone()
                break
            default:break
            }

        }else{
            showBanner("亲，还没联网呢")
        }
    }
    function postNewModel(key)
    {
        listmodel.clear()
        isOneStart=true
        maxnewsidData=0
        minnewsidData=99999999
        console.log("cleraing... list count:"+listview.count)
        xmlModel.beginPost("http://www.ithome.com/rss/"+zone+".xml",key)
    }

    function addNewsZone(){
        if(zone!="news"){
            zone="news"
            stateText.text="最新资讯"
            postNewModel(zone)
        }
    }
    function addRankZone(){
        if(zone!="rank"){
            zone="rank"
            stateText.text="排行榜"
            isOneStart=true
            maxnewsidData=0
            minnewsidData=99999999
            listmodel.clear()
            //console.log("cleraing... list count:"+listview.count)
            ranktype=weekRank
            rankmodel.addRank("双日榜",doubleDayRank)
        }
    }
    function addWPZone(){
        if(zone!="wp"){
            zone="wp"
            stateText.text="WP专区"
            postNewModel(zone)
        }
    }
    function addWIN8Zone(){
        if(zone!="win8"){
            zone="win8"
            stateText.text="WIN8专区"
            postNewModel(zone)
        }
    }
    function addIOSZone(){
        if(zone!="ios"){
            zone="ios"
            stateText.text="IOS专区"
            postNewModel(zone)
        }
    }
    function addAndroidZone(){
        if(zone!="android"){
            zone="android"
            stateText.text="Android专区"
            postNewModel(zone)
        }
    }

    Component.onCompleted: {
        if(!online){
            loading=false
            showBanner("老大，木有联网，你可以联网后刷新")
        }else{
            xmlModel.beginPost("http://www.ithome.com/rss/news.xml",zone)//如果有网络就加载新闻
        }
    }
    Image{
        id:pageheader
        source: "qrc:/Image/PageHeader.svg"
        width: parent.width
        opacity: night_mode?brilliance_control:1
        Text{
            id:stateText
            text:"最新资讯"
            font.pixelSize: sysIsSymbian?22:30
            color: "white"
            x:10
            anchors.verticalCenter: parent.verticalCenter
        }
        Image{
            source: "qrc:/Image/ist_indicator.svg"
            x:parent.width-width-10
            anchors.verticalCenter: parent.verticalCenter
            z:1
        }
        MouseArea{
            anchors.fill: parent
            onClicked: {
                open_selection_list()
            }
        }
    }

    ListModel{
        id:listmodel
    }

    NewXmlModel{
        id:xmlModel
    }

    RankModel{
        id:rankmodel
    }
    AddOneModel{
        id:addonemodel
    }

    AddXmlModel{
        id:addxmlmodel
        signal postClose
        onStatusChanged: {
            if(status==XmlListModel.Ready&&count>0)
            {
                loading=false
                postClose()
            }
            else if(status==XmlListModel.Loading)
            {
                loading=true
                //console.log("addModel status:Loading,post url="+addxmlmodel.source)
            }

            else if(status==XmlListModel.Error)
            {
                console.log("xmlModel status:Error:"+addxmlmodel.errorString())
                //showBanner(xmlModel.errorString())
            }
        }
    }

    FontLoader{
        id:fonts
        source: "../../data/Hiragino.otf"
    }
    MyLiseView{
        id:listview
        NumberAnimation on contentY{
            id:animation3
            to:0
            duration: 300
            running: false
            easing.type: Easing.OutQuart
        }
        Component.onCompleted: up.visible=true
    }

    Image{
        id:up
        visible: false
        source: "qrc:/Image/upmeego.svg"
        anchors.right: parent.right
        anchors.rightMargin: -1*sysIsSymbian*10
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
        scale: sysIsSymbian?0.6:0.8
        smooth: true
        MouseArea{
            anchors.fill: parent
            onClicked: {
                animation3.start()
            }
        }
    }
}
