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
NavigationPane {
    peekEnabled: true
    property string userlogin: _app.getv('login', '')
    id: cardnav
    Page {
        attachedObjects: [
            Common {
                id: co
            }
        ]
        Container {
            Header {
                title: qsTr("New Post")
                subtitle: userlogin
            }
            leftPadding: 20.0
            topPadding: 20.0
            rightPadding: 20.0
            bottomPadding: 20.0
            layout: StackLayout {

            }

            TextArea {
                layoutProperties: StackLayoutProperties {
                    spaceQuota: 1.0
                }
                id: qiuText
                backgroundVisible: false
                input.submitKey: SubmitKey.None
                textStyle.fontWeight: FontWeight.W100
                hintText: qsTr("Write your story here.")
                onTextChanging: {
                    if (text.length > 0) {
                        terms.visible = false;
                        postbutton.enabled = true;
                    } else {
                        terms.visible = true;
                        postbutton.enabled = false;
                    }
                }
            }
            Label {
                text: qsTr("Share your real life story here, your post will be reviewed by several users under the pricinple of REAL & FUNNY. Pornographic, political, terrorist, or disclosure of privacy posts will be deleted after verification, users who submited these materials will be banned. All rights reserved by www.qiushibaike.com including your posts.")
                multiline: true
                textStyle.fontSize: FontSize.XSmall
                opacity: 0.6
                id: terms
            }
            Divider {
                horizontalAlignment: HorizontalAlignment.Center
            }
            Container {
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight

                }
                Container {
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight

                    }
                    layoutProperties: StackLayoutProperties {
                        spaceQuota: 1.0

                    }
                    CheckBox {
                        verticalAlignment: VerticalAlignment.Center
                        text: qsTr("Anonymous")
                        id: anonymousToggle
                        horizontalAlignment: HorizontalAlignment.Left
                    }
                }
            }
        }
        actions: [
            ActionItem {
                id: postbutton
                ActionBar.placement: co.signature
                imageSource: "asset:///icon/yes.png"
                title: qsTr("Submit")
                enabled: userlogin.length > 0 && qiuText.text.length > 5
                onTriggered: {
                    var content = qiuText.text;
                    if (content.length < 5) {
                        toast_length_req.show()
                        return;
                    }
                    var anonymous = anonymousToggle.checked
                    co.genCreateArticleParams(function(edp, p) {
                            _app.post(edp, p);
                        }, content, anonymous, 0, 0, 0, 0, 0, null, 0, 0, 0, null);
                }
                attachedObjects: [
                    SystemToast {
                        id: toast_length_req
                        body: qsTr("At least 5 charactors required.")
                    }
                ]

            }
        ]
    }

    function setMemo(new_memo) {
        qiuText.text = new_memo;
    }
    function loginsheetclosed() {
        //登录页面关闭，重新读取登录数据
        userlogin = _app.getv('login', '')
    }
    onCreationCompleted: {
        //如果有分享过来的文本，把它显示到文本框里
        _app.memoChanged.connect(setMemo);
        _app.posted.connect(posted);
        //如果没有登录，显示登录框
        if (userlogin.length == 0) {
            var loginsheet = Qt.createComponent("LoginSheet.qml").createObject(cardnav)
            loginsheet.closed.connect(loginsheetclosed)
            loginsheet.open();
        }
    }
    function posted(success, data) {
        console.log(success);
        console.log(data)
        if (success) {
            _app.requestQuit();
        } else {
            toast_custom.body = JSON.parse(data).err_msg;
            toast_custom.show();
        }
    }
    attachedObjects: [
        SystemToast {
            id: toast_custom
        }
    ]
}
