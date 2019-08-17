import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:oauth1/oauth1.dart' as oauth1;
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class TwitterModel extends ChangeNotifier {
  SharedPreferences _prefs;

  String consumerKey;
  String consumerSecret;

  String get accessToken => _prefs.getString('accessToken') ?? '';

  set accessToken(String value) => _prefs.setString('accessToken', value);

  String get accessSecret => _prefs.getString('accessSecret') ?? '';

  set accessSecret(String value) => _prefs.setString('accessSecret', value);

  String get username => _prefs.getString('usernmae') ?? '';

  set username(String value) => _prefs.setString('accessSecret', value);

  String get userId => _prefs.getString('userId') ?? '';

  set userId(String value) => _prefs.setString('userId', value);

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
    if (isAuthenticated) return;

    var twitterLogin = new TwitterLogin(
      consumerKey: consumerKey,
      consumerSecret: consumerSecret,
    );

    final TwitterLoginResult result = await twitterLogin.authorize();

    switch (result.status) {
      case TwitterLoginStatus.loggedIn:
        accessToken = result.session.token;
        accessSecret = result.session.secret;
        userId = result.session.userId;
        username = result.session.username;
        break;
      case TwitterLoginStatus.cancelledByUser:
        throw Exception('ログインがキャンセルされました');
        break;
      case TwitterLoginStatus.error:
        throw Exception('ログイン処理でエラーが発生しました');
        break;
    }
  }

  void logout() {
    accessToken = null;
    accessSecret = null;
    username = null;
    userId = null;
    notifyListeners();
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

  Future<TweetResult> tweet(String text, File file) async {
    String baseUrl = 'https://upload.twitter.com/1.1/media/upload.json';

    var response = await client.post(baseUrl, body: {
      'command': 'INIT',
      'total_bytes': file.lengthSync().toString(),
      'media_type': 'image/gif',
    });
    if (!TweetResult(response).isSuccess) return TweetResult(response);

    String mediaId = jsonDecode(response.body)['media_id_string'];

    var request = http.MultipartRequest('POST', Uri.parse(baseUrl));
    request.fields['command'] = 'APPEND';
    request.fields['media_id'] = mediaId;
    request.fields['segment_index'] = '0';
    request.files.add(await http.MultipartFile.fromPath(
      'media',
      file.path,
      contentType: MediaType('multipart', 'form-data'),
    ));
    var response2 = await client.send(request);
    if (!TweetResult(response2).isSuccess) return TweetResult(response2);

    var response3 = await client.post(baseUrl, body: {
      'command': 'FINALIZE',
      'media_id': mediaId,
    });
    if (!TweetResult(response3).isSuccess) return TweetResult(response3);

    var response4 = await client.post(
      'https://api.twitter.com/1.1/statuses/update.json',
      body: {
        'status': text,
        'media_ids': mediaId,
      },
    );
    return TweetResult(response4);
  }
}

class TweetResult {
  final http.BaseResponse response;

  bool get isSuccess {
    return 200 <= response.statusCode && response.statusCode <= 299;
  }

  TweetResult(this.response);
}
