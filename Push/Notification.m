//
//  Notification.m
//  Rapnet
//
//  Created by Home on 5/16/13.
//  Copyright (c) 2013 coolban@gmail.com. All rights reserved.
//

#import "Notification.h"

@implementation Notification

//@synthesize messageData;

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:[NSString stringWithFormat:@"%d", _notificationID] forKey:@"notificationID"];
    [encoder encodeObject:_messageData forKey:@"messageData"];
    [encoder encodeObject:_messageDate forKey:@"messageDate"];
    [encoder encodeObject:_readMessage ? @"YES" : @"NO" forKey:@"readMessage"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.notificationID = [[[decoder decodeObjectForKey:@"notificationID"] copy] integerValue];
        self.messageData = [[decoder decodeObjectForKey:@"messageData"] copy];
        self.messageDate = [[decoder decodeObjectForKey:@"messageDate"] copy];
        self.readMessage = [[[decoder decodeObjectForKey:@"messageData"] copy] boolValue];
    }
    return self;
}

/*- (id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    
    if (copy)
    {
        // Copy NSObject subclasses
     //   [copy setVendorID:[[self.vendorID copyWithZone:zone] autorelease]];
     //   [copy setAvailableCars:[[self.availableCars copyWithZone:zone] autorelease]];
        
    //    // Set primitives
    //    [copy setAtAirport:self.atAirport];
    }
    
    return copy;
}
*/
@end
