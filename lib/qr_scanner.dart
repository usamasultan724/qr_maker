import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class QrScanner extends StatefulWidget {
  const QrScanner({super.key});

  @override
  State<QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
  String _scanResult = 'Scan a QR Code';

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final color =  isDarkMode ? '#000000' : '#FFFFFF';
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scanner'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeInDown(
              child: Text(
                _scanResult,
                style: const TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            FadeInUp(
              child: ElevatedButton(
                onPressed: ()=>scanQRCode(color),
                child: const Text('Start QR Scan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<void> scanQRCode(String color) async {
    try {
      String scanResult = await FlutterBarcodeScanner.scanBarcode(
        color, // Color of the scanning line
        'Cancel', // Button to cancel the scan
        true, // Whether to show the flash icon
        ScanMode.QR,
      );

      if (scanResult != '-1') {
        setState(() {
          _scanResult = scanResult;
        });
      }
    } catch (e) {
      setState(() {
        _scanResult = 'Failed to scan QR code: $e';
      });
    }
  }
}
