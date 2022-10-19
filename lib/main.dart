import 'package:flutter/material.dart';
import 'package:secure_banking_app/biometric_storage_demo.dart';
import 'package:secure_banking_app/hive_demo.dart';
import 'package:secure_banking_app/local_auth_demo.dart';
import 'package:secure_banking_app/secure_application_demo.dart';
import 'package:secure_banking_app/secure_storage_demo.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(),
        body: const HiveDemo(),
      ),
    );
  }
}
