import 'package:flutter/material.dart';
import 'galleryhome.dart';
import 'categorypage.dart';
import 'statbox.dart';
import 'sectioncard.dart';
import 'demobutton.dart';
import 'demofeedback.dart';
import 'demoinput.dart';
import 'demolayout.dart';
import 'displaydemo.dart';
import 'quiz.dart';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

// Class MyApp
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfilePage(),
    );
  }
}

// Class ProfilePage
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? image;

  String tentang =
      'Saya suka belajar hal baru, terutama yang berkaitan dengan teknologi dan pengembangan aplikasi mobile.';
  String pendidikan = 'Universitas Pasundan — Semester 6\nIPK: 3.75';
  String hobi = 'Coding • Sepak Bola • Game';
  String kontak = 'widibangkitjuniar@gmail.com\n+62 821-2494-3674';
  String skills = 'Flutter, Dart, Java, SQL';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //AppBar
      appBar: AppBar(
        title: const Text('Profil Saya'),
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
      ),

      //Navigasi Menu
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(leading: Icon(Icons.home), title: Text('Beranda')),
            ListTile(leading: Icon(Icons.person), title: Text('Profil')),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Pengaturan'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) =>
                      AlertDialog(
                        title: const Text('Pengaturan'),
                        content: const Text('Fitur belum tersedia'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                );
              },
            ),
            ListTile(leading: Icon(Icons.info), title: Text('Tentang')),
            ListTile(
              leading: const Icon(Icons.widgets),
              title: const Text('Widget Gallery'),
              onTap: () {
                Navigator.pop(context); // tutup drawer dulu
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GalleryHome()),
                );
              },
            ),
          ],
        ),
      ),

      //Body
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // === HEADER PROFIL ===
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: image != null
                        ? NetworkImage(image!)
                        : const NetworkImage(
                      'https://avatars.githubusercontent.com/u/145557065?s=400&v=4',
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Widy Bangkit Juniar',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Mahasiswa Teknik Informatika',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            // === BARIS STATISTIK (Row + Expanded) ===
            Row(
              children: [
                Expanded(
                  child: StatBox(label: 'Post', value: '12'),
                ),
                Expanded(
                  child: StatBox(label: 'Teman', value: '128'),
                ),
                Expanded(
                  child: StatBox(label: 'Like', value: '1.2K'),
                ),
              ],
            ),

            const SizedBox(height: 24),
            // === SECTION CARD ===
            SectionCard(
              icon: Icons.info_outline,
              title: 'Tentang Saya',
              content: tentang,
            ),
            SectionCard(
              icon: Icons.school,
              title: 'Pendidikan',
              content: pendidikan,
            ),
            SectionCard(
              icon: Icons.favorite,
              title: 'Hobi & Minat',
              content: hobi,
            ),
            SectionCard(icon: Icons.email, title: 'Kontak', content: kontak),
            SectionCard(icon: Icons.star, title: 'Skills', content: skills),
            const SizedBox(height: 80), // ruang agar FAB tidak nutupi konten
          ],
        ),
      ),

      //Button Edit
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const EditProfilePage()),
          );

          if (result != null) {
            setState(() {
              image = result['image'];
              tentang = result['tentang'] ?? tentang;
              pendidikan = result['pendidikan'] ?? pendidikan;
              hobi = result['hobi'] ?? hobi;
              kontak = result['kontak'] ?? kontak;
              skills = result['skills'] ?? skills;
            });
          }
        },
        child: const Icon(Icons.edit),
      ),

      //Button Navigasi Bawah
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (index) {},
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profil'),
          NavigationDestination(icon: Icon(Icons.message), label: 'Pesan'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Setting'),
        ],
      ),
    );
  }
}
