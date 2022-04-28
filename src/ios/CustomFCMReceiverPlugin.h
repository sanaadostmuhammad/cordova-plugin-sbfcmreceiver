#import <Cordova/CDV.h>

@interface CustomFCMReceiverPlugin : CDVPlugin

@property(nonatomic, copy) NSString *notificationCallbackId;
@property(nonatomic, retain) NSMutableArray *notificationStack;

+ (CustomFCMReceiverPlugin *)customFCMReceiverPlugin;

- (void)coolMethod:(CDVInvokedUrlCommand *)command;
- (void)onMessageReceived:(CDVInvokedUrlCommand *)command;
- (void)handlePluginExceptionWithContext:(NSException *)exception:(CDVInvokedUrlCommand *)command;

+ (void)processNotification:(NSDictionary *)userInfo;
@end
