import bb.cascades 1.2
import bb.platform 1.2
Sheet {
    id: sheetobj
    Page {
        id: pageobj
        attachedObjects: [
            PlatformInfo {
                id: pi
            }
        ]
        titleBar: TitleBar {
            title: qsTr("Application Settings")
            dismissAction: ActionItem {
                title: qsTr("Back")
                onTriggered: {
                    sheetobj.close()
                }
            }
        }
        actionBarVisibility: ChromeVisibility.Default
        actionBarAutoHideBehavior: ActionBarAutoHideBehavior.HideOnScroll
        ScrollView {

            Container {
                leftPadding: 20.0
                rightPadding: 20.0
                //---------------------------------
                Header {
                    title: qsTr("Theme Settings")
                }
                CheckBox {
                    visible: pi.osVersion > "10.3.0"
                    text: qsTr("Use Dark Theme")
                    checked: Application.themeSupport.theme.colorTheme.style === VisualStyle.Dark
                    onCheckedChanged: {
                        checked ? _app.setv("use_dark_theme", "dark") : _app.setv("use_dark_theme", "bright")
                        console.log(pi.osVersion);
                        Application.themeSupport.setVisualStyle(checked ? VisualStyle.Dark : VisualStyle.Bright);
                    }
                }
                CheckBox {
                    visible: pi.osVersion < "10.3.0"
                    text: qsTr("Use Dark Theme")
                    checked: _app.getv("use_dark_theme", "dark") == "dark"
                    onCheckedChanged: {
                        checked ? _app.setv("use_dark_theme", "dark") : _app.setv("use_dark_theme", "bright")
                        console.log(pi.osVersion);
                    }
                }
                Label {
                    text: qsTr("This will apply immediately on BlackBerry OS 10.3 and above.")
                    multiline: true
                    visible: pi.osVersion > "10.3.0"
                }
                Label {
                    text: qsTr("This will apply when app restarts.")
                    multiline: true
                    visible: pi.osVersion < "10.3.0"
                }
                Header {
                    title: qsTr("Text Size")
                }
                Label {
                    text: qsTr("Move this slider to adjust text size.")
                    multiline: true
                }
                Slider {
                    fromValue: 5
                    toValue: 18
                    value: parseInt(_app.getv('size', '8'))
                    id: text_size_slider
                    onValueChanged: {
                        _app.setv('size',value);
                    }
                }
                Container {
                    leftMargin: 40.0
                    topMargin: 40.0
                    rightMargin: 40.0
                    bottomMargin: 40.0
                    background: Color.create("#80bfbfbf")
                    leftPadding: 40.0
                    topPadding: 40.0
                    rightPadding: 40.0
                    bottomPadding: 40.0
                    horizontalAlignment: HorizontalAlignment.Fill
                    Label {
                        textStyle.fontSizeValue: text_size_slider.value
                        text: "生活中遇到那些尴尬、倒霉、搞笑、口误、无奈、欲哭无泪的事，都可以称为糗事。糗事百科是一个原创分享糗事的平台，遵循UGC原则，网友可以自由投稿、投票、评论、审核内容，并与其它网友互动。糗事内容真实，文字简洁、清晰、口语化，适合随时随地观看，缓解生活压力。"
                        horizontalAlignment: HorizontalAlignment.Left
                        verticalAlignment: VerticalAlignment.Center
                        multiline: true
                        textStyle.fontSize: FontSize.PointValue
                    }
                }
                Header {
                    title: qsTr("Unlock Features")
                }
                Container {
                    Label {
                        text: qsTr("Unlock full features.")
                        multiline: true
                        textFormat: TextFormat.Html
                    }
                    Button {
                        horizontalAlignment: HorizontalAlignment.Center
                        text: qsTr("Unlock for $0.99")
                        imageSource: "asset:///icon/shop.png"
                    }
                    Label {
                        text: qsTr("If you've purchased this app before with the same BlackBerry ID, you can press the button below to sync the status.")
                        multiline: true
                    }
                    Button {
                        horizontalAlignment: HorizontalAlignment.Center
                        imageSource: "asset:///icon/sync.png"
                        text: qsTr("Sync Purchase")
                    }
                    Label {
                        text: qsTr("In case of purchasing issues with PayPal or Credit card, you can use the unlock code to unlock full features too.")
                        multiline: true
                    }
                    Container {
                        layout: StackLayout {
                            orientation: LayoutOrientation.LeftToRight
                        }
                        Label {
                            text: qsTr("APP-PIN : ")
                            verticalAlignment: VerticalAlignment.Center
                        }
                        TextField {
                            enabled: false
                            textStyle.textAlign: TextAlign.Center
                            hintText: qsTr("")
                        }
                        Button {
                            imageSource: "asset:///icon/copy.png"
                            preferredWidth: 1.0
                        }
                    }
                    Label {
                        text: qsTr("Unlock Code:")
                    }
                    TextField {
                        hintText: qsTr("Enter the 4-digit Unlock-Code")
                        input.submitKey: SubmitKey.Submit
                        input.submitKeyFocusBehavior: SubmitKeyFocusBehavior.Lose
                        textStyle.textAlign: TextAlign.Center

                    }
                }

            }
        }
    }

}