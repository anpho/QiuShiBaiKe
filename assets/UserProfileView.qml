import bb.cascades 1.2
import org.labsquare 1.0
import bb.system 1.2
Page {
    property string uid: ""
    property bool infovisible: true
    property bool loaded: false
    property variant navroot
    onUidChanged: {
        if (uid.length > 0) {
            loaddata()
        }
    }
    titleBar: TitleBar {
        title: login
        appearance: TitleBarAppearance.Plain
        visibility: ChromeVisibility.Hidden
    }
    // 用户信息查看页
    attachedObjects: [
        Common {
            id: co
        },
        SystemToast {
            id: sst
        }
    ]
    function loaddata() {
        co.getUserDetails(function(b, d) {
                if (! b) {
                    if (d && d.trim().length > 0) {
                        sst.body = d;
                    } else {
                        sst.body = qsTr("Login Required.");
                    }
                    sst.show()
                    navroot.pop();
                } else {
                    age = d.userdata.age ? d.userdata.age : ""
                    astrology = d.userdata.astrology ? d.userdata.astrology : ""
                    bigcover = d.userdata.big_cover ? d.userdata.big_cover : ""
                    bigcovereday = d.userdata.big_cover_eday ? d.userdata.big_cover_eday : ""
                    createdat = d.userdata.created_at
                    gender = d.userdata.gender
                    haunt = d.userdata.haunt ? d.userdata.haunt : ""
                    hobby = d.userdata.hobby ? d.userdata.hobby : ""
                    hometown = d.userdata.hometown ? d.userdata.hometown : ""
                    icon = d.userdata.icon
                    iconeday = d.userdata.icon_eday
                    intro = d.userdata.introduce ? d.userdata.introduce : ""
                    job = d.userdata.job ? d.userdata.job : ""
                    login = d.userdata.login
                    mobilebrand = d.userdata.mobile_brand ? d.userdata.mobile_brand : ""
                    qbage = d.userdata.qb_age //days
                    qscnt = d.userdata.qs_cnt
                    relationship = d.userdata.relationship
                    signature = d.userdata.signature ? d.userdata.signature : ""
                    smilecount = d.userdata.smile_cnt
                    loaded = true
                }
            }, uid);
    }
    property string age //年龄
    property string astrology //星座
    property string bigcover //背景大图
    property string bigcovereday //未知
    property int createdat //账户创建时间
    property string gender //性别F/M
    property string haunt //出没于
    property string hobby //兴趣
    property string hometown //家乡
    property string icon //头像
    property string iconeday // unknown
    property string intro //简介
    property string job //工作
    property string login //登录名
    property string mobilebrand //手机型号
    property int qbage //加入糗百时间
    property int qscnt //糗事数量
    property string relationship //no_rel
    property string signature // 签名
    property int smilecount //笑脸数量
    onIconChanged: {
        userprofile_icon.url = getUserIcon()
    }
    onBigcoverChanged: {
        //        bigcoverimage.resetImage();
        //        if (bigcover && bigcover.length > 0) {
        //            bigcoverimage.url = bigcover;
        //        }
    }
    function getUserIcon() {
        //http://pic.qiushibaike.com/system/avtnew/553/5532615/medium/20150210165740.jpg
        if (uid.length < 1 || ! icon || icon.length < 1) return "asset:///res/default_user_avatar.png"

        var base = "http://pic.qiushibaike.com/system/avtnew/"
        base += uid.substring(0, uid.length - 4);
        base = base + "/" + uid + "/medium/" + icon;
        return base;
    }

    Container {

        layout: DockLayout {

        }
        background: Color.Black
        ImageView {
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center
            imageSource: "asset:///res/default_no_content_grey.png"
            scalingMethod: ScalingMethod.AspectFit
            opacity: 0.05
            preferredWidth: 150.0
            preferredHeight: 150.0
        }
        WebImageView {
            scalingMethod: infovisible ? ScalingMethod.AspectFill : ScalingMethod.AspectFit
            verticalAlignment: VerticalAlignment.Fill
            horizontalAlignment: HorizontalAlignment.Fill
            id: bigcoverimage
            loadEffect: ImageViewLoadEffect.FadeZoom
            onUrlChanged: {
                console.log("background : " + url)
            }
            url: bigcover
            visible: bigcover && bigcover.length > 0
            gestureHandlers: TapHandler {
                onTapped: {
                    infovisible = ! infovisible
                }
            }
        }
        Container {
            visible: infovisible
            background: Color.create("#88808080")
            verticalAlignment: VerticalAlignment.Top
            horizontalAlignment: HorizontalAlignment.Fill
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
            leftPadding: 50.0
            rightPadding: 20.0
            topPadding: 20.0
            bottomPadding: 20.0
            WebImageView {
                id: userprofile_icon
                preferredWidth: 120.0
                preferredHeight: 120.0
                rightMargin: 20.0
                verticalAlignment: VerticalAlignment.Center
            }

            Container {
                verticalAlignment: VerticalAlignment.Center

                layoutProperties: StackLayoutProperties {
                    spaceQuota: 11.0

                }
                Label {
                    textStyle.fontSize: FontSize.Large
                    textStyle.fontWeight: FontWeight.W100
                    text: login
                    textStyle.color: Color.White
                    visible: login.length > 0
                }
                Container {
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight

                    }

                    verticalAlignment: VerticalAlignment.Top
                    horizontalAlignment: HorizontalAlignment.Left
                    Label {
                        text: co.emoji["girl"]
                        textStyle.fontSize: FontSize.Small
                        visible: gender == 'F'
                        textStyle.color: Color.White
                    }
                    Label {
                        text: co.emoji["boy"]
                        textStyle.fontSize: FontSize.Small
                        visible: gender == 'M'
                        textStyle.color: Color.White
                    }
                    Label {
                        text: age
                        textStyle.fontSize: FontSize.Small
                        textStyle.color: Color.White
                        visible: age.length > 0
                    }
                    Label {
                        text: astrology
                        textStyle.fontWeight: FontWeight.W100
                        textStyle.fontSize: FontSize.Small
                        textStyle.color: Color.White
                        visible: astrology.length > 0
                    }
                }

            }
            ImageView {
                imageSource: "asset:///icon/tagged.png"
                verticalAlignment: VerticalAlignment.Center
                gestureHandlers: TapHandler {
                    onTapped: {
                        var uav = Qt.createComponent("UserArticlesView.qml").createObject(navroot);
                        uav.userid = uid;
                        uav.username = login;
                        uav.navigationPaneId = navroot;
                        uav.load();
                        navroot.push(uav);
                    }
                }
                visible: qscnt > 0
                preferredWidth: 100.0
                preferredHeight: 100.0
            }
        }
        Container {
            visible: infovisible
            verticalAlignment: VerticalAlignment.Bottom
            horizontalAlignment: HorizontalAlignment.Fill
            bottomPadding: 10.0
            background: Color.create("#88808080")
            topPadding: 10.0
            Container {
                horizontalAlignment: HorizontalAlignment.Center
                Label {
                    text: intro
                    visible: intro.length > 0
                    textStyle.color: Color.White
                    horizontalAlignment: HorizontalAlignment.Center
                }
            }
            Container {
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight

                }
                horizontalAlignment: HorizontalAlignment.Center
                Label {
                    text: co.emoji['home'] + haunt
                    visible: haunt.length > 0
                    textStyle.color: Color.White
                    textStyle.fontSize: FontSize.Small
                }
                Label {
                    text: co.emoji['clock'] + qbage + qsTr(" days")
                    textStyle.fontSize: FontSize.Small
                    textStyle.color: Color.White
                    visible: qbage > 0
                }
                Label {
                    text: co.emoji['phone'] + mobilebrand
                    textStyle.fontSize: FontSize.Small
                    textStyle.color: Color.White
                    visible: mobilebrand.length > 0
                }
            }
            Container {
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight

                }
                horizontalAlignment: HorizontalAlignment.Center
                Label {
                    text: co.emoji["occ"] + job
                    textStyle.fontSize: FontSize.Small
                    textStyle.color: Color.White
                    visible: job.length > 0
                }
                Label {
                    textStyle.fontSize: FontSize.Small
                    text: co.emoji["earth"] + hometown
                    textStyle.color: Color.White
                    visible: hometown.length > 0
                }
                Label {
                    textStyle.fontSize: FontSize.Small
                    text: co.emoji["happy"] + smilecount
                    textStyle.color: Color.White
                    visible: smilecount > 0
                }
                Label {
                    textStyle.fontSize: FontSize.Small
                    text: co.emoji["num"] + qscnt
                    textStyle.color: Color.White
                    visible: qscnt > 0
                }
            }
            Label {
                text: qsTr("Waiting for approval.")
                textStyle.fontSize: FontSize.Small
                textStyle.color: Color.White
                horizontalAlignment: HorizontalAlignment.Center
                visible: relationship == 'follow_unreplied'
            }

        }
        ActivityIndicator {
            verticalAlignment: VerticalAlignment.Fill
            horizontalAlignment: HorizontalAlignment.Fill
            running: true
            visible: ! loaded
        }
    }
    actions: [
        ActionItem {
            imageSource: "asset:///icon/ic_cancel.png"
            ActionBar.placement: ActionBarPlacement.OnBar
            enabled: loaded
            title: qsTr("Block")
            onTriggered: {
                if (relationship == 'black') {
                    co.unblackuser(function(b, d) {
                            if (! b) {
                                if (d & d.trim().length > 0) {
                                    sst.body = d;
                                } else {
                                    sst.body = qsTr("Login Required.");
                                }
                                sst.show();
                            } else {
                                relationship = d.relationship
                                sst.body = qsTr("This user is successfully removed from your blacklist.")
                                sst.show();
                            }
                        }, _app.getv("userid", ""), uid)
                } else {
                    co.blackuser(function(b, d) {
                            if (! b) {
                                if (d & d.trim().length > 0) {
                                    sst.body = d;
                                } else {
                                    sst.body = qsTr("Login Required.");
                                }
                                sst.show();
                            } else {
                                relationship = d.relationship
                                sst.body = qsTr("This user won't be able to send message to you.")
                                sst.show();
                            }
                        }, _app.getv("userid", ""), uid)
                }

            }
        },
        ActionItem {
            ActionBar.placement: co.signature
            title: (relationship == "no_rel") ? qsTr("Follow") : qsTr("Unfollow")
            enabled: loaded && relationship != "black"
            onTriggered: {
                if (relationship == "no_rel") {
                    //加为好友
                    co.follow(function(b, d) {
                            if (! b) {
                                if (d & d.trim().length > 0) {
                                    sst.body = d;
                                } else {
                                    sst.body = qsTr("Login Required.");
                                }
                                sst.show();
                            } else {
                                relationship = d.relationship
                                sst.body = qsTr("Request sent.")
                                sst.show();
                            }
                        }, _app.getv('userid', ''), uid, 4, 12)
                } else {
                    //移除好友
                    co.unfollow(function(b, d) {
                            if (! b) {
                                if (d & d.trim().length > 0) {
                                    sst.body = d;
                                } else {
                                    sst.body = qsTr("Login Required.");
                                }
                                sst.show();
                            } else {
                                relationship = d.relationship
                                sst.body = qsTr("Request complete.")
                                sst.show();
                            }
                        }, _app.getv('userid', ''), uid);
                }
            }
            imageSource: (relationship == "no_rel") ? "asset:///icon/add.png" : "asset:///icon/stop.png"
        },
        ActionItem {
            ActionBar.placement: ActionBarPlacement.OnBar
            imageSource: "asset:///icon/ic_textmessage_dk.png"
            enabled: false
            title: qsTr("Message")
        },
        ActionItem {
            title: qsTr("Block & Report")
            imageSource: "asset:///icon/alert.png"
            onTriggered: {

            }
            enabled: loaded
        }
    ]
    actionBarVisibility: ChromeVisibility.Visible
    actionBarAutoHideBehavior: ActionBarAutoHideBehavior.Disabled
}
