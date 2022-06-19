import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '/model/http_exception.dart';
import '/model/student.dart';
import '../constants.dart';
import 'firestore.dart';

class Auth with ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null) {
      if (_expiryDate!.isAfter(DateTime.now()) && _token != null) {
        return _token;
      }
    }

    return null;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment, bool rememberMe,
      [Student? student]) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyC1iM_wrE9Q7SjYulC8_Ulv5nYQYnNRw6s';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        print(responseData['error']['message']);
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      if (urlSegment == 'signUp') {
        await FireStore().addStudent(student: student!, uid: _userId!);
      }
      String name = await FireStore().getStudentName(_userId!);
      Constants.setUpConstants(name, _userId);
      if (rememberMe) {
        saveUserData(_token!, _userId!, _expiryDate!.toIso8601String(), name,
            rememberMe.toString());
      } else {
        _storage.deleteAll();
        _autoLogout();
      }
      Constants.loggedout = false;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signup(String email, String password, Student student) async {
    return _authenticate(email, password, 'signUp', false, student);
  }

  Future<void> login(String email, String password, bool rememberMe) async {
    return _authenticate(email, password, 'signInWithPassword', rememberMe);
  }

  Future<bool> tryAutoLogin() async {
    final extractedUserData2 = await _storage.readAll();
    if (!extractedUserData2.containsKey('token')) {
      return false;
    }
    final expiryDate =
        DateTime.parse(extractedUserData2['expiryDate'] as String);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData2['token'] as String;
    _userId = extractedUserData2['userId'] as String;
    _expiryDate = expiryDate;
    Constants.setUpConstants(extractedUserData2['name'], _userId);
    notifyListeners();
    if (!(extractedUserData2['rememberMe'] as bool)) {
      _autoLogout();
    }
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    Constants.clear();
    notifyListeners();
    _storage.deleteAll();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  Future<void> resetPass(String email) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=AIzaSyC1iM_wrE9Q7SjYulC8_Ulv5nYQYnNRw6s';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            'requestType': "PASSWORD_RESET",
            'email': email,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        print(responseData['error']['message']);
        throw HttpException(responseData['error']['message']);
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> saveUserData(String token, String uid, String expiryDate,
      String name, String rememberMe) async {
    await _storage.write(
      key: 'token',
      value: token,
    );
    await _storage.write(
      key: 'userId',
      value: uid,
    );
    await _storage.write(
      key: 'expiryDate',
      value: expiryDate,
    );
    await _storage.write(
      key: 'name',
      value: name,
    );
    await _storage.write(
      key: 'rememberMe',
      value: rememberMe,
    );
  }
}
