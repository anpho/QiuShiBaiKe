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

TabbedPane {
    attachedObjects: [
        Common {
            id: co
        }
    ]
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
                            }
                        ]
                        Container {
                            SegmentedControl {
                                options: [
                                    Option {
                                        id: s_hot
                                        text: qsTr("Hot")
                                        value: "http://m2.qiushibaike.com/article/list/suggest"
                                    },
                                    Option {
                                        id: s_video
                                        text: qsTr("Video")
                                        value: "http://m2.qiushibaike.com/article/list/video"
                                    },
                                    Option {
                                        id: s_image
                                        text: qsTr("Image")
                                        value: "http://m2.qiushibaike.com/article/list/imgrank"
                                    },
                                    Option {
                                        id: s_text
                                        text: qsTr("Text")
                                        value: "http://m2.qiushibaike.com/article/list/text"
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
            imageSource: "asset:///res/ic_message_select.png"
            delegate: Delegate {

            }
            delegateActivationPolicy: TabDelegateActivationPolicy.ActivatedWhileSelected
            title: qsTr("Messages")
            ActionBar.placement: ActionBarPlacement.InOverflow
            Page {

            }
        },
        Tab {
            imageSource: "asset:///res/ic_nearby_select.png"
            title: qsTr("Nearby")
            ActionBar.placement: ActionBarPlacement.InOverflow
            delegate: Delegate {

            }
            delegateActivationPolicy: TabDelegateActivationPolicy.ActivatedWhileSelected
            Page {

            }
        },
        Tab {
            imageSource: "asset:///res/evaluate_face_l0.png"
            title: qsTr("Review")

        },
        Tab {
            imageSource: "asset:///res/session_profile.png"
            ActionBar.placement: ActionBarPlacement.InOverflow
            title: qsTr("My Profile")
            delegate: Delegate {

            }
            delegateActivationPolicy: TabDelegateActivationPolicy.ActivatedWhileSelected
            Page {

            }

        }
    ]
    sidebarState: SidebarState.Hidden
}
