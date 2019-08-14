import 'package:flutter/material.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:oauth1/oauth1.dart' as oauth1;

class TwitterModel extends ChangeNotifier {
  SharedPreferences _prefs;

  String consumerKey;
  String consumerSecret;

  String get accessToken => _prefs.getString('accessToken') ?? '';

  set accessToken(String value) => _prefs.setString('accessToken', value);

  String get accessSecret => _prefs.getString('accessSecret') ?? '';

  set accessSecret(String value) => _prefs.setString('accessSecret', value);

  TwitterModel() {
    SharedPreferences.getInstance().then((instance) {
      _prefs = instance;
    });
    DotEnv().load('.env').then((_) {
      consumerKey = DotEnv().env['TWITTER_KEY'];
      consumerSecret = DotEnv().env['TWITTER_SECRET'];
    });
  }

  bool get isAuthenticated {
    return accessToken.isNotEmpty && accessSecret.isNotEmpty;
  }

  Future<void> login() async {
    var twitterLogin = new TwitterLogin(
      consumerKey: consumerKey,
      consumerSecret: consumerSecret,
    );

    final TwitterLoginResult result = await twitterLogin.authorize();

    switch (result.status) {
      case TwitterLoginStatus.loggedIn:
        accessToken = result.session.token;
        accessSecret = result.session.secret;
        break;
      case TwitterLoginStatus.cancelledByUser:
        print('canceled');
        break;
      case TwitterLoginStatus.error:
        print(result.errorMessage);
        break;
    }
  }

  oauth1.Client get client {
    var consumerCredentials = oauth1.ClientCredentials(
      consumerKey,
      consumerSecret,
    );

    var accessTokenCredentials = oauth1.Credentials(
      accessToken,
      accessSecret,
    );

    return oauth1.Client(
      oauth1.SignatureMethods.hmacSha1,
      consumerCredentials,
      accessTokenCredentials,
    );
  }

  void tweet() {
    client.post(
        'https://api.twitter.com/1.1/statuses/update.json?status=これはDartからのツイート').then((result) {
          print(result.statusCode);
    });
  }
}
