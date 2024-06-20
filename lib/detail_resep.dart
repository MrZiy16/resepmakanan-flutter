import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';

class DetailResep extends StatefulWidget {
  final DocumentSnapshot document;

  DetailResep(this.document);

  @override
  _DetailResepState createState() => _DetailResepState();
}

class _DetailResepState extends State<DetailResep> {
  late Map<String, dynamic> data;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaController;
  late TextEditingController _deskripsiController;
  late TextEditingController _resepController;
  File? _imageFile;
  final picker = ImagePicker();
  final uuid = Uuid();

  @override
  void initState() {
    super.initState();
    data = widget.document.data() as Map<String, dynamic>;
    _namaController = TextEditingController(text: data['nama']);
    _deskripsiController = TextEditingController(text: data['deskripsi']);
    _resepController = TextEditingController(text: data['resep']);
  }

  @override
  void dispose() {
    _namaController.dispose();
    _deskripsiController.dispose();
    _resepController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tidak ada gambar yang dipilih')),
        );
      }
    });
  }

  Future<String?> _uploadImage(File image) async {
    try {
      // Generate a unique ID for the image
      String imageId = uuid.v4();
      // Reference to Firebase Storage
      final storageRef = FirebaseStorage.instance.ref().child('kuliner_images/$imageId.jpg');
      // Upload the file to Firebase Storage
      final uploadTask = storageRef.putFile(image);
      await uploadTask;
      // Get the download URL of the uploaded image
      String downloadURL = await storageRef.getDownloadURL();
      return downloadURL;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal meng-upload gambar: $e')),
      );
      return null;
    }
  }

  void _editResep() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Resep'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: _namaController,
                    decoration: InputDecoration(labelText: 'Nama'),
                    validator: (value) => value!.isEmpty ? 'Nama tidak boleh kosong' : null,
                  ),
                  TextFormField(
                    controller: _deskripsiController,
                    decoration: InputDecoration(labelText: 'Deskripsi'),
                  ),
                  TextFormField(
                    controller: _resepController,
                    decoration: InputDecoration(labelText: 'Resep'),
                    maxLines: 3,
                  ),
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: Text('Pilih Gambar dari Galeri'),
                  ),
                  SizedBox(height: 10),
                  _imageFile == null
                      ? (data['gambar'] != null && data['gambar'].isNotEmpty
                          ? Image.network(data['gambar'], height: 100)
                          : Text('Belum ada gambar yang dipilih'))
                      : Image.file(_imageFile!, height: 100),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Batal'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Simpan'),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  String? imageUrl = data['gambar'];
                  if (_imageFile != null) {
                    imageUrl = await _uploadImage(_imageFile!);
                  }
                  if (imageUrl != null) {
                    widget.document.reference.update({
                      'nama': _namaController.text,
                      'deskripsi': _deskripsiController.text,
                      'resep': _resepController.text,
                      'gambar': imageUrl,
                    }).then((_) {
                      Navigator.of(context).pop();
                      setState(() {
                        data = {
                          'nama': _namaController.text,
                          'deskripsi': _deskripsiController.text,
                          'resep': _resepController.text,
                          'gambar': imageUrl,
                        };
                      });
                    });
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _hapusResep() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi'),
          content: Text('Apakah Anda yakin ingin menghapus resep ini?'),
          actions: <Widget>[
            TextButton(
              child: Text('Batal'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Hapus'),
              onPressed: () {
                widget.document.reference.delete().then((_) {
                  Navigator.of(context).pop(); // Tutup dialog
                  Navigator.of(context).pop(); // Kembali ke halaman sebelumnya
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data['nama']),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: _editResep,
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _hapusResep,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (data['gambar'] != null && data['gambar'].isNotEmpty)
              Image.network(
                data['gambar'],
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['nama'],
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Deskripsi:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(data['deskripsi'] ?? 'Tidak ada deskripsi'),
                  SizedBox(height: 16),
                  Text(
                    'Resep:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(data['resep'] ?? 'Tidak ada resep'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
