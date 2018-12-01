using Toybox.WatchUi;

class MenuDelegate extends WatchUi.BehaviorDelegate {
    var openNotificationsCB;
    var readAllCB;
    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() {
        var menu = new WatchUi.Menu();
        var delegate;
        menu.setTitle(WatchUi.loadResource(Rez.Strings.MenuOperations));
        menu.addItem(WatchUi.loadResource(Rez.Strings.MenuOpenOnPhone), :open_notifications);
        menu.addItem(WatchUi.loadResource(Rez.Strings.MenuMarkAllAsRead), :read_all);
        menu.addItem(WatchUi.loadResource(Rez.Strings.MenuStartOAuth), :start_oauth);
        delegate = new MenuInputDelegate(openNotificationsCB, readAllCB); // a WatchUi.MenuInputDelegate
        WatchUi.pushView(menu, delegate, WatchUi.SLIDE_IMMEDIATE);
        return true;
    }
}

class MenuInputDelegate extends WatchUi.MenuInputDelegate {
    var openNotificationsCB;
    var readAllCB;
    function initialize(onOpenNotifications, onReadAll) {
        openNotificationsCB = onOpenNotifications;
        readAllCB = onReadAll;
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item) {
        if (item == :open_notifications) {
            System.println("Open notifications");
            if (openNotificationsCB!=null) {
                openNotificationsCB.invoke();
            }
        } else if (item == :read_all) {
            System.println("Mark all as read");
            if (readAllCB!=null) {
                readAllCB.invoke();
            }
        } else if (item == :start_oauth) {
            System.println("Start OAuth");
            Application.getApp().startOauth();
        }
    }
}