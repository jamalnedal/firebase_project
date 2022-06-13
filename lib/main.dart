import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vp9_firebase/bloc/bloc/storage_bloc.dart';
import 'package:vp9_firebase/bloc/states/storage_state.dart';
import 'package:vp9_firebase/controllers/fb_notifications.dart';
import 'package:vp9_firebase/screens/app/notes_screen.dart';
import 'package:vp9_firebase/screens/auth/login_screen.dart';
import 'package:vp9_firebase/screens/auth/password/forget_password_screen.dart';
import 'package:vp9_firebase/screens/auth/register_screen.dart';
import 'package:vp9_firebase/screens/images/images_screen.dart';
import 'package:vp9_firebase/screens/images/upload_image_screen.dart';
import 'package:vp9_firebase/screens/launch_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FbNotifications.initNotifications();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<StorageBloc>(
            create: (context) => StorageBloc(LoadingState())),
      ],
      child: MaterialApp(
        initialRoute: '/launch_screen',
        routes: {
          '/launch_screen': (context) => LaunchScreen(),
          '/login_screen': (context) => LoginScreen(),
          '/register_screen': (context) => RegisterScreen(),
          '/forget_password_screen': (context) => ForgetPasswordScreen(),
          '/notes_screen': (context) => NotesScreen(),
          '/images_screen': (context) => ImagesScreen(),
          '/upload_image_screen': (context) => UploadImageScreen(),
        },
      ),
    );
  }
}
