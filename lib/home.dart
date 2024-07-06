import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/vt_resep.dart';
import 'list_resep.dart';
// Suggested code may be subject to a license. Learn more: ~LicenseLog:4248592281.
import 'profile.dart';
// Suggested code may be subject to a license. Learn more: ~LicenseLog:2356447146.
import 'scan.dart';

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
          centerTitle: true,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: GestureDetector(
                onTap: () {
                  // Define the action when the profile icon is tapped
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()),
                  );
                },
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/profile_picture.png'), // Replace with your profile image asset
                ),
              ),
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.list), text: 'Resep'),
              Tab(icon: Icon(Icons.video_library), text: 'Video Tutorial'),
              Tab(icon: Icon(Icons.qr_code), text: 'Scan'),
            ],
            labelColor: Color.fromARGB(255, 159, 143, 143),
          ),
        ),
        body: TabBarView(
          children: [
            DataList(),
            FirebaseVideoPlayer(),
            ScanPage(),
          ],
        ),
      ),
    );
  }
}

// Placeholder for ProfileScreen. Replace with your actual profile screen.
