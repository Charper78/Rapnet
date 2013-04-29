//
//  NotificationSettings.h
//  Rapnet
//
//  Created by Home on 4/25/13.
//  Copyright (c) 2013 coolban@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationSettings : NSObject
{
    
}

+(NSString*)getDeviceToken;
+(void)setDeviceToken:(NSString*)token;

+(BOOL)getAutoUpdatePriceList;
+(void)setAutoUpdatePriceList:(BOOL)autoUpdate;

+(BOOL)getNotifyPriceListChange;
+(void)setNotifyPriceListChange:(BOOL)autoUpdate;

@end
