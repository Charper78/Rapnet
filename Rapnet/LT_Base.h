//
//  LT_Base.h
//  Rapnet
//
//  Created by Itzik Kramer on 2/7/13.
//  Copyright (c) 2013 coolban@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LT_Helper.h"

@interface LT_Base : NSObject
{
    
}

+(NSMutableDictionary*)getLT:(NSString*)val desc:(NSString*)desc order:(NSInteger)order;
@end
