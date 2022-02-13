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
  String timeElapsed = '';
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('MlKit ocr example app'),
        ),
        body: ListView(
          physics: const ClampingScrollPhysics(),
          children: [
            const SizedBox(height: 20),
            if (image != null)
              SizedBox(
                height: 200,
                width: 200,
                child: InteractiveViewer(
                  child: Image.file(
                    File(image!.path),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            const SizedBox(height: 20),
            if (recognitions.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SelectableText('Recognized Text: $recognitions'),
              ),
            if (timeElapsed.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Time elapsed: $timeElapsed ms'),
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
                    timeElapsed = '';
                    setState(() {});
                  },
                  child: const Text('Pick Image'),
                ),
                if (image != null)
                  isProcessing
                      ? const Center(
                          child: CircularProgressIndicator.adaptive(),
                        )
                      : ElevatedButton(
                          onPressed: () async {
                            recognitions = '';
                            final ocr = MlKitOcr();
                            final stopwatch = Stopwatch()..start();
                            isProcessing = true;
                            setState(() {});
                            final result = await ocr.processImage(
                                InputImage.fromFilePath(image!.path));
                            timeElapsed =
                                stopwatch.elapsedMilliseconds.toString();
                            isProcessing = false;
                            stopwatch.reset();
                            stopwatch.stop();
                            for (var blocks in result.blocks) {
                              for (var lines in blocks.lines) {
                                recognitions += '\n';
                                for (var words in lines.elements) {
                                  recognitions += words.text + ' ';
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
