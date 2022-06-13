
import 'package:flutter/material.dart';
import 'package:vp9_firebase/controllers/fb_auth_controller.dart';
import 'package:vp9_firebase/helpers/helpers.dart';
import 'package:vp9_firebase/widgets/app_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with Helpers {
  late TextEditingController _emailTextController;
  late TextEditingController _passwordTextController;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailTextController = TextEditingController();
    _passwordTextController = TextEditingController();
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
        title: Text('Register'),
      ),
      body: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          const Text(
            'Create new account...',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          const Text(
            'Enter details below',
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
            onPressed: () async => await performRegister(),
            child: const Text('REGISTER'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(0, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> performRegister() async {
    if(checkData()){
      await register();
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

  Future<void> register() async {
    bool status = await FbAuthController().createAccount(context, email: _emailTextController.text, password: _passwordTextController.text);
    if(status) {
      Navigator.pop(context);
    }
  }
}
