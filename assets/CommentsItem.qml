import bb.cascades 1.2
import org.labsquare 1.0
Container {
    signal profilePressed(string userid)
    property string s_floor: ""
    property string s_username: ""
    property string s_comment: ""
    property string s_useravator: ""
    property string s_userid: ""
    property string s_commentid: ""

    layout: StackLayout {
        orientation: LayoutOrientation.LeftToRight

    }

    function getUserIcon() {
        //http://pic.qiushibaike.com/system/avtnew/553/5532615/medium/20150210165740.jpg
        if (s_useravator == "" || s_userid == "") return ""

        var base = "http://pic.qiushibaike.com/system/avtnew/"
        base += s_userid.substring(0, s_userid.length - 4);
        base = base + "/" + s_userid + "/medium/" + s_useravator;
        return base;
    }

    topPadding: 20.0
    leftPadding: 20.0
    bottomPadding: 20.0
    rightPadding: 20.0
    WebImageView {
        preferredHeight: 100
        preferredWidth: 100
        onCreationCompleted: {
            var uicon = getUserIcon();
            if (uicon.length > 0) {
                url = uicon
            } else {
                imageSource = "asset:///res/default_user_avatar.png"
            }
        }
        gestureHandlers: TapHandler {
            onTapped: {
                profilePressed(s_userid)
            }
        }
        verticalAlignment: VerticalAlignment.Center
    }
    Container {
        layoutProperties: StackLayoutProperties {
            spaceQuota: 10.0
        }
        leftPadding: 20.0
        rightPadding: 20.0
        verticalAlignment: VerticalAlignment.Center
        Label {
            text: s_username
            textStyle.fontSize: FontSize.Small
            textStyle.fontWeight: FontWeight.W100
        }
        Label {
            text: s_comment
            multiline: true
            textStyle.fontWeight: FontWeight.W100
        }
    }
    Container {
        layout: DockLayout {

        }
        verticalAlignment: VerticalAlignment.Center
        Label {
            text: s_floor
            verticalAlignment: VerticalAlignment.Top
            horizontalAlignment: HorizontalAlignment.Right
            textStyle.fontSize: FontSize.XSmall
        }
    }
}
