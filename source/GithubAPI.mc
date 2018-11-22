using Toybox.Application;
using Toybox.Communications;
using Toybox.System;

const GITHUB_SAVE_FORMAT_REV=4;

class GithubAPI {
    hidden var headers = {"Accept" => "application/vnd.github.v3+json"};
    
    function initialize(token) {
        headers["Authorization"] = "token "+token;
    }
    
    function openNotificationOnPhone() {
        Communications.openWebPage(
            "https://github.com/notifications",
            null,
            null
        );
    }
    
    hidden var markAllAsReadCBs = [];
    function markAllAsReadReceiver(status_code, data) {
        var cb = markAllAsReadCBs[0];
        markAllAsReadCBs.remove(cb);
        if (status_code == 205) {
            cb.invoke(true, status_code);
        } else {
            cb.invoke(false, status_code);
        }
    }
    
    function markAllAsRead(cb) {
       var url = "https://api.github.com/notifications";                         // set the url

       var options = {                                             // set the options
           :method => Communications.HTTP_REQUEST_METHOD_PUT,      // set HTTP method
           :headers => headers,
           //:context => cb,
       };

                                                                   // onReceive() method
       Communications.makeWebRequest(url, null, options, method(:markAllAsReadReceiver));
       markAllAsReadCBs.add(cb);
    }
    
    hidden var getNotificationCBs = [];
    function getNotificationsReceiver(status_code, data) {
        var cb = getNotificationCBs[0];
        getNotificationCBs.remove(cb); 
        System.println(status_code);
        if (status_code == 200) {
            var lastResult = Application.getApp().getProperty("lastGithubResult");
            var res = (lastResult!=null && lastResult.get("version")==GITHUB_SAVE_FORMAT_REV)?lastResult["data"] : [];
            var latest = null;
            System.println("Got "+data.size()+" notifications.");
            for (var i=0;i<data.size();i++) {
                var updateTime = TimeHelper.parseISO(data[i]["updated_at"]);
                if (latest==null || TimeHelper.isLaterThan(updateTime, latest)==1) {
                    latest = updateTime;
                }
                if (data[i]["unread"]) {
                    var found = false;
                    for (var j=0;j<res.size();j++) {
                        if (res[j]["id"].equals(data[i]["id"])) {
                            found = true;
                        }
                    }
                    if (!found) {
                        res.add({
                            "reason"  => data[i]["reason"],
                            "id"      => data[i]["id"],
                            "unread"  => data[i]["unread"],
                            "url"     => data[i]["url"],
                            "title"   => data[i]["subject"]["title"],
                            "type"    => data[i]["subject"]["type"],
                            "repo"    => data[i]["repository"]["full_name"],
                        });
                    }
                } else {
                    for (var i=0;i<res.size();i++) {
                        if (res[i]["id"].equals(data[i]["id"])) {
                            res.remove(res[i]);
                            continue;
                        }
                    }
                }
            }
            /*
            var save = {
                "modified" => latest==null ? TimeHelper.formatISO(TimeHelper.nowutc()): TimeHelper.formatISO(latest),
                "version" => GITHUB_SAVE_FORMAT_REV,
                "data" => res,
            };
            Application.getApp().setProperty("lastGithubResult", save);
            */
            cb.invoke(true, res);
        } else if (status_code == 304) {
            var save = Application.getApp().getProperty("lastGithubResult");
            cb.invoke(true, save["data"]);
        } else {
            cb.invoke(false, status_code);
        }
    }
    
    function getNotifications(cb) {
       var url = "https://api.github.com/notifications";                         // set the url
       var this_header;
       var lastResult = Application.getApp().getProperty("lastGithubResult");
       if (lastResult!=null && lastResult.get("version")==GITHUB_SAVE_FORMAT_REV) {
           this_header = {};
           var header_keys = headers.keys();
           for (var i=0;i<header_keys.size();i++) {
               this_header[header_keys[i]] = headers[header_keys[i]];
           }
           this_header["If-Modified-Since"] = TimeHelper.formatLastModifiedHeader(TimeHelper.parseISO(lastResult["modified"]));
       } else {
           this_header = headers;
       }
       var options = {                                             // set the options
           :method => Communications.HTTP_REQUEST_METHOD_GET,      // set HTTP method
           :headers => this_header,
           //:context => cb, // for 1.x compatibility
       };

                                                                   // onReceive() method
       Communications.makeWebRequest(url, null, options, method(:getNotificationsReceiver));
       getNotificationCBs.add(cb);
    }

}