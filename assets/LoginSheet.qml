import bb.cascades 1.2

Sheet {
    id: sheetroot
    attachedObjects: [
        Common {
            id: co
        }
    ]
    peekEnabled: false
    Page {
        titleBar: TitleBar {
            dismissAction: ActionItem {
                title: qsTr("Cancel")
                onTriggered: {
                    sheetroot.close();
                }
            }
            appearance: TitleBarAppearance.Plain

        }
        Container {
            verticalAlignment: VerticalAlignment.Fill
            horizontalAlignment: HorizontalAlignment.Fill
            //login page
            layout: DockLayout {

            }
            Container {
                verticalAlignment: VerticalAlignment.Center
                horizontalAlignment: HorizontalAlignment.Center
                leftPadding: 20.0
                rightPadding: 20.0
                topPadding: 20.0
                bottomPadding: 20.0
                ImageView {
                    imageSource: "asset:///userguide/user_guide_logo.png"
                    horizontalAlignment: HorizontalAlignment.Center
                }
                TextField {
                    hintText: qsTr("Username")
                    id: login_username
                    horizontalAlignment: HorizontalAlignment.Center
                }
                TextField {
                    id: login_password
                    hintText: qsTr("Password")
                    input.masking: TextInputMasking.Masked
                    horizontalAlignment: HorizontalAlignment.Center
                    inputMode: TextFieldInputMode.Password
                }
                Label {
                    textStyle.color: Color.Red
                    textStyle.fontWeight: FontWeight.W100
                    horizontalAlignment: HorizontalAlignment.Center
                    visible: text.length > 0
                    id: error_text
                }
                Button {
                    text: qsTr("Login")
                    horizontalAlignment: HorizontalAlignment.Center
                    onClicked: {
                        // LOGIN
                        if (login_username.text.length > 0 && login_password.text.length > 0) {
                            co.login(login_username.text, login_password.text, function(r, data) {
                                    console.log(r + JSON.stringify(data))
                                    if (! r) {
                                        //出错了，显示出错信息
                                        error_text.text = data;
                                    } else {
                                        error_text.text = ""; //清空出错信息
                                        _app.setv('token',data.token);
                                        _app.setv('login', data.user.login);
                                        _app.setv("userinfo", JSON.stringify(data.user));
                                        _app.setv("userarticles", JSON.stringify(data.userdata.articles));
                                        sheetroot.close();
                                    }
                                });
                        }
                    }
                }
            }
        }
    }
}