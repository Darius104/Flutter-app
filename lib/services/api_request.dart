import 'dart:io';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/url.dart';
import 'flutter_secure_storage_class.dart';

import './flutter_secure_storage_class.dart';

class ApiRequest {
  static Future getAuthors() async {
    try {
      final response = await http.get(authorsUrl);
      return response.body;
    } catch (e) {
      print('error: $e');
      return "error: $e";
    }
  }

  static Future getPosts() async {
    try {
      String? token = await FlutterSecureStorageClass().getJWT();
      final response = await http.get(postsUrl, headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      });
      if (response.statusCode == 401) throw ErrorDescription("Unauthorized");
      if (response.statusCode != 201) {
        throw ErrorDescription("something Went wrong");
      }
      return response.body;
    } catch (e) {
      print('error: $e');
      return "error: $e";
    }
  }

  static Future getSinglePosts(id) async {
    final getSiglePostUrl = Uri.parse("$url/api/Posts/$id");
    try {
      String? token = await FlutterSecureStorageClass().getJWT();
      final response = await http.get(getSiglePostUrl, headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      });
      if (response.statusCode == 401) throw ErrorDescription("Unauthorized");
      if (response.statusCode != 201) {
        throw ErrorDescription("something Went wrong");
      }
      return response.body;
    } catch (e) {
      print('error: $e');
      return "error: $e";
    }
  }

  static Future login(name, email, password) async {
    try {
      final response = await http.post(loginUrl,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'displayName': name,
            'email': email,
            'password': password,
          }));
      if (response.statusCode != 200) {
        if (response.body == "Invalid credentials") {
          throw ErrorDescription(response.body);
        }
        throw ErrorDescription("something Went wrong");
      }
      return response.body;
    } catch (e) {
      print('error: $e');
      return "error: $e";
    }
  }

  static Future register(name, email, password) async {
    try {
      final response = await http.post(registerUrl,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'displayName': name,
            'email': email,
            'password': password,
          }));

      if (response.statusCode != 201) {
        if (response.body == "Invalid credentials") {
          throw ErrorDescription(response.body);
        }
        throw ErrorDescription("something Went wrong");
      }
      return response.body;
    } catch (e) {
      print('error: $e');
      return "error: $e";
    }
  }

  static Future addPost(
      {required String title,
      required String content,
      required int authorCode}) async {
    try {
      String? token = await FlutterSecureStorageClass().getJWT();
      final response = await http.post(postsUrl,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            'title': title,
            'content': content,
            "authorCode": authorCode,
          }));
      debugPrint("${response.statusCode}");
      if (response.statusCode == 401) throw ErrorDescription("Unauthorized");
      if (response.statusCode != 201) {
        throw ErrorDescription("something Went wrong");
      }
      return "success";
    } catch (e) {
      print('error: $e');
      return "error: $e";
    }
  }

  static Future modifyPost({
    required String title,
    required String content,
    required int authorCode,
    required int postId,
  }) async {
    try {
      String? token = await FlutterSecureStorageClass().getJWT();
      final response = await http.put(postsUrl,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            'code': postId,
            'title': title,
            'content': content,
            "authorCode": authorCode,
          }));
      debugPrint("${response.statusCode}");
      if (response.statusCode == 401) throw ErrorDescription("Unauthorized");
      if (response.statusCode != 204) {
        throw ErrorDescription("something Went wrong");
      }
      return "success";
    } catch (e) {
      print('error: $e');
      return "error: $e";
    }
  }

  static Future commentPost(
      {required String content, required int replyTo, required int id}) async {
    try {
      String? token = await FlutterSecureStorageClass().getJWT();
      final response = await http.post(postsUrl,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            'title': "comment",
            'content': content,
            "authorCode": id,
            "replyTo": replyTo
          }));

      if (response.statusCode == 401) throw ErrorDescription("Unauthorized");
      if (response.statusCode != 201) {
        throw ErrorDescription("something Went wrong");
      }
      return "success";
    } catch (e) {
      print('error: $e');
      return "error: $e";
    }
  }

  static Future deletePost(id) async {
    final getSiglePostUrl = Uri.parse("$url/api/Posts/$id");
    try {
      String? token = await FlutterSecureStorageClass().getJWT();
      final response = await http.delete(getSiglePostUrl, headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      });
      if (response.statusCode == 401) throw ErrorDescription("Unauthorized");
      if (response.statusCode != 204) {
        throw ErrorDescription("something Went wrong");
      }
      return response.body;
    } catch (e) {
      print('error: $e');
      return "error: $e";
    }
  }
}
