import bb.cascades 1.2
import org.labsquare 1.0
import bb.system 1.2
Page {
    attachedObjects: [
        Common {
            id: co
        },
        SystemToast {
            body: qsTr("No Data Received.")
            id: toast_no_data_recv
        },
        LoginSheet {
            id: ls
        }
    ]
    actionBarAutoHideBehavior: ActionBarAutoHideBehavior.Default
    property int page: 1
    function genAjaxURL() {
        var base = co.u_comments.replace("%aid%", s_postid);
        base = base + "page=" + page;
        console.log("[COMMENTS] Contacting : " + base)
        return base;
    }
    property bool loading: false
    function loadData() {
        if (loading) return;
        loading = true;
        if (addm.isEmpty()) {
            var iv = {
                "type": "header"
            };
            iv.s_postid = s_postid
            iv.d_date = d_date
            iv.s_tag = s_tag
            iv.s_state = s_state
            iv.s_usericon = s_usericon
            iv.s_userid = s_userid
            iv.s_username = s_username
            iv.s_imageurl = s_imageurl
            iv.s_imagesize = s_imagesize
            iv.d_votedown = d_votedown
            iv.d_voteup = d_voteup
            iv.d_comments = d_comments
            iv.s_content = s_content
            iv.allowcomment = allowcomment
            iv.s_hivideo = s_hivideo
            iv.s_lovideo = s_lovideo
            iv.d_loop = d_loop
            iv.s_picurl = s_picurl
            iv.isvideopost = isvideopost
            addm.insert(0, iv);
            page = 1;
        }
        co.ajax("GET", genAjaxURL(), [], function(r) {
                if (r['success']) {
                    var qiulistdata = JSON.parse(r['data']);
                    if (qiulistdata.count > 0) {
                        addm.append(qiulistdata.items)
                        page ++;
                    } else {
                    }
                } else {
                }
                loading = false;
            }, [ {
                    'k': 'Uuid',
                    'V': co.uuid
                } ], false)
    }
    property string s_postid: "" //糗事ID
    property int d_date: 0 //发布时间
    property string s_tag: "" //标签
    property string s_state: "" //状态

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

    property string s_content: "" //内容
    property bool allowcomment: true //允许评论

    property string s_hivideo: ""
    property string s_lovideo: ""
    property int d_loop: 0
    property variant s_picurl: null

    property bool isvideopost: ! ! s_picurl
    Container {
        layout: DockLayout {

        }
        verticalAlignment: VerticalAlignment.Fill
        horizontalAlignment: HorizontalAlignment.Fill
        Container {
            layout: StackLayout {

            }
            ListView {
                attachedObjects: [
                    ListScrollStateHandler {
                        onAtEndChanged: {
                            if (atEnd) {
                                loadData()
                            }
                        }
                    }
                ]
                function viewvideo(xurl) {
                    _app.invokeVideo("", xurl);
                }
                dataModel: ArrayDataModel {
                    id: addm
                }
                function itemType(data, indexPath) {
                    if (data.type == "header") {
                        return "header"
                    } else return "item";
                }
                listItemComponents: [
                    ListItemComponent {
                        type: "item"
                        CommentsItem {
                            s_floor: ListItemData.floor
                            s_comment: ListItemData.content
                            s_commentid: ListItemData.id
                            s_useravator: ListItemData.user && ListItemData.user.icon ? ListItemData.user.icon : ""
                            s_userid: ListItemData.user && ListItemData.user.id ? ListItemData.user.id : ""
                            s_username: ListItemData.user && ListItemData.user.login ? ListItemData.user.login : ""
                        }
                    },
                    ListItemComponent {
                        type: "header"
                        Container {
                            id: hhh
                            horizontalAlignment: HorizontalAlignment.Fill
                            function getUserIcon() {
                                //http://pic.qiushibaike.com/system/avtnew/553/5532615/medium/20150210165740.jpg
                                if (ListItemData.s_userid.length < 1 || ListItemData.s_usericon.length < 1) return "asset:///res/default_user_avatar.png"

                                var base = "http://pic.qiushibaike.com/system/avtnew/"
                                base += ListItemData.s_userid.substring(0, ListItemData.s_userid.length - 4);
                                base = base + "/" + ListItemData.s_userid + "/medium/" + ListItemData.s_usericon;
                                return base;
                            }
                            function getImageURL(imageurl) {
                                if (! imageurl || imageurl == "") {
                                    return "";
                                }
                                /*
                                 * http://pic.qiushibaike.com/system/pictures/10588/105887800/medium/app105887800.jpg
                                 */
                                try {
                                    var reg = /[a-z]*([0-9]*).[a-z]*/i;
                                    var e = reg.exec(imageurl)[1];
                                    var d = e.substr(0, e.length - 4);
                                    var a = "http://pic.qiushibaike.com/system/pictures/" + d + "/" + e + "/medium/" + imageurl;
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
                                    url: hhh.getUserIcon()
                                }
                                Label {
                                    text: ListItemData.s_username
                                    verticalAlignment: VerticalAlignment.Center
                                    horizontalAlignment: HorizontalAlignment.Left
                                }
                            }
                            Divider {
                                verticalAlignment: VerticalAlignment.Center
                                horizontalAlignment: HorizontalAlignment.Center

                            }
                            Container {
                                horizontalAlignment: HorizontalAlignment.Fill
                                Label {
                                    multiline: true
                                    textFormat: TextFormat.Plain
                                    text: ListItemData.s_content
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
                                        visible: ListItemData.s_imageurl && ! ListItemData.isvideopost
                                        url: hhh.getImageURL(ListItemData.s_imageurl)
                                        verticalAlignment: VerticalAlignment.Fill
                                    }

                                    WebImageView {
                                        horizontalAlignment: HorizontalAlignment.Fill
                                        scalingMethod: ScalingMethod.AspectFit
                                        loadEffect: ImageViewLoadEffect.FadeZoom
                                        url: ListItemData.s_picurl ? ListItemData.s_picurl : ""
                                        visible: ListItemData.isvideopost
                                        id: videohover
                                    }

                                    Container {
                                        visible: videohover.visible
                                        horizontalAlignment: HorizontalAlignment.Right
                                        verticalAlignment: VerticalAlignment.Top
                                        Button {
                                            onClicked: {
                                                hhh.ListItem.view.viewvideo(ListItemData.s_hivideo)
                                            }
                                            visible: ListItemData.s_hivideo.length > 0
                                            text: qsTr("HQ")
                                            preferredWidth: 1
                                        }
                                        Button {
                                            onClicked: {
                                                hhh.ListItem.view.viewvideo(ListItemData.s_lovideo)
                                            }
                                            visible: ListItemData.s_lovideo.length > 0
                                            text: qsTr("LQ")
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
                                //投票区
                            }
                        }
                    }
                ]
                scrollRole: ScrollRole.Main
            }
            Container {
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight

                }
                leftPadding: 10.0
                rightPadding: 10.0
                bottomPadding: 10.0
                topPadding: 10.0
                TextArea {
                    horizontalAlignment: HorizontalAlignment.Left
                    verticalAlignment: VerticalAlignment.Center
                    id: comment_textarea
                }
                Button {
                    preferredWidth: 1
                    text: qsTr("Send")
                    verticalAlignment: VerticalAlignment.Center
                    horizontalAlignment: HorizontalAlignment.Right
                    onClicked: {
                        if (_app.getv('token', '').length == 0) {
                            ls.open()
                        } else {
                            if (comment_textarea.text.trim().length == 0) {
                                //不能发空评论
                                return;
                            }
                            co.comment(s_postid, comment_textarea.text, false, function(b, r) {
                                    if (b) {
                                        toast_comment_posted.show();
                                        comment_textarea.text = ""
                                    } else {
                                        toast_other.body = r
                                        toast_other.show();
                                    }
                                })
                        }
                    }
                    gestureHandlers: LongPressHandler {
                        onLongPressed: {
                            if (_app.getv('token', '').length == 0) {
                                ls.open()
                            } else {
                                if (comment_textarea.text.trim().length == 0) {
                                    //不能发空评论
                                    return;
                                }
                                co.comment(s_postid, comment_textarea.text, true, function(b, r) {
                                        if (b) {
                                            toast_comment_posted.show();
                                            comment_textarea.text = ""
                                        } else {
                                            toast_other.body = r
                                            toast_other.show();
                                        }
                                    })
                            }
                        }
                    }
                    attachedObjects: [
                        SystemToast {
                            id: toast_comment_posted
                            body: qsTr("Comment Posted.")
                        },
                        SystemToast {
                            id: toast_other
                        }
                    ]
                }
            }
        }
        ActivityIndicator {
            running: true
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center
        }
    }
}