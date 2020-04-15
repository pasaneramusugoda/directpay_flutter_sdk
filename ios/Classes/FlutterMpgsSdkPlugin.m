#import "FlutterMpgsSdkPlugin.h"
#if __has_include(<flutter_mpgs_sdk/flutter_mpgs_sdk-Swift.h>)
#import <flutter_mpgs_sdk/flutter_mpgs_sdk-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_mpgs-Swift.h"
#endif

@implementation FlutterMpgsSdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    [SwiftFlutterMPGSPlugin registerWithRegistrar:registrar];
}
@end
