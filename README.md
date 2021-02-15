# MLKit OCR

Plugin which provides native ML Kit OCR APIs

### Requirements

**Android**
- Set `minSdkVersion 21` in `android/app/build.gradle`
- Set `ext.kotlin_version = '1.6.10'` in `android/build.gradle`
- Add `<meta-data android:name="com.google.mlkit.vision.DEPENDENCIES" android:value="ocr" />`  in  `android/src/main/AndroidManifest.xml`
- Note: In case you are using multiple models separate them with commas `android:value="ocr,ica"`
- *App size impact: 260KB*, refer [here](https://developers.google.com/ml-kit/vision/text-recognition/android)

**iOS**
- Minimum iOS Deployment Target: 10.0
- Xcode 12.5.1 or greater.
- ML Kit only supports 64-bit architectures (x86_64 and arm64). Check this [list](https://developer.apple.com/support/required-device-capabilities/) to see if your device has the required device capabilities.
- Since ML Kit does not support 32-bit architectures (i386 and armv7) [Read more](https://developers.google.com/ml-kit/migration/ios), you need to exclude amrv7 architectures in Xcode in order to build iOS
- *App size impact: About 20 MB*, refer [here](https://developers.google.com/ml-kit/vision/text-recognition/ios)


### Usage 
```dart
// Create an Instance of [MlKitOcr]
final ocr = MlKitOcr();

//...
// Pick Image using image picker
//...

// Call `processImage()` and pass params as `InputImage` [check example for more info]
final result = await ocr
    .processImage(InputImage.fromFilePath(image.path));
recognitions = '';

// Iterate over TextBlocks 
for (var blocks in result.blocks) {
    for (var lines in blocks.lines) {
        for (var words in lines.elements) {
            recognitions += words.text;
        }
    }
}
```

This plugin is basically a trimmed down version of [google_ml_kit](https://pub.dev/packages/google_ml_kit). As google_ml_kit contains all the NLP and Vison APIs, the App size increases drastically. So, I created this plugin and now the example app's fat apk is of 17MB and splitted apks are 6MB.




