import 'package:flutter/material.dart';

import '../model/catatan.dart';

// DETAIL PAGE
class DetailCatatanPage extends StatelessWidget {
  // DATA CATATAN
  final Catatan catatan;

  const DetailCatatanPage({super.key, required this.catatan});

  // FORMAT TANGGAL
  String _formatTanggal(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // APPBAR
      appBar: AppBar(title: const Text('Detail Catatan')),

      // BODY
      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // JUDUL
            Text(
              catatan.judul,

              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            // KATEGORI
            Row(
              children: [
                const Icon(Icons.category),

                const SizedBox(width: 8),

                Text(catatan.kategori),
              ],
            ),

            const SizedBox(height: 10),

            // TANGGAL
            Row(
              children: [
                const Icon(Icons.calendar_month),

                const SizedBox(width: 8),

                Text(_formatTanggal(catatan.dibuatPada)),
              ],
            ),

            const SizedBox(height: 24),

            // ISI CATATAN
            const Text(
              'Isi Catatan',

              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text(catatan.isi, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
