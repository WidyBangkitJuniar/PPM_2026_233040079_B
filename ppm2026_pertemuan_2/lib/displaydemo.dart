import 'package:flutter/material.dart';

//Class DisplayDemo
class DisplayDemo extends StatelessWidget {
  const DisplayDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Card', style: TextStyle(fontWeight: FontWeight.bold)),
        const Card(
          child: ListTile(
            leading: Icon(Icons.album),
            title: Text('Judul Item'),
            subtitle: Text('Sub-judul'),
          ),
        ),
        const SizedBox(height: 16),
        const Text('Chip', style: TextStyle(fontWeight: FontWeight.bold)),
        Wrap(
          spacing: 8,
          children: const [
            Chip(label: Text('Flutter')),
            Chip(label: Text('Dart')),
            Chip(label: Text('Mobile')),
          ],
        ),
        const SizedBox(height: 16),
        const Text('Divider', style: TextStyle(fontWeight: FontWeight.bold)),
        const Divider(thickness: 2),
        const SizedBox(height: 16),
        const Text(
          'CircleAvatar & Icon',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Row(
          children: const [
            CircleAvatar(child: Text('A')),
            SizedBox(width: 12),
            CircleAvatar(
              backgroundColor: Colors.green,
              child: Icon(Icons.check),
            ),
            SizedBox(width: 12),
            Icon(Icons.star, color: Colors.amber, size: 40),
          ],
        ),
      ],
    );
  }
}