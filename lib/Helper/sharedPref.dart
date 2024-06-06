import 'package:shared_preferences/shared_preferences.dart';

///sahrepref const
final ID = "She_ID";
final TOKEN = "She-TOKEN";
final COUNT = "count";
final CATID = "catid";
final PRICELOW = "low";
final PRICEHIGH = "high";
final RATING = "rating";
final COUPON = "coupon";

Future setSharedPrefrence(key, data) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(key, data);
}

Future getSharedPrefrence(key) async {
  var prefs = await SharedPreferences.getInstance();
  var value = prefs.getString(key);

  return value;
}
