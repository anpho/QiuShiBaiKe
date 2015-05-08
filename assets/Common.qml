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
    
    
    property string u_comments :"http://m2.qiushibaike.com/article/%aid%/comments?"
}
