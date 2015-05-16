import bb.cascades 1.2

Page {
    // 用户发布的全部糗事
    property variant navigationPaneId
    property string userid
    property string username
    property string endpoint: "http://m2.qiushibaike.com/user/%uid%/articles?"
    property int fontsize: parseInt(_app.getv('size', '8'))
    attachedObjects: [
        Common {
            id: co
        }
    ]
    titleBar: TitleBar {
        title: username + qsTr("'s posts")
        appearance: TitleBarAppearance.Plain
        scrollBehavior: TitleBarScrollBehavior.NonSticky
    }
    function load() {
        if (userid.trim().length > 0) {
            pageview.baseurl = endpoint.replace("%uid%", userid)
        }
    }
    PageView {
        id: pageview
        type: co.pageview_userarticles
        navroot: navigationPaneId
        basefontsize: fontsize
    }
}
