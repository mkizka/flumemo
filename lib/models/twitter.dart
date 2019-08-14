import 'package:flutter/material.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:oauth1/oauth1.dart' as oauth1;

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

  Future<oauth1.Client> getClient() async {
    await DotEnv().load('.env');

    var consumerCredentials = oauth1.ClientCredentials(
      DotEnv().env['TWITTER_KEY'],
      DotEnv().env['TWITTER_SECRET'],
    );

    var accessTokenCredentials = oauth1.Credentials(
      token,
      secret,
    );

    return oauth1.Client(
      oauth1.SignatureMethods.hmacSha1,
      consumerCredentials,
      accessTokenCredentials,
    );
  }
}
