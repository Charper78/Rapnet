//
//  LT_FancyColor.m
//  Rapnet
//
//  Created by Itzik on 18/05/12.
//  Copyright (c) 2012 coolban@gmail.com. All rights reserved.
//

#import "LT_FancyColor.h"

@implementation LT_FancyColor

static NSString * const kTableName = @"LT_FancyColor";

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
    
    
    lt = [LT_FancyColor  getLT:@"1" desc:@"Yellow" order:1];
    [arr addObject:lt];
    
    lt = [LT_FancyColor  getLT:@"2" desc:@"Pink" order:2];
    [arr addObject:lt];
    
    lt = [LT_FancyColor  getLT:@"3" desc:@"Blue" order:3];
    [arr addObject:lt];
    
    lt = [LT_FancyColor  getLT:@"4" desc:@"Red" order:4];
    [arr addObject:lt];
    
    lt = [LT_FancyColor  getLT:@"5" desc:@"Green" order:5];
    [arr addObject:lt];
    
    lt = [LT_FancyColor  getLT:@"6" desc:@"Purple" order:6];
    [arr addObject:lt];
    
    lt = [LT_FancyColor  getLT:@"7" desc:@"Orange" order:7];
    [arr addObject:lt];
    
    lt = [LT_FancyColor  getLT:@"8" desc:@"Violet" order:8];
    [arr addObject:lt];
    
    lt = [LT_FancyColor  getLT:@"9" desc:@"Gray" order:9];
    [arr addObject:lt];
    
    lt = [LT_FancyColor  getLT:@"10" desc:@"Black" order:10];
    [arr addObject:lt];
    
    lt = [LT_FancyColor  getLT:@"11" desc:@"Brown" order:11];
    [arr addObject:lt];
    
    lt = [LT_FancyColor  getLT:@"12" desc:@"Champagne" order:12];
    [arr addObject:lt];
    
    lt = [LT_FancyColor  getLT:@"13" desc:@"Cognac" order:13];
    [arr addObject:lt];
    
    
    
    lt = [LT_FancyColor  getLT:@"15" desc:@"Chameleon" order:14];
    [arr addObject:lt];
    
    lt = [LT_FancyColor  getLT:@"16" desc:@"White" order:15];
    [arr addObject:lt];
    
    lt = [LT_FancyColor  getLT:@"14" desc:@"Other" order:16];
    [arr addObject:lt];
    
    return arr;
}

+(void)addToDatabase:(NSMutableArray*)arr
{
    NSString *value;
    NSString *description;
    NSString *listOrder;
    
    [LT_Helper openDatabase];
    
    [LT_FancyColor deleteAll];
    
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
