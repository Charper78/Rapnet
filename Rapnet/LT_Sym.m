//
//  LT_Sym.m
//  Rapnet
//
//  Created by Itzik on 11/05/12.
//  Copyright (c) 2012 appdev@diamonds.net. All rights reserved.
//

#import "LT_Sym.h"
#import "LT_Helper.h"

@implementation LT_Sym

static NSString * const kTableName = @"LT_Symmetry";

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
    
    
    lt = [LT_Sym  getLT:@"6" desc:@"Ideal" order:1];
    [arr addObject:lt];
    
    lt = [LT_Sym  getLT:@"1" desc:@"Excellent" order:2];
    [arr addObject:lt];
    
    lt = [LT_Sym  getLT:@"2" desc:@"Very Good" order:3];
    [arr addObject:lt];
    
    lt = [LT_Sym  getLT:@"3" desc:@"Good" order:4];
    [arr addObject:lt];
    
    lt = [LT_Sym  getLT:@"4" desc:@"Fair" order:5];
    [arr addObject:lt];
    
    lt = [LT_Sym  getLT:@"5" desc:@"Poor" order:6];
    [arr addObject:lt];
    
    return arr;
}

+(void)addToDatabase:(NSMutableArray*)arr
{
    NSString *value;
    NSString *description;
    NSString *listOrder;
    
    [LT_Helper openDatabase];
    
    [LT_Sym deleteAll];
    
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
