import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  String _scanResult = 'Belum ada hasil scan';
  final BarcodeScanner _barcodeScanner = BarcodeScanner();

  Future<void> _scanBarcode() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Batal',
        true,
        ScanMode.BARCODE,
      );
    } catch (e) {
      barcodeScanRes = 'Gagal melakukan pemindaian: $e';
    }

    if (!mounted) return;

    setState(() {
      _scanResult = barcodeScanRes != '-1' ? barcodeScanRes : 'Scan dibatalkan';
    });
  }

  Future<void> _getImageFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final InputImage inputImage = InputImage.fromFilePath(image.path);
      try {
        final List<Barcode> barcodes = await _barcodeScanner.processImage(inputImage);

        if (barcodes.isNotEmpty) {
          setState(() {
            _scanResult = barcodes.first.rawValue ?? 'Tidak dapat membaca barcode';
          });
        } else {
          setState(() {
            _scanResult = 'Tidak ditemukan barcode';
          });
        }
      } catch (e) {
        setState(() {
          _scanResult = 'Error saat memproses gambar: $e';
        });
      }
    }
  }

  @override
  void dispose() {
    _barcodeScanner.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Barcode Scanner'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Hasil Scan:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              _scanResult,
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _scanBarcode,
              child: Text('Scan Barcode'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _getImageFromGallery,
              child: Text('Pilih dari Galeri'),
            ),
          ],
        ),
      ),
    );
  }
}