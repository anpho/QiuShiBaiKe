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
import bb.cascades.pickers 1.0
NavigationPane {
    peekEnabled: true
    property string userlogin: _app.getv('login', '')
    property string imageurl: ""
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
            ImageView {
                id: localimageviewer
                scalingMethod: ScalingMethod.AspectFit
                preferredWidth: 120.0
                preferredHeight: 120.0
                visible: imageurl.length > 0
                imageSource: imageurl
                attachedObjects: ImageTracker {
                    imageSource: imageurl
                    id: localimagetracker
                }
                gestureHandlers: TapHandler {
                    onTapped: {
                        imageurl = "";
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
                    if (imageurl.length > 0) {
                        console.log("image upload");
                        var ext = imageurl.split(".");
                        ext = ext[ext.length - 1];
                        co.genCreateArticleParams(function(edp, p) {
                                _app.postImage(edp, p, imageurl.replace("file://", ""));
                            }, content, anonymous, 0, 0, 0, 0, 0, 0, ext, localimagetracker.width, localimagetracker.height, null)
                    } else {
                        co.genCreateArticleParams(function(edp, p) {
                                _app.post(edp, p);
                            }, content, anonymous, 0, 0, 0, 0, 0, -1, 0, 0, 0, null);
                    }
                }
                attachedObjects: [
                    SystemToast {
                        id: toast_length_req
                        body: qsTr("At least 5 charactors required.")
                    }
                ]

            },
            ActionItem {
                title: qsTr("Image")
                imageSource: "asset:///icon/ic_view_image.png"
                ActionBar.placement: ActionBarPlacement.OnBar
                onTriggered: {
                    imagepicker.open();
                }
                attachedObjects: [
                    FilePicker {
                        mode: FilePickerMode.Picker
                        type: FileType.Picture
                        defaultType: FileType.Picture
                        title: qsTr("Select an image to upload")
                        viewMode: FilePickerViewMode.GridView
                        imageCropEnabled: false
                        id: imagepicker
                        onFileSelected: {
                            if (selectedFiles.length > 0) {
                                imageurl = "file://" + selectedFiles[0];
                                console.log(imageurl)
                            } else {
                                imageurl = "";
                            }
                        }
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
        imageurl = "";
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
