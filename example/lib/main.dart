import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

import 'package:ml_kit_ocr/ml_kit_ocr.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  XFile? image;
  String recognitions = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('MlKit ocr example app'),
        ),
        body: ListView(
          children: [
            const SizedBox(height: 20),
            if (image != null)
              SizedBox(
                height: 200,
                width: 200,
                child: Image.file(
                  File(image!.path),
                  fit: BoxFit.contain,
                ),
              ),
            const SizedBox(height: 20),
            if (recognitions.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Recognized Text: $recognitions'),
              ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    image = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                    recognitions = '';
                    setState(() {});
                  },
                  child: const Text('Pick Image'),
                ),
                if (image != null)
                  ElevatedButton(
                    onPressed: () async {
                      final ocr = MlKitOcr();
                      final result = await ocr
                          .processImage(InputImage.fromFilePath(image!.path));
                      recognitions = '';
                      for (var blocks in result.blocks) {
                        for (var lines in blocks.lines) {
                          for (var words in lines.elements) {
                            recognitions += words.text;
                          }
                        }
                      }
                      setState(() {});
                    },
                    child: const Text('Predict from Image'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
