#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint ml_kit_ocr.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'ml_kit_ocr'
  s.version          = '0.0.4'
  s.summary          = 'Flutter Plugin for ML Kit ocr'
  s.description      = <<-DESC
Flutter Plugin for ML Kit ocr.
                       DESC
  s.homepage         = 'https://github.com/madhavtripathi05/ml_kit_ocr'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'GoogleMLKit/TextRecognition', '~> 2.6.0'
  s.platform = :ios, '10.0'
  s.ios.deployment_target = '10.0'
  s.static_framework = true

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
