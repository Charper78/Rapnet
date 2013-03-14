//
//  LT_Lab.m
//  Rapnet
//
//  Created by Itzik on 11/05/12.
//  Copyright (c) 2012 appdev@diamonds.net. All rights reserved.
//

#import "LT_Lab.h"
#import "LT_Helper.h"

@implementation LT_Lab

static NSString * const kTableName = @"LT_Lab";

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
    
    
    lt = [LT_Lab  getLT:@"1" desc:@"GIA" order:1];
    [arr addObject:lt];
    
    lt = [LT_Lab  getLT:@"4" desc:@"AGS" order:2];
    [arr addObject:lt];
    
    lt = [LT_Lab  getLT:@"5" desc:@"HRD" order:3];
    [arr addObject:lt];
    
    lt = [LT_Lab  getLT:@"2" desc:@"IGI" order:4];
    [arr addObject:lt];
    
    lt = [LT_Lab  getLT:@"9" desc:@"VGR" order:5];
    [arr addObject:lt];
    
    lt = [LT_Lab  getLT:@"17" desc:@"Other" order:6];
    [arr addObject:lt];
    
    lt = [LT_Lab  getLT:@"16" desc:@"Uncertified" order:7];
    [arr addObject:lt];
    
    lt = [LT_Lab  getLT:@"10" desc:@"EGL USA" order:8];
    [arr addObject:lt];
    
    lt = [LT_Lab  getLT:@"11,34,35" desc:@"EGL Other" order:9];
    [arr addObject:lt];
    
    lt = [LT_Lab  getLT:@"36" desc:@"CGL (Japan)" order:11];
    [arr addObject:lt];
    
    lt = [LT_Lab  getLT:@"6" desc:@"PGS" order:12];
    [arr addObject:lt];
    
    lt = [LT_Lab  getLT:@"7" desc:@"DCLA" order:13];
    [arr addObject:lt];
    
    return arr;

}

+(void)addToDatabase:(NSMutableArray*)arr
{
    NSString *value;
    NSString *description;
    NSString *listOrder;
    
    [LT_Helper openDatabase];
    
    [LT_Lab deleteAll];
    
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
