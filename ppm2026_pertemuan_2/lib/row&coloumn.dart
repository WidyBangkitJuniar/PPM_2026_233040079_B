import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(Icons.home, size: 40),
            Icon(Icons.star, size: 40),
            Icon(Icons.person, size: 40),
          ],
        ),
      ),
    ),
  ));
}