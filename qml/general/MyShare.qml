// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item{
    signal close;
    signal copyContent
    signal openUrl
    width:sysIsSymbian?parent.width:480
    height: sysIsSymbian?main.height:854
    opacity: 0
    function open()
    {
        opacity=1
        main.showToolBar=false
    }

    function shareUrl(to,key)
    {
        if(!online){
            showBanner("还没联网哦")
            return
        }
        hide_me.start()
        var string1="http://s.share.baidu.com/?click=1&url=http://www.ithome.com"+myurl
        var string2="&uid=0&to="+to+"&type=text&pic=&title="+title
        var string3="&key="+key+"&desc=&comment=&relateUid=&searchPic=0&sign=on&l=18hrfu3j718hrfu4if18hrfub95&linkid=hs7148kvhp0&firstime=1393550178804"
        Qt.openUrlExternally(string1+string2+string3)
    }
    NumberAnimation on opacity{
        id:hide_me
        duration: 100
        from:1
        to:0
        onCompleted: close()
    }

    Rectangle{
        anchors.fill: parent
        color: "black"
        opacity: 0.8
    }
    Behavior on opacity{
        NumberAnimation{duration: 100}
    }
    MouseArea{
        anchors.fill: parent
        onClicked: hide_me.start()
    }
    Grid{
        columns: 3
        rows:2
        spacing: sysIsSymbian?20:30
        anchors.centerIn: parent
        Image{
            id:sina_weibo
            width: sysIsSymbian?75:96
            height: sysIsSymbian?75:96
            source: "qrc:/Image/shadow.png"
            smooth: true
            Image{
                width: sysIsSymbian?75:96
                height: sysIsSymbian?75:96
                source: "qrc:/Image/Sina_Weibo.svg"
                smooth: true
                anchors.left: parent.left
                y:-5
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        shareUrl("tsina","1369706960")
                    }
                }
            }
            Item{
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.bottom
                width: parent.width*2/3
                height: 20
                Rectangle{
                    anchors.fill: parent
                    color: "black"
                    opacity: 0.7
                    radius: 8
                }
                Text{
                    anchors.centerIn: parent
                    text:"新浪微博"
                    font.pixelSize: sysIsSymbian?10:12
                    color: "white"
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }
        Image{
            id:tencent_weibo
            width: sysIsSymbian?75:96
            height: sysIsSymbian?75:96
            source: "qrc:/Image/shadow.png"
            smooth: true
            Image{
                width: sysIsSymbian?75:96
                height: sysIsSymbian?75:96
                source: "qrc:/Image/tencent_Weibo.svg"
                smooth: true
                anchors.left: parent.left
                y:-5
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        shareUrl("tqq","801077952")
                    }
                }
            }
            Item{
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.bottom
                width: parent.width*2/3
                height: 20
                Rectangle{
                    anchors.fill: parent
                    color: "black"
                    opacity: 0.7
                    radius: 8
                }
                Text{
                    anchors.centerIn: parent
                    text:"腾讯微博"
                    font.pixelSize: sysIsSymbian?10:12
                    color: "white"
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }
        Image{
            id:qzone
            width: sysIsSymbian?75:96
            height: sysIsSymbian?75:96
            source: "qrc:/Image/shadow.png"
            smooth: true

            Image{
                width: sysIsSymbian?75:96
                height: sysIsSymbian?75:96
                source: "qrc:/Image/Qzone.svg"
                smooth: true
                anchors.left: parent.left
                y:-5
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        shareUrl("qzone","")
                    }
                }
            }
            Item{
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.bottom
                width: parent.width*2/3
                height: 20
                Rectangle{
                    anchors.fill: parent
                    color: "black"
                    opacity: 0.7
                    radius: 8
                }
                Text{
                    anchors.centerIn: parent
                    text:"QQ空间"
                    font.pixelSize: sysIsSymbian?10:12
                    color: "white"
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }
        Image{
            id:wechat
            width: sysIsSymbian?75:96
            height: sysIsSymbian?75:96
            source: "qrc:/Image/shadow.png"
            smooth: true

            Image{
                width: sysIsSymbian?75:96
                height: sysIsSymbian?75:96
                source: "qrc:/Image/tieba.svg"
                smooth: true
                anchors.left: parent.left
                y:-5
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        if(!online){
                            showBanner("还没联网哦")
                            return
                        }
                        hide_me.start()
                        var string1="http://tieba.baidu.com/f/commit/share/openShareApi?url=http://www.ithome.com"+myurl
                        var string2="&title="+title+"&desc=&comment="+cacheContent.getContent_text(mysid)
                        Qt.openUrlExternally(string1+string2)
                    }
                }
            }
            Item{
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.bottom
                width: parent.width*2/3
                height: 20
                Rectangle{
                    anchors.fill: parent
                    color: "black"
                    opacity: 0.7
                    radius: 8
                }
                Text{
                    anchors.centerIn: parent
                    text:"百度贴吧"
                    font.pixelSize: sysIsSymbian?10:12
                    color: "white"
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }
        Image{
            id:browser
            width: sysIsSymbian?75:96
            height: sysIsSymbian?75:96
            source: "qrc:/Image/shadow.png"
            smooth: true

            y:parent.height/2+15
            Image{
                width: sysIsSymbian?75:96
                height: sysIsSymbian?75:96
                source: "qrc:/Image/Browser.svg"
                smooth: true
                anchors.left: parent.left
                y:-5
                MouseArea
                {
                    anchors.fill: parent
                    onClicked: {
                        hide_me.start()
                        openUrl()
                    }
                }
            }
            Item{
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.bottom
                width: parent.width*2/3
                height: 20
                Rectangle{
                    anchors.fill: parent
                    color: "black"
                    opacity: 0.7
                    radius: 8
                }
                Text{
                    anchors.centerIn: parent
                    text:"浏览器"
                    font.pixelSize: sysIsSymbian?10:12
                    color: "white"
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }
        Image{
            id:copy
            width: sysIsSymbian?75:96
            height: sysIsSymbian?75:96
            source: "qrc:/Image/shadow.png"
            smooth: true

            Image{
                width: sysIsSymbian?75:96
                height: sysIsSymbian?75:96
                source: "qrc:/Image/Copy.svg"
                smooth: true
                anchors.left: parent.left
                y:-5
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        hide_me.start()
                        copyContent()
                    }
                }
            }
            Item{
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.bottom
                width: parent.width*2/3
                height: 20
                Rectangle{
                    anchors.fill: parent
                    color: "black"
                    opacity: 0.7
                    radius: 8
                }
                Text{
                    anchors.centerIn: parent
                    text:"复制全文"
                    font.pixelSize: sysIsSymbian?10:12
                    color: "white"
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }
    }

}
