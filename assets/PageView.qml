import bb.cascades 1.2
import bb.system 1.2
ListView {
    id: listviewroot
    property bool loadingInProgress
    property string baseurl
    property int page: 1
    property int total
    property int count: 30
    property string lastArticleID: ""
    function p() {
        //生成当前请求的URL
        var result = baseurl + "page=" + page
        if (lastArticleID && lastArticleID.length > 0) {
            result = result + "&readarticles=[" + lastArticleID + "]"
        }
        console.log("[AJAX]Contacting: " + result)
        return result;
    }
    function viewvideo(xurl) {
        _app.invokeVideo("", xurl);
        //显示视频
        //        var viewer = vviewer.createObject(nav);
        //        viewer.play(xurl);
        //        nav.push(viewer)
    }
    function refresh() {
        //恢复成初始状态
        page = 1;
        lastArticleID = "";
    }
    attachedObjects: [
        Common {
            id: co
        },
        SystemToast {
            body: qsTr("No Data Received.")
            id: toast_no_data_recv
        },
        ListScrollStateHandler {
            onAtEndChanged: {
                if (atEnd) {
                    loaddata()
                }
            }
        },
        ComponentDefinition {
            source: "ItemView.qml"
            id: itemview
        }
    ]
    function viewPost(meta) {
        var iv = itemview.createObject(nav);
        iv.s_postid = meta.s_postid
        iv.d_date = meta.d_date
        iv.s_tag = meta.s_tag
        iv.s_state = meta.s_state
        iv.s_usericon = meta.s_usericon
        iv.s_userid = meta.s_userid
        iv.s_username = meta.s_username
        iv.s_imageurl = meta.s_imageurl
        iv.s_imagesize = meta.s_imagesize
        iv.d_votedown = meta.d_votedown
        iv.d_voteup = meta.d_voteup
        iv.d_comments = meta.d_comments
        iv.s_content = meta.s_content
        iv.allowcomment = meta.allowcomment
        iv.s_hivideo = meta.s_hivideo
        iv.s_lovideo = meta.s_lovideo
        iv.d_loop = meta.d_loop
        iv.s_picurl = meta.s_picurl
        nav.push(iv);
    }
    onCreationCompleted: {
        //        loaddata()
    }
    dataModel: ArrayDataModel {
        id: adm
        onItemAdded: {
            loadingInProgress = false
        }
    }
    leadingVisual: Container {
    }
    scrollIndicatorMode: ScrollIndicatorMode.ProportionalBar
    snapMode: SnapMode.Default
    horizontalAlignment: HorizontalAlignment.Fill
    scrollRole: ScrollRole.Main
    function loaddata() {
        if (loadingInProgress) {
            return;
        }
        loadingInProgress = true;
        co.ajax("GET", p(), [], function(r) {
                if (r['success']) {
                    var qiulistdata = JSON.parse(r['data']);
                    if (qiulistdata.count > 0) {
                        adm.append(qiulistdata.items)
                        lastArticleID = qiulistdata.items[qiulistdata.count - 1].id;
                        page ++;
                        console.log("[DataModel]Last Article Id is: " + lastArticleID);
                    } else {
                        toast_no_data_recv.show();
                    }
                } else {
                    toast_no_data_recv.show();
                }
                loadingInProgress = false;
            }, [ {
                    'k': 'Uuid',
                    'V': co.uuid
                } ], false)
    }
    listItemComponents: ListItemComponent {
        type: ''
        PostItem {
            id: itemroot
            s_postid: ListItemData.id
            d_date: ListItemData.published_at
            s_tag: ListItemData.tag
            s_state: ListItemData.state

            s_usericon: ListItemData.user && ListItemData.user.icon ? ListItemData.user.icon : ""
            s_userid: ListItemData.user ? ListItemData.user.id : ""
            s_username: ListItemData.user ? ListItemData.user.login : qsTr("Anonymous")

            s_imageurl: ListItemData.image
            s_imagesize: ListItemData.image_size

            d_votedown: ListItemData.votes.down
            d_voteup: ListItemData.votes.up
            d_comments: ListItemData.comments_count

            s_content: ListItemData.content
            allowcomment: ListItemData.allow_comment

            s_hivideo: ListItemData.high_url ? ListItemData.high_url : ""
            s_lovideo: ListItemData.low_url ? ListItemData.low_url : ""
            d_loop: ListItemData.loop ? ListItemData.loop : 0
            s_picurl: ListItemData.pic_url
            onPostTouched: {
                console.log("[VIEW]Opening : " + postid)
                var iv = {
                };
                iv.s_postid = itemroot.s_postid
                iv.d_date = itemroot.d_date
                iv.s_tag = itemroot.s_tag
                iv.s_state = itemroot.s_state
                iv.s_usericon = itemroot.s_usericon
                iv.s_userid = itemroot.s_userid
                iv.s_username = itemroot.s_username
                iv.s_imageurl = itemroot.s_imageurl
                iv.s_imagesize = itemroot.s_imagesize
                iv.d_votedown = itemroot.d_votedown
                iv.d_voteup = itemroot.d_voteup
                iv.d_comments = itemroot.d_comments
                iv.s_content = itemroot.s_content
                iv.allowcomment = itemroot.allowcomment
                iv.s_hivideo = itemroot.s_hivideo
                iv.s_lovideo = itemroot.s_lovideo
                iv.d_loop = itemroot.d_loop
                iv.s_picurl = itemroot.s_picurl
                itemroot.ListItem.view.viewPost(iv);
            }
        }

    }

}
