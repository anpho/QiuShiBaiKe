import bb.cascades 1.2
import bb.system 1.2

ListView {
    id: listviewroot
    property bool showAvatar: _app.getv('avatar', 'true') == 'true'

    property bool loadingInProgress
    property variant navroot
    property int basefontsize
    property int type: co.pageview_mainlist

    property string baseurl
    property int page: 1
    property int total
    property int count: 30
    property string lastArticleID: ""
    function p() {
        //生成当前请求的URL
        var result = baseurl + "page=" + page;
        if (! type == co.pageview_myfavs) {
            if (lastArticleID && lastArticleID.length > 0) {
                result = result + "&readarticles=[" + lastArticleID + "]"
            }
        }
        console.log("[AJAX]Contacting: " + result)
        return result;
    }
    function viewvideo(xurl) {
        _app.invokeVideo("", xurl);
        //显示视频
    }
    function refresh() {
        //恢复成初始状态
        page = 1;
        lastArticleID = "";
        adm.clear();
        loaddata();
    }
    attachedObjects: [
        Common {
            id: co
        },
        SystemToast {
            body: qsTr("No Data Received.")
            id: toast_no_data_recv
        },
        SystemToast {
            id: toast_custom
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
        },
        LayoutUpdateHandler {
            //设置PTR的宽度
            onLayoutFrameChanged: {
                ptr.preferredWidth = layoutFrame.width
            }
        }
    ]
    function viewPost(meta) {
        var iv = itemview.createObject(navroot);
        iv.navroot = navroot;
        iv.basefont = basefontsize;
        iv.s_postid = meta.s_postid
        iv.d_date = meta.d_date
        iv.s_tag = meta.s_tag
        iv.s_state = meta.s_state
        iv.s_usericon = meta.s_usericon
        iv.s_userid = meta.s_userid
        iv.type = meta.type
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
        navroot.push(iv);
    }
    onCreationCompleted: {
    }
    dataModel: ArrayDataModel {
        id: adm
    }
    leadingVisual: PTR {
        // 下拉刷新的主体
        id: ptr
        loading: loadingInProgress
        onTriggerRefresh: {
            refresh();
        }
        horizontalAlignment: HorizontalAlignment.Fill
    }
    onTouch: {
        ptr.onlistviewTouch(event)
        //  下拉刷新
    }
    leadingVisualSnapThreshold: 1.0
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
                    if (qiulistdata.items.length > 0) {
                        adm.append(qiulistdata.items)
                        lastArticleID = qiulistdata.items[qiulistdata.items.length - 1].id;
                        console.log("[DataModel]Last Article Id is: " + lastArticleID);
                        page ++;
                    } else {
                        if (qiulistdata['err'] > 0) {
                            if (qiulistdata['err_msg'] && qiulistdata['err_msg'].length > 0) {
                                toast_custom.body = qiulistdata['err_msg']
                            } else {
                                toast_custom.body = qsTr("Login Required.")
                            }
                            toast_custom.show()
                        } else {
                            //toast_no_data_recv.show();
                        }
                    }
                } else {
                    console.log(r['data']);
                    toast_no_data_recv.show();
                }
                loadingInProgress = false;
            }, [ {
                    'k': 'Uuid',
                    'v': co.uuid
                } ], false)
    }
    property string userid: _app.getv('userid', '')
    function requestDelete(postid, indexpath) {
        co.requestDelete(function(b, r) {
                if (b) {
                    if (indexpath) {
                        console.log('about to remove' + indexpath + JSON.stringify(adm.data(indexpath)));
                        adm.removeAt(adm.indexOf(adm.data(indexpath)))
                    }

                    toast_custom.body = postid + "  " + qsTr("successfully deleted.")
                } else {
                    toast_custom.body = r;
                }
                toast_custom.show();
            }, postid);
    }

    function requestUserProfileView(uid, articleid) {
        var upv = Qt.createComponent("UserProfileView.qml").createObject(navroot);
        upv.uid = uid;
        upv.navroot = navroot;
        navroot.push(upv)
    }
    function requestVoteUp(pid) {
        co.vote(function(b, d) {
                console.log(b + d)
                //TODO: vote logic completion.
            }, pid, true);
    }
    function requestVoteDown(pid) {
        co.vote(function(b, d) {
                console.log(b + d)
            }, pid, false);
    }
    function getShowAvatar() {
        return showAvatar;
    }
    function requestShareTEXT(text) {
        _app.sharetext(text)
    }
    function requestSetClipboard(text) {
        _app.setClipboard(text);
    }
    function requestFav(postid) {
        co.addFav(function(b, d) {
                console.log(b + d);
                if (b) {
                    toast_custom.body = qsTr("Post added to your favourite list.")
                } else {
                    toast_custom.body = d;
                }
                toast_custom.show()
            }, postid)
    }
    function requestUNFav(postid, indexpath) {
        co.delFav(function(b, d) {
                console.log(b + d);
                if (b) {
                    toast_custom.body = qsTr("Post removed from your favourite list.")
                    if (indexpath) {
                        console.log('about to remove' + indexpath + JSON.stringify(adm.data(indexpath)));
                        adm.removeAt(adm.indexOf(adm.data(indexpath)))
                    }
                } else {
                    toast_custom.body = d;
                }
                toast_custom.show()
            }, postid)
    }
    property alias ptype: listviewroot.type
    listItemComponents: ListItemComponent {
        type: ''
        PostItem {
            id: itemroot
            showAvatar: itemroot.ListItem.view.getShowAvatar()
            iam: itemroot.ListItem.view.userid
            type: itemroot.ListItem.view.ptype
            fontsize: itemroot.ListItem.view.basefontsize
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
                iv.type = itemroot.ListItem.view.ptype;
                itemroot.ListItem.view.viewPost(iv);
            }
            onRequestDelete: {
                itemroot.ListItem.view.requestDelete(postid);
            }
            onUserprofileTriggered: {
                itemroot.ListItem.view.requestUserProfileView(userid);
            }
            onSupportTriggered: {
                itemroot.ListItem.view.requestVoteUp(postid);
            }
            onUnsupportTriggered: {
                itemroot.ListItem.view.requestVoteDown(postid);
            }
            contextActions: [
                ActionSet {
                    id: actionset
                    title: qsTr("Post ID")
                    subtitle: ListItemData.id
                    actions: [
                        ActionItem {
                            id: addFav
                            title: qsTr("Add to Fav.")
                            imageSource: "asset:///icon/ic_add_bookmarks.png"
                            onTriggered: {
                                itemroot.ListItem.view.requestFav(ListItemData.id)
                            }
                        },
                        ActionItem {
                            title: qsTr("Copy")
                            imageSource: "asset:///icon/ic_copy.png"
                            onTriggered: {
                                itemroot.ListItem.view.requestSetClipboard(ListItemData.content)
                            }
                        },
                        ActionItem {
                            title: qsTr("Share")
                            imageSource: "asset:///icon/ic_share.png"
                            onTriggered: {
                                itemroot.ListItem.view.requestShareTEXT(ListItemData.content)
                            }
                        }
                    ]
                }
            ]
            contextMenuHandler: ContextMenuHandler {
                onPopulating: {
                    if (itemroot.ListItem.view.ptype == 3) {
                        console.log("[context] in My-Fav context");
                        // show rm fav and hide add fav.
                        if (actionset.indexOf(rmFav) > -1) {
                            //bypass
                        } else {
                            actionset.add(rmFav)
                            actionset.remove(addFav);
                        }
                        // hide delMyPost
                        if (actionset.indexOf(delMyPost) > -1) {
                            actionset.remove(delMyPost);
                        }
                    } else if (itemroot.ListItem.view.ptype == 2) {
                        console.log("my posts")
                        // hide rm fav & add fav.
                        // show delMyPost

                        if (actionset.indexOf(rmFav) > -1) {
                            actionset.remove(rmFav)
                        }

                        if (actionset.indexOf(addFav) > -1) {
                            actionset.remove(addFav)
                        }

                        if (actionset.indexOf(delMyPost) < 0) {
                            actionset.add(delMyPost);
                        }

                    }

                }
                attachedObjects: [
                    DeleteActionItem {
                        imageSource: "asset:///icon/ic_delete.png"
                        id: rmFav
                        title: qsTr("Remove from Fav.")
                        onTriggered: {
                            itemroot.ListItem.view.requestUNFav(ListItemData.id, itemroot.ListItem.indexPath);
                        }
                    },
                    DeleteActionItem {
                        imageSource: "asset:///icon/ic_delete.png"
                        id: delMyPost
                        title: qsTr("Delete")
                        onTriggered: {
                            itemroot.ListItem.view.requestDelete(ListItemData.id, itemroot.ListItem.indexPath);
                        }
                    }
                ]
            }
        }

    }
    bufferedScrollingEnabled: true

}
