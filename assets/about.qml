import bb.cascades 1.2
import bb 1.0
Sheet {
    id: aboutsheet
    Page {
        id: aboutpage
        titleBar: TitleBar {
            title: qsTr("About")
            appearance: TitleBarAppearance.Plain
            dismissAction: ActionItem {
                title: qsTr("Close")
                onTriggered: {
                    aboutsheet.close()
                }
            }

        }
        attachedObjects: [
            PackageInfo {
                id: pi
            }
        ]
        ScrollView {
            Container {
                bottomPadding: 50.0
                topPadding: 50.0
                Container {
                    horizontalAlignment: HorizontalAlignment.Center

                    topPadding: 20.0
                    bottomPadding: 20.0
                    ImageView {
                        imageSource: "asset:///res/ic_launcher.png"
                        horizontalAlignment: HorizontalAlignment.Center
                    }
                    Label {
                        text: pi.version
                    }
                }

                Header {
                    title: qsTr("about www.qiushibaike.com")
                }
                Container {
                    leftPadding: 10.0
                    topPadding: 10.0
                    rightPadding: 10.0
                    bottomPadding: 10.0
                    Label {
                        text: qsTr("www.qiushibaike.com ( qsbk ) is a FML copycat which is very popular in China mainland. Users post their emberessed moments via text, image, and video, which could make people laugh.")
                        multiline: true
                        horizontalAlignment: HorizontalAlignment.Left
                        textFit.mode: LabelTextFitMode.FitToBounds
                    }
                    Label {
                        text: qsTr("Website: <a href='http://www.qiushibaike.com'>www.qiushibaike.com</a>")
                        textFormat: TextFormat.Html
                    }
                }
                Header {
                    title: qsTr("about this app")
                }
                Container {
                    topPadding: 10.0
                    leftPadding: 10.0
                    bottomPadding: 10.0
                    rightPadding: 10.0
                    Label {
                        text: qsTr("This app is built on BlackBerry Cascades native framework, focusing on bring best user experience to you. You can submit feedbacks via the <Feedback*> button at the bottom.")
                        multiline: true
                        textFit.mode: LabelTextFitMode.FitToBounds
                    }
                    Label {
                        multiline: true
                        text: qsTr("*Feedback requires <a href='http://github.com'>Github</a> account.")
                        textFormat: TextFormat.Html

                    }
                }
                Header {
                    title: qsTr("about me")
                }
                Container {
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight

                    }
                    leftPadding: 20.0
                    topPadding: 20.0
                    bottomPadding: 20.0
                    rightPadding: 20.0
                    ImageView {
                        imageSource: "asset:///res/avatar.png"
                        rightMargin: 50.0
                    }
                    Container {
                        layoutProperties: StackLayoutProperties {
                            spaceQuota: 1.0
                        }
                        Label {
                            text: qsTr("Merrick Zhang")
                        }
                        Label {
                            text: qsTr("Independent BlackBerry Developer")
                            textStyle.fontWeight: FontWeight.W100
                            textStyle.fontSize: FontSize.XSmall
                            multiline: true
                        }
                        Label {
                            text: qsTr("You can find all my apps <a href='appworld://vendor/26755'>Here</a>")
                            multiline: true
                            textFormat: TextFormat.Html
                            textStyle.fontWeight: FontWeight.W100
                            textStyle.fontSize: FontSize.Small
                        }
                        Label {
                            text: qsTr("<a href='mailto:anphorea@gmail.com'>Email Me</a>")
                            textFormat: TextFormat.Html
                            textStyle.fontWeight: FontWeight.W100
                            textStyle.fontSize: FontSize.Small
                        }
                    }
                }
            }
        }
        actions: [
            ActionItem {
                ActionBar.placement: ActionBarPlacement.Signature
                imageSource: "asset:///icon/ic_info.png"
                title: qsTr("Feedback")
                onTriggered: {
                    var issue = Qt.createComponent("Issues.qml").createObject(aboutpage);
                    issue.open();
                }

            }
        ]
    }

}