//
//  RegisterDevice.h
//  Rapnet
//
//  Created by Home on 4/26/13.
//  Copyright (c) 2013 coolban@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NotificationSettings.h"
#import "RegisterDeviceParser.h"

@interface RegisterDevice : NSObject
{
    
}

+(void)registerDevice;
+(void)registerDevice:(BOOL)notifyPriceChange;
//+(void)registerDevice:(NSString*)clientID;
//+(void)registerDevice:(NSString*)clientID notifyPriceChange:(BOOL)notifyPriceChange;
@end
