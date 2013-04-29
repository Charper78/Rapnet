//
//  NotificationSettings.m
//  Rapnet
//
//  Created by Home on 4/25/13.
//  Copyright (c) 2013 coolban@gmail.com. All rights reserved.
//

#import "NotificationSettings.h"

@implementation NotificationSettings

+(NSString*)getDeviceToken
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString *token = [prefs stringForKey:@"NotificationSettings_DeviceToken"];
    return [token copy];
}

+(void)setDeviceToken:(NSString*)token
{
    NSUserDefaults *SaveData = [NSUserDefaults standardUserDefaults];
    [SaveData setObject:token forKey:@"NotificationSettings_DeviceToken"];
    [SaveData synchronize];
}

+(BOOL)getAutoUpdatePriceList
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	BOOL autoUpdate = [prefs boolForKey:@"NotificationSettings_AutoUpdatePriceList"];
    return autoUpdate;
}

+(void)setAutoUpdatePriceList:(BOOL)autoUpdate
{
    NSUserDefaults *SaveData = [NSUserDefaults standardUserDefaults];
    [SaveData setBool:autoUpdate forKey:@"NotificationSettings_AutoUpdatePriceList"];
    [SaveData synchronize];
}

+(BOOL)getNotifyPriceListChange
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	BOOL autoUpdate = [prefs boolForKey:@"NotificationSettings_NotifyPriceListChange"];
    return autoUpdate;
}

+(void)setNotifyPriceListChange:(BOOL)autoUpdate
{
    NSUserDefaults *SaveData = [NSUserDefaults standardUserDefaults];
    [SaveData setBool:autoUpdate forKey:@"NotificationSettings_NotifyPriceListChange"];
    [SaveData synchronize];
}



@end
