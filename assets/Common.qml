import bb.cascades 1.2

QtObject {
    function ajax(method, endpoint, paramsArray, callback, customheader, form) {
        var request = new XMLHttpRequest();
        request.onreadystatechange = function() {
            if (request.readyState === XMLHttpRequest.DONE) {
                if (request.status === 200) {
                    console.log("[AJAX]Response = " + request.responseText);
                    callback({
                            "success": true,
                            "data": request.responseText
                        });
                } else {
                    console.log("[AJAX]Status: " + request.status + ", Status Text: " + request.statusText);
                    callback({
                            "success": false,
                            "data": request.statusText
                        });
                }
            }
        };
        var params = paramsArray.join("&");
        var url = endpoint;
        if (method == "GET" && params.length > 0) {
            url = url + "?" + params;
        }
        request.open(method, url, true);
        if (form) {
            request.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        }
        request.setRequestHeader("Model", "BLACKBERRY 10 DEVICES");
//        request.setRequestHeader("Source", "BLACKBERRY_2.0.15");
        var token = _app.getv('token', '');
        if (token.length > 0) {
            request.setRequestHeader("Qbtoken", token);
        }
        if (customheader) {
            for (var i = 0; i < customheader.length; i ++) {
                request.setRequestHeader(customheader[i].k, customheader[i].v);
            }
        }
        if (method == "GET") {
            request.send();
        } else {
            request.send(params);
        }
    }

    property string uid: Qt.md5("anpho.blackberry10.qiushibaike").toString()
    property string uuid: "IMEI_" + Qt.md5("anpho.blackberry10.qiushibaike").toString()
    onCreationCompleted: {
        console.log("[QML]Common.qml loaded.")
    }

    property string u_suggest: "http://m2.qiushibaike.com/article/list/suggest?"
    property string u_video: "http://m2.qiushibaike.com/article/list/video?"
    property string u_text: "http://m2.qiushibaike.com/article/list/text?"
    property string u_image: "http://m2.qiushibaike.com/article/list/imgrank?"
    property string u_latest: "http://m2.qiushibaike.com/article/list/latest?"
    property string u_mainpage :"http://m2.qiushibaike.com/mainpage/list?"
        
    property string u_my_posts:"http://m2.qiushibaike.com/user/my/articles?"
    property string u_my_fav:"http://m2.qiushibaike.com/collect/list?"
    property string u_my_part :"http://m2.qiushibaike.com/user/my/participate?"
    
    property string u_dayrank :"http://m2.qiushibaike.com/article/list/day?"
    property string u_weekrank :"http://m2.qiushibaike.com/article/list/week?"
    property string u_month:"http://m2.qiushibaike.com/article/list/month?"
    
    property string u_comments: "http://m2.qiushibaike.com/article/%aid%/comments?"
    property string param_login: '{"login":"%username%","pass":"%password%"}'
    //登录
    function login(username, password, callback) {
        var param = param_login.replace("%username%", username).replace("%password%", password);
        ajax("POST", "http://m2.qiushibaike.com/user/signin", [ param ], function(r) {
                if (r['success']) {
                    var logindata = JSON.parse(r['data']);
                    if (logindata.err > 0) {
                        //登录失败，返回失败信息
                        callback(false, logindata.err_msg)
                    } else {
                        //登录成功，返回登录数据
                        callback(true, logindata)
                    }
                } else {
                    callback(false, qsTr("Network Error."))
                }
            }, [], true)
    }
    //评论
    property string u_comment: "http://m2.qiushibaike.com/article/%aid%/comment/create"
    property string param_comment: '{"content":"%c%","anonymous":%b%}' //c:content ; b: true/false
    function comment(aid, comment, anonymous, callback) {
        var token = _app.getv('token', '');
        if (token.length == 0) {
            callback(false, qsTr("Need Login."));
            return;
        }
        var p = {
        };
        p.content = comment;
        p.anonymous = anonymous;
        p = JSON.stringify(p);
        var endpoint = u_comment.replace("%aid%", aid);
        ajax("POST", endpoint, [ p ], function(r) {
                if (r['success']) {
                    var result = JSON.parse(r['data']);
                    if (result.err > 0) {
                        //登录失败，返回失败信息
                        callback(false, result.err_msg)
                    } else {
                        //登录成功，返回登录数据
                        callback(true, result)
                    }
                } else {
                    callback(false, qsTr("Network Error."))
                }
            }, [], true)
    }

    // 发新糗事
    property string u_createArticle: "http://m2.qiushibaike.com/article/create?imgsrc=-1&from_topic=0"

    function genCreateArticleParams(callback, content, anonymous, displayGeo, lat, lon, city, district, imgsrc, imagetype, imagewidth, imageheight, fromtopic) {
        var token = _app.getv('token', '');
        if (token.length == 0) {
            callback(false, qsTr("Need Login."));
            return;
        }
        // 生成参数列表
        var p = {
        };
        p.content = content;
        p.anonymous = anonymous;
        if (displayGeo) {
            p.display = 1;
            p.city = city;
            p.district = district;
            p.latitude = lat;
            p.longitude = lon;
        }
        if (imgsrc) {
            p.image_type = imagetype;
            p.image_width = imagewidth;
            p.image_height = imageheight;
        }
        p = JSON.stringify(p);
        console.debug(p);
        //生成URL
        var endpoint = u_createArticle;
        if (imgsrc) {
            endpoint.replace("-1", imgsrc);
        }
        if (fromtopic) {
            endpoint.replace("topic=0", "topic=" + fromtopic)
        }

        callback(endpoint, p)
    }
}
