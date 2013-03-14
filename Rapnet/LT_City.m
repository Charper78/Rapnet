//
//  LT_City.m
//  Rapnet
//
//  Created by Itzik on 25/05/12.
//  Copyright (c) 2012 coolban@gmail.com. All rights reserved.
//

#import "LT_City.h"

@implementation LT_City

@synthesize cityID, countryID, desc;


+(NSMutableArray*)get:(NSInteger)countryID
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    LT_City *c;
    
    if(countryID == 1)
    {
        c = [LT_City getCity:88 countryID:countryID desc:@"New York"];
        [arr addObject:c];
        
        c = [LT_City getCity:4 countryID:countryID desc:@"Atlanta"];
        [arr addObject:c];
        
        c = [LT_City getCity:6 countryID:countryID desc:@"Austin"];
        [arr addObject:c];
        
        c = [LT_City getCity:15 countryID:countryID desc:@"Boston"];
        [arr addObject:c];
        
        c = [LT_City getCity:24 countryID:countryID desc:@"Chicago"];
        [arr addObject:c];
        
        c = [LT_City getCity:32 countryID:countryID desc:@"Dallas"];
        [arr addObject:c];
        
        c = [LT_City getCity:72 countryID:countryID desc:@"Los Angeles"];
        [arr addObject:c];
        
        c = [LT_City getCity:77 countryID:countryID desc:@"Miami"];
        [arr addObject:c];
        
        c = [LT_City getCity:102 countryID:countryID desc:@"Philadephia"];
        [arr addObject:c];
        
        c = [LT_City getCity:117 countryID:countryID desc:@"San Diego"];
        [arr addObject:c];
        
        c = [LT_City getCity:118 countryID:countryID desc:@"San Francisco"];
        [arr addObject:c];
    }
    else if(countryID == 217)
    {
        c = [LT_City getCity:215 countryID:countryID desc:@"Ahmedabad"];
        [arr addObject:c];
        
        c = [LT_City getCity:14 countryID:countryID desc:@"Bombay"];
        [arr addObject:c];
        
        c = [LT_City getCity:23 countryID:countryID desc:@"Chennai"];
        [arr addObject:c];
        
        c = [LT_City getCity:33 countryID:countryID desc:@"Delhi"];
        [arr addObject:c];
        
        c = [LT_City getCity:176 countryID:countryID desc:@"Hyderabad"];
        [arr addObject:c];
        
        c = [LT_City getCity:63 countryID:countryID desc:@"Kolkata"];
        [arr addObject:c];
        
        c = [LT_City getCity:85 countryID:countryID desc:@"Mumbai"];
        [arr addObject:c];
        
        c = [LT_City getCity:137  countryID:countryID desc:@"Surat"];
        [arr addObject:c];
    }
    return arr;
}

+(LT_City*)getCity:(NSInteger)cityID countryID:(NSInteger)countryID desc:(NSString*)desc
{
    LT_City *c = [[LT_City alloc] init];
    
    c.cityID = cityID;
    c.countryID = countryID;
    c.desc = desc;
    
    return c;
}
@end
