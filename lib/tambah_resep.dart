import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';

class TambahData extends StatefulWidget {
  @override
  _TambahDataState createState() => _TambahDataState();
}

class _TambahDataState extends State<TambahData> {
  final _formKey = GlobalKey<FormState>();
  String _nama = '';
  String _deskripsi = '';
  String _resep = '';
  File? _imageFile;
  final picker = ImagePicker();
  final uuid = Uuid();

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

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Upload image to Firebase Storage
      String? imageUrl;
      if (_imageFile != null) {
        imageUrl = await _uploadImage(_imageFile!);
      }

      if (imageUrl != null) {
        // Save data to Firestore
        CollectionReference kuliner = FirebaseFirestore.instance.collection('kuliner');

        kuliner.add({
          'nama': _nama,
          'deskripsi': _deskripsi,
          'resep': _resep,
          'gambar': imageUrl,
          'timestamp': FieldValue.serverTimestamp(),
        }).then((value) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Data berhasil ditambahkan')),
          );
          Navigator.pop(context); // Kembali ke halaman sebelumnya
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $error')),
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Data Kuliner'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Nama Makanan'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mohon masukkan nama makanan';
                  }
                  return null;
                },
                onSaved: (value) => _nama = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Deskripsi'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mohon masukkan deskripsi';
                  }
                  return null;
                },
                onSaved: (value) => _deskripsi = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Resep'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mohon masukkan resep';
                  }
                  return null;
                },
                onSaved: (value) => _resep = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Pilih Gambar dari Galeri'),
              ),
              SizedBox(height: 10),
              _imageFile == null
                  ? Text('Belum ada gambar yang dipilih')
                  : Image.file(
                      _imageFile!,
                      height: 200,
                    ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
