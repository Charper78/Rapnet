//
//  Notification.m
//  Rapnet
//
//  Created by Home on 5/16/13.
//  Copyright (c) 2013 coolban@gmail.com. All rights reserved.
//

#import "Notification.h"

@implementation Notification

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_notificationID forKey:@"notificationID"];
    [encoder encodeObject:_messageData forKey:@"messageData"];
    [encoder encodeObject:_messageDate forKey:@"messageDate"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.notificationID = [[decoder decodeObjectForKey:@"notificationID"] copy];
        self.messageData = [[decoder decodeObjectForKey:@"messageData"] copy];
        self.messageDate = [[decoder decodeObjectForKey:@"messageDate"] copy];
    }
    return self;
}

@end
