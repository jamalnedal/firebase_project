import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:vp9_firebase/controllers/fb_auth_controller.dart';
import 'package:vp9_firebase/controllers/fb_notifications.dart';
import 'package:vp9_firebase/helpers/helpers.dart';
import 'package:vp9_firebase/widgets/app_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with Helpers, FbNotifications {
  late TextEditingController _emailTextController;
  late TextEditingController _passwordTextController;

  late TapGestureRecognizer _tapGestureRecognizer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestNotificationPermissions();

    _emailTextController = TextEditingController();
    _passwordTextController = TextEditingController();

    _tapGestureRecognizer = TapGestureRecognizer()
      ..onTap = navigateToRegisterScreen;
    // _tapGestureRecognizer.onTap = navigateToRegisterScreen;
  }

  void navigateToRegisterScreen() {
    Navigator.pushNamed(context, '/register_screen');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LOGIN'),
      ),
      body: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          const Text(
            'Welcome back...',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          const Text(
            'Enter your email & password',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 15),
          AppTextField(
            hint: 'Email',
            controller: _emailTextController,
            prefixIcon: Icons.email,
          ),
          const SizedBox(height: 10),
          AppTextField(
            hint: 'Password',
            controller: _passwordTextController,
            prefixIcon: Icons.lock,
            obscureText: true,
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () async => await performLogin(),
            child: const Text('LOGIN'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(0, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: 10),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'Don\'t have an account?',
              style: const TextStyle(
                color: Colors.black,
              ),
              children: [
                const TextSpan(text: ' '),
                TextSpan(
                  recognizer: _tapGestureRecognizer,
                  text: 'Create Now!',
                  style: const TextStyle(
                    color: Colors.blue,
                  ),
                )
              ],
            ),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pushNamed(context, '/forget_password_screen'),
            child: const Text("Forget Password?"),
          )
        ],
      ),
    );
  }

  Future<void> performLogin() async {
    if (checkData()) {
      await login();
    }
  }

  bool checkData() {
    if (_emailTextController.text.isNotEmpty &&
        _passwordTextController.text.isNotEmpty) {
      return true;
    }
    showSnackBar(
      context: context,
      message: 'Enter required data!',
      error: true,
    );
    return false;
  }

  Future<void> login() async {
   String? fcmToken = await FirebaseMessaging.instance.getToken();
   print('TOKEN: $fcmToken');
   FirebaseMessaging.instance.onTokenRefresh.listen((String newFcmToken) {
     //TODO: send new FCM Token
   });
   // FirebaseMessaging.instance.sendMessage(to: fcmToken);
    bool status = await FbAuthController().signIn(context,
        email: _emailTextController.text,
        password: _passwordTextController.text);
    if (status) Navigator.pushReplacementNamed(context, '/notes_screen');
  }
}
