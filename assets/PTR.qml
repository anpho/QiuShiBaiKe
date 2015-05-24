import bb.cascades 1.2
// Pull To Refresh
Container {
    signal triggerRefresh()
    property bool loading: false
    property bool watchLoading: false
    property bool refreshcooked: false
    property int pullThreshold: 40
    property string pull_to_refresh: qsTr("Pull down to refresh")
    property string release_to_refresh: qsTr("Release to Refresh")
    property string refreshing: qsTr("Loading")
    id: refHeader
    ImageView {
        imageSource: "asset:///icon/down.png"
        scalingMethod: ScalingMethod.AspectFit
        horizontalAlignment: HorizontalAlignment.Center
        visible: ! loadingInProgress
        id: refimage
    }
    onLoadingChanged: {
        if (watchLoading) {
            watchLoading = false;
            reflabel = pull_to_refresh;
            refHeader.visible = false;
            refHeader.preferredHeight = 0;
            refHeader.visible = true;
        }
    }
    ActivityIndicator {
        horizontalAlignment: HorizontalAlignment.Center
        running: loadingInProgress
        visible: loadingInProgress
    }
    Label {
        text: pull_to_refresh
        horizontalAlignment: HorizontalAlignment.Center
        id: reflabel
    }
    attachedObjects: [
        LayoutUpdateHandler {
            id: refreshhandler
            onLayoutFrameChanged: {
                if (! loading) {
                    if (! refreshcooked && layoutFrame.y > pullThreshold) {
                        refimage.rotationZ = 180;
                        refreshcooked = true;
                        reflabel.text = release_to_refresh
                    } else if (refreshcooked && layoutFrame.y < pullThreshold) {
                        refimage.rotationZ = 0;
                        refreshcooked = false;
                        reflabel.text = pull_to_refresh
                    }
                }
            }
        }
    ]
    horizontalAlignment: HorizontalAlignment.Fill
    function onlistviewTouch(event) {
        if (! loading) {
            refHeader.resetPreferredHeight();
            if (event.touchType == TouchType.Up && refreshcooked) {
                refimage.rotationZ = 0;
                refreshcooked = false;
//                reflabel.text = refreshing
                triggerRefresh()
                watchLoading = true;
            }
        }
    }
}
