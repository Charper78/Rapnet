//
//  LT_Flour.m
//  Rapnet
//
//  Created by Itzik on 11/05/12.
//  Copyright (c) 2012 appdev@diamonds.net. All rights reserved.
//

#import "LT_Fluor.h"
#import "LT_Helper.h"

@implementation LT_Fluor

static NSString * const kTableName = @"LT_Fluor";

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
    
    
    lt = [LT_Fluor  getLT:@"1" desc:@"None" order:1];
    [arr addObject:lt];
    
    lt = [LT_Fluor  getLT:@"2" desc:@"Very Slight" order:2];
    [arr addObject:lt];
    
    lt = [LT_Fluor  getLT:@"3,7" desc:@"Faint / Slight" order:3];
    [arr addObject:lt];
    
    lt = [LT_Fluor  getLT:@"4" desc:@"Medium" order:4];
    [arr addObject:lt];
    
    lt = [LT_Fluor  getLT:@"5" desc:@"Strong" order:5];
    [arr addObject:lt];
    
    lt = [LT_Fluor  getLT:@"6" desc:@"Very Strong" order:6];
    [arr addObject:lt];

    return arr;
}

+(void)addToDatabase:(NSMutableArray*)arr
{
    NSString *value;
    NSString *description;
    NSString *listOrder;
    
    [LT_Helper openDatabase];
    
    [LT_Fluor deleteAll];
    
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
