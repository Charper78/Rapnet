//
//  LT_FancyColorOvertone.m
//  Rapnet
//
//  Created by Itzik on 18/05/12.
//  Copyright (c) 2012 coolban@gmail.com. All rights reserved.
//

#import "LT_FancyColorOvertone.h"
#import "LT_Helper.h"

@implementation LT_FancyColorOvertone

static NSString * const kTableName = @"LT_FancyColorOvertone";

/*+(void)insert:(NSString *)value description:(NSString *)description listOrder:(NSString*)listOrder
 {
 [LT_Helper insert:kTableName value:value description:description listOrder:listOrder];
 }*/

+(void)deleteAll
{
    [LT_Helper deleteAll:kTableName];
}

+(NSMutableArray *)get
{
   // [LT_Helper openDatabase];
    //return [LT_Helper get:kTableName];
    
    NSMutableDictionary *lt;
    NSMutableArray *arr = [[NSMutableArray alloc]init ];
    
    
    lt = [LT_FancyColorOvertone  getLT:@"10" desc:@"None" order:1];
    [arr addObject:lt];
    
    lt = [LT_FancyColorOvertone  getLT:@"1" desc:@"Brownish" order:2];
    [arr addObject:lt];
    
    lt = [LT_FancyColorOvertone  getLT:@"2" desc:@"Greenish" order:3];
    [arr addObject:lt];
    
    lt = [LT_FancyColorOvertone  getLT:@"3" desc:@"Yellowish" order:4];
    [arr addObject:lt];
    
    lt = [LT_FancyColorOvertone  getLT:@"4" desc:@"Pinkish" order:5];
    [arr addObject:lt];
    
    lt = [LT_FancyColorOvertone  getLT:@"5" desc:@"Purplish" order:6];
    [arr addObject:lt];
    
    lt = [LT_FancyColorOvertone  getLT:@"6" desc:@"Grayish" order:7];
    [arr addObject:lt];
    
    lt = [LT_FancyColorOvertone  getLT:@"7" desc:@"Orangey" order:8];
    [arr addObject:lt];
    
    lt = [LT_FancyColorOvertone  getLT:@"8" desc:@"Reddish" order:9];
    [arr addObject:lt];
    
    lt = [LT_FancyColorOvertone  getLT:@"9" desc:@"Bluish" order:10];
    [arr addObject:lt];
 
    return arr;
}

+(void)addToDatabase:(NSMutableArray*)arr
{
    NSString *value;
    NSString *description;
    NSString *listOrder;
    
    [LT_Helper openDatabase];
    
    [LT_FancyColorOvertone deleteAll];
    
    for (int i = 0; i<[arr count]; i++) {
        NSDictionary *dic = [arr objectAtIndex:i];
        value = [dic objectForKey:kValueElementName];
        description = [dic objectForKey:kDescriptionElementName];
        listOrder = [dic objectForKey:kListOrderElementName];
        [LT_Helper insert:kTableName value:value description:description listOrder:listOrder];
    }
    
    [LT_Helper closeDatabase];
    
}

@end

