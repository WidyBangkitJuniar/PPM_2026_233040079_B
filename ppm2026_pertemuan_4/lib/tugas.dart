import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// MODEL CATATAN
class Catatan {
  final String judul;
  final String isi;
  final String kategori;
  final DateTime dibuatPada;

  Catatan({
    required this.judul,
    required this.isi,
    required this.kategori,
    required this.dibuatPada,
  });
}

// ROOT APP
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catatan Mahasiswa',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),

      initialRoute: '/',

      routes: {'/': (context) => const HomePage()},
    );
  }
}

// HOMEPAGE
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

// STATE HOMEPAGE
class _HomePageState extends State<HomePage> {
  // LIST CATATAN
  final List<Catatan> _catatan = [
    Catatan(
      judul: 'Belajar Flutter',
      isi: 'Mempelajari Stateful Widget',
      kategori: 'Kuliah',
      dibuatPada: DateTime.now(),
    ),
  ];

  // FILTER
  String _filterKategori = 'Semua';

  // FORMAT TANGGAL
  String _formatTanggal(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  // LIST FILTER
  List<Catatan> get _catatanFilter {
    if (_filterKategori == 'Semua') {
      return _catatan;
    }

    return _catatan.where((c) => c.kategori == _filterKategori).toList();
  }

  // FUNCTION TAMBAH / EDIT
  Future<void> _bukaTambahCatatan({Catatan? catatan, int? index}) async {
    final hasil = await Navigator.push(
      context,

      MaterialPageRoute(
        builder: (_) => TambahCatatanPage(catatan: catatan, index: index),
      ),
    );

    if (hasil != null) {
      final Catatan hasilCatatan = hasil['catatan'];
      final int? hasilIndex = hasil['index'];

      setState(() {
        // EDIT
        if (hasilIndex != null) {
          _catatan[hasilIndex] = hasilCatatan;
        }
        // TAMBAH
        else {
          _catatan.add(hasilCatatan);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // APPBAR
      appBar: AppBar(title: const Text('Catatan Mahasiswa')),

      // BODY
      body: Column(
        children: [
          // FILTER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),

            child: Row(
              children: [
                const Icon(Icons.filter_list),

                const SizedBox(width: 10),

                const Text(
                  'Filter:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),

                const SizedBox(width: 15),

                DropdownButton<String>(
                  value: _filterKategori,

                  items: const [
                    DropdownMenuItem(value: 'Semua', child: Text('Semua')),

                    DropdownMenuItem(value: 'Kuliah', child: Text('Kuliah')),

                    DropdownMenuItem(value: 'Tugas', child: Text('Tugas')),

                    DropdownMenuItem(value: 'Pribadi', child: Text('Pribadi')),

                    DropdownMenuItem(value: 'Lainnya', child: Text('Lainnya')),
                  ],

                  onChanged: (v) {
                    if (v != null) {
                      setState(() {
                        _filterKategori = v;
                      });
                    }
                  },
                ),
              ],
            ),
          ),

          // LIST CATATAN
          Expanded(
            child: _catatanFilter.isEmpty
                ? const Center(
                    child: Text(
                      'Belum ada catatan',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    itemCount: _catatanFilter.length,

                    itemBuilder: (context, i) {
                      final c = _catatanFilter[i];

                      return ListTile(
                        // JUDUL
                        title: Text(c.judul),

                        // SUBTITLE
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text(c.kategori),

                            Text(
                              _formatTanggal(c.dibuatPada),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),

                        // TRAILING
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,

                          children: [
                            // EDIT
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),

                              onPressed: () {
                                _bukaTambahCatatan(catatan: c, index: i);
                              },
                            ),

                            // DELETE
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),

                              onPressed: () {
                                setState(() {
                                  _catatan.remove(c);
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Catatan dihapus'),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),

                        // DETAIL
                        onTap: () {
                          Navigator.push(
                            context,

                            MaterialPageRoute(
                              builder: (_) => DetailCatatanPage(catatan: c),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),

      // FLOATING BUTTON
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _bukaTambahCatatan();
        },

        child: const Icon(Icons.add),
      ),
    );
  }
}

// HALAMAN TAMBAH CATATAN
class TambahCatatanPage extends StatefulWidget {
  // DATA EDIT
  final Catatan? catatan;
  final int? index;

  const TambahCatatanPage({super.key, this.catatan, this.index});

  @override
  State<TambahCatatanPage> createState() => _TambahCatatanPageState();
}

// STATE TAMBAH CATATAN
class _TambahCatatanPageState extends State<TambahCatatanPage> {
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

  // INIT EDIT
  @override
  void initState() {
    super.initState();

    // JIKA EDIT
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
  void _simpan() {
    if (!_formKey.currentState!.validate()) return;

    final catatanBaru = Catatan(
      judul: _judulCtrl.text.trim(),

      isi: _isiCtrl.text.trim(),

      kategori: _kategori,

      dibuatPada: DateTime.now(),
    );

    // KIRIM DATA + INDEX
    Navigator.pop(context, {'catatan': catatanBaru, 'index': widget.index});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.catatan == null ? 'Tambah Catatan' : 'Edit Catatan'),
      ),

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

              items: _kategoriOpsi
                  .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                  .toList(),

              onChanged: (v) {
                if (v != null) {
                  setState(() {
                    _kategori = v;
                  });
                }
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

// HALAMAN DETAIL
class DetailCatatanPage extends StatelessWidget {
  final Catatan catatan;

  const DetailCatatanPage({super.key, required this.catatan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Catatan')),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              catatan.judul,

              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text('Kategori: ${catatan.kategori}'),

            const SizedBox(height: 10),

            Text(catatan.isi),
          ],
        ),
      ),
    );
  }
}
