import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:salsabil/auth/signup.dart';
import 'package:salsabil/views/home/home.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

void main() async {
 await ZIMKit().init(appID:519790171,appSign: 'b4a3a7fca0cf1f397f6f406ee66e5acadc21408d1b319f237870ccca09526a6c');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Salsabil',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: FirebaseAuth.instance.currentUser == null
          ? const Signup()
          :  HomePage(),
    );
  }
}
