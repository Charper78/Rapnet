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
    //NSMutableDictionary *curDic =  [[NSMutableDictionary alloc] initWithDictionary:[Functions readObjectFromFile:kNotificationsFile] copyItems:YES];
    NSMutableDictionary *curDic =  [[NSMutableDictionary alloc] initWithDictionary:[Functions readObjectFromFile:kNotificationsFile]];
    [curDic removeObjectForKey:[NSString stringWithFormat:@"%d", notificationID]];
    [Functions deleteFile:kNotificationsFile];
    [Functions writeObjectToFile:curDic fileName:kNotificationsFile];
}

+(void)removeAllNotifications
{
    //NSMutableDictionary *curDic =  [[NSMutableDictionary alloc] initWithDictionary:[Functions readObjectFromFile:kNotificationsFile] copyItems:YES];
    NSMutableDictionary *curDic =  [[NSMutableDictionary alloc] initWithDictionary:[Functions readObjectFromFile:kNotificationsFile]];
    [curDic removeAllObjects];
    [Functions deleteFile:kNotificationsFile];
    [Functions writeObjectToFile:curDic fileName:kNotificationsFile];
}

+(void)addNotification:(Notification*)n
{
    NSMutableDictionary *curDic =  [[NSMutableDictionary alloc] initWithDictionary:[Functions readObjectFromFile:kNotificationsFile] ];
    
    if ([curDic objectForKey:[NSString stringWithFormat:@"%d", n.notificationID]] == nil) {
    //if ([curDic objectForKey: n.messageData] == nil) {
        [curDic setObject:n forKey:[NSString stringWithFormat:@"%d", n.notificationID]];
     //   [curDic setObject:n forKey: n.messageData];
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
