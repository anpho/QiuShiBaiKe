import bb.cascades 1.2

Page {
    property variant navroot
    property bool datacoming: false
    titleBar: TitleBar {
        title: qsTr("Search User")
        appearance: TitleBarAppearance.Plain

    }
    Container {
        topPadding: 20.0
        bottomPadding: 20.0
        SegmentedControl {
            options: [
                Option {
                    text: qsTr("By UserID")
                    id: op_byid
                },
                Option {
                    text: qsTr("By Nickname")
                    id: op_byname
                }
            ]
        }

        Container {
            visible: op_byid.selected
            leftPadding: 20
            rightPadding: leftPadding
            topPadding: leftPadding
            bottomPadding: leftPadding
            Label {
                text: qsTr("Type her/his user ID below.")
            }
            TextField {
                hintText: qsTr("Her/His UserID.")
                id: text_userid
                textFormat: TextFormat.Plain
                inputMode: TextFieldInputMode.NumbersAndPunctuation
                validator: Validator {
                    onValidate: {
                        var intvalue = parseInt(text_userid.text) + "";
                        if (intvalue == text_userid.text) {
                            valid = true;
                        } else {
                            valid = false;
                        }
                    }
                    mode: ValidationMode.Immediate
                    errorMessage: qsTr("Only Numeric Allowed.")
                    valid: false
                    state: ValidationState.Unknown
                }
                onTextChanging: {
                    errormessage.text = "";
                }
            }
        }
        Container {
            visible: op_byname.selected
            leftPadding: 20
            rightPadding: leftPadding
            topPadding: leftPadding
            bottomPadding: leftPadding
            Label {
                text: qsTr("Type her/his nickname below.")
            }
            TextField {
                hintText: qsTr("Her/His Nickname.")
                id: text_username
                textFormat: TextFormat.Plain
                inputMode: TextFieldInputMode.Text
                onTextChanging: {
                    errormessage.text = "";
                }
            }
        }
        Label {
            id: errormessage
            multiline: true
            textStyle.fontSize: FontSize.Small
            textStyle.fontWeight: FontWeight.Normal
            textStyle.textAlign: TextAlign.Center
            horizontalAlignment: HorizontalAlignment.Center
            textStyle.color: Color.Red
        }
        ActivityIndicator {
            running: datacoming
            horizontalAlignment: HorizontalAlignment.Center

        }
    }
    actions: [
        ActionItem {
            imageSource: "asset:///icon/ic_search.png"
            title: qsTr("Search")
            ActionBar.placement: co.signature
            onTriggered: {
                if (op_byid.selected) {
                    if (text_userid.text.trim().length == 0) {
                        return;
                    }
                    datacoming = true;
                    co.getUserDetails(function(b, d) {
                            datacoming = false
                            if (! b) {
                                errormessage.text = d;
                            } else {
                                var userid = text_userid.text;
                                var userprofileview = Qt.createComponent("UserProfileView.qml").createObject(navroot)
                                userprofileview.uid = userid;
                                userprofileview.navroot = navroot;
                                navroot.push(userprofileview);
                            }
                        }, text_userid.text);
                } else if (op_byname.selected) {
                    if (text_username.text.trim().length == 0) {
                        return;
                    }
                    datacoming = true;
                    co.getUserDetailByNickname(function(b, d) {
                            datacoming = false;
                            if (b) {
                                var uid = d.user.id;
                                var userprofileview = Qt.createComponent("UserProfileView.qml").createObject(navroot)
                                userprofileview.uid = uid;
                                userprofileview.navroot = navroot;
                                navroot.push(userprofileview);
                            } else {
                                errormessage.text = d;
                            }
                        }, text_username.text)
                }
            }
        }
    ]
    attachedObjects: [
        Common {
            id: co
        }
    ]
}
