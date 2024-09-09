import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

class QRGenerator extends StatefulWidget {
  const QRGenerator({super.key});

  @override
  State<QRGenerator> createState() => _QRGeneratorState();
}

class _QRGeneratorState extends State<QRGenerator> {
  final TextEditingController _controller = TextEditingController();
  String _inputText = '';
  final ScreenshotController _screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final color = isDarkMode ? Colors.white : Colors.black;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('QR Code Generator'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeInDown(
                child: TextField(
                  controller: _controller,
                  cursorColor: color,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: color), // Border color when enabled
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: color, width: 2.0), // Border color when focused
                    ),
                    labelText: 'Enter text to generate QR code',
                    labelStyle: TextStyle(color: color), // Label text color
                    focusColor: color, // Focus color
                    hoverColor: color, // Hover color
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (_inputText.isNotEmpty)
                FadeInLeft(
                  child: Center(
                    child: Screenshot(
                      controller: _screenshotController,
                      child: QrImageView(
                        eyeStyle: QrEyeStyle(color: color),
                        dataModuleStyle: QrDataModuleStyle(color: isDarkMode ? Colors.white : Colors.black),
                        data: _inputText,
                        version: QrVersions.auto,
                        size: 200.0,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              FadeInUp(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _inputText = _controller.text;
                    });
                  },
                  child: const Text('Generate QR Code'),
                ),
              ),
              if (_inputText.isNotEmpty)
                FadeInLeft(
                  child: ElevatedButton(
                    onPressed: _downloadQR, // Call the download function
                    child: const Text('Download'),
                  ),
                ),
              if (_inputText.isNotEmpty)
                FadeInLeft(
                  child: ElevatedButton(
                    onPressed: _shareQR, // Call the share function
                    child: const Text('Share'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to download the QR code as an image
  Future<void> _downloadQR() async {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final color = isDarkMode ? Colors.white : Colors.black;
    final directory = await getApplicationDocumentsDirectory();
    String filePath = '${directory.path}/qr_code.png';

    await _screenshotController.captureAndSave(directory.path, fileName: "qr_code.png").then((value) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('QR Code saved to $filePath'),
      ));
    }).catchError((err) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error saving QR code: $err'),
        backgroundColor: color,
      ));
    });
  }

  // Method to share the QR code
  Future<void> _shareQR() async {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final color = isDarkMode ? Colors.white : Colors.black;
    final directory = await getApplicationDocumentsDirectory();
    String filePath = '${directory.path}/qr_code.png';

    await _screenshotController.captureAndSave(directory.path, fileName: "qr_code.png").then((value) async{
      // Share.shareFiles([filePath], text: 'Here is your QR Code!');
      await Share.shareXFiles([XFile(filePath)]);
    }).catchError((err) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error sharing QR code: $err'),
        backgroundColor: color,
      ));
    });
  }
}
