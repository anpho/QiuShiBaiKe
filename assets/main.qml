/*
 * Copyright (c) 2013-2014 BlackBerry Limited.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import bb.cascades 1.2
import bb.system 1.2
TabbedPane {
    id: tabroot
    Menu.definition: MenuDefinition {
        settingsAction: SettingsActionItem {
            onTriggered: {
                // 因为不太好直接丢到一个nav pane里面，这里用sheet做settings
                var settingssheet = Qt.createComponent("settings.qml").createObject(tabroot);
                settingssheet.closed.connect(reloadsettings)
                settingssheet.open();

            }
        }
        helpAction: HelpActionItem {
            onTriggered: {
                var aboutsheet = Qt.createComponent("about.qml").createObject(tabroot);
                aboutsheet.open();
            }
        }
        actions: [
            ActionItem {
                title: loggedin ? qsTr("Logout") : qsTr("Login")
                imageSource: "asset:///icon/ic_contact.png"
                onTriggered: {
                    if (loggedin) {
                        //已经登录，清空登录数据
                        _app.setv('token', "");
                        _app.setv('login', "");
                        _app.setv("userinfo", "");
                        _app.setv("userid", "");
                        _app.setv("userarticles", "");
                        tabroot.refreshUserLoginState();
                        toast_menu_custom.body = qsTr("Logged out successfully.")
                        toast_menu_custom.show();
                    } else {
                        //准备登录
                        var loginsheet = Qt.createComponent("LoginSheet.qml").createObject(tabroot);
                        loginsheet.closed.connect(refreshUserLoginState)
                        loginsheet.open();
                    }
                }
            },
            ActionItem {
                title: qsTr("Review App")
                imageSource: "asset:///icon/ic_edit_bookmarks.png"
                onTriggered: {
                    Qt.openUrlExternally("appworld://content/59962387")
                }
            }
        ]
        attachedObjects: [
            SystemToast {
                id: toast_menu_custom
            }
        ]
    }
    property string token: _app.getv('token', '')
    property bool loggedin: token.length > 0
    property int baseFontsize: parseInt(_app.getv('size', '8'))
    property string lock: _app.getv('lock', '')
    property bool unlocked: lock == "unlocked"
    property bool displayAltBar: (_app.getv('displayaltbar', '') == 'true')
    onDisplayAltBarChanged: {
        console.log("DISPLAY ALT. BAR IS NOW: "+displayAltBar)
    }
    attachedObjects: [
        Common {
            id: co
        },
        SystemToast {
            id: toast_post_success
            body: qsTr("Successfully posted, please wait for approval.")
        },
        SystemToast {
            id: toast_custom
        }
    ]
    onCreationCompleted: {
        _app.cardDone.connect(cardDoneHandle)
    }
    function reloadsettings() {
        // be called when user back from settings page.
        baseFontsize = parseInt(_app.getv('size', '8'));
        lock = _app.getv('lock', '')
        tabroot.displayAltBar = (_app.getv('displayaltbar', '') == 'true')
    }
    function cardDoneHandle(msg) {
        refreshUserLoginState()
        console.log("card done message:" + msg)
        if (msg == 'Success') {
            toast_post_success.show()
        }
    }
    function refreshUserLoginState() {
        console.debug("refreshUserLoginState");
        token = _app.getv('token', '');
        if (token.length == 0) {
            // still not logged in.
            tabroot.activeTab = browsetab;
            toast_custom.body = qsTr("Not logged in, now back to Browse")
            toast_custom.show();
        }
    }
    tabs: [
        Tab {
            imageSource: "asset:///res/ic_qiushi_select.png"
            delegate: Delegate {
                active: true
                NavigationPane {
                    id: nav1
                    onPopTransitionEnded: {
                        page.destroy()
                    }
                    Page {
                        actionBarVisibility: ChromeVisibility.Overlay
                        actionBarAutoHideBehavior: ActionBarAutoHideBehavior.HideOnScroll
                        actions: [
                            ActionItem {
                                imageSource: "asset:///res/submit.png"
                                ActionBar.placement: ActionBarPlacement.OnBar
                                title: qsTr("Submit")
                                onTriggered: {
                                    _app.invokeCard("");
                                }
                            }
                        ]
                        titleBar: TitleBar {
                            kind: TitleBarKind.Segmented
                            id: titlebar
                            options: [
                                Option {
                                    id: s_hot
                                    text: qsTr("Hot")
                                },
                                Option {
                                    id: s_video
                                    text: qsTr("Video")
                                },
                                Option {
                                    id: s_image
                                    text: qsTr("Image")
                                },
                                Option {
                                    id: s_text
                                    text: qsTr("Text")
                                }
                            ]
                            appearance: TitleBarAppearance.Plain
                            scrollBehavior: TitleBarScrollBehavior.Sticky
                        }
                        Container {
                            layout: StackLayout {

                            }
                            ControlDelegate {
                                delegateActive: s_hot.selected
                                attachedObjects: ComponentDefinition {
                                    id: hotview
                                    content: PageView {
                                        baseurl: co.u_suggest
                                        navroot: nav1
                                        basefontsize: baseFontsize
                                    }
                                }
                                sourceComponent: hotview
                            }
                            ControlDelegate {
                                delegateActive: s_video.selected
                                attachedObjects: ComponentDefinition {
                                    id: videoview
                                    content: PageView {
                                        basefontsize: baseFontsize
                                        baseurl: co.u_video
                                        navroot: nav1
                                    }
                                }

                                sourceComponent: videoview
                            }
                            ControlDelegate {
                                delegateActive: s_image.selected
                                attachedObjects: ComponentDefinition {
                                    id: imgview
                                    content: PageView {
                                        basefontsize: baseFontsize
                                        baseurl: co.u_image
                                        navroot: nav1
                                    }
                                }
                                sourceComponent: imgview
                            }
                            ControlDelegate {
                                delegateActive: s_text.selected
                                attachedObjects: ComponentDefinition {
                                    id: txtview
                                    content: PageView {
                                        basefontsize: baseFontsize
                                        baseurl: co.u_text
                                        navroot: nav1
                                    }
                                }
                                sourceComponent: txtview
                            }
                            Container {
                                layoutProperties: StackLayoutProperties {
                                    spaceQuota: 10.0
                                }
                                layout: DockLayout {

                                }
                                horizontalAlignment: HorizontalAlignment.Fill
                                ImageView {
                                    imageSource: "asset:///res/default_no_content_grey.png"
                                    scalingMethod: ScalingMethod.AspectFit
                                    horizontalAlignment: HorizontalAlignment.Center
                                    verticalAlignment: VerticalAlignment.Center
                                }
                            }
//                            SegmentedControl {
//                                selectedIndex: titlebar.selectedIndex
//                                onSelectedIndexChanged: {
//                                    titlebar.selectedIndex = selectedIndex
//                                }
//                                visible: tabroot.displayAltBar
//                                options: [
//                                    Option {
//                                        text: qsTr("Hot")
//                                    },
//                                    Option {
//                                        text: qsTr("Video")
//                                    },
//                                    Option {
//                                        text: qsTr("Image")
//                                    },
//                                    Option {
//                                        text: qsTr("Text")
//                                    }
//                                ]
//                            }
                        }
                    }
                }
            }
            delegateActivationPolicy: TabDelegateActivationPolicy.Default
            title: qsTr("Browse")
            id: browsetab
        },
        Tab {
            imageSource: "asset:///res/ic_qiushi_normal.png"
            title: qsTr("Ranks")
            delegateActivationPolicy: TabDelegateActivationPolicy.ActivatedWhileSelected
            delegate: Delegate {
                NavigationPane {
                    id: nav2
                    onPopTransitionEnded: {
                        page.destroy()
                    }
                    Page {
                        titleBar: TitleBar {
                            id: titlebar_rank
                            kind: TitleBarKind.Segmented
                            options: [
                                Option {
                                    id: s_month
                                    text: qsTr("Month")
                                },
                                Option {
                                    id: s_week
                                    text: qsTr("Week")
                                },
                                Option {
                                    id: s_day
                                    text: qsTr("Day")
                                },
                                Option {
                                    id: s_new
                                    text: qsTr("Newest")
                                }
                            ]
                            appearance: TitleBarAppearance.Plain
                            scrollBehavior: TitleBarScrollBehavior.Sticky
                        }

                        actionBarAutoHideBehavior: ActionBarAutoHideBehavior.HideOnScroll
                        actionBarVisibility: ChromeVisibility.Overlay
                        Container {
                            ControlDelegate {
                                delegateActive: s_month.selected
                                attachedObjects: ComponentDefinition {
                                    id: monthview
                                    content: PageView {
                                        basefontsize: baseFontsize
                                        baseurl: co.u_month
                                        navroot: nav2
                                    }
                                }
                                sourceComponent: monthview
                            }
                            ControlDelegate {
                                delegateActive: s_week.selected
                                attachedObjects: ComponentDefinition {
                                    id: weekview
                                    content: PageView {
                                        basefontsize: baseFontsize
                                        baseurl: co.u_weekrank
                                        navroot: nav2
                                    }
                                }
                                sourceComponent: weekview
                            }
                            ControlDelegate {
                                delegateActive: s_day.selected
                                attachedObjects: ComponentDefinition {
                                    id: dayview
                                    content: PageView {
                                        basefontsize: baseFontsize
                                        baseurl: co.u_dayrank
                                        navroot: nav2
                                    }
                                }
                                sourceComponent: dayview
                            }
                            ControlDelegate {
                                delegateActive: s_new.selected
                                attachedObjects: ComponentDefinition {
                                    id: newview
                                    content: PageView {
                                        basefontsize: baseFontsize
                                        baseurl: co.u_latest
                                        navroot: nav2
                                    }
                                }
                                sourceComponent: newview
                            }
                            Container {
                                layoutProperties: StackLayoutProperties {
                                    spaceQuota: 10
                                }
                            }
//                            SegmentedControl {
//                                visible: tabroot.displayAltBar
//                                options: [
//                                    Option {
//                                        text: qsTr("Month")
//                                    },
//                                    Option {
//                                        text: qsTr("Week")
//                                    },
//                                    Option {
//                                        text: qsTr("Day")
//                                    },
//                                    Option {
//                                        text: qsTr("Newest")
//                                    }
//                                ]
//                                selectedIndex: titlebar_rank.selectedIndex
//                                onSelectedIndexChanged: {
//                                    titlebar_rank.selectedIndex = selectedIndex
//                                }
//                            }
                        }
                    }
                }
            }
            ActionBar.placement: ActionBarPlacement.Default

        },
//        Tab {
//            imageSource: "asset:///res/ic_message_select.png"
//            delegate: Delegate {
//                Page {
//                    Container {
//                        layout: DockLayout {
//
//                        }
//                        verticalAlignment: VerticalAlignment.Fill
//                        horizontalAlignment: HorizontalAlignment.Fill
//                        Label {
//                            text: qsTr("Not implemented yet.")
//                            verticalAlignment: VerticalAlignment.Center
//                            horizontalAlignment: HorizontalAlignment.Center
//
//                        }
//                    }
//                }
//            }
//            delegateActivationPolicy: TabDelegateActivationPolicy.ActivatedWhileSelected
//            title: qsTr("Messages")
//        },
        //        Tab {
        //            imageSource: "asset:///res/evaluate_face_l0.png"
        //            title: qsTr("Review")
        //            enabled: token.length > 0
        //            delegate: Delegate {
        //                Page {
        //                    actionBarAutoHideBehavior: ActionBarAutoHideBehavior.Disabled
        //                    actionBarVisibility: ChromeVisibility.Visible
        //                    actions: [
        //                        ActionItem {
        //                            imageSource: "asset:///icon/yes.png"
        //                            title: qsTr("Yes!")
        //                            ActionBar.placement: ActionBarPlacement.OnBar
        //                        },
        //                        ActionItem {
        //                            title: qsTr("No")
        //                            imageSource: "asset:///icon/wrong.png"
        //                            ActionBar.placement: ActionBarPlacement.OnBar
        //                        },
        //                        ActionItem {
        //                            imageSource: "asset:///icon/right.png"
        //                            title: qsTr("Pass")
        //                            ActionBar.placement: ActionBarPlacement.OnBar
        //
        //                        }
        //                    ]
        //                    Container {
        //                        verticalAlignment: VerticalAlignment.Fill
        //                        horizontalAlignment: HorizontalAlignment.Fill
        //                        layout: DockLayout {
        //
        //                        }
        //                        Label {
        //                            verticalAlignment: VerticalAlignment.Center
        //                            horizontalAlignment: HorizontalAlignment.Center
        //                            text: qsTr("Not implemented yet.")
        //
        //                        }
        //                    }
        //                }
        //            }
        //            delegateActivationPolicy: TabDelegateActivationPolicy.ActivatedWhileSelected
        //        },
        Tab {
            id: tab_myPosts
            imageSource: "asset:///userguide/user_guide_paper.png"
            title: qsTr("My Posts")
            onTriggered: {
                if (! loggedin) {
                    var loginsheet = Qt.createComponent("LoginSheet.qml").createObject(tabroot);
                    loginsheet.closed.connect(refreshUserLoginState)
                    loginsheet.open();
                }
            }
            delegate: Delegate {
                NavigationPane {
                    id: nav5
                    onPopTransitionEnded: {
                        page.destroy()
                    }
                    Page {
                        actionBarVisibility: ChromeVisibility.Overlay
                        actionBarAutoHideBehavior: ActionBarAutoHideBehavior.HideOnScroll
                        actions: [
                            ActionItem {
                                imageSource: "asset:///res/submit.png"
                                ActionBar.placement: ActionBarPlacement.OnBar
                                title: qsTr("Submit")
                                onTriggered: {
                                    _app.invokeCard("");
                                }
                            }
                        ]
                        titleBar: TitleBar {
                            id: titlebar_my
                            kind: TitleBarKind.Segmented
                            options: [
                                Option {
                                    id: op_my_posts
                                    text: qsTr("My Posts")
                                },
                                Option {
                                    id: op_my_fav
                                    text: qsTr("My Favourites")
                                },
                                Option {
                                    id: op_my_attendence
                                    text: qsTr("My Participates")
                                }
                            ]
                            appearance: TitleBarAppearance.Plain
                        }
                        Container {
                            ControlDelegate {
                                delegateActive: op_my_posts.selected
                                attachedObjects: ComponentDefinition {
                                    id: mypostsview
                                    content: PageView {
                                        basefontsize: baseFontsize
                                        baseurl: co.u_my_posts
                                        navroot: nav5
                                        type: co.pageview_myarticles
                                    }
                                }
                                sourceComponent: mypostsview
                            }
                            ControlDelegate {
                                delegateActive: op_my_fav.selected
                                attachedObjects: ComponentDefinition {
                                    id: myfavview
                                    content: PageView {
                                        basefontsize: baseFontsize
                                        baseurl: co.u_my_fav
                                        navroot: nav5
                                        type: co.pageview_myfavs
                                    }
                                }
                                sourceComponent: myfavview
                            }
                            ControlDelegate {
                                delegateActive: op_my_attendence.selected
                                attachedObjects: ComponentDefinition {
                                    id: myattview
                                    content: PageView {
                                        basefontsize: baseFontsize
                                        baseurl: co.u_my_part
                                        navroot: nav5
                                    }
                                }
                                sourceComponent: myattview
                            }
                            Container {
                                layoutProperties: StackLayoutProperties {
                                    spaceQuota: 10
                                }
                            }
//                            SegmentedControl {
//                                visible: tabroot.displayAltBar
//                                options: [
//                                    Option {
//                                        text: qsTr("My Posts")
//                                    },
//                                    Option {
//                                        text: qsTr("My Favourites")
//                                    },
//                                    Option {
//                                        text: qsTr("My Participates")
//                                    }
//                                ]
//                                onSelectedIndexChanged: {
//                                    titlebar_my.selectedIndex = selectedIndex
//                                }
//                                selectedIndex: titlebar_my.selectedIndex
//                            }
                        }
                    }
                }
            }
            delegateActivationPolicy: TabDelegateActivationPolicy.ActivatedWhileSelected
        },
        Tab {
            id: tab_qiuyou
            imageSource: "asset:///userguide/user_guide_little_2.png"
            onTriggered: {
                if (! loggedin) {
                    var loginsheet = Qt.createComponent("LoginSheet.qml").createObject(tabroot);
                    loginsheet.closed.connect(refreshUserLoginState)
                    loginsheet.open();
                }
            }
            delegate: Delegate {
                NavigationPane {
                    id: qiuyouroot
                    onPopTransitionEnded: {
                        page.destroy()
                    }
                    Page {
                        actions: [
                            ActionItem {
                                ActionBar.placement: ActionBarPlacement.OnBar
                                imageSource: "asset:///icon/ic_search.png"
                                title: qsTr("Search")
                                onTriggered: {
                                    var searchpage = Qt.createComponent("page-SearchUser.qml").createObject(qiuyouroot);
                                    searchpage.navroot = qiuyouroot;
                                    qiuyouroot.push(searchpage);
                                }

                            }
                        ]
                        titleBar: TitleBar {
                            kind: TitleBarKind.Segmented
                            appearance: TitleBarAppearance.Plain
                            scrollBehavior: TitleBarScrollBehavior.Sticky
                            id: titlebar_friends
                            options: [
                                Option {
                                    id: op_myFriends
                                    text: qsTr("Friends")
                                },
                                Option {
                                    id: op_following
                                    text: qsTr("Following")
                                },
                                Option {
                                    id: op_followers
                                    text: qsTr("Followers")
                                }
                            ]
                        }
                        actionBarAutoHideBehavior: ActionBarAutoHideBehavior.HideOnScroll
                        actionBarVisibility: ChromeVisibility.Overlay
                        Container {
                            ControlDelegate {
                                delegateActive: op_myFriends.selected
                                attachedObjects: ComponentDefinition {
                                    id: myfriendsview
                                    content: FriendsView {
                                        baseurl: co.u_friendlist
                                        navroot: qiuyouroot
                                    }
                                }
                                sourceComponent: myfriendsview
                            }
                            ControlDelegate {
                                delegateActive: op_following.selected
                                attachedObjects: ComponentDefinition {
                                    id: followingview
                                    content: FriendsView {
                                        baseurl: co.u_followlist
                                        navroot: qiuyouroot
                                    }
                                }
                                sourceComponent: followingview
                            }
                            ControlDelegate {
                                delegateActive: op_followers.selected
                                attachedObjects: ComponentDefinition {
                                    id: fanview
                                    content: FriendsView {
                                        baseurl: co.u_fanlist
                                        navroot: qiuyouroot
                                    }
                                }
                                sourceComponent: fanview
                            }
                            Container {
                                layoutProperties: StackLayoutProperties {
                                    spaceQuota: 10
                                }
                            }
//                            SegmentedControl {
//                                visible: tabroot.displayAltBar
//                                options: [
//                                    Option {
//                                        text: qsTr("Friends")
//                                    },
//                                    Option {
//                                        text: qsTr("Following")
//                                    },
//                                    Option {
//                                        text: qsTr("Followers")
//                                    }
//                                ]
//                                selectedIndex: titlebar_friends.selectedIndex
//                                onSelectedIndexChanged: {
//                                    titlebar_friends.selectedIndex = selectedIndex
//                                }
//                            }
                        }
                    }
                }
            }
            delegateActivationPolicy: TabDelegateActivationPolicy.ActivatedWhileSelected
            title: qsTr("My Friends")
        }
    ]
    showTabsOnActionBar: false
}
