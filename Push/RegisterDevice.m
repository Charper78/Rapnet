//
//  RegisterDevice.m
//  Rapnet
//
//  Created by Home on 4/26/13.
//  Copyright (c) 2013 coolban@gmail.com. All rights reserved.
//

#import "RegisterDevice.h"

@implementation RegisterDevice

+(void)registerDevice
{
    [RegisterDevice registerDevice:nil];
}

+(void)registerDevice:(NSString*)clientID
{
    RegisterDevice *reg = [[RegisterDevice alloc] init];
    [reg performSelectorInBackground:@selector(performRegistration:) withObject:clientID];
}

-(void)performRegistration : (NSString*)clientID
{
    // Get Bundle Info for Remote Registration (handy if you have more than one app)
	NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
	NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
	
	// Check what Notifications the user has turned on.  We registered for all three, but they may have manually disabled some or all of them.
	NSUInteger rntypes = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
	
	// Set the defaults to disabled unless we find otherwise...
	BOOL *pushBadge = (rntypes & UIRemoteNotificationTypeBadge) ? TRUE : FALSE;
	BOOL *pushAlert = (rntypes & UIRemoteNotificationTypeAlert) ? TRUE : FALSE;
	BOOL *pushSound = (rntypes & UIRemoteNotificationTypeSound) ? TRUE : FALSE;
	
	// Get the users Device Model, Display Name, Unique ID, Token & Version Number
	UIDevice *dev = [UIDevice currentDevice];
	NSString *deviceModel = dev.model;
	NSString *deviceSystemVersion = dev.systemVersion;
	NSString *deviceToken = [NotificationSettings getDeviceToken];
    
	// Prepare the Device Token for Registration (remove spaces and < >)
	/*NSString *deviceToken = [[[[devToken description]
     stringByReplacingOccurrencesOfString:@"<"withString:@""]
     stringByReplacingOccurrencesOfString:@">" withString:@""]
     stringByReplacingOccurrencesOfString: @" " withString: @""];
     */
    
    RegisterDeviceParser *reg = [[RegisterDeviceParser alloc] init];
    BOOL r = [reg registerDevice:appName appVersion:appVersion clientID:clientID deviceToken:deviceToken deviceModel:deviceModel deviceVersion:deviceSystemVersion pushBadge:pushBadge pushAlert:pushAlert pushSound:pushSound];
    NSLog(@"Return Data: %@", [Functions boolToString: r]);

}

@end
