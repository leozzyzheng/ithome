// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import QtWebKit 1.0
AddXmlModel{
    id:xmlModel
    property string verifyKey
    query: "/rss/channel/item"
    function beginPost(url,key)
    {
        verifyKey=key
        source=url
        xmlModel.reload()
    }
    onStatusChanged: {
        //console.log("xmlModel status:"+status)
        if(status==XmlListModel.Ready&&count>0)
        {
            //console.log("xmlModel status:Ready")
            var temp=Number(xmlModel.get(0).newsid)
            //console.log("adding:"+(temp-maxnewsidData))
            //if(isOneStart){
                for(var i=0;i<xmlModel.count;++i){
                    //console.log("re sid:"+xmlModel.get(i).newsid)
                    cacheContent.saveTitle(xmlModel.get(i).newsid,xmlModel.get(i).title)
                    cacheContent.saveContent(xmlModel.get(i).newsid,xmlModel.get(i).detail)
                    if(verifyKey!=zone) return
                    listmodel.append({
                                 "title":xmlModel.get(i).title,
                                 "m_url":xmlModel.get(i).m_url,
                                 "image":xmlModel.get(i).image,
                                 "description":xmlModel.get(i).description,
                                 "detail":xmlModel.get(i).detail,
                                 "newsid":xmlModel.get(i).newsid,
                                 "hitcount":xmlModel.get(i).hitcount,
                                 "commentcount":xmlModel.get(i).commentcount,
                                 "postdate":xmlModel.get(i).postdate,
                                 "newssource":xmlModel.get(i).newssource,
                                 "newsauthor":xmlModel.get(i).newsauthor,
                                 "isHighlight":false,
                                 "m_text":""
                                })

                }
                //console.log("add ok")
                if(temp>maxnewsidData)
                    maxnewsidData=temp
                if(Number(xmlModel.get(count-1).newsid)<minnewsidData)
                {
                    minnewsidData=Number(xmlModel.get(count-1).newsid)
                    //console.log("min sid="+minnewsidData)
                }

                addxmlmodel.source="http://www.ithome.com/rss/"+zone+"lessthan_"+String(minnewsidData)+".xml"
                addxmlmodel.query="/rss/channel/item"
                //isOneStart=false
            /*}else{
                for(var j=0;j<temp-maxnewsidData;++j){
                    //console.log("add modeling")
                    //console.log("add sid:"+xmlModel.get(j).newsid)
                    cacheContent.saveTitle(xmlModel.get(j).newsid,xmlModel.get(j).title)
                    cacheContent.saveContent(xmlModel.get(j).newsid,xmlModel.get(j).detail)
                    listmodel.insert(j,{
                                         "title":xmlModel.get(j).title,
                                         "m_url":xmlModel.get(j).m_url,
                                         "image":xmlModel.get(j).image,
                                         "description":xmlModel.get(j).description,
                                         "detail":xmlModel.get(j).detail,
                                         "newsid":xmlModel.get(j).newsid,
                                         "hitcount":xmlModel.get(j).hitcount,
                                         "commentcount":xmlModel.get(j).commentcount,
                                         "postdate":xmlModel.get(j).postdate,
                                         "newssource":xmlModel.get(j).newssource,
                                         "newsauthor":xmlModel.get(j).newsauthor,
                                         "isHighlight":false,
                                         "m_text":""
                                        })
                }
                //console.log("add ok")
                if(temp>maxnewsidData)
                    maxnewsidData=temp
                if(Number(xmlModel.get(count-1).newsid)<minnewsidData)
                    minnewsidData=Number(xmlModel.get(count-1).newsid)
            }*/
            loading=false
        }
        else if(status==XmlListModel.Loading)
        {
            //console.log("xmlModel status:Loading,post url="+xmlModel.source)
            loading=true
        }
        else if(status==XmlListModel.Error)
        {
            //console.log("xmlModel status:Error:"+xmlModel.errorString())
            //showBanner("貌似有情况，看看后面是啥："+xmlModel.errorString())
        }
    }
}
