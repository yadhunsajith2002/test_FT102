import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:test_project_1/model/user_model.dart';
import 'package:test_project_1/services/api_services.dart';

class UserDetailsController with ChangeNotifier {
  String? _authToken;

  UserModel userModel = UserModel();

  Future<void> fetchUserDetails() async {
    _authToken = await ApiServices.getToken();
    print(" My Token : ${_authToken}");
    var url = Uri.parse('http://trial.weberfox.in/test/api/user-details');
    var headers = {
      'Authorization': 'Bearer $_authToken',
    };

    try {
      var response = await http.get(url, headers: headers);
      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        var decodedData = json.decode(response.body);

        userModel = UserModel.fromJson(decodedData);

        userModel.data = Data.fromJson(decodedData['data']);
        print(userModel);
      } else {
        print('Failed to fetch user details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during user details request: $e');
    }
  }
}
