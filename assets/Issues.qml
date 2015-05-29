import bb.cascades 1.2

Sheet {
    id: issuesSheet
    property string defaulturl: "https://github.com/anpho/qsbk/issues"
    Page {
        titleBar: TitleBar {
            title: qsTr("Issues")
            appearance: TitleBarAppearance.Plain
            dismissAction: ActionItem {
                title: qsTr("Close")
                onTriggered: {
                    issuesSheet.close()
                }

            }
            acceptAction: ActionItem {
                title: qsTr("Reload")
                onTriggered: {
                    webv.url = defaulturl;
                }
                enabled: webv.url.toString() != defaulturl
            }

        }

        ScrollView {
            scrollViewProperties.scrollMode: ScrollMode.Vertical
            scrollViewProperties.overScrollEffectMode: OverScrollEffectMode.None
            WebView {
                id: webv
                settings.formAutoFillEnabled: true
                settings.credentialAutoFillEnabled: true
                settings.activeTextEnabled: false
                settings.zoomToFitEnabled: true
                settings.defaultFontSizeFollowsSystemFontSize: true
                horizontalAlignment: HorizontalAlignment.Fill
                url: defaulturl
                settings.userAgent: "Mozilla/5.0 (Linux; U; Android 2.3.7; en-us; Nexus One Build/FRF91) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1"
                settings.imageDownloadingEnabled: true
                settings.binaryFontDownloadingEnabled: true
                verticalAlignment: VerticalAlignment.Fill
            }
        }
    }
}