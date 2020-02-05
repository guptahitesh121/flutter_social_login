#import "FlutterSocialLoginPlugin.h"
#if __has_include(<flutter_social_login/flutter_social_login-Swift.h>)
#import <flutter_social_login/flutter_social_login-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_social_login-Swift.h"
#endif

@implementation FlutterSocialLoginPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterSocialLoginPlugin registerWithRegistrar:registrar];
}
@end
