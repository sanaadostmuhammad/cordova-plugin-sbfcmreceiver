#import "CustomFCMReceiverPlugin.h"
#import "CustomFCMReceiver.h"

@implementation CustomFCMReceiverPlugin

static CustomFCMReceiverPlugin* customFCMReceiverPlugin;
static CustomFCMReceiver* customFCMReceiver;

@synthesize notificationCallbackId;

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
    }@catch (NSException *exception) {
        [self handlePluginExceptionWithContext:exception :command];
    }
}

- (void) handlePluginExceptionWithContext: (NSException*) exception :(CDVInvokedUrlCommand*)command
{
    [self handlePluginExceptionWithoutContext:exception];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:exception.reason];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

+ (void)passSendbirdPaylod:(NSDictionary *)userInfo {
    CDVPluginResult* pluginResult = nil;

    @try {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:userInfo];
    }@catch (NSException *exception) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }
    [customFCMReceiverPlugin.commandDelegate sendPluginResult:pluginResult callbackId:customFCMReceiverPlugin.notificationCallbackId];
}

@end
