import bb.cascades 1.2
import org.labsquare 1.0
Container {
    signal profilePressed(string uid)
    property variant navroot
    property string icon
    property int age
    property string astrology
    property string gender
    property string login
    property string relationship
    property string uid

    gestureHandlers: TapHandler {
        onTapped: {
            profilePressed(uid);
        }
    }
    function getUserIcon(uid, icon) {
        //http://pic.qiushibaike.com/system/avtnew/553/5532615/medium/20150210165740.jpg
        if (uid.length < 1 || ! icon || icon.length < 1) return "asset:///res/default_user_avatar.png"

        var base = "http://pic.qiushibaike.com/system/avtnew/"
        base += uid.substring(0, uid.length - 4);
        base = base + "/" + uid + "/medium/" + icon;
        console.log("[AVATAR]: " + base)
        return base;
    }
    property string iconurl: getUserIcon(uid, icon)

    layout: StackLayout {
        orientation: LayoutOrientation.LeftToRight

    }
    topPadding: 10.0
    bottomPadding: 10.0
    leftPadding: 10.0
    rightPadding: 10.0
    WebImageView {
        preferredWidth: 120.0
        preferredHeight: 120.0
        url: iconurl

        verticalAlignment: VerticalAlignment.Center
    }
    Container {
        leftPadding: 10.0
        verticalAlignment: VerticalAlignment.Center
        Label {
            text: login
            textStyle.fontWeight: FontWeight.W100
            textStyle.fontSize: FontSize.Large
        }
        Container {
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
            Label {
                textStyle.fontWeight: FontWeight.W100
                textStyle.fontSize: FontSize.Small
                text: gender
            }
            Label {
                text: age
                textStyle.fontWeight: FontWeight.W100
                textStyle.fontSize: FontSize.Small
            }
            Label {
                text: astrology
                textStyle.fontWeight: FontWeight.W100
                textStyle.fontSize: FontSize.Small
            }
        }
        layoutProperties: StackLayoutProperties {
            spaceQuota: 1
        }
    }
    Label {
        text: relationship
        verticalAlignment: VerticalAlignment.Center
        textStyle.fontWeight: FontWeight.W100
        textStyle.fontSize: FontSize.Small
    }
}
