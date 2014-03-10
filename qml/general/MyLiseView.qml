// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

ListView {
     id:listview
     interactive: allowMouse
     anchors.top: pageheader.bottom
     anchors.bottom: parent.bottom

     clip:true
     //highlight: Rectangle { color: "lightsteelblue"; radius: 5 }
     //keyNavigationWraps:true
     focus:true
     model: listmodel
     //highlightFollowsCurrentItem: true
     delegate: MyLiseComponent{id:delegate}
     maximumFlickVelocity: 1500
     width: parent.width
     property bool loadSwitch: true
     property bool biaoji: false

     function addmodel(){
         if(online&!loading)
         {
             console.log("zone type="+zone)
             if(zone==="rank"){
                 return
             }else{
                 //console.log("add modeling")
                 for(var i=0;i<addxmlmodel.count;++i){
                     //console.log("add2 sid:"+addxmlmodel.get(i).newsid)
                     cacheContent.saveTitle(addxmlmodel.get(i).newsid,addxmlmodel.get(i).title)
                     cacheContent.saveContent(addxmlmodel.get(i).newsid,addxmlmodel.get(i).detail)
                     listmodel.append({
                                  "title":addxmlmodel.get(i).title,
                                  "m_url":addxmlmodel.get(i).m_url,
                                  "image":addxmlmodel.get(i).image,
                                  "description":addxmlmodel.get(i).description,
                                  "detail":addxmlmodel.get(i).detail,
                                  "newsid":addxmlmodel.get(i).newsid,
                                  "hitcount":addxmlmodel.get(i).hitcount,
                                  "commentcount":addxmlmodel.get(i).commentcount,
                                  "postdate":addxmlmodel.get(i).postdate,
                                  "newssource":addxmlmodel.get(i).newssource,
                                  "newsauthor":addxmlmodel.get(i).newsauthor,
                                  "isHighlight":false,
                                  "m_text":""
                                 })
                 }
                 if(Number(addxmlmodel.get(addxmlmodel.count-1).newsid)<minnewsidData)
                 {
                     minnewsidData=Number(addxmlmodel.get(addxmlmodel.count-1).newsid)
                     console.log("min2 sid="+minnewsidData)
                 }
                 if(!loading)
                 {
                     addxmlmodel.source="http://www.ithome.com/rss/"+zone+"lessthan_"+String(minnewsidData)+".xml"
                     addxmlmodel.query="/rss/channel/item"
                 }
             }

         }else{
             showBanner("亲，还没联网呢")
         }
     }
     Item{
         id:pull_down
         implicitHeight: loadImage.height
         implicitWidth: loadData.width+loadData.width-10
         anchors.horizontalCenter: parent.horizontalCenter
         y:-contentY-20-pull_down.height
         Image{
             id:loadImage
             opacity: night_mode?brilliance_control:1
             source:main.night_mode? "qrc:/Image/pull_down.svg":"qrc:/Image/pull_down_inverse.svg"
             anchors.verticalCenter: parent.verticalCenter
             Behavior on rotation{
                 NumberAnimation{duration: 100}
             }
         }
         Text {
             id: loadData
             text: "下拉刷新"
             color: main.night_mode?"#f0f0f0":"#282828"
             font.pixelSize: main.sysIsSymbian?20:22
             anchors.left: loadImage.right
             anchors.leftMargin: 10
             anchors.verticalCenter: parent.verticalCenter
             opacity: 0.5//night_mode?brilliance_control:
         }
         NumberAnimation on y{
             id:pull_down_to_homeing
             duration: 000
             to:-50
             running: false
         }
     }
     onContentYChanged: {
         if(contentY<-10)
         {
             //pull_down.y=-contentY-20-pull_down.height
             if(listview.contentY<-80)
             {
                 if(loadImage.rotation===0){
                     loadImage.rotation=180
                     loadData.text="松手刷新"
                     //listview.biaoji=true
                 }
             }else if(loadImage.rotation===180){
                 loadImage.rotation=0
                 loadData.text="下拉刷新"
                 console.log("bo about to refresh,loading is:"+loading)
                 if(!loading)
                 {
                     console.log("bo about to refresh")
                     reModel()
                     //pull_down_to_homeing.start()
                 }

                 //listview.biaoji=false
             }
         }
     }
     onMovementStarted:{
         if(loadSwitch){
             //connect.target=listview
         }
     }
     onMovementEnded: {
         //console.log("list move end:"+loading)
         if((listview.contentY>=listview.contentHeight-parent.height)&!loading){
             console.log("addmodel")
             addmodel()
         }

     }
     onAtYBeginningChanged: loadSwitch=!loadSwitch
    //onCountChanged:  console.log("add list ok,list count is:"+listview.count)
    //onStateChanged: console.log("list state changed state is:"+listview.state)
 }
