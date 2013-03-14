//
//  LT_Clarity.m
//  Rapnet
//
//  Created by Itzik on 11/05/12.
//  Copyright (c) 2012 coolban@gmail.com. All rights reserved.
//

#import "LT_Clarity.h"
#import "LT_Helper.h"

@implementation LT_Clarity

static NSString * const kTableName = @"LT_Clarity";

/*+(void)insert:(NSString *)value description:(NSString *)description listOrder:(NSString*)listOrder
 {
 [LT_Helper insert:kTableName value:value description:description listOrder:listOrder];
 }*/

/*
+(void)deleteAll
{
    [LT_Helper deleteAll:kTableName];
}
*/

+(NSMutableArray *)get
{
    //[LT_Helper openDatabase];
    //return [LT_Helper get:kTableName];
    NSMutableDictionary *lt;
    NSMutableArray *arr = [[NSMutableArray alloc]init ];
    
    
    lt = [LT_Clarity  getLT:@"1" desc:@"FL" order:1];
    [arr addObject:lt];
    
    lt = [LT_Clarity  getLT:@"2" desc:@"IF" order:1];
    [arr addObject:lt];
    
    lt = [LT_Clarity  getLT:@"3" desc:@"VVS1" order:2];
    [arr addObject:lt];
    
    lt = [LT_Clarity  getLT:@"4" desc:@"VVS2" order:3];
    [arr addObject:lt];
    
    lt = [LT_Clarity  getLT:@"5" desc:@"VS1" order:4];
    [arr addObject:lt];
    
    lt = [LT_Clarity  getLT:@"6" desc:@"VS2" order:5];
    [arr addObject:lt];
    
    lt = [LT_Clarity  getLT:@"7" desc:@"SI1" order:6];
    [arr addObject:lt];
    
    lt = [LT_Clarity  getLT:@"8" desc:@"SI2" order:7];
    [arr addObject:lt];
    
    lt = [LT_Clarity  getLT:@"9" desc:@"SI3" order:8];
    [arr addObject:lt];
    
    lt = [LT_Clarity  getLT:@"10" desc:@"I1" order:9];
    [arr addObject:lt];
    
    lt = [LT_Clarity  getLT:@"11" desc:@"I2" order:10];
    [arr addObject:lt];
    
    lt = [LT_Clarity  getLT:@"12" desc:@"I3" order:11];
    [arr addObject:lt];
    
    return arr;
}

/*
+(void)addToDatabase:(NSMutableArray*)arr
{
    NSString *value;
    NSString *description;
    NSString *listOrder;
    
    [LT_Helper openDatabase];
    
    [LT_Clarity deleteAll];
    
    for (int i = 0; i<[arr count]; i++) {
        NSDictionary *dic = [arr objectAtIndex:i];
        value = [dic objectForKey:kValueElementName];
        description = [dic objectForKey:kDescriptionElementName];
        listOrder = [dic objectForKey:kListOrderElementName];
        [LT_Helper insert:kTableName value:value description:description listOrder:listOrder];
    }
    
    [LT_Helper closeDatabase];
    
}
*/
@end
