import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning/app/widget/app_elevated_button.dart';
import 'package:learning/app/widget/app_image_assets.dart';
import 'package:learning/app/widget/app_loader.dart';
import 'package:learning/app/widget/app_text.dart';
import 'package:learning/app/widget/app_text_form_field.dart';
import 'package:learning/app/widget/app_toast.dart';
import 'package:learning/constant/app_asset.dart';
import 'package:learning/constant/color_constant.dart';
import 'package:learning/controller/login_controller.dart';
import 'package:learning/utils/validation_utils.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstant.appDarkGreen,
        title: const AppText(
          'User integration',
          color: ColorConstant.appWhite,
          fontSize: 18,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: GetBuilder<LoginController>(
        init: LoginController(),
        builder: (controller) {
          return Stack(
            children: [
              Center(
                child: ListView(
                  shrinkWrap: true,
                  primary: true,
                  padding: const EdgeInsets.only(top: 30),
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  children: [
                    AppTextFormFiled(
                      hintText: 'Email address',
                      controller: controller.emailController,
                      textInputType: TextInputType.emailAddress,
                      isError: controller.emailError.value,
                    ),
                    const SizedBox(height: 20),
                    AppTextFormFiled(
                      hintText: 'Password',
                      controller: controller.passwordController,
                      showVisibility: true,
                      visibility: controller.obscureText.value,
                      suffixTap: () => controller.changeVisibility(),
                      isError: controller.passwordError.value,
                    ),
                    const SizedBox(height: 30),
                    AppElevatedButton(
                      onPressed: () {
                        if (ValidationUtils.validateEmptyController(controller.emailController)) {
                          controller.emailError = true.obs;
                          'Email can\'t be empty'.showToast(isError: true);
                        } else if (!ValidationUtils.regexValidator(controller.emailController, ValidationUtils.emailRegExp)) {
                          controller.emailError = true.obs;
                          'Invalid email address'.showToast(isError: true);
                        } else if (ValidationUtils.validateEmptyController(controller.passwordController)) {
                          controller.emailError = false.obs;
                          controller.passwordError = true.obs;
                          'Password can\'t be empty'.showToast(isError: true);
                        } else if (controller.isSignIn.isFalse && ValidationUtils.lengthValidator(controller.passwordController, 8)) {
                          controller.emailError = false.obs;
                          controller.passwordError = true.obs;
                          'Password must contains at least 8 character'.showToast(isError: true);
                        } else {
                          controller.emailError = false.obs;
                          controller.passwordError = false.obs;
                          FocusScope.of(context).unfocus();
                          controller.isSignIn.isTrue ? controller.verifyUser() : controller.createUser();
                        }
                        controller.update();
                      },
                      buttonName: controller.isSignIn.isTrue ? 'Login' : 'SignUp',
                    ),
                    const SizedBox(height: 30),
                    const AppText(
                      'Or continue with',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: InkWell(
                        onTap: () => controller.googleSignIn(),
                        child: Container(
                          height: 40,
                          width: 40,
                          padding: const EdgeInsets.all(6),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(400),
                            child: const AppImageAsset(image: AppAsset.googleIcon),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        controller.isSignIn.value = !controller.isSignIn.value;
                        controller.update();
                      },
                      child: AppText(
                        controller.isSignIn.isTrue ? 'Don\'t have account?\nWant to Join Us' : 'Already have account?\nSign in',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              if (controller.isLoading.isTrue) const AppLoader(),
            ],
          );
        },
      ),
    );
  }
}
