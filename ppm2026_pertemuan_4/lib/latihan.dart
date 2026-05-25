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

  // Constructor
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
    // MaterialApp
    return MaterialApp(
      // Judul aplikasi
      title: 'Catatan Mahasiswa',

      // Menghilangkan debug banner
      debugShowCheckedModeBanner: false,

      // Theme aplikasi
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),

      // Route pertama saat aplikasi dibuka
      initialRoute: '/',

      // Named Route
      routes: {
        // Route Home
        '/': (context) => const HomePage(),

        // Route Tambah Catatan
        '/tambah': (context) => const TambahCatatanPage(),
      },

      // Route yang membutuhkan argument/data
      onGenerateRoute: (settings) {
        switch (settings.name) {
          // Route Detail
          case '/detail':
            // Ambil data dari arguments
            final catatan = settings.arguments as Catatan;

            return MaterialPageRoute(
              builder: (_) => DetailCatatanPage(catatan: catatan),
            );
        }

        return null;
      },
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
  // State list catatan
  final List<Catatan> _catatan = [
    // Data awal
    Catatan(
      judul: 'Belajar Flutter',
      isi: 'Mempelajari Stateful Widget, Form, dan Navigation.',
      kategori: 'Kuliah',
      dibuatPada: DateTime.now(),
    ),
  ];

  // Format tanggal
  String _formatTanggal(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  // Function membuka halaman tambah catatan
  Future<void> _bukaTambahCatatan() async {
    // Pindah halaman menggunakan named route
    final hasil = await Navigator.pushNamed(context, '/tambah');

    // Jika hasil berupa Catatan
    if (hasil is Catatan) {
      // Tambahkan ke list
      setState(() {
        _catatan.add(hasil);
      });

      // Cek widget masih aktif
      if (!mounted) return;

      // Tampilkan snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Catatan "${hasil.judul}" ditambahkan')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar
      appBar: AppBar(title: const Text('Catatan Mahasiswa')),

      // Body
      body: _catatan.isEmpty
          ? const Center(
              child: Text('Belum ada catatan', style: TextStyle(fontSize: 18)),
            )
          : ListView.builder(
              // Jumlah item
              itemCount: _catatan.length,

              // Builder item list
              itemBuilder: (context, i) {
                // Ambil data catatan
                final c = _catatan[i];

                return ListTile(
                  // Judul
                  title: Text(c.judul),

                  // Subtitle
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Kategori
                      Text(c.kategori),

                      // Tanggal
                      Text(
                        _formatTanggal(c.dibuatPada),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),

                  // Tombol hapus
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),

                    onPressed: () {
                      setState(() {
                        _catatan.removeAt(i);
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Catatan dihapus')),
                      );
                    },
                  ),

                  // Detail catatan
                  onTap: () {
                    Navigator.pushNamed(context, '/detail', arguments: c);
                  },
                );
              },
            ),

      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        // Ketika ditekan
        onPressed: _bukaTambahCatatan,

        // Icon
        child: const Icon(Icons.add),
      ),
    );
  }
}

// HALAMAN TAMBAH CATATAN
class TambahCatatanPage extends StatefulWidget {
  const TambahCatatanPage({super.key});

  @override
  State<TambahCatatanPage> createState() => _TambahCatatanPageState();
}

// STATE TAMBAH CATATAN
class _TambahCatatanPageState extends State<TambahCatatanPage> {
  // Key Form
  final _formKey = GlobalKey<FormState>();

  // Controller TextField
  final _judulCtrl = TextEditingController();
  final _isiCtrl = TextEditingController();

  // Nilai default dropdown
  String _kategori = 'Kuliah';

  // Opsi dropdown
  final _kategoriOpsi = const ['Kuliah', 'Tugas', 'Pribadi', 'Lainnya'];

  @override
  void dispose() {
    // Hapus controller
    _judulCtrl.dispose();
    _isiCtrl.dispose();

    super.dispose();
  }

  // Function simpan data
  void _simpan() {
    // Validasi form
    if (!_formKey.currentState!.validate()) return;

    // Membuat object catatan baru
    final catatanBaru = Catatan(
      judul: _judulCtrl.text.trim(),

      isi: _isiCtrl.text.trim(),

      kategori: _kategori,

      dibuatPada: DateTime.now(),
    );

    // Kembali ke halaman sebelumnya
    // sambil mengirim data
    Navigator.pop(context, catatanBaru);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar
      appBar: AppBar(title: const Text('Tambah Catatan')),

      // Body
      body: Form(
        // Key form
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

              // Validasi judul
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

            // DROPDOWN KATEGORI
            DropdownButtonFormField<String>(
              value: _kategori,

              decoration: const InputDecoration(
                labelText: 'Kategori',
                prefixIcon: Icon(Icons.category),
                border: OutlineInputBorder(),
              ),

              // Isi dropdown
              items: _kategoriOpsi
                  .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                  .toList(),

              // Saat dropdown berubah
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

              // Validasi isi
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
              // Saat ditekan
              onPressed: _simpan,

              // Icon
              icon: const Icon(Icons.save),

              // Text
              label: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}

// HALAMAN DETAIL CATATAN
class DetailCatatanPage extends StatelessWidget {
  // Menerima data catatan
  final Catatan catatan;

  const DetailCatatanPage({super.key, required this.catatan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar
      appBar: AppBar(title: const Text('Detail Catatan')),

      // Body
      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // Judul
            Text(
              catatan.judul,

              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            // Kategori
            Text('Kategori: ${catatan.kategori}'),

            const SizedBox(height: 10),

            // Isi catatan
            Text(catatan.isi),
          ],
        ),
      ),
    );
  }
}
