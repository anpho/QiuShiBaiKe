import bb.cascades 1.2

Sheet {
    id: sheetroot
    Page {
        titleBar: TitleBar {
            title: qsTr("Password Recovery")
            appearance: TitleBarAppearance.Plain
            dismissAction: ActionItem {
                title: qsTr("Close")
                onTriggered: {
                    sheetroot.close();
                }
            }
        }
        Container {
            layout: DockLayout {

            }
            WebView {
                preferredHeight: Infinity
                url: "http://www.qiushibaike.com/new4/fetchpass?uuid=" + _app.getv('uuid', '')
                horizontalAlignment: HorizontalAlignment.Fill
                settings.defaultFontSizeFollowsSystemFontSize: true
                settings.zoomToFitEnabled: true
                id: webv
                settings.userAgent: "Mozilla/5.0 (Linux; U; Android 4.3; zh-cn; ZTE Q802T Build/JLS36C) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Mobile Safari/534.30"
            }
            Container {
                visible: webv.loading

                verticalAlignment: VerticalAlignment.Center
                horizontalAlignment: HorizontalAlignment.Center
                ActivityIndicator {
                    running: true
                }
                Label {
                    text: qsTr("Connecting to Server...")
                    textStyle.textAlign: TextAlign.Center
                    textStyle.fontWeight: FontWeight.W100
                    horizontalAlignment: HorizontalAlignment.Fill
                }
            }
            
        }
    }
}