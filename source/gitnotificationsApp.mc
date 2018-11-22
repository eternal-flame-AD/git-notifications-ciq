using Toybox.Application;
using Toybox.System;
using Toybox.WatchUi;

class gitnotificationsApp extends Application.AppBase {
    var githubAPI;
    var mainView;
    function initialize() {
        githubAPI = new GithubAPI(Application.getApp().getProperty("githubAccessToken"));
        AppBase.initialize();
        System.println("UTC Now is: "+ TimeHelper.formatISO(TimeHelper.nowutc()));
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

    // Return the initial view of your application here
    function getInitialView() {
        var menu = new MenuDelegate();
        menu.readAllCB = method(:markAllAsRead);
        menu.openNotificationsCB = method(:openNotifications);
        mainView = new MainView(githubAPI);
        return [ mainView,  menu];
    }

}