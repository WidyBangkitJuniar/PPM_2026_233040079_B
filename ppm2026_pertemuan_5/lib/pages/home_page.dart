import 'package:flutter/material.dart';

import '../db_helper.dart';

import '../model/catatan.dart';

import 'catatan_form_page.dart';
import 'detail_catatan_page.dart';

// HOMEPAGE
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

// STATE HOMEPAGE
class _HomePageState extends State<HomePage> {
  // FUTURE LIST CATATAN
  late Future<List<Catatan>> _futureCatatan;

  // FILTER
  String _filterKategori = 'Semua';

  @override
  void initState() {
    super.initState();

    _muatUlang();
  }

  // REFRESH DATA
  void _muatUlang() {
    setState(() {
      _futureCatatan = DbHelper.instance.getAll();
    });
  }

  // FORMAT TANGGAL
  String _formatTanggal(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  // BUKA FORM
  Future<void> _bukaForm({Catatan? catatan}) async {
    await Navigator.push(
      context,

      MaterialPageRoute(builder: (_) => CatatanFormPage(catatan: catatan)),
    );

    // REFRESH
    _muatUlang();
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

          // LIST DATA
          Expanded(
            child: FutureBuilder<List<Catatan>>(
              future: _futureCatatan,

              builder: (context, snapshot) {
                // LOADING
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }

                // ERROR
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                // DATA
                final data = snapshot.data ?? [];

                // FILTER DATA
                final filterData = _filterKategori == 'Semua'
                    ? data
                    : data.where((c) {
                        return c.kategori == _filterKategori;
                      }).toList();

                // EMPTY
                if (filterData.isEmpty) {
                  return const Center(
                    child: Text(
                      'Belum ada catatan',

                      style: TextStyle(fontSize: 18),
                    ),
                  );
                }

                // LISTVIEW
                return ListView.builder(
                  itemCount: filterData.length,

                  itemBuilder: (context, i) {
                    final c = filterData[i];

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
                              _bukaForm(catatan: c);
                            },
                          ),

                          // DELETE
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),

                            onPressed: () async {
                              // DIALOG
                              final yakin = await showDialog<bool>(
                                context: context,

                                builder: (_) {
                                  return AlertDialog(
                                    title: const Text('Hapus Catatan'),

                                    content: const Text(
                                      'Yakin ingin menghapus?',
                                    ),

                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context, false);
                                        },

                                        child: const Text('Batal'),
                                      ),

                                      FilledButton(
                                        onPressed: () {
                                          Navigator.pop(context, true);
                                        },

                                        child: const Text('Hapus'),
                                      ),
                                    ],
                                  );
                                },
                              );

                              // DELETE
                              if (yakin == true) {
                                await DbHelper.instance.delete(c.id!);

                                _muatUlang();

                                if (!mounted) {
                                  return;
                                }

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Catatan dihapus'),
                                  ),
                                );
                              }
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
                );
              },
            ),
          ),
        ],
      ),

      // FLOATING BUTTON
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _bukaForm();
        },

        child: const Icon(Icons.add),
      ),
    );
  }
}
