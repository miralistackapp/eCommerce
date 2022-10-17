import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:learning/model/users_model.dart';
import 'package:learning/screen/product_screen/product_screen.dart';
import 'package:learning/service/auth_services.dart';
import 'package:learning/service/db_helper.dart';
import 'package:learning/utils/shared_preference.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  RxBool obscureText = true.obs;
  RxBool isSignIn = true.obs;
  RxBool isLoading = false.obs;
  RxBool emailError = false.obs;
  RxBool passwordError = false.obs;

  void changeVisibility() {
    obscureText.value = !obscureText.value;
    refresh();
  }

  Future<void> createUser() async {
    isLoading = true.obs;
    update();
    UserCredential? userCredential = await AuthServices.createUser(emailController.text, passwordController.text);
    if (userCredential != null) {
      isSignIn = true.obs;
      emailController.clear();
      passwordController.clear();
      UserModel userModel = UserModel(
        userId: userCredential.user!.uid,
        userEmail: userCredential.user!.email,
        userName: userCredential.user!.displayName ?? '',
      );
      await DBHelper.instance.addUser(userModel);
      await setPrefBoolValue(isLoggedIn, true);
    }
    isLoading = false.obs;
    update();
  }

  Future<void> verifyUser() async {
    isLoading = true.obs;
    update();
    UserCredential? userCredential = await AuthServices.verifyUser(emailController.text, passwordController.text);
    if (userCredential != null) {
      isSignIn = true.obs;
      await DBHelper.instance.getAllUsers();
      await setPrefBoolValue(isLoggedIn, true);
      Get.offAll(() => ProductScreen());
    }
    isLoading = false.obs;
    update();
  }

  Future<void> googleSignIn() async {
    isLoading = true.obs;
    update();
    UserCredential? userCredential = await AuthServices.signInWithGoogle();
    if (userCredential != null) {
      isSignIn = true.obs;
      List<UserModel> users = await DBHelper.instance.getAllUsers();
      UserModel userExist = users.firstWhere(
        (element) => element.userEmail == userCredential.user!.email,
        orElse: () => UserModel(),
      );
      if (userExist.userId == null || userExist.userId!.isEmpty) {
        UserModel userModel = UserModel(
          userId: userCredential.user!.uid,
          userEmail: userCredential.user!.email,
          userName: userCredential.user!.displayName ?? '',
        );
        await DBHelper.instance.addUser(userModel);
      }
      Get.offAll(() => ProductScreen());
    }
    isLoading = false.obs;
    update();
  }
}
