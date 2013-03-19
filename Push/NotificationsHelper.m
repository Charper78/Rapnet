//
//  NotificationsHelper.m
//  Rapnet
//
//  Created by Home on 3/19/13.
//  Copyright (c) 2013 coolban@gmail.com. All rights reserved.
//

#import "NotificationsHelper.h"

@implementation NotificationsHelper

+(NSDictionary*)getNotifications
{
    return [Functions readFromFile:kNotificationsFile];
}

+(void)removeNotification:(NSString*)key
{
    NSMutableDictionary *curDic =  [[NSMutableDictionary alloc] initWithDictionary: [Functions readFromFile:kNotificationsFile] copyItems:YES];
    [curDic removeObjectForKey:key];
    [Functions writeToFile:curDic fileName:kNotificationsFile];
}
@end
