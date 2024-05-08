import 'package:flutter/material.dart';
import 'login_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/boxes.dart';
import 'models/pengguna.dart';

void main() async{
  Hive.initFlutter();
  Hive.registerAdapter(PenggunaAdapter());
  await Hive.openBox<Pengguna>(HiveBoxex.pengguna);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: LoginPage(),

    );
  }
}
