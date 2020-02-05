import 'dart:async';

import 'package:flutter/services.dart';

class FlutterSocialLogin {
  static const MethodChannel _channel = const MethodChannel('com.baxture.flutter_social_login');

  Future<void> setConfig(SocialConfig socialConfig) {
    return _channel.invokeMethod(
      ChannelMethods.SET_CONFIG,
      socialConfig.toMap(),
    );
  }

  Future<FacebookUser> logInFacebookWithPermissions(List<String> permissions) async {
    final response = await _channel.invokeMethod(
      ChannelMethods.LOGIN_FACEBOOK,
      permissions,
    );
    if (response != null)
      return FacebookUser.fromMap(response);
    else
      return null;
  }

  Future<FacebookUser> getCurrentFacebookUser() async {
    final response = await _channel.invokeMethod(ChannelMethods.GET_CURRENT_USER_FACEBOOK);
    if (response != null)
      return FacebookUser.fromMap(response);
    else
      return null;
  }

  Future<void> logOutFacebook() async {
    return await _channel.invokeMethod(ChannelMethods.LOGOUT_FACEBOOK);
  }

  Future<GoogleUser> logInGoogle() async {
    final response = await _channel.invokeMethod(ChannelMethods.LOGIN_GOOGLE);
    if (response != null)
      return GoogleUser.fromMap(response);
    else
      return null;
  }

  Future<GoogleUser> getCurrentGoogleUser() async {
    final response = await _channel.invokeMethod(ChannelMethods.GET_CURRENT_USER_GOOGLE);
    if (response != null)
      return GoogleUser.fromMap(response);
    else
      return null;
  }

  Future<void> logOutGoogle() async {
    return await _channel.invokeMethod(ChannelMethods.LOGOUT_GOOGLE);
  }
}

class FacebookPermissions {
  static const EMAIL = "email";
  static const PUBLIC_PROFILE = "public_profile";

  static const DEFAULT = [EMAIL, PUBLIC_PROFILE];

  FacebookPermissions._();
}

class ChannelMethods {
  static const SET_CONFIG = "set_config";
  static const LOGIN_FACEBOOK = "login_facebook";
  static const GET_CURRENT_USER_FACEBOOK = "get_current_user_facebook";
  static const LOGOUT_FACEBOOK = "logout_facebook";
  static const LOGIN_GOOGLE = "login_google";
  static const GET_CURRENT_USER_GOOGLE = "get_current_user_google";
  static const LOGOUT_GOOGLE = "logout_google";

  ChannelMethods._();
}

class SocialConfig {
  static const KEY_FACEBOOK_APP_ID = "facebook_app_id";
  final String facebookAppId;

  SocialConfig({
    this.facebookAppId,
  });

  Map toMap() => {
        KEY_FACEBOOK_APP_ID: facebookAppId,
      };
}

class UserFields {
  static const ID = "id";
  static const EMAIL = "email";
  static const NAME = "name";
  static const PICTURE_URL = "picture_url";
  static const EXTRA_DATA = "extra_data";
  static const FACEBOOK_TOKEN = "facebook_token";
  static const GOOGLE_ID_TOKEN = "google_id_token";

  UserFields._();
}

abstract class SocialUser {
  final String id;
  final String email;
  final String name;
  final String pictureUrl;

  SocialUser(this.id, this.email, this.name, this.pictureUrl);
}

class FacebookUser extends SocialUser {
  final String token;

  FacebookUser(
    String id,
    String email,
    String name,
    String pictureUrl,
    this.token,
  ) : super(id, email, name, pictureUrl);

  factory FacebookUser.fromMap(Map map) {
    final extraMap = map[UserFields.EXTRA_DATA] as Map;
    return FacebookUser(
      map[UserFields.ID],
      map[UserFields.EMAIL],
      map[UserFields.NAME],
      map[UserFields.PICTURE_URL],
      extraMap[UserFields.FACEBOOK_TOKEN],
    );
  }
}

class GoogleUser extends SocialUser {
  final String idToken;

  GoogleUser(
    String id,
    String email,
    String name,
    String pictureUrl,
    this.idToken,
  ) : super(id, email, name, pictureUrl);

  factory GoogleUser.fromMap(Map map) {
    final extraMap = map[UserFields.EXTRA_DATA] as Map;
    return GoogleUser(
      map[UserFields.ID],
      map[UserFields.EMAIL],
      map[UserFields.NAME],
      map[UserFields.PICTURE_URL],
      extraMap[UserFields.GOOGLE_ID_TOKEN],
    );
  }
}
