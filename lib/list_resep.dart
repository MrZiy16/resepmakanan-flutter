// File: list_resep.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'detail_resep.dart';
import 'tambah_resep.dart'; // Pastikan untuk mengimpor ini

class DataList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('kuliner').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          var data = snapshot.data!.docs;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              var item = data[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailResep(item),
                    ),
                  );
                },
                child: Card(
                  elevation: 3,
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (item['gambar'] != null && item['gambar'].isNotEmpty)
                          Image.network(
                            item['gambar'],
                            width: double.infinity,
                            height: 300,
                            fit: BoxFit.cover,
                          ),
                        SizedBox(height: 10),
                        Text(
                          item['nama'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TambahData()),
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Add Data',
        backgroundColor: Color.fromARGB(255, 159, 143, 143),
      ),
    );
  }
}