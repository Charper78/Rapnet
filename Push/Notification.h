//
//  Notification.h
//  Rapnet
//
//  Created by Home on 5/16/13.
//  Copyright (c) 2013 coolban@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Notification : NSObject
{
    NSInteger _notificationID;
    NSString *_messageData;
    NSDate *_messageDate;
}

@property (nonatomic) NSInteger notificationID;
@property (nonatomic, retain) NSString *messageData;
@property (nonatomic, retain) NSDate *messageDate;
@end
