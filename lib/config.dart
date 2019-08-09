import 'package:shared_preferences/shared_preferences.dart';

class Config {
  SharedPreferences _prefs;
  double strokeWidth = 1;

  Future<Config> init() async {
    await SharedPreferences.getInstance().then((SharedPreferences prefs) {
      strokeWidth = prefs.getDouble('strokeWidth') ?? strokeWidth;
      _prefs = prefs;
    });
    return this;
  }

  void save() {
    _prefs.setDouble('strokeWidth', strokeWidth);
  }
}

Config config = Config();
