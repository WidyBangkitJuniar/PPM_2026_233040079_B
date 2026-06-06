import 'package:flutter/material.dart';

import 'pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

// ROOT APP
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,

      title: 'Catatan Mahasiswa',

      theme: ThemeData(

        colorSchemeSeed: Colors.indigo,

        useMaterial3: true,
      ),

      home: const HomePage(),
    );
  }
}