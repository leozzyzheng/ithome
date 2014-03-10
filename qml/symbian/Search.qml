// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.symbian 1.1
MyPage{
    id:root
    function close()
    {
        if(online){
            if(so.searchText!=""){
                Qt.openUrlExternally("https://www.google.com.hk/search?q=www.ithome.com"+so.searchText)
                so.searchTextInputFocus=false
                so.closeSoftwareInputPanel()
                so.searchText=""
            }
        }else{
            showBanner("亲，还没联网呢")
        }
    }
    tools: CustomToolBarLayout{
        id:searchTool
        backImage.source: night_mode?"qrc:/Image/toolbar.svg":""
        //opacity: night_mode?brilliance_control:1
        ToolButton{
            iconSource: night_mode?"qrc:/Image/back2.svg":"qrc:/Image/back.svg"
            onClicked: {
                current_page="page"
                so.searchText=""
                so.searchTextInputFocus=false
                so.closeSoftwareInputPanel()
                pageStack.pop()
            }
        }
        ToolButton{
            iconSource: night_mode?"qrc:/Image/search2.svg":"qrc:/Image/search.svg"
            //opacity: night_mode?brilliance_control:1
            onClicked: close()
        }
    }
    MySearchBox{
        id:so
        placeHolderText: "请输入内容搜索"
        platformInverted: main.platformInverted
    }
    Keys.onEnterPressed: {
        console.log("search text is:"+so.searchText)
        close()
    }
    Keys.onPressed: {
        if(event.key===16777220)
        {
            console.log("activeFocus:"+so.activeFocus)
            if(so.activeFocus){
                close()
            }else so.forceActiveFocus()
        }

        //console.log(event.key)
    }
}
//
