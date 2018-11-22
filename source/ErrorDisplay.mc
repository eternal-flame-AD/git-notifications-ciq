using Toybox.WatchUi as Ui;
using Toybox.System;
using Toybox.Graphics;
using Toybox.Application;

class ErrorDisplay extends Ui.Drawable {

    hidden var mMsg, mOffsetX, mOffsetY;

    function initialize(params) {
        Drawable.initialize(params);

        mMsg = params.get(:msg);
        if (mMsg==null) {
            mMsg = "Error";
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
    
    function draw(dc) {
        dc.drawText(dc.getWidth()/2+mOffsetX, dc.getHeight()+mOffsetY, Graphics.FONT_SMALL, mMsg, Graphics.TEXT_JUSTIFY_CENTER);
    }
}