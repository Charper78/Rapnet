//
//  LT_FancyColorIntensity.m
//  Rapnet
//
//  Created by Itzik on 18/05/12.
//  Copyright (c) 2012 coolban@gmail.com. All rights reserved.
//

#import "LT_FancyColorIntensity.h"
#import "LT_Helper.h"

@implementation LT_FancyColorIntensity

static NSString * const kTableName = @"LT_FancyColorIntensity";

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
    
    
    lt = [LT_FancyColorIntensity  getLT:@"1" desc:@"Faint" order:1];
    [arr addObject:lt];
    
    lt = [LT_FancyColorIntensity  getLT:@"2" desc:@"Very Light" order:2];
    [arr addObject:lt];
    
    lt = [LT_FancyColorIntensity  getLT:@"3" desc:@"Light" order:3];
    [arr addObject:lt];
    
    lt = [LT_FancyColorIntensity  getLT:@"4" desc:@"Fancy Light" order:4];
    [arr addObject:lt];
    
    lt = [LT_FancyColorIntensity  getLT:@"5" desc:@"Fancy" order:5];
    [arr addObject:lt];
    
    lt = [LT_FancyColorIntensity  getLT:@"6" desc:@"Fancy Dark" order:6];
    [arr addObject:lt];
    
    lt = [LT_FancyColorIntensity  getLT:@"7" desc:@"Fancy Intense" order:7];
    [arr addObject:lt];
    
    lt = [LT_FancyColorIntensity  getLT:@"8" desc:@"Fancy Vivid" order:8];
    [arr addObject:lt];
    
    lt = [LT_FancyColorIntensity  getLT:@"9" desc:@"Fancy Deep" order:9];
    [arr addObject:lt];
    
    
    return arr;

}

+(void)addToDatabase:(NSMutableArray*)arr
{
    NSString *value;
    NSString *description;
    NSString *listOrder;
    
    [LT_Helper openDatabase];
    
    [LT_FancyColorIntensity deleteAll];
    
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
