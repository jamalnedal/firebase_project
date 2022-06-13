import 'package:flutter/material.dart';
import 'package:vp9_firebase/controllers/fb_auth_controller.dart';
import 'package:vp9_firebase/helpers/helpers.dart';
import 'package:vp9_firebase/widgets/app_text_field.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen>
    with Helpers {
  late TextEditingController _emailTextController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailTextController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FORGET PASSWORD'),
      ),
      body: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          const Text(
            'Enter email...',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          const Text(
            'Reset code will be sent!',
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
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () async => await performForgetPassword(),
            child: const Text('SEND'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(0, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> performForgetPassword() async {
    if (checkData()) {
      await forgetPassword();
    }
  }

  bool checkData() {
    if (_emailTextController.text.isNotEmpty) {
      return true;
    }
    showSnackBar(
      context: context,
      message: 'Enter required data!',
      error: true,
    );
    return false;
  }

  Future<void> forgetPassword() async {
    bool status = await FbAuthController()
        .forgetPassword(context, email: _emailTextController.text);
    if (status) Navigator.pop(context);
  }
}
