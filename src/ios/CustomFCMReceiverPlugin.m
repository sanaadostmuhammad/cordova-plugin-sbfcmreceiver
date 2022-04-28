#import "CustomFCMReceiverPlugin.h"
#import "CustomFCMReceiver.h"

@implementation CustomFCMReceiverPlugin

static CustomFCMReceiverPlugin* customFCMReceiverPlugin;
static CustomFCMReceiver* customFCMReceiver;

@synthesize notificationCallbackId;
@synthesize notificationStack;


static NSInteger const kNotificationStackSize = 10;

+ (CustomFCMReceiverPlugin*) customFCMReceiverPlugin {
    return customFCMReceiverPlugin;
}

- (void)pluginInitialize {
    customFCMReceiverPlugin = self;
    customFCMReceiver = [[CustomFCMReceiver alloc] init];
}


- (void)coolMethod:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* echo = [command.arguments objectAtIndex:0];

    if (echo != nil && [echo length] > 0) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:echo];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)onMessageReceived:(CDVInvokedUrlCommand *)command {
    @try {
        self.notificationCallbackId = command.callbackId;

        if (self.notificationStack != nil && [self.notificationStack count]) {
            for (NSDictionary *userInfo in self.notificationStack) {
                [CustomFCMReceiverPlugin passSendbirdPaylod:userInfo];
            }
            [self.notificationStack removeAllObjects];
        }
    }@catch (NSException *exception) {
        [self handlePluginExceptionWithContext:exception :command];
    }
}


- (void) handlePluginExceptionWithContext: (NSException*) exception :(CDVInvokedUrlCommand*)command
{
    NSLog(@"%@ ERROR: %@", @"CustomFCMReceiverPlugin", exception);
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:exception.reason];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

+ (void)processNotification:(NSDictionary *)userInfo {
    if (customFCMReceiverPlugin.notificationCallbackId != nil) {
        [CustomFCMReceiverPlugin passSendbirdPaylod:userInfo];
    } else {
        if (!customFCMReceiverPlugin.notificationStack) {
            customFCMReceiverPlugin.notificationStack = [[NSMutableArray alloc] init];
        }

        // stack notifications until a callback has been registered
        [customFCMReceiverPlugin.notificationStack addObject:userInfo];

        if ([customFCMReceiverPlugin.notificationStack count] >= kNotificationStackSize) {
            [customFCMReceiverPlugin.notificationStack removeLastObject];
        }
    }
    
}

+ (void)passSendbirdPaylod:(NSDictionary *)userInfo {
    CDVPluginResult* pluginResult = nil;

    @try {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:userInfo];
        [pluginResult setKeepCallbackAsBool:YES];
    }@catch (NSException *exception) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }
    [customFCMReceiverPlugin.commandDelegate sendPluginResult:pluginResult callbackId:customFCMReceiverPlugin.notificationCallbackId];
}

@end
