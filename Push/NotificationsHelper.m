//
//  NotificationsHelper.m
//  Rapnet
//
//  Created by Home on 3/19/13.
//  Copyright (c) 2013 coolban@gmail.com. All rights reserved.
//

#import "NotificationsHelper.h"

@implementation NotificationsHelper

+(NSArray*)getNotifications
{
    return [Functions readObjectFromFile:kNotificationsFile];
}

+(void)removeNotification:(NSInteger)index
{
    NSMutableArray *curArr =  [[NSMutableArray alloc] initWithArray:[Functions readObjectFromFile:kNotificationsFile] copyItems:YES];
    [curArr removeObjectAtIndex:index];
    [Functions writeObjectToFile:curArr fileName:kNotificationsFile];
}

+(void)addNotification:(NSDictionary*)d
{
    NSMutableArray *curArr =  [[NSMutableArray alloc] initWithArray:[Functions readObjectFromFile:kNotificationsFile] copyItems:YES];
    [curArr addObject:d];
    [Functions writeObjectToFile:curArr fileName:kNotificationsFile];

}

+(NSDictionary*)getNotification:(NSInteger)index
{
    NSMutableArray *curArr =  [[NSMutableArray alloc] initWithArray:[Functions readObjectFromFile:kNotificationsFile] copyItems:YES];
    NSDictionary *d = [curArr objectAtIndex:index];
    return d;
}
@end
