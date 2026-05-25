import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: Center(
        child: Text(
          'Latihan 4: Icon Bottom Bar',
          style: TextStyle(fontSize: 20),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(Icons.home, size: 32, color: Colors.red),
            Icon(Icons.receipt_long, size: 32, color: Colors.green),
            Icon(Icons.favorite, size: 32, color: Colors.purple),
            Icon(Icons.person, size: 32, color: Colors.blue),
          ],
        ),
      ),
    ),
  ));
}