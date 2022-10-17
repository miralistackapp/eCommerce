import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning/screen/product_screen/product_screen.dart';
import 'package:learning/screen/sign_in_screen/sign_in_screen.dart';
import 'package:learning/utils/shared_preference.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  bool isLogin = await getPrefBoolValue(isLoggedIn) ?? false;
  runApp(MyApp(isLogin: isLogin));
}

class MyApp extends StatefulWidget {
  final bool isLogin;

  const MyApp({super.key, this.isLogin = false});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: GetMaterialApp(
        title: 'Flutter GetX Demo',
        debugShowCheckedModeBanner: false,
        scrollBehavior: MyBehavior(),
        builder: BotToastInit(),
        navigatorObservers: [BotToastNavigatorObserver()],
        home: widget.isLogin ? ProductScreen() : const SignInScreen(),
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

void logs(String message) {
  if (kDebugMode) {
    print(message);
  }
}

List<String> productImagesFromJson(String str) => List<String>.from(json.decode(str).map((x) => x));

String productImagesToJson(List<String> data) => json.encode(List<dynamic>.from(data.map((x) => x)));
