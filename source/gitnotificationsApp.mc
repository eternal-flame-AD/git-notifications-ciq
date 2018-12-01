using Toybox.Application;
using Toybox.System;
using Toybox.WatchUi;
using Toybox.Communications;
using Toybox.Timer;

class gitnotificationsApp extends Application.AppBase {
    var githubAPI;
    var mainView;
    function initialize() {
        var token = Application.getApp().getProperty("githubAccessToken");
        githubAPI = new GithubAPI(token);
        Communications.registerForOAuthMessages(method(:receiveCode));
        AppBase.initialize();
        System.println("UTC Now is: "+ TimeHelper.formatISO(TimeHelper.nowutc()));
    }
    
    function receiveToken(success, code) {
        if (success) {
            githubAPI.updateToken(code);
            Application.getApp().setProperty("githubAccessToken", code);
            mainView.stopBusy(true, WatchUi.loadResource(Rez.Strings.SuccessOauth));
            mainView.updateNotifications();
        } else {
            mainView.stopBusy(false, WatchUi.loadResource(Rez.Strings.ErrOauthExchange));
        }
    }
    
    var oAuthCodeReceived = false;
    function receiveCode(message) {
        if (message.data != null && message.data.hasKey("code")) {
            var code = message.data["code"];
            System.println("Got code: " + code);
            githubAPI.exchangeOAuthCodeForToken(code, method(:receiveToken));
        } else {
            System.println(message.responseCode);
            mainView.stopBusy(false, WatchUi.loadResource(Rez.Strings.ErrOauthCode));
        }
    }

    // onStart() is called on application start up
    function onStart(state) {
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }
    
    function openNotifications() {
        githubAPI.openNotificationOnPhone();
    }
    
    function markAllAsReadReceiver(success, code) {
        System.println("Success: "+success+" Code: "+code);
        if (!success) {
            mainView.stopBusy(false, WatchUi.loadResource(Rez.Strings.ErrMarkAllAsRead));
        } else {
            mainView.stopBusy(true, WatchUi.loadResource(Rez.Strings.SuccessMarkAllAsRead));
        }
        mainView.updateNotifications();
    }
    
    function markAllAsRead() {
        mainView.startBusy(WatchUi.loadResource(Rez.Strings.ProgMarkAll));
        githubAPI.markAllAsRead(method(:markAllAsReadReceiver));
    }
    
    function startOauth() {
        GithubAPI.startOAuth();
        mainView.startBusy(WatchUi.loadResource(Rez.Strings.ProgOauth));
    }
    
    function checkStartOauth() {
        var token = Application.getApp().getProperty("githubAccessToken");
        if (token.equals("not_entered") && !oAuthCodeReceived) {
            startOauth();
        }
    }

    // Return the initial view of your application here
    function getInitialView() {
        var menu = new MenuDelegate();
        menu.readAllCB = method(:markAllAsRead);
        menu.openNotificationsCB = method(:openNotifications);
        mainView = new MainView(githubAPI);
        var timer = new Timer.Timer();
        timer.start(method(:checkStartOauth),1000,false);
        return [ mainView,  menu ];
    }

}