import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/vt_resep.dart';
import 'list_resep.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'KULINERIN',
            style: GoogleFonts.aclonica(
              textStyle: TextStyle(
                color: Color.fromARGB(255, 159, 143, 143),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          centerTitle: true, // Center the title
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.list), text: 'Resep'),
              Tab(icon: Icon(Icons.video_library), text: 'Video Tutorial'),
              Tab(icon: Icon(Icons.person), text: 'Profil'),
            ],
            labelColor: Color.fromARGB(255, 159, 143, 143),
          ),
        ),
        body: TabBarView(
          children: [
            DataList(),
            FirebaseVideoPlayer(),
            Center(child: Text('Halaman Profil')),
          ],
        ),
      ),
    );
  }
}
