//
//  AnalyticHelper.h
//  Rapnet
//
//  Created by Itzik Kramer on 2/10/13.
//  Copyright (c) 2013 coolban@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GAI.h"

@interface AnalyticHelper : NSObject
{
    
}

+ (void)initAnalytic;

+ (BOOL)sendEventWithCategory:(NSString *)category
                   withAction:(NSString *)action
                    withLabel:(NSString *)label
                    withValue:(NSNumber *)value;
+ (BOOL)sendEventWithCategory:(NSString *)category
                   withAction:(NSString *)action;
+ (BOOL)sendView:(NSString *)screen;
@end
