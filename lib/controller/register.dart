import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_project_1/api_config/api_config.dart';
import 'package:http/http.dart ' as http;
import 'package:test_project_1/constants/colors.dart';
import 'package:test_project_1/screens/login/login.dart';

class RegisterController extends GetxController {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController cpassword = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController location = TextEditingController();
  //------------------------------------------------------------------Toggle Obscure
  final RxBool obscure = true.obs;
  final RxBool obscure1 = true.obs;

  void toggleObscure() {
    obscure(!obscure.value);
  }

  void toggleObscure1() {
    obscure1(!obscure1.value);
  }

  //------------------------------------------------------------------Select Gender
  String _selectGender = 'Select Gender';
  String get selectGender => _selectGender;
  List<String> gender = ['Select Gender', 'Male', 'Female', 'Other'];

  selectedGender(gender) {
    _selectGender = gender;
  }

  //------------------------------------------------------------------Select Date
  final Rx<DateTime?> selectDate = Rx<DateTime?>(null);

  Future<void> selectedDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      selectDate.value = picked;
    } else {
      if (kDebugMode) {
        print('Date of Birth not Selected');
      }
    }
  }

  //------------------------------------------------------------------Select Image from Gallery
  final Rx<File?> selectedImage = Rx<File?>(null);
  Future<void> openImagePicker() async {
    final XFile? pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      selectedImage.value = File(pickedImage.path);
    } else {
      if (kDebugMode) {
        print('Image not Selected');
      }
    }
  }

  final RxBool isRegistering = false.obs;

  Future<void> registerwithEmail() async {
    try {
      isRegistering(true);
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.registerEmail);

      var request = http.MultipartRequest('POST', url);
      request.headers.addAll({"Content-Type": "multipart/form-data"});

      request.fields['name'] = name.text;
      request.fields['gender'] = _selectGender;
      request.fields['phone'] = phone.text;
      request.fields['email'] = email.text;
      request.fields['password'] = password.text;
      request.fields['location'] = location.text;
      request.fields['dob'] = selectDate.value.toString();

      if (selectedImage.value != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
              'avatar', selectedImage.value!.path),
        );
      }

      var response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.showSnackbar(const GetSnackBar(
          duration: Duration(seconds: 2),
          message: "Registration Succesful",
          backgroundColor: green,
          isDismissible: true,
          barBlur: 5,
        ));
        Get.to(const Login());
        print('Registration successful');
      } else {
        Get.showSnackbar(GetSnackBar(
          message:
              'Registration failed with status code: ${response.statusCode}',
        ));
        print('Registration failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during registration: $e');
    } finally {
      isRegistering(false);
    }
  }
}
