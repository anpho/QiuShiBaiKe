import bb.cascades 1.2
import org.labsquare 1.0

Container {
    //点击标题
    signal userprofileTriggered(string userid)
    signal supportTriggered(string postid)
    signal unsupportTriggered(string postid)
    signal commentsTriggered(string postid)
    signal postTouched(string postid)

    property string s_postid: null //糗事ID
    property int d_date: 0 //发布时间
    property string s_tag: null //标签
    property string s_state: null //状态

    property string s_username: null //用户名
    property string s_userid: null //用户ID
    property string s_usericon: null //用户头像

    property string s_imageurl: null //图片URL
    property variant s_imagesize: null //图片大小
    /*
     * image_size: {
     * s: (3)[
     * 220,
     * 69,
     * 4702
     * ], m: (3)[
     * 500,
     * 156,
     * 33637
     * ]
     * },
     */

    property int d_votedown: 0 //不好笑
    property int d_voteup: 0 //好笑
    property int d_comments: 0 //评论数

    property string s_content: null //内容
    property bool allowcomment: true //允许评论

    property string s_hivideo: ""
    property string s_lovideo: ""
    property int d_loop: 0
    property string s_picurl: ""

    property bool isvideopost: s_picurl.length > 0

    leftPadding: 20.0
    rightPadding: 20.0
    topPadding: 20.0
    bottomPadding: 20.0
    function getUserIcon() {
        //http://pic.qiushibaike.com/system/avtnew/553/5532615/medium/20150210165740.jpg
        if (s_userid.length < 1 || s_usericon.length < 1) return ""

        var base = "http://pic.qiushibaike.com/system/avtnew/"
        base += s_userid.substring(0, s_userid.length - 4);
        base = base + "/" + s_userid + "/medium/" + s_usericon;
        return base;
    }
    function getImageURL() {
        if (! s_imageurl || s_imageurl == "") {
            return;
        }
        /*
         * http://pic.qiushibaike.com/system/pictures/10588/105887800/medium/app105887800.jpg
         */
        try {
            var reg = /[a-z]*([0-9]*).[a-z]*/i;
            var e = reg.exec(s_imageurl)[1];
            var d = e.substr(0, e.length - 4);
            var a = "http://pic.qiushibaike.com/system/pictures/" + d + "/" + e + "/medium/" + s_imageurl;
            console.log("[IMAGE]URL :" + a);
            return a;
        } catch (e) {
            console.log(JSON.stringify(e));
            return "" //TODO: add default image broke icon.
        }
    }
    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight
        }
        WebImageView {
            preferredWidth: 80
            preferredHeight: 80
            scalingMethod: ScalingMethod.AspectFit
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Left
            loadEffect: ImageViewLoadEffect.Subtle
            onCreationCompleted: {
                var uicon = getUserIcon();
                if (uicon.length > 0) {
                    url = uicon
                } else {
                    imageSource = "asset:///res/default_user_avatar.png"
                }
            }
        }
        Label {
            text: s_username
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Left
        }
    }
    Divider {
        verticalAlignment: VerticalAlignment.Center
        horizontalAlignment: HorizontalAlignment.Center

    }
    Container {
        gestureHandlers: [
            TapHandler {
                onTapped: {
                    postTouched(s_postid)
                }
            }
        ]
        horizontalAlignment: HorizontalAlignment.Fill
        overlapTouchPolicy: OverlapTouchPolicy.Allow
        Label {
            multiline: true
            textFormat: TextFormat.Plain
            text: s_content
            textStyle.fontWeight: FontWeight.W100
            textFit.mode: LabelTextFitMode.Default
        }
        Container {

            layout: DockLayout {

            }
            horizontalAlignment: HorizontalAlignment.Fill

            WebImageView {
                horizontalAlignment: HorizontalAlignment.Fill
                scalingMethod: ScalingMethod.AspectFit
                loadEffect: ImageViewLoadEffect.FadeZoom
                enabled: s_imageurl && s_imageurl.length > 0
                onEnabledChanged: {
                    if (enabled) {
                        var v = getImageURL();
                        if (v) {
                            url = v;
                        }
                    }
                }
                visible: s_imageurl && ! isvideopost
            }

            WebImageView {
                horizontalAlignment: HorizontalAlignment.Fill
                scalingMethod: ScalingMethod.AspectFit
                loadEffect: ImageViewLoadEffect.FadeZoom
                url: s_picurl
                visible: isvideopost
                id: videohover
            }

            Container {
                visible: videohover.visible
                horizontalAlignment: HorizontalAlignment.Right
                verticalAlignment: VerticalAlignment.Center
                Button {
                    text: qsTr("HIGH")
                    enabled: s_hivideo.length > 0
                    onClicked: {
                        itemroot.ListItem.view.viewvideo(s_hivideo)
                    }
                    preferredWidth: 1
                }
                Button {
                    text: qsTr("LOW")
                    enabled: s_lovideo.length > 0
                    onClicked: {
                        itemroot.ListItem.view.viewvideo(s_lovideo)
                    }
                    preferredWidth: 1
                }
            }
        }
    }
    Container {
        //Status Data
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight
        }
        topPadding: 20.0
        bottomPadding: 20.0
        Label {
            text: qsTr("Funny")
            textStyle.fontSize: FontSize.Small
        }
        Label {
            text: d_voteup
            textStyle.fontWeight: FontWeight.W100
            textStyle.fontSize: FontSize.Small
        }
        Label {
            text: qsTr("Comments")
            textStyle.fontSize: FontSize.Small
        }
        Label {
            text: d_comments
            textStyle.fontWeight: FontWeight.W100
            textStyle.fontSize: FontSize.Small
        }
    }
    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight

        }
        ImageButton {
            defaultImageSource: "asset:///res/operation_support_night.png"
            pressedImageSource: "asset:///res/operation_support_press.png"
            preferredWidth: 120.0
            preferredHeight: 120.0
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Left
            onClicked: {
                supportTriggered(s_postid)
            }
        }
        ImageButton {
            defaultImageSource: "asset:///res/operation_unsupport_night.png"
            pressedImageSource: "asset:///res/operation_unsupport_press.png"
            preferredWidth: 120.0
            preferredHeight: 120.0
            onClicked: {
                unsupportTriggered(s_postid)
            }
        }
        ImageButton {
            defaultImageSource: "asset:///res/operation_comments_night.png"
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center
            preferredWidth: 120.0
            preferredHeight: 120.0
            pressedImageSource: "asset:///res/operation_comments.png"
            onClicked: {
                commentsTriggered(s_postid);
            }
        }
    }
}
