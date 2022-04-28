#import "CustomFCMReceiver.h"
#import "CustomFCMReceiverPlugin.h"

@implementation CustomFCMReceiver

static NSString*const javascriptNamespace = @"cordova.plugin.customfcmreceiver";

- (bool) sendNotification:(NSDictionary *)userInfo {
    bool isHandled = false;
    if([userInfo objectForKey:@"sendbird"] != nil){
        isHandled = true;
        [CustomFCMReceiverPlugin passSendbirdPaylod:userInfo];
    }
    return isHandled;
}

@end
