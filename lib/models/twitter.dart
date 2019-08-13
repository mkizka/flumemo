import 'package:flutter/material.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TwitterModel extends ChangeNotifier {
  String token;
  String secret;

  Future<void> login() async {
    await DotEnv().load('.env');

    var twitterLogin = new TwitterLogin(
      consumerKey: DotEnv().env['TWITTER_KEY'],
      consumerSecret: DotEnv().env['TWITTER_SECRET'],
    );

    final TwitterLoginResult result = await twitterLogin.authorize();

    switch (result.status) {
      case TwitterLoginStatus.loggedIn:
        token = result.session.token;
        secret = result.session.secret;
        break;
      case TwitterLoginStatus.cancelledByUser:
        print('canceled');
        break;
      case TwitterLoginStatus.error:
        print(result.errorMessage);
        break;
    }
  }
}
