//
//  AnalyticHelper.m
//  Rapnet
//
//  Created by Itzik Kramer on 2/10/13.
//  Copyright (c) 2013 coolban@gmail.com. All rights reserved.
//

#import "AnalyticHelper.h"

@implementation AnalyticHelper

+ (void)initAnalytic
{
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    [GAI sharedInstance].dispatchInterval = 0;
    [GAI sharedInstance].debug = YES;
    
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:kGoogleAnalyticsAccount];
    tracker.appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
    tracker.appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
}

+ (BOOL)sendEventWithCategory:(NSString *)category
                   withAction:(NSString *)action
                    withLabel:(NSString *)label
                    withValue:(NSNumber *)value
{
    //return [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"asdasd" withAction:@"asdasd" withLabel:nil withValue:nil];
    return [[GAI sharedInstance].defaultTracker sendEventWithCategory:category
                                                    withAction:action
                                                     withLabel:label
                                                     withValue:value];

}

+ (BOOL)sendEventWithCategory:(NSString *)category
                   withAction:(NSString *)action
{
    return[AnalyticHelper sendEventWithCategory:category withAction:action withLabel:nil withValue:nil];
}

+ (BOOL)sendView:(NSString *)screen
{
    return [[GAI sharedInstance].defaultTracker sendView:screen];
}
@end
