import bb.cascades 1.2
import org.labsquare 1.0

Container {
    //点击标题
    signal userprofileTriggered(string userid, string username)
    signal supportTriggered(string postid)
    signal unsupportTriggered(string postid)
    signal commentsTriggered(string postid)
    signal postTouched(string postid)
    signal requestDelete(string postid)

    property bool showAvatar: true

    property string iam: "" // my user id
    property int type: 0
    property string s_postid: "" //糗事ID
    property int d_date: 0 //发布时间
    property string s_tag: "" //标签
    property string s_state: "" //状态
    // pending , public , private

    property string s_username: "" //用户名
    property string s_userid: "" //用户ID
    property variant s_usericon: "" //用户头像

    property variant s_imageurl: null //图片URL
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
    property variant s_picurl: ""

    property bool isvideopost: ! ! s_picurl

    property int fontsize: 8

    leftPadding: 20.0
    rightPadding: 20.0
    topPadding: 20.0
    bottomPadding: 20.0
    function getUserIcon() {
        //http://pic.qiushibaike.com/system/avtnew/553/5532615/medium/20150210165740.jpg
        if (s_userid.length < 1 || ! s_usericon || s_usericon.length < 1) return "asset:///res/default_user_avatar.png"

        var base = "http://pic.qiushibaike.com/system/avtnew/"
        base += s_userid.substring(0, s_userid.length - 4);
        base = base + "/" + s_userid + "/medium/" + s_usericon;
        return base;
    }
    function getImageURL() {
        if (! s_imageurl || s_imageurl == "") {
            return "";
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
        visible: type != 2
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
            url: showAvatar ? getUserIcon() : "asset:///res/default_user_avatar.png"

        }
        Label {
            text: s_username
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Left
        }
        gestureHandlers: TapHandler {
            onTapped: {
                if (s_userid.length > 0) {
                    userprofileTriggered(s_userid, s_username);
                }
            }
        }
        horizontalAlignment: HorizontalAlignment.Fill
    }
    Container {
        visible: type != 0
        Label {
            text: Qt.formatDateTime(new Date(d_date * 1000), "yyyy.MM.dd ddd h:mm")
            textStyle.fontSize: FontSize.XSmall
        }
    }
    Divider {
        verticalAlignment: VerticalAlignment.Center
        horizontalAlignment: HorizontalAlignment.Center

    }
    Container {
        //未审核通过
        background: Color.create("#ffff4200")
        leftPadding: 20.0
        rightPadding: 20.0
        visible: type == 2 && s_state == "private"
        Label {
            text: qsTr("Rejected")
        }
    }
    Container {
        //Pending for approval
        background: Color.create("#77ffff00")
        leftPadding: 20.0
        rightPadding: 20.0
        visible: type == 2 && s_state == "pending"
        Label {
            text: qsTr("Pending")
        }
    }
    Container {
        //审核通过
        background: Color.create("#6d00ff00")
        leftPadding: 20.0
        rightPadding: 20.0
        visible: type == 2 && s_state == "publish"
        Label {
            text: qsTr("Published")
        }
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
            textStyle.fontSize: FontSize.PointValue
            textStyle.fontSizeValue: fontsize
        }
        Container {

            layout: DockLayout {

            }
            horizontalAlignment: HorizontalAlignment.Fill

            WebImageView {
                horizontalAlignment: HorizontalAlignment.Fill
                scalingMethod: ScalingMethod.AspectFit
                loadEffect: ImageViewLoadEffect.FadeZoom
                url: getImageURL()
                visible: ! ! s_imageurl && ! isvideopost
            }

            WebImageView {
                horizontalAlignment: HorizontalAlignment.Fill
                scalingMethod: ScalingMethod.AspectFit
                loadEffect: ImageViewLoadEffect.FadeZoom
                visible: isvideopost
                id: videohover
                url: s_picurl ? s_picurl : ""
            }

            Container {
                visible: videohover.visible
                horizontalAlignment: HorizontalAlignment.Right
                verticalAlignment: VerticalAlignment.Top
                Button {
                    onClicked: {
                        itemroot.ListItem.view.viewvideo(s_hivideo)
                    }
                    visible: ListItemData.s_hivideo && ListItemData.s_hivideo.length > 0
                    text: qsTr("HQ")
                    preferredWidth: 1
                }
                Button {
                    onClicked: {
                        itemroot.ListItem.view.viewvideo(s_lovideo);
                    }
                    visible: ListItemData.s_lovideo && ListItemData.s_lovideo.length > 0
                    text: qsTr("LQ")
                    preferredWidth: 1
                }
            }
        }
    }
    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight

        }
        Label {
            text: qsTr("Funny")
            verticalAlignment: VerticalAlignment.Center
            textStyle.fontSize: FontSize.XSmall
            textStyle.fontWeight: FontWeight.W100
        }
        Label {
            text: d_voteup + d_votedown
            verticalAlignment: VerticalAlignment.Center
            textStyle.fontSize: FontSize.XSmall
            textStyle.fontWeight: FontWeight.W100
        }
        Label {
            textStyle.fontSize: FontSize.XSmall
            textStyle.fontWeight: FontWeight.W100
            text: qsTr("Replies")
            verticalAlignment: VerticalAlignment.Center
        }
        Label {
            textStyle.fontSize: FontSize.XSmall
            textStyle.fontWeight: FontWeight.W100
            text: d_comments
            verticalAlignment: VerticalAlignment.Center
        }
        Label {
            textStyle.fontSize: FontSize.XSmall
            textStyle.fontWeight: FontWeight.W100
            text: qsTr("Replays")
            visible: isvideopost
            verticalAlignment: VerticalAlignment.Center
        }
        Label {
            textStyle.fontSize: FontSize.XSmall
            textStyle.fontWeight: FontWeight.W100
            text: d_loop
            visible: isvideopost
            verticalAlignment: VerticalAlignment.Center
        }
    }
    Container {
        visible: s_state == 'public'
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight

        }
        ImageToggleButton {
            id: voteupbutton
            preferredWidth: 120.0
            preferredHeight: 120.0
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Left
            onCheckedChanged: {

                if (checked) {
                    if (votedownbutton.checked) {
                        votedownbutton.checked = false;
                    }
                    supportTriggered(s_postid)
                    d_voteup ++;
                } else {
                    d_voteup --;
                }
            }
            imageSourceDefault: "asset:///res/operation_support_night.png"
            imageSourceChecked: "asset:///res/operation_support_press.png"
            imagePressedChecked: imageSourceChecked
            imagePressedUnchecked: imageSourceChecked
        }
        ImageToggleButton {
            id: votedownbutton
            imageSourceDefault: "asset:///res/operation_unsupport_night.png"
            imageSourceChecked: "asset:///res/operation_unsupport_press.png"
            imagePressedChecked: imageSourceChecked
            imagePressedUnchecked: imageSourceChecked
            preferredWidth: 120.0
            preferredHeight: 120.0
            onCheckedChanged: {
                if (checked) {
                    if (voteupbutton.checked) {
                        voteupbutton.checked = false
                    }
                    unsupportTriggered(s_postid)
                    d_votedown --;
                } else {
                    d_votedown ++;
                }
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
                //                commentsTriggered(s_postid);
                postTouched(s_postid);
            }
        }
        ImageButton {
            defaultImageSource: "asset:///res/delete.png"
            preferredWidth: 120.0
            preferredHeight: 120.0
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center
            pressedImageSource: "asset:///res/delete2.png"
            visible: (iam == s_userid) && (iam != "")
            onClicked: {
                requestDelete(s_postid);
            }
            onCreationCompleted: {
            }
        }
    }
}
