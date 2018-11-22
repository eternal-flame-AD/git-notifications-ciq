using Toybox.WatchUi as Ui;
using Toybox.System;
using Toybox.Graphics;
using Toybox.Application;

class GithubNotificationIcon extends Ui.Drawable {

    hidden var mCount, mOffsetX, mOffsetY;
    hidden var textOffsetX, textOffsetY;
    hidden var githubIcon;

    function initialize(params) {
        Drawable.initialize(params);

        githubIcon = Ui.loadResource(Rez.Drawables.github_logo);
        textOffsetX = Application.getApp().getProperty("notification_number_x_offset"); textOffsetY = Application.getApp().getProperty("notification_number_y_offset");

        mCount = params.get(:count);
        if (mCount==null) {
            mCount = "?";
        }
        mOffsetX = params.get(:offsetX);
        if (mOffsetX==null) {
            mOffsetX = 0;
        }
        mOffsetY = params.get(:offsetY);
        if (mOffsetY==null) {
            mOffsetY = 0;
        }
    }
    
    function updateCount(count) {
        mCount = count;
    }
    
    function drawAt(x, y, dc) {
        dc.drawBitmap(x-32, y+15, githubIcon);
        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(x+20, y+15, 12);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x+21+textOffsetX, y+4+textOffsetY, Graphics.FONT_TINY, mCount, Graphics.TEXT_JUSTIFY_CENTER);
    }
    
    function draw(dc) {
        var width = dc.getWidth();
        drawAt(width/2+mOffsetX, mOffsetY, dc);
    }
}