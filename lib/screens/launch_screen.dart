import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vp9_firebase/controllers/fb_auth_controller.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({Key? key}) : super(key: key);

  @override
  _LaunchScreenState createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  late StreamSubscription _streamSubscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      _streamSubscription = FbAuthController().listenToUserState(
        userStateCallback: (status) {
          print('Status: $status');
          String route = status ? '/notes_screen' : '/login_screen';
          Navigator.pushReplacementNamed(context, route);
        },
      );
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: AlignmentDirectional.topStart,
            end: AlignmentDirectional.bottomEnd,
            colors: [
              Colors.blue.shade800,
              Colors.orange.shade600,
            ],
          ),
        ),
        child: const Text(
          'FIREBASE APP',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}
