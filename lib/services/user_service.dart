import 'dart:convert';
import 'dart:io';

import 'package:fkc1/constant.dart';
import 'package:fkc1/models/api_response.dart';
import 'package:fkc1/models/user.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// ユーザーのログインを行う関数
// 引数としてメールアドレスとパスワードを受け取り、APIにリクエストを送信
Future<ApiResponse> login(String email, String password) async {
  // APIのレスポンスを格納するためのオブジェクトを作成
  ApiResponse apiResponse = ApiResponse();

  try {
    final response = await http.post(
      Uri.parse(loginURL),
      headers: {
        // 'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: {'email': email, 'password': password},
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = somethingWentWrong;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

// ユーザーの登録を行う関数
// 引数として名前、メールアドレス、パスワードを受け取り、APIにリクエストを送信
Future<ApiResponse> register(String name, String email, String password) async {
  // APIのレスポンスを格納するためのオブジェクトを作成
  ApiResponse apiResponse = ApiResponse();

  try {
    final response = await http.post(
      Uri.parse(registerURL),
      headers: {'Accept': 'application/json'},
      body: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password,
      },
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      default:
        apiResponse.error = somethingWentWrong;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

// ユーザー情報を取得する関数
// 引数としてトークンを受け取り、APIにリクエストを送信
Future<ApiResponse> getUserDetail() async {
  // APIのレスポンスを格納するためのオブジェクトを作成
  ApiResponse apiResponse = ApiResponse();

  try {
    String token = await getToken();
    final response = await http.get(
      Uri.parse(userURL),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

// Update user
Future<ApiResponse> updateUser(String name, String? image) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.put(
      Uri.parse(userURL),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
      body: image == null ? {'name': name} : {'name': name, 'image': image},
    );
    // user can update his/her name or name and image

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        debugPrint(response.body);
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

Future<String> getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // String? token = prefs.getString('token') ?? '';
  // return token;
  return prefs.getString('token') ?? '';
}

Future<int> getUserId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt('userId') ?? 0;
}

Future<bool> logout() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return await prefs.remove('token');
}

// Get base64 encoded image
String? getStringImage(File? file) {
  if (file == null) return null;
  return base64Encode(file.readAsBytesSync());
}
