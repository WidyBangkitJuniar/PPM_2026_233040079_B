import 'package:flutter/material.dart';

import '../db_helper.dart';

import '../model/catatan.dart';

// FORM PAGE
class CatatanFormPage extends StatefulWidget {
  // DATA EDIT
  final Catatan? catatan;

  const CatatanFormPage({super.key, this.catatan});

  @override
  State<CatatanFormPage> createState() => _CatatanFormPageState();
}

// STATE FORM PAGE
class _CatatanFormPageState extends State<CatatanFormPage> {
  // FORM KEY
  final _formKey = GlobalKey<FormState>();

  // CONTROLLER
  final _judulCtrl = TextEditingController();

  final _isiCtrl = TextEditingController();

  final _emailCtrl = TextEditingController();

  // DEFAULT DROPDOWN
  String _kategori = 'Kuliah';

  // LIST DROPDOWN
  final _kategoriOpsi = const ['Kuliah', 'Tugas', 'Pribadi', 'Lainnya'];

  @override
  void initState() {
    super.initState();

    // MODE EDIT
    if (widget.catatan != null) {
      _judulCtrl.text = widget.catatan!.judul;

      _isiCtrl.text = widget.catatan!.isi;

      _kategori = widget.catatan!.kategori;
    }
  }

  @override
  void dispose() {
    _judulCtrl.dispose();

    _isiCtrl.dispose();

    _emailCtrl.dispose();

    super.dispose();
  }

  // FUNCTION SIMPAN
  Future<void> _simpan() async {
    // VALIDASI
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      // MODE EDIT
      if (widget.catatan != null) {
        final updated = widget.catatan!.copyWith(
          judul: _judulCtrl.text.trim(),

          isi: _isiCtrl.text.trim(),

          kategori: _kategori,
        );

        await DbHelper.instance.update(updated);

        if (!mounted) return;

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Catatan diperbarui')));
      }
      // MODE TAMBAH
      else {
        final baru = Catatan(
          judul: _judulCtrl.text.trim(),

          isi: _isiCtrl.text.trim(),

          kategori: _kategori,

          dibuatPada: DateTime.now(),
        );

        await DbHelper.instance.insert(baru);

        if (!mounted) return;

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Catatan ditambahkan')));
      }

      // KEMBALI
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menyimpan: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // APPBAR
      appBar: AppBar(
        title: Text(widget.catatan == null ? 'Tambah Catatan' : 'Edit Catatan'),
      ),

      // BODY
      body: Form(
        key: _formKey,

        child: ListView(
          padding: const EdgeInsets.all(16),

          children: [
            // TEXTFIELD JUDUL
            TextFormField(
              controller: _judulCtrl,

              decoration: const InputDecoration(
                labelText: 'Judul',

                prefixIcon: Icon(Icons.title),

                border: OutlineInputBorder(),
              ),

              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Judul wajib diisi';
                }

                if (v.trim().length < 3) {
                  return 'Minimal 3 karakter';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            // DROPDOWN
            DropdownButtonFormField<String>(
              value: _kategori,

              decoration: const InputDecoration(
                labelText: 'Kategori',

                prefixIcon: Icon(Icons.category),

                border: OutlineInputBorder(),
              ),

              items: _kategoriOpsi.map((k) {
                return DropdownMenuItem(value: k, child: Text(k));
              }).toList(),

              onChanged: (v) {
                if (v != null) {
                  setState(() {
                    _kategori = v;
                  });
                }
              },
            ),

            const SizedBox(height: 16),

            // TEXTFIELD EMAIL
            TextFormField(
              controller: _emailCtrl,

              decoration: const InputDecoration(
                labelText: 'Email Pengirim',

                prefixIcon: Icon(Icons.email),

                border: OutlineInputBorder(),
              ),

              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Email wajib diisi';
                }

                // REGEX EMAIL
                final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

                if (!emailRegex.hasMatch(v.trim())) {
                  return 'Format email tidak valid';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            // TEXTFIELD ISI
            TextFormField(
              controller: _isiCtrl,

              maxLines: 5,

              decoration: const InputDecoration(
                labelText: 'Isi',

                prefixIcon: Icon(Icons.notes),

                border: OutlineInputBorder(),
              ),

              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Isi wajib diisi';
                }

                return null;
              },
            ),

            const SizedBox(height: 24),

            // BUTTON SIMPAN
            FilledButton.icon(
              onPressed: _simpan,

              icon: const Icon(Icons.save),

              label: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
