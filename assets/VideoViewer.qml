import bb.cascades 1.2
import bb.multimedia 1.2

Page {
    function play(u) {
        mp.sourceUrl = u;
        mp.play()
    }
    attachedObjects: [
        MediaPlayer {
            id: mp
            videoOutput: VideoOutput.PrimaryDisplay
            windowId: fwvideo.windowId
            onMediaStateChanged: {
                if (mediaState == MediaState.Started) {
                } else if (mediaState == mediaState.Stopped) {
                }
            }
        }
    ]
    Container {
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        ForeignWindowControl {
            id: fwvideo
            windowId: "anpho's video surface"
            visible: boundToWindow
            updatedProperties: WindowProperty.Size | WindowProperty.Position | WindowProperty.Visible
            verticalAlignment: VerticalAlignment.Fill
            horizontalAlignment: HorizontalAlignment.Fill
        }
    }
    actions: [
    ]
}
