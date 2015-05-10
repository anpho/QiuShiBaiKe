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
    property string token: _app.getv('token', '')
    attachedObjects: [
        Common {
            id: co
        },
        SystemToast {
            id: toast_post_success
            body: qsTr("Successfully posted, please wait for approval.")
        }
    ]
    onCreationCompleted: {
        _app.cardDone.connect(cardDoneHandle)
    }
    function cardDoneHandle(msg) {
        console.log("card done message:" + msg)
        if (msg == 'Success') {
            toast_post_success.show()
        }
    }
    tabs: [
        Tab {
            ActionBar.placement: ActionBarPlacement.InOverflow
            imageSource: "asset:///res/ic_qiushi_select.png"
            delegate: Delegate {
                active: true
                NavigationPane {
                    id: nav
                    onPopTransitionEnded: {
                        page.destroy(1000)
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

                        Container {
                            SegmentedControl {
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
                                verticalAlignment: VerticalAlignment.Center
                            }
                            ControlDelegate {
                                delegateActive: s_hot.selected
                                attachedObjects: ComponentDefinition {
                                    id: hotview
                                    content: PageView {
                                        baseurl: co.u_suggest
                                    }
                                }
                                sourceComponent: hotview
                            }
                            ControlDelegate {
                                delegateActive: s_video.selected
                                attachedObjects: ComponentDefinition {
                                    id: videoview
                                    content: PageView {
                                        baseurl: co.u_video
                                    }
                                }

                                sourceComponent: videoview
                            }
                            ControlDelegate {
                                delegateActive: s_image.selected
                                attachedObjects: ComponentDefinition {
                                    id: imgview
                                    content: PageView {
                                        baseurl: co.u_image
                                    }
                                }
                                sourceComponent: imgview
                            }
                            ControlDelegate {
                                delegateActive: s_text.selected
                                attachedObjects: ComponentDefinition {
                                    id: txtview
                                    content: PageView {
                                        baseurl: co.u_text
                                    }
                                }
                                sourceComponent: txtview
                            }
                        }
                    }
                }
            }
            delegateActivationPolicy: TabDelegateActivationPolicy.ActivateImmediately
            title: qsTr("Browse")
        },
        Tab {
            imageSource: "asset:///res/ic_launcher.png"
            title: qsTr("Sticky Posts")
            delegateActivationPolicy: TabDelegateActivationPolicy.ActivateImmediately
            delegate: Delegate {
                Page {
                    Container {
                        SegmentedControl {
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
                                }
                            ]
                        }
                        ControlDelegate {
                            delegateActive: s_month.selected
                            attachedObjects: ComponentDefinition {
                                id: monthview
                                content: PageView {
                                    baseurl: co.u_month
                                }
                            }
                            sourceComponent: monthview
                        }
                        ControlDelegate {
                            delegateActive: s_week.selected
                            attachedObjects: ComponentDefinition {
                                id: weekview
                                content: PageView {
                                    baseurl: co.u_weekrank
                                }
                            }
                            sourceComponent: weekview
                        }
                        ControlDelegate {
                            delegateActive: s_day.selected
                            attachedObjects: ComponentDefinition {
                                id: dayview
                                content: PageView {
                                    baseurl: co.u_dayrank
                                }
                            }
                            sourceComponent: dayview
                        }
                    }
                }
            }

        },
        Tab {
            imageSource: "asset:///res/ic_message_select.png"
            delegate: Delegate {
                Page {
                    Container {
                        layout: DockLayout {

                        }
                        verticalAlignment: VerticalAlignment.Fill
                        horizontalAlignment: HorizontalAlignment.Fill
                        Label {
                            text: qsTr("Not implemented yet.")
                            verticalAlignment: VerticalAlignment.Center
                            horizontalAlignment: HorizontalAlignment.Center

                        }
                    }
                }
            }
            delegateActivationPolicy: TabDelegateActivationPolicy.ActivateImmediately
            title: qsTr("Messages")
            ActionBar.placement: ActionBarPlacement.InOverflow

        },
        Tab {
            imageSource: "asset:///res/evaluate_face_l0.png"
            title: qsTr("Review")
            enabled: token.length > 0
            delegate: Delegate {
                Page {
                    actionBarAutoHideBehavior: ActionBarAutoHideBehavior.Disabled
                    actionBarVisibility: ChromeVisibility.Visible
                    actions: [
                        ActionItem {
                            imageSource: "asset:///icon/yes.png"
                            title: qsTr("Yes!")
                            ActionBar.placement: ActionBarPlacement.OnBar
                        },
                        ActionItem {
                            title: qsTr("No")
                            imageSource: "asset:///icon/no.png"
                            ActionBar.placement: ActionBarPlacement.OnBar
                        },
                        ActionItem {
                            imageSource: "asset:///icon/right.png"
                            title: qsTr("Pass")
                            ActionBar.placement: ActionBarPlacement.OnBar

                        }
                    ]
                    Container {
                        verticalAlignment: VerticalAlignment.Fill
                        horizontalAlignment: HorizontalAlignment.Fill
                        layout: DockLayout {

                        }
                        Label {
                            verticalAlignment: VerticalAlignment.Center
                            horizontalAlignment: HorizontalAlignment.Center
                            text: qsTr("Not implemented yet.")

                        }
                    }
                }
            }
            delegateActivationPolicy: TabDelegateActivationPolicy.ActivateImmediately
        },
        Tab {
            id: tab_profile
            imageSource: "asset:///res/session_profile.png"
            ActionBar.placement: ActionBarPlacement.InOverflow
            title: qsTr("My Posts")
            delegate: Delegate {
                Page {
                    function refreshUserLoginState() {
                        console.debug("[ OK ] Login Sheet closed.");
                        token = _app.getv('token', '');
                    }
                    onCreationCompleted: {
                        if (token.length == 0) {
                            var loginsheet = Qt.createComponent("LoginSheet.qml").createObject(this);
                            loginsheet.closed.connect(refreshUserLoginState)
                            loginsheet.open();
                        }
                    }
                    Container {
                        SegmentedControl {
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
                        }
                        ControlDelegate {
                            delegateActive: op_my_posts.selected
                            attachedObjects: ComponentDefinition {
                                id: mypostsview
                                content: PageView {
                                    baseurl: co.u_my_posts
                                }
                            }
                            sourceComponent: mypostsview
                        }
                        ControlDelegate {
                            delegateActive: op_my_fav.selected
                            attachedObjects: ComponentDefinition {
                                id: myfavview
                                content: PageView {
                                    baseurl: co.u_my_fav
                                }
                            }
                            sourceComponent: myfavview
                        }
                        ControlDelegate {
                            delegateActive: op_my_attendence.selected
                            attachedObjects: ComponentDefinition {
                                id: myattview
                                content: PageView {
                                    baseurl: co.u_my_part
                                }
                            }
                            sourceComponent: myattview
                        }
                    }
                }
            }
            delegateActivationPolicy: TabDelegateActivationPolicy.ActivateImmediately
        }
    ]
    sidebarState: SidebarState.Hidden
}
