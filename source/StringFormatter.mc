class StringFormatter {

    static function cap(str, len) {
        if (str.length()>len) {
            return str.substring(0, len) + "...";
        }
        return str;
    }

}