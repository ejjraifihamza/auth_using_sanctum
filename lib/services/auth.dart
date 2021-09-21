// ignore_for_file: avoid_print
import 'package:auth_using_sanctum/models/user.dart';
import 'package:auth_using_sanctum/services/dio.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Auth extends ChangeNotifier {
  bool _isLoggedIn = false;
  User? _user;
  String? _token;
  bool get authenticated => _isLoggedIn;
  User get user => _user!;
  final storage = const FlutterSecureStorage();

  void login({Map? data}) async {
    print(data);
    try {
      Dio.Response response = await dio().post('/sanctum/token', data: data);
      print(response.data.toString());
      String token = response.data.toString();
      tryToken(token: token);
    } catch (e) {
      print(e);
    }
  }

  void register({Map? registerData, data}) async {
    print('Register data is $registerData');
    print('Login data is $data');

    try {
      Dio.Response response = await dio().post('/register', data: registerData);
    } catch (e) {
      print(e);
    }

    try {
      Dio.Response responseTwo = await dio().post('/sanctum/token', data: data);
      String token = responseTwo.data.toString();
      tryToken(token: token);
    } catch (e) {
      print(e);
    }
  }

  void tryToken({String? token}) async {
    if (token == null) {
      return;
    } else {
      try {
        Dio.Response response = await dio().get('/user',
            options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
        _isLoggedIn = true;
        _user = User.fromJson(response.data);
        storeToken(token: token);
        _token = token;
        // to change any thing in Auth class you have to use notifyListeners()
        notifyListeners();
        print(_user);
      } catch (e) {
        print(e);
      }
    }
  }

  void storeToken({String? token}) async {
    storage.write(key: 'token', value: token);
  }

  void logout() async {
    try {
      Dio.Response response = await dio().post('/user/revoke',
          options: Dio.Options(headers: {'Authorization': 'Bearer $_token'}));
      cleanUp();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void cleanUp() async {
    _user = null;
    _isLoggedIn = false;
    _token = null;
    await storage.delete(key: 'token');
  }
}
