import 'package:flutter/material.dart';
import 'displaydemo.dart';
import 'demoinput.dart';
import 'demobutton.dart';
import 'demofeedback.dart';
import 'demolayout.dart';

// Class CategoryPage
class CategoryPage extends StatelessWidget {
  final String name;

  const CategoryPage({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    final body = switch (name) {
      'Display' => const DisplayDemo(),
      'Input' => const InputDemo(),
      'Button' => const ButtonDemo(),
      'Feedback' => const FeedbackDemo(),
      'Layout' => const LayoutDemo(),
      _ => const Center(child: Text('?')),
    };

    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB3E5FC), Color(0xFFE1F5FE)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(),
        ),
      ),
    );
  }
}