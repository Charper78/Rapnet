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
    return [Functions readObjectFromFile:kNotificationsFile];
}

+(void)removeNotification:(NSInteger)notificationID
{
    NSMutableDictionary *curDic =  [[NSMutableDictionary alloc] initWithDictionary:[Functions readObjectFromFile:kNotificationsFile] copyItems:YES];
    [curDic removeObjectForKey:notificationID];
    [Functions writeObjectToFile:curDic fileName:kNotificationsFile];
}

+(void)removeAllNotifications
{
    NSMutableDictionary *curDic =  [[NSMutableDictionary alloc] initWithDictionary:[Functions readObjectFromFile:kNotificationsFile] copyItems:YES];
    [curDic removeAllObjects];
    [Functions writeObjectToFile:curDic fileName:kNotificationsFile];
}

+(void)addNotification:(Notification*)n
{
    NSMutableDictionary *curDic =  [[NSMutableDictionary alloc] initWithDictionary:[Functions readObjectFromFile:kNotificationsFile] copyItems:YES];
    
    if ([curDic objectForKey:n.notificationID] != nil) {
        [curDic setObject:n forKey:n.notificationID];
        [Functions writeObjectToFile:curDic fileName:kNotificationsFile];
    }
}

/*+(NSDictionary*)getNotification:(NSInteger)index
{
    NSMutableArray *curArr =  [[NSMutableArray alloc] initWithArray:[Functions readObjectFromFile:kNotificationsFile] copyItems:YES];
    NSDictionary *d = [curArr objectAtIndex:index];
    return d;
}*/
@end
