using Toybox.WatchUi;
using Toybox.Application;
using Toybox.System;
using Toybox.Timer;
using Toybox.Attention;
using Toybox.Lang;

class MainView extends WatchUi.View {
    var githubNotificationIcon;
    var githubAPI;
    var views = [];
    function initialize(api) {
        githubNotificationIcon = new GithubNotificationIcon({
            :offsetX => 0,
            :offsetY => 0,
            :count => "...",
        });
        githubAPI = api;
        views = [githubNotificationIcon];
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
        updateNotifications();
    }
    
    hidden var progress = null;
    function startBusy(msg) {
        if (progress!=null) {
            return;
        }
        progress = new WatchUi.ProgressBar(msg, null);
        WatchUi.pushView(progress, null, WatchUi.SLIDE_DOWN);
    }
    
    function stopBusyNow() {
        if (progress==null) {
            return;
        }
        WatchUi.popView(WatchUi.SLIDE_UP);
        progress = null;
    }
    
    function stopBusy(success, msg) {
        progress.setDisplayString(msg);
        if (Attention has :vibrate) {
            Attention.vibrate([new Attention.VibeProfile(50, 500)]);
        }
        var timer = new Timer.Timer();
        timer.start(method(:stopBusyNow), 2000, false);
    }
    
    function updateNotifications() {
        githubNotificationIcon.updateCount("...");
        var i=0;
        while (i<views.size()) {
            var view = views[i];
            if (view instanceof NotificationList || view instanceof ErrorDisplay) {
                views.remove(view);
            } else {
                i++;
            }
        }
        WatchUi.requestUpdate();
        if (Application.getApp().getProperty("githubAccessToken").equals("not_entered")) {
            getNotifications(false, 401);
        } else {
            githubAPI.getNotifications(method(:getNotifications));
        }
    }
    
    function getNotifications(success, data) {
        if (success) {
            githubNotificationIcon.updateCount(data.size());
            views.add(new NotificationList({
                :offsetY => 73,
                :data => data,
            }));
            WatchUi.requestUpdate();
        } else if (data instanceof Lang.Number) {
            switch (data) {
                case 401:
                    githubNotificationIcon.updateCount("X");
                    displayError((Application.getApp().getProperty("githubAccessToken").equals("not_entered")) ?  WatchUi.loadResource(Rez.Strings.ErrTokenNotSet): WatchUi.loadResource(Rez.Strings.ErrUnauthorized));
                    break;
                case 403:
                    githubNotificationIcon.updateCount("X");
                    displayError(WatchUi.loadResource(Rez.Strings.ErrRateLimitExceeded));
                    break;
                case -402:
                    githubNotificationIcon.updateCount("++");
                    displayError(WatchUi.loadResource(Rez.Strings.ErrTooManyNotifications));
                    break;
                case -1:
                case -2:
                case -3:
                case -4:
                case -5:
                case -101:
                case -102:
                case -103:
                    githubNotificationIcon.updateCount("X");
                    displayError(WatchUi.loadResource(Rez.Strings.ErrBLEError)+" Code="+data);
                    break;
                case -104:
                    githubNotificationIcon.updateCount("?");
                    displayError(WatchUi.loadResource(Rez.Strings.ErrBLEUnavail));
                    break;
                default:
                    githubNotificationIcon.updateCount("X");
                    displayError(WatchUi.loadResource(Rez.Strings.ErrUnknown)+" Code="+data);
                    break;
            }
        }
    }
    
    function displayError(msg) {
        var i=0;
        while (i<views.size()) {
            var view = views[i];
            if (view instanceof ErrorDisplay) {
                views.remove(view);
            } else {
                i++;
            }
        }
        var err = new ErrorDisplay({
            :msg => msg,
            :offsetY => -60,
        });
        views.add(err);
        WatchUi.requestUpdate();
    }

    // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        for (var i=0;i<views.size();i++) {
            views[i].draw(dc);
        }
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

}
