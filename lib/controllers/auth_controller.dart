import 'package:get/get.dart';

class AuthController extends GetxController {
  var token = ''.obs;
  var userId = ''.obs;
  var userName = ''.obs;
  var userEmail = ''.obs;
  var userPhone = ''.obs;

  bool get isLoggedIn => token.value.isNotEmpty;

  void setUserData({
    required String token,
    required String id,
    required String name,
    required String email,
    required String phone,
  }) {
    this.token.value = token;
    userId.value = id;
    userName.value = name;
    userEmail.value = email;
    userPhone.value = phone;
  }

  void logout() {
    token.value = '';
    userId.value = '';
    userName.value = '';
    userEmail.value = '';
    userPhone.value = '';
  }
}