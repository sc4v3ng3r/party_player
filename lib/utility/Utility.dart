class Utility {

  static const String TAG_HERO_SPLASH_LOGO = "splashLogoTag";



  static String parseToMinutesSeconds(final Duration duration) {
    String data;

    int minutes = duration.inMinutes;
    int seconds = (duration.inSeconds) - (minutes * 60);

    data = minutes.toString() + ":";
    if (seconds <= 9) data += "0";

    data += seconds.toString();
    return data;
  }
}