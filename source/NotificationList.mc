using Toybox.WatchUi as Ui;
using Toybox.System;
using Toybox.Graphics;
using Toybox.Application;

class NotificationList extends Ui.Drawable {

    hidden var mData, mOffsetX, mOffsetY;

    function initialize(params) {
        // You should always call the parent's initializer and
        // in this case you should pass the params along as size
        // and location values may be defined.
        Drawable.initialize(params);

        // Get any extra values you wish to use out of the params Dictionary
        mData = params.get(:data);
        if (mData==null) {
            mData = [{
                "type"=> "Commit",
                "repo"=>"github/hello-world",
                "title"=>"Just A Very Very Very Very Very Very Long PR Description",
            }];
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
        var height = dc.getHeight();
        var width = dc.getWidth();
        var yRef = mOffsetY;
        var xRef = 20;
        
        dc.drawText(20, yRef, Graphics.FONT_SYSTEM_XTINY, "Type", Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawText(55, yRef, Graphics.FONT_SYSTEM_XTINY, "Repo", Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawText(120, yRef, Graphics.FONT_SYSTEM_XTINY, "Title", Graphics.TEXT_JUSTIFY_LEFT);
        yRef += 20;
        dc.drawLine(width*0.1, yRef, width*0.9, yRef);
        for (var i=0;i<mData.size();i++) {
            //yRef += 20;
            var type;
            switch (mData[i]["type"]){
                case "PullRequest":
                    type = "PR";
                    break;
                case "Issue":
                    type = "ISH";
                    break;
                case "Commit":
                    type = "CMIT";
                    break;
                default:
                    type = mData[i]["type"];
            }
            dc.drawText(20, yRef, Graphics.FONT_SYSTEM_XTINY, StringFormatter.cap(type, 4), Graphics.TEXT_JUSTIFY_LEFT);
            var slashPos = mData[i]["repo"].find("/");
            var repo = StringFormatter.cap(mData[i]["repo"].substring(0, slashPos),1) + "/" + StringFormatter.cap(mData[i]["repo"].substring(slashPos+1, mData[i]["repo"].length()), 4);
            dc.drawText(55, yRef, Graphics.FONT_SYSTEM_XTINY, repo, Graphics.TEXT_JUSTIFY_LEFT);
            dc.drawText(120, yRef, Graphics.FONT_SYSTEM_XTINY, StringFormatter.cap(mData[i]["title"], 12), Graphics.TEXT_JUSTIFY_LEFT);
            yRef += 20;
            dc.drawLine(width*0.1, yRef, width*0.9, yRef);
            if (yRef>height) {
                 break;
            }
        }
    }
}