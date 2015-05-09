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

    property string uid: Qt.md5("anpho.blackberry10.qiushibaike")
    property string uuid: "IMEI_" + uid
    onCreationCompleted: {
        console.log("[QML]Common.qml loaded.")
    }

    property string u_suggest: "http://m2.qiushibaike.com/article/list/suggest?"
    property string u_video: "http://m2.qiushibaike.com/article/list/video?"
    property string u_text: "http://m2.qiushibaike.com/article/list/text?"
    property string u_image: "http://m2.qiushibaike.com/article/list/imgrank?"
    property string u_latest: "http://m2.qiushibaike.com/article/list/latest?"
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
        var param = param_comment.replace("%c%", comment).replace("%b%", anonymous);
        var endpoint = u_comment.replace("%aid%", aid);
        ajax("POST", endpoint, [ param ], function(r) {
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
            }, [ {
                    'k': "Qbtoken",
                    'v': token
                } ], true)
    }
}
