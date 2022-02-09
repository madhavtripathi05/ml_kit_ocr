#import "MlKitOcrPlugin.h"
#if __has_include(<ml_kit_ocr/ml_kit_ocr-Swift.h>)
#import <ml_kit_ocr/ml_kit_ocr-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "ml_kit_ocr-Swift.h"
#endif

@implementation MlKitOcrPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftMlKitOcrPlugin registerWithRegistrar:registrar];
}
@end
