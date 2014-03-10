// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.1
import "../general"
MyPage{
    id:page
    property bool isQuit: false

    property bool allowMouse: true

    function pushContent()
    {
        pageStack.push(content)
    }
    function open_selection_list()
    {
        main_selection_list.open()
    }
    Timer{
        id:judgeQuit
        interval: 2000
        onTriggered: isQuit=false
    }

    tools: ToolBarLayout{
        opacity: night_mode?brilliance_control:1
        ToolIcon{
            iconId: "toolbar-back"
            onClicked: {
                if(isQuit){
                    Qt.quit()
                }
                else{
                    main.showBanner("再按一次退出")
                    isQuit=true
                    judgeQuit.start()
                }
            }
        }
        ToolIcon{
            iconId: "toolbar-refresh"
            onClicked: {
                list.reModel()
            }
        }
        ToolIcon{
            iconId: "toolbar-search"
            onClicked: {
                current_page="search"
                loading=false
                pageStack.push(Qt.resolvedUrl("Search.qml"))
            }
        }
        ToolIcon{
            iconId: "toolbar-settings"
            onClicked: {
                current_page="setting"
                loading=false
                pageStack.push(setting)
            }
        }
    }
    MainList{
        id:list
    }
    Content{
        id:content
        //anchors.left: listview.right
    }
    MySettings{
        id:setting
    }
    SelectionDialog {
        id: main_selection_list
        titleText: "选择要显示的新闻"
        model: ListModel {
            ListElement { name: "最新资讯" }
            ListElement { name: "排行榜" }
            ListElement { name: "WP专区" }
            ListElement { name: "WIN8专区" }
            ListElement { name: "IOS专区" }
            ListElement { name: "Android专区" }
        }
        //onPrivateClicked: console.log("PrivateClicked")
        onAccepted: {
            switch(selectedIndex){
            case 0:
                list.addNewsZone()
                break
            case 1:
                list.addRankZone()
                break
            case 2:
                list.addWPZone()
                break
            case 3:
                list.addWIN8Zone()
                break
            case 4:
                list.addIOSZone()
                break
            case 5:
                list.addAndroidZone()
                break
            default:break
            }
        }
    }
}
