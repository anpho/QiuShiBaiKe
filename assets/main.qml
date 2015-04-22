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
    tabs: [
        Tab {
            ActionBar.placement: ActionBarPlacement.InOverflow
            imageSource: "asset:///res/ic_qiushi_select.png"
            delegate: Delegate {
                active: true
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
                    SegmentedControl {
                        options: [
                            Option {
                                text: qsTr("Hot")
                            },
                            Option {
                                text: qsTr("Video")
                            },
                            Option {
                                text: qsTr("Text")
                            },
                            Option {
                                text: qsTr("Image")
                            }
                        ]
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
        },Tab {
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
