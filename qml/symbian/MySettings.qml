// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.symbian 1.1
import "../general"
MyPage{
    id:setting
    tools: CustomToolBarLayout{
        id:settingTool
        backImage.source: night_mode?"qrc:/Image/toolbar.svg":""
        ToolButton{
            iconSource: night_mode?"qrc:/Image/back2.svg":"qrc:/Image/back.svg"
            //opacity: night_mode?brilliance_control:1
            onClicked: {
                current_page="about"
                if(signature_input.text!="")
                {
                    settings.setValue("signature",signature_input.text)
                    signature_input.placeholderText=signature_input.text
                    signature_input.text=""
                }
                pageStack.pop()
            }
        }
    }

    Image{
        id:header
        opacity: night_mode?brilliance_control:1
        source: "qrc:/Image/PageHeader.svg"
        Text{
            text:"设置"
            font.pixelSize: 22
            color: "white"
            x:10
            anchors.verticalCenter: parent.verticalCenter
        }
    }
    Flickable{
        id:settingFlick
        anchors.top: header.bottom
        height: parent.height-header.height
        width: parent.width
        clip: true
        focus:true
        contentHeight: logo.height+text1.height+700
        MouseArea{
            anchors.fill:parent
            onClicked: {
                if(signature_input.activeFocus){
                    //console.log("click signature_input fouse:"+signature_input.focus)
                    signature_input.focus=false
                    signature_input.closeSoftwareInputPanel()
                    phone_list.visible=false
                    phone_list.open()
                    phone_list.close()
                    phone_list.visible=true
                }
            }
        }

        Image{
            id:logo
            opacity: night_mode?brilliance_control:1
            //height: main.sysIsSymbian?150:200
            source: "qrc:/Image/ithome_logo.png"
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Text{
            id:text1
            text:"版本：1.0.0"
            opacity: night_mode?brilliance_control:1
            color: main.night_mode?"#f0f0f0":"#282828"
            font.pixelSize: main.sysIsSymbian?20:22
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.right: parent.right
            anchors.rightMargin: main.sysIsSymbian?10:20
            anchors.top: logo.bottom
            anchors.topMargin: 10
        }

        CuttingLine{
            id:divide1
            anchors.top: text1.bottom
        }
        MySwitch{
            id:night_mode_off_on
            anchors.top: divide1.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 10
            switch_text: "夜间模式"
            checked: settings.getValue("night_mode",false)
            onIsPressed: {
                //console.log("night_mode:"+checked)
                night_mode=checked
                settings.setValue("night_mode",checked)
            }
        }
        MySwitch{
            id:show_image_off_on
            checked: settings.getValue("show_image_off_on",false)
            anchors.top: night_mode_off_on.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 10
            switch_text: "无图模式"
            onIsPressed: {
                no_show_image=checked
                settings.setValue("show_image_off_on",checked)
            }
        }
        MySwitch{
            id:wifi_load_image
            checked: settings.getValue("wifi_load_image",true)
            anchors.top: show_image_off_on.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 10
            switch_text: "仅WiFi下加载图片"
            onIsPressed: {
                isWifi=checked
                settings.setValue("wifi_load_image",checked)
            }
        }
        MySwitch{
            id:full_screen
            checked: settings.getValue("full_screen",false)
            anchors.top: wifi_load_image.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 10
            switch_text: "新闻/评论滑动全屏"
            onIsPressed: {
                full=checked
                settings.setValue("full_screen",checked)
            }
    }

        CuttingLine{
            id:cut_off
            anchors.top: full_screen.bottom
        }
        MySlider {
            id:fontSize
            anchors.top: cut_off.bottom
            anchors.topMargin: 10
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 10
            slider_text:"文字大小"
            maximumValue: 26
            minimumValue: 16
            value: settings.getValue("fontSize",20)
            stepSize: 1
            onValueChanged: {
                content_font_size=parseInt(value)
                settings.setValue("fontSize",value)
            }
         }
        MySlider {
            id:intensity_control
            anchors.top: fontSize.bottom
            anchors.topMargin: 20
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 10
            slider_text:"夜间亮度"
            maximumValue: 1
            minimumValue: 0.3
            value: settings.getValue("intensity_control",0.60)
            stepSize:0.01
            onValueChanged: {
                brilliance_control=parseFloat(value)
                settings.setValue("intensity_control",value)
                //console.log(settings.getValue("intensity_control",0.60))
            }
        }

        CuttingLine{
            id:cut_off2
            anchors.top: intensity_control.bottom
        }
        Text{
            id:my_phone
            text:"我的设备"
            font.pixelSize: 22
            anchors.left: parent.left
            anchors.leftMargin:10
            anchors.top: cut_off2.bottom
            anchors.topMargin:20
            opacity: night_mode?brilliance_control:1
            color: main.night_mode?"#f0f0f0":"#282828"
        }
        Text{
            id:current_phone
            text:settings.getValue("myphone","Lumia 920")
            anchors.right: parent.right
            font.pixelSize: 22
            anchors.rightMargin: 10
            anchors.top: my_phone.top
            opacity: night_mode?brilliance_control:1
            color: main.night_mode?"#f0f0f0":"#282828"
            MouseArea{
                anchors.fill: parent
                onClicked: phone_list.open()
            }

            SelectionDialog {
                id: phone_list
                platformInverted: main.platformInverted
                titleText: "选择要显示的设备称号"
                model: ListModel {
                    ListElement { name: "Lumia 920" }
                    ListElement { name: "Lumia 1020" }
                    ListElement { name: "Lumia 1520" }
                    ListElement { name: "WP客户端" }
                    ListElement { name: "IOS客户端" }
                    ListElement { name: "Android客户端" }
                }
                function setPhone(phoneModel,osMode,phoneName)
                {
                    current_phone.text=phoneModel
                    settings.setValue("myphone",phoneModel)
                    settings.setValue("client",osMode)
                    settings.setValue("device",phoneName)
                }

                onAccepted: {
                    switch(selectedIndex){
                    case 0:
                        setPhone("Lumia 920","1","RM-821")
                        break
                    case 1:
                        setPhone("Lumia 1020","1","RM-875")
                        break;
                    case 2:
                        setPhone("Lumia 1520","1","RM-937")
                        break
                    case 3:
                        setPhone("WP客户端","1","")
                        break
                    case 4:
                        setPhone("IOS客户端","3","")
                        break
                    case 5:
                        setPhone("Android客户端","android","RM-696")
                        break
                    default:break
                    }
                }
            }
        }

        Text{
            id:my_signature
            text:"我的签名"
            anchors.left: parent.left
            anchors.leftMargin:10
            font.pixelSize: 22
            opacity: night_mode?brilliance_control:1
            color: main.night_mode?"#f0f0f0":"#282828"
            //anchors.horizontalCenter: signature_input.horizontalCenter
            anchors.verticalCenter: signature_input.verticalCenter
        }
        TextField{
            id:signature_input
            platformInverted: main.platformInverted
            placeholderText: settings.getValue("signature","点击输入签名")
            anchors.left: my_signature.right
            anchors.leftMargin: 10
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.top: my_phone.bottom
            anchors.topMargin:20
            onActiveFocusChanged: {
                if(activeFocus)
                    settingFlick.contentY=600
                //console.log("signature_input status:"+signature_input.activeFocus+" "+settingFlick.contentY)
            }
            //anchors.horizontalCenter: my_signature.horizontalCenter
        }
        Behavior on contentY{
            NumberAnimation{duration: 200}
        }

        //onContentYChanged: console.log("setting page flick ContentY:"+settingFlick.contentY)
        CuttingLine{
            id:cut_off3
            anchors.top: signature_input.bottom
        }
        Text{
            id:remove_cache
            opacity: night_mode?brilliance_control:1
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.top: cut_off3.bottom
            anchors.topMargin: 20
            text:"清理缓存"
            font.pixelSize: 22
            color: main.night_mode?"#f0f0f0":"#282828"
            MouseArea{
                anchors.fill: parent

                onClicked: {
                    showBanner("请稍后，正在清理")
                    cacheContent.clearCache()
                    cache.text="0M"
                    settings.setValue("cache_size",0)
                    showBanner("呼~~~~~终于清理完了")
                }
            }
        }
        Text{
            id:cache
            opacity: night_mode?brilliance_control:1
            anchors.top: remove_cache.top
            anchors.right: parent.right
            anchors.rightMargin: 10
            text:Math.round(100*settings.getValue("cache_size",0)/(1024*1024))/100+"M"
            font.pixelSize: 22
            color: main.night_mode?"#f0f0f0":"#282828"
        }

        Text{
            opacity: night_mode?brilliance_control:1
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.top: remove_cache.bottom
            anchors.topMargin: 30
            text:"关于"
            font.pixelSize: 22
            color: main.night_mode?"#f0f0f0":"#282828"
            MouseArea{
                anchors.fill: parent

                onClicked: {
                    current_page="about"
                    pageStack.push(Qt.resolvedUrl("About.qml"))
                }
            }
        }
    }
    Component.onCompleted: {
        cache.text=Math.round(100*settings.getValue("cache_size",0)/(1024*1024))/100+"M"
    }
}
