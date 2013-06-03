//
//  NotificationsHelper.h
//  Rapnet
//
//  Created by Home on 3/19/13.
//  Copyright (c) 2013 coolban@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Functions.h"
#import "Constants.h"
#import "Notification.h"

@class Notification;
@interface NotificationsHelper : NSObject
{
    
}

+(NSDictionary*)getNotifications;
+(void)removeNotification:(NSInteger)notificationID;
+(void)removeAllNotifications;
+(void)addNotification:(Notification*)n;
@end
