//
//  Notification.h
//  Rapnet
//
//  Created by Home on 5/16/13.
//  Copyright (c) 2013 coolban@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NotificationsHelper.h"

@interface Notification : NSObject
{
    NSInteger _notificationID;
    NSString *_messageData;
    NSDate *_messageDate;
    BOOL _readMessage;
}

@property (nonatomic) NSInteger notificationID;
@property (nonatomic, retain) NSString *messageData;
@property (nonatomic, retain) NSDate *messageDate;
@property (nonatomic) BOOL readMessage;

-(void)save;

@end
