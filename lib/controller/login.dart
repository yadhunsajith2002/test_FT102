import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart ' as http;
import 'package:test_project_1/api_config/api_config.dart';
import 'package:test_project_1/constants/colors.dart';

import 'package:test_project_1/screens/user_details/user_details.dart';
import 'package:test_project_1/services/api_services.dart';

class LoginController with ChangeNotifier {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  //------------------------------------------------------------------Toggle Obscure

  final RxBool obscure = true.obs;

  void toggleObscure() {
    obscure(!obscure.value);
  }

  Future<void> login() async {
    try {
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.loginEmail);

      var response = await http.post(
        url,
        body: {
          'email': email.text,
          'password': password.text,
        },
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        var authToken = responseData['access_token'];

        ApiServices.setToken(authToken);
        print(ApiServices.getToken());

        Get.snackbar(
          duration: Duration(seconds: 2),
          "Message",
          "Logged in Succesfully",
          colorText: Colors.white,
          backgroundColor: Colors.lightBlue,
        );

        print("Token: ${authToken}");

        Get.to(() => const UserDetail());
      } else {
        Get.snackbar(
          duration: Duration(seconds: 2),
          "Message",
          "Invalid Credentials",
          colorText: Colors.white,
          backgroundColor: green,
        );

        print('Login failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during login: $e');
    }
  }
}
