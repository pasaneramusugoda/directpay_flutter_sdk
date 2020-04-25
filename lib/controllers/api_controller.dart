import 'package:flutter/material.dart';
import 'package:flutter_mpgs_sdk/card_add_form.dart';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_mpgs_sdk/controllers/parameters.dart';

fetch(BuildContext context, String url, Map params,
    {Function(Map<String, dynamic> data) success,
    Function(String code, String title, String message) failed,
    Function() completed}) async {
  HttpClient httpClient = new HttpClient();
  HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
  request.headers.set('content-type', 'application/json');
  request.headers.set('Authorization', 'Bearer ' + CardAddForm.accessToken);

  if (params == null) {
    params = Map();
  }

  params["platform"] = getPlatform();
  params["version"] = Parameters.VERSION;
  if (IS_DEV) {
    print("url:" + url);
    print(params);
    print("token: " + CardAddForm.accessToken);
  }
  request.add(utf8.encode(json.encode(params)));
  HttpClientResponse response = await request.close();
  // todo - you should check the response.statusCode
  try {
    String reply = await response.transform(utf8.decoder).join();
    if (IS_DEV) {
      print("response: " + reply);
    }
    switch (response.statusCode) {
      case 200:
        final responseJson = json.decode(reply);
        final data = responseJson["data"];
        if (responseJson["status"] == 200) {
          success(data);
        } else if (responseJson["status"] == 400) {
          final code = data["error"];
          final title = data["title"];
          final message = data["message"];

          failed(code, title, message);
        }
        break;
      default:
        failed(
            response.statusCode.toString(), "Failed", "Something went wrong!");
        break;
    }
  } catch (e) {} finally {
    httpClient.close();
    completed();
  }
}
