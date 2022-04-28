#import <Cordova/CDV.h>

@interface CustomFCMReceiverPlugin : CDVPlugin

@property(nonatomic, copy) NSString *notificationCallbackId;

+ (CustomFCMReceiverPlugin *)customFCMReceiverPlugin;

- (void)coolMethod:(CDVInvokedUrlCommand *)command;
- (void)onMessageReceived:(CDVInvokedUrlCommand *)command;
- (void)handlePluginExceptionWithContext:(NSException *)exception:(CDVInvokedUrlCommand *)command;

+ (void)passSendbirdPaylod:(NSDictionary *)userInfo;
@end
