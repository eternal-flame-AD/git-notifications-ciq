using Toybox.Lang;
using Toybox.System;
using Toybox.Time.Gregorian as Gre;
using Toybox.Time;

class TimeHelper {

    static function parseISO(str) {
        return {
            :year   => str.substring(0,4).toNumber(),
            :month  => str.substring(5,7).toNumber(),
            :day    => str.substring(8,10).toNumber(),
            :hour   => str.substring(11,13).toNumber(),
            :minute => str.substring(14,16).toNumber(),
            :second => str.substring(17,19).toNumber(),
        };
    }
    
    static function isLaterThan(x, y) {
        var keys = [:year, :month, :day, :hour, :minute, :second];
        for (var i=0;i<keys.size();i++) {
            var delta = x.get(keys[i]) - y.get(keys[i]);
            if (delta>0) {
                return 1;
            } else if (delta<0) {
                return -1;
            }
        }
        return 0;
    }
    
    static function nowutc() {
        var clockTime = System.getClockTime();
        var offset = clockTime.dst + clockTime.timeZoneOffset;
        var info = Gre.info(new Time.Moment(Time.now().value() - offset), Time.FORMAT_SHORT);
        return {
            :year   => info.year,
            :month  => info.month,
            :day    => info.day,
            :hour   => info.hour,
            :minute => info.min,
            :second => info.sec,
        };
    }
    
    static function formatISO(info) {
        return Lang.format(
            "$1$-$2$-$3$T$4$:$5$:$6$Z",
            [
                info[:year].format("%04u"),
                info[:month].format("%02u"),
                info[:day].format("%02u"),
                info[:hour].format("%02u"),
                info[:minute].format("%02u"),
                info[:second].format("%02u"),
            ]
        );
    }
    
    static function formatLastModifiedHeader(info) {
        var gre = Gre.info(Gre.moment(info), Time.FORMAT_MEDIUM);
        
        return Lang.format(
            "$1$, $4$ $3$ $2$ $5$:$6$:$7$ GMT",
            [
                gre.day_of_week,
                info[:year].format("%04u"),
                gre.month,
                info[:day].format("%02u"),
                info[:hour].format("%02u"),
                info[:minute].format("%02u"),
                info[:second].format("%02u"),
            ]
        );
    }
    
}