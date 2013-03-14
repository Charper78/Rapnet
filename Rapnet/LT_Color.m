//
//  LT_Color.m
//  Rapnet
//
//  Created by Itzik on 11/05/12.
//  Copyright (c) 2012 coolban@gmail.com. All rights reserved.
//


#import "LT_Color.h"
#import "LT_Helper.h"

@implementation LT_Color

static NSString * const kTableName = @"LT_Color";

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
    //[LT_Helper openDatabase];
    //return [LT_Helper get:kTableName];
    NSMutableDictionary *lt;
    NSMutableArray *arr = [[NSMutableArray alloc]init ];
    
    
    lt = [LT_Color  getLT:@"1" desc:@"D" order:1];
    [arr addObject:lt];
    
    lt = [LT_Color  getLT:@"2" desc:@"E" order:2];
    [arr addObject:lt];
    
    lt = [LT_Color  getLT:@"3" desc:@"F" order:3];
    [arr addObject:lt];
    
    lt = [LT_Color  getLT:@"4" desc:@"G" order:4];
    [arr addObject:lt];
    
    lt = [LT_Color  getLT:@"5" desc:@"H" order:5];
    [arr addObject:lt];
    
    lt = [LT_Color  getLT:@"6" desc:@"I" order:6];
    [arr addObject:lt];
    
    lt = [LT_Color  getLT:@"7" desc:@"J" order:7];
    [arr addObject:lt];
    
    lt = [LT_Color  getLT:@"8" desc:@"K" order:8];
    [arr addObject:lt];
    
    lt = [LT_Color  getLT:@"9" desc:@"L" order:9];
    [arr addObject:lt];
    
    lt = [LT_Color  getLT:@"10" desc:@"M" order:10];
    [arr addObject:lt];
    
    lt = [LT_Color  getLT:@"11" desc:@"N" order:11];
    [arr addObject:lt];
    
    lt = [LT_Color  getLT:@"12" desc:@"O" order:12];
    [arr addObject:lt];
    
    lt = [LT_Color  getLT:@"13" desc:@"P" order:13];
    [arr addObject:lt];
    
    lt = [LT_Color  getLT:@"14" desc:@"Q" order:14];
    [arr addObject:lt];
    
    lt = [LT_Color  getLT:@"15" desc:@"R" order:15];
    [arr addObject:lt];
    
    lt = [LT_Color  getLT:@"16" desc:@"S" order:16];
    [arr addObject:lt];
    
    lt = [LT_Color  getLT:@"17" desc:@"T" order:17];
    [arr addObject:lt];
    
    lt = [LT_Color  getLT:@"18" desc:@"U" order:18];
    [arr addObject:lt];
    
    lt = [LT_Color  getLT:@"19" desc:@"V" order:19];
    [arr addObject:lt];
    
    lt = [LT_Color  getLT:@"20" desc:@"W" order:20];
    [arr addObject:lt];
    
    lt = [LT_Color  getLT:@"21" desc:@"X" order:21];
    [arr addObject:lt];
    
    lt = [LT_Color  getLT:@"22" desc:@"Y" order:22];
    [arr addObject:lt];
    
    lt = [LT_Color  getLT:@"23" desc:@"Z" order:23];
    [arr addObject:lt];
    
    return arr;

}

+(void)addToDatabase:(NSMutableArray*)arr
{
    NSString *value;
    NSString *description;
    NSString *listOrder;
    
    [LT_Helper openDatabase];
    
    [LT_Color deleteAll];
    
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
