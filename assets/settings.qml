import bb.cascades 1.2
import bb.platform 1.2
import bb.system 1.2
import bb 1.0
Sheet {
    id: sheetobj
    property string lock: _app.getv('lock', '')
    property bool unlocked: lock == "unlocked"
    Page {
        id: pageobj
        attachedObjects: [
            PlatformInfo {
                id: pi
            },
            PackageInfo {
                id: pai
            }
        ]
        titleBar: TitleBar {
            title: qsTr("Application Settings")
            dismissAction: ActionItem {
                title: qsTr("Close")
                onTriggered: {
                    sheetobj.close()
                }
            }
        }
        actionBarVisibility: ChromeVisibility.Default
        actionBarAutoHideBehavior: ActionBarAutoHideBehavior.HideOnScroll
        actions: [
            ActionItem {
                ActionBar.placement: ActionBarPlacement.OnBar
                imageSource: "asset:///icon/yes.png"
                title: qsTr("Done")
                onTriggered: {
                    sheetobj.close()
                }

            }
        ]
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
                    title: qsTr("UI Settings")
                }
                Container {
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight
                    }

                    topPadding: 10.0
                    bottomPadding: 10.0
                    CheckBox {
                        text: qsTr("Show Avatar")
                        checked: _app.getv('avatar', 'true') == 'true'
                        onCheckedChanged: {
                            _app.setv('avatar', checked)
                        }
                    }
                }
                Label {
                    text: qsTr("Turn this off could improve app's performance and reduce network usage.")
                    multiline: true
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
                        _app.setv('size', value);
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
                        text: qsTr("sample text")
                        horizontalAlignment: HorizontalAlignment.Left
                        verticalAlignment: VerticalAlignment.Center
                        multiline: true
                        textStyle.fontSize: FontSize.PointValue
                    }
                }
                Header {
                    title: qsTr("Unlock Features")
                    visible: false
                }
                Container {
                    visible: false // ! unlocked
                    Label {
                        text: qsTr("Unlock full features including: Picture uploading / Messages / Nearby and other upcoming advanced features, thanks for your support.")
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
                            id: pin
                            enabled: false
                            textStyle.textAlign: TextAlign.Center
                            hintText: ""
                            text: _app.genCodeByKey(pai.installId)
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
                        id: ucode
                    }
                    Button {
                        horizontalAlignment: HorizontalAlignment.Center
                        text: qsTr("Unlock")
                        onClicked: {
                            var src = pin.text;
                            var tar = ucode.text.toLowerCase();
                            var realtar = _app.genCodeByKey(src).toLowerCase();
                            console.debug(realtar);
                            if (tar == realtar) {
                                toast_unlock.body = qsTr("Application Unlocked")
                                _app.setv('lock', 'unlocked');
                                lock = _app.getv('lock', '')
                            } else {
                                toast_unlock.body = qsTr("Invalid Code")
                            }
                            toast_unlock.show();
                        }
                        attachedObjects: SystemToast {
                            id: toast_unlock
                        }
                    }
                    Divider {

                    }
                }

            }
        }
    }

}