#import "CustomFCMReceiver.h"
#import "CustomFCMReceiverPlugin.h"

@implementation CustomFCMReceiver

static NSString*const javascriptNamespace = @"cordova.plugin.customfcmreceiver";

- (bool) sendNotification:(NSDictionary *)userInfo {
    bool isHandled = false;
    // if([userInfo objectForKey:@"sendbird"] != nil){
    //     isHandled = true;
    //     [CustomFCMReceiverPlugin executeGlobalJavascript:[NSString stringWithFormat:@"%@._onMessageReceived(\"%@\")", javascriptNamespace, [self escapeDoubleQuotes:[self dictionaryToString:[userInfo objectForKey:@"sendbird"]]]]];
    // }
    return isHandled;
}

- (NSString*)dictionaryToString:(NSDictionary*) sendbird {
    NSError *error; 
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:sendbird 
                                                    options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                        error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }
}

- (NSString*)escapeDoubleQuotes: (NSString*)str {
    NSString *result =[str stringByReplacingOccurrencesOfString: @"\"" withString: @"\\\""];
    return result;
}

@end
