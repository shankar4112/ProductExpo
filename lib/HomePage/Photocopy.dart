import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

class PhotocopyPage extends StatefulWidget {
  @override
  _PhotocopyPageState createState() => _PhotocopyPageState();
}

class _PhotocopyPageState extends State<PhotocopyPage> {
  File? selectedFile;
  final TextEditingController quantityController = TextEditingController();

  // Function to pick a file using FilePicker
  Future<void> pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['jpg','png','pdf','doc'],
      );

      if (result != null) {
        setState(() {
          selectedFile = File(result.files.single.path!);
        });
      } else {
        // User canceled the picker
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('File selection canceled.'),
        ));
      }
    } catch (e) {
      // Handle any errors here
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error picking file: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photocopy Service'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Upload File for Photocopy',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            selectedFile == null
                ? Text('No file selected.')
                : Text('Selected file: ${selectedFile!.path.split('/').last}'),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: pickFile,
              child: Text('Choose File'),
            ),
            SizedBox(height: 30),
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Quantity',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement the logic to process the file and quantity
                if (selectedFile != null && quantityController.text.isNotEmpty) {
                  final quantity = int.parse(quantityController.text);
                  // Handle file upload and photocopy logic here
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        'File: ${selectedFile!.path.split('/').last}, Quantity: $quantity'),
                  ));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Please select a file and enter quantity'),
                  ));
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
