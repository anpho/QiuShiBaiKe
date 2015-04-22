import bb.cascades 1.2
import org.labsquare 1.0
Container {
    //点击标题
    signal userprofileTriggered(string id)
    signal supportTriggered(string postid)
    signal unsupportTriggered(string postid)
    signal commentsTriggered(string postid)
    signal postTouched(string postid)
    
    property string s_postid : null     //糗事ID
    property int d_date: 0                 //发布时间
    property string s_tag:null            //标签
    property string s_state:null          //状态
    
    property string s_username : null    //用户名
    property string s_userid : null         //用户ID
    property string s_usericon : null      //用户头像
    
    property string s_imageurl : null     //图片URL
    property variant  s_imagesize : null    //图片大小
    /*
     * image_size: {
     s: (3)[
     220,
     69,
     4702
     ], m: (3)[
     500,
     156,
     33637
     ]
     },
     */
    
    property int d_votedown : 0            //不好笑
    property int d_voteup : 0                //好笑
    property int d_comments : 0            //评论数
    
    property string content : null            //内容
    property bool allowcomment : true    //允许评论
    
    
    
    leftPadding: 20.0
    rightPadding: 20.0
    topPadding: 20.0
    bottomPadding: 20.0
    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight
        }
        WebImageView {
            imageSource: "http://pic.qiushibaike.com/system/avtnew/1623/16230413/medium/20140513210414.jpg"
            preferredWidth: 80
            preferredHeight: 80
            scalingMethod: ScalingMethod.AspectFit
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Left
            loadEffect: ImageViewLoadEffect.Subtle
        }
        Label {
            text: qsTr("大王叫我来巡山")
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Left
        }
    }
    Divider {
        verticalAlignment: VerticalAlignment.Center
        horizontalAlignment: HorizontalAlignment.Center

    }
    Container {
        Label {
            multiline: true
            textFormat: TextFormat.Plain
            text: "我们经理平时是个很厉害妹子，今天玩糗百被他发现，紧张要死…\r\n没有想到她也是组织的人，她说让我发一条，过500加薪带走，不过扣我奖金…\r\n各位朋友多支持，附经理照片一张，过了拿下……"
            textStyle.fontWeight: FontWeight.W100
            textFit.mode: LabelTextFitMode.Default
        }
        Container {
            layout: DockLayout {
                
            }
            horizontalAlignment: HorizontalAlignment.Fill
            
            WebImageView {
                horizontalAlignment: HorizontalAlignment.Fill
                scalingMethod: ScalingMethod.AspectFit
                loadEffect: ImageViewLoadEffect.FadeZoom
                imageSource: "http://pic.qiushibaike.com/system/pictures/10504/105049406/medium/app105049406.jpg"
            }
            
        }
    }
    Container {
        //Status Data
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight
        }
        topPadding: 20.0
        bottomPadding: 20.0
        Label {
            text: qsTr("好笑")
        }
        Label {
            text: d_voteup
            textStyle.fontWeight: FontWeight.W100
        }
        Label {
            text: "评论"
        }
        Label {
            text: d_comments
            textStyle.fontWeight: FontWeight.W100
        }
    }
    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight

        }
       ImageButton {
            defaultImageSource: "asset:///res/operation_support_night.png"
            pressedImageSource: "asset:///res/operation_support_press.png"
            preferredWidth: 120.0
            preferredHeight: 120.0
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Left
        }
       ImageButton {
            defaultImageSource: "asset:///res/operation_unsupport_night.png"
            pressedImageSource: "asset:///res/operation_unsupport_press.png"
            preferredWidth: 120.0
            preferredHeight: 120.0
        }
       ImageButton {
            defaultImageSource: "asset:///res/operation_comments_night.png"
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center
            preferredWidth: 120.0
            preferredHeight: 120.0

        }
    }
}
