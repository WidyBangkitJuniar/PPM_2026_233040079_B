import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

// Class EditProfilPage
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String? imagePath;

  final tentang = TextEditingController();
  final pendidikan = TextEditingController();
  final hobi = TextEditingController();
  final kontak = TextEditingController();
  final skills = TextEditingController();

  Future pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        imagePath = picked.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage:
                  imagePath != null ? FileImage(File(imagePath!)) : null,
                  child: imagePath == null ? const Icon(Icons.add_a_photo) : null,
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: tentang,
                decoration: const InputDecoration(labelText: 'Tentang'),
              ),
              TextField(
                controller: pendidikan,
                decoration: const InputDecoration(labelText: 'Pendidikan'),
              ),
              TextField(
                controller: hobi,
                decoration: const InputDecoration(labelText: 'Hobi'),
              ),
              TextField(
                controller: kontak,
                decoration: const InputDecoration(labelText: 'Kontak'),
              ),
              TextField(
                controller: skills,
                decoration: const InputDecoration(labelText: 'Skills'),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, {
                    'image': imagePath,
                    'tentang': tentang.text,
                    'pendidikan': pendidikan.text,
                    'hobi': hobi.text,
                    'kontak': kontak.text,
                    'skills': skills.text,
                  });
                },
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

