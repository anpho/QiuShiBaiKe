import bb.cascades 1.2
import bb.system 1.2
ListView {
    property variant navroot

    property string baseurl
    property int page: 1
    property int has_more: 1
    property bool loadingInProgress: false
    property string userid: _app.getv('userid', '')
    function p() {
        //生成当前请求的URL
        var result = baseurl.replace("%myid%", userid) + "page=" + page
        return result;
    }
    function refresh() {
        page = 1
        has_more = 1
        loadingInProgress = false
    }
    function loadData() {
        if (loadingInProgress) {
            return;
        } else {
            loadingInProgress = true;
        }
        if (userid.length == 0) {
            sst.body = qsTr("Login Required.");
            sst.show();
            return;
        }
        co.ajax("GET", p(), [], function(r) {
                if (r['success']) {
                    var d = JSON.parse(r['data'])
                    if (d.err > 0) {
                        console.log(r['data'])
                        sst = qsTr("Error: ") + d['err_msg']
                        sst.show();
                    } else {
                        has_more = d.has_more ? d.has_more : 0
                        adm.append(d.data);
                        page ++;
                    }
                } else {
                    sst = qsTr("Server unavailable.") + r['data']
                    sst.show();
                }
                loadingInProgress = false;
            }, [], false)
    }
    attachedObjects: [
        ListScrollStateHandler {
            onAtEndChanged: {
                if (atEnd && has_more > 0) {
                    loadData()
                }
            }
        },
        Common {
            id: co
        },
        SystemToast {
            id: sst
        }
    ]
    dataModel: ArrayDataModel {
        id: adm
        onItemAdded: {
            loadingInProgress = false
        }
    }
    scrollIndicatorMode: ScrollIndicatorMode.ProportionalBar
    snapMode: SnapMode.Default
    horizontalAlignment: HorizontalAlignment.Fill
    scrollRole: ScrollRole.Main

    listItemComponents: ListItemComponent {
        type: ""
        FriendItem {
            id: itemroot
            age: ListItemData.age
            astrology: ListItemData.astrology
            gender: ListItemData.gender
            icon: ListItemData.icon
            login: ListItemData.login
            relationship: ListItemData.relationship
            uid: ListItemData.uid
            navroot: itemroot.ListItem.view.navroot
            onProfilePressed: {
                itemroot.ListItem.view.requestProfile(uid)
            }
        }
    }

    function requestProfile(uid) {
        var upv = Qt.createComponent("UserProfileView.qml").createObject(navroot);
        upv.uid = uid;
        upv.navroot = navroot;
        navroot.push(upv)
    }
}
