//
//  Shape.m
//  Rapnet
//
//  Created by Itzik on 10/05/12.
//  Copyright (c) 2012 coolban@gmail.com. All rights reserved.
//

#import "LT_Shape.h"
#import "LT_Helper.h"

@implementation LT_Shape

static NSString * const kTableName = @"LT_Shapes";

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
    NSMutableDictionary *lt;
    NSMutableArray *arr = [[NSMutableArray alloc]init ];
    
       
    lt = [LT_Shape  getLT:@"1" desc:@"Round" order:1];
    [arr addObject:lt];
    
    lt = [LT_Shape  getLT:@"2" desc:@"Pear" order:2];
    [arr addObject:lt];
    
    lt = [LT_Shape  getLT:@"3" desc:@"Princess" order:3];
    [arr addObject:lt];
    
    lt = [LT_Shape  getLT:@"4" desc:@"Marquise" order:4];
    [arr addObject:lt];   
    
    lt = [LT_Shape  getLT:@"9" desc:@"Emerald" order:1];
    [arr addObject:lt];
    
    lt = [LT_Shape  getLT:@"17,5" desc:@"Asc&Sq.Em" order:2];
    [arr addObject:lt];
    
    lt = [LT_Shape  getLT:@"5" desc:@"Sq. Emrld" order:3];
    [arr addObject:lt];
    
    lt = [LT_Shape  getLT:@"17" desc:@"Asscher" order:4];
    [arr addObject:lt];  
    
    lt = [LT_Shape  getLT:@"7" desc:@"Oval" order:1];
    [arr addObject:lt];
    
    lt = [LT_Shape  getLT:@"8" desc:@"Radiant" order:2];
    [arr addObject:lt];
    
    lt = [LT_Shape  getLT:@"10" desc:@"Trillnt" order:3];
    [arr addObject:lt];
    
    lt = [LT_Shape  getLT:@"11" desc:@"Heart" order:4];
    [arr addObject:lt];   
    
    lt = [LT_Shape  getLT:@"12" desc:@"Eur. Cut" order:1];
    [arr addObject:lt];
    
    lt = [LT_Shape  getLT:@"13" desc:@"Old Mnr" order:2];
    [arr addObject:lt];
    
    lt = [LT_Shape  getLT:@"14" desc:@"Flanders" order:3];
    [arr addObject:lt];
    
    lt = [LT_Shape  getLT:@"15,16" desc:@"Cush(all)" order:4];
    [arr addObject:lt];  
    
    lt = [LT_Shape  getLT:@"15" desc:@"Cush Br" order:1];
    [arr addObject:lt];
    
    lt = [LT_Shape  getLT:@"16" desc:@"Cush Mod" order:2];
    [arr addObject:lt];
    
    lt = [LT_Shape  getLT:@"18" desc:@"Baguette" order:3];
    [arr addObject:lt];
    
    lt = [LT_Shape  getLT:@"34" desc:@"Tap. Bag" order:4];
    [arr addObject:lt];  
    
    lt = [LT_Shape  getLT:@"19" desc:@"Kite" order:1];
    [arr addObject:lt];
    
    lt = [LT_Shape  getLT:@"20" desc:@"Star" order:2];
    [arr addObject:lt];
    
    lt = [LT_Shape  getLT:@"21" desc:@"Other" order:3];
    [arr addObject:lt];
    
    lt = [LT_Shape  getLT:@"22" desc:@"Hlf Moon" order:4];
    [arr addObject:lt];  
    
    lt = [LT_Shape  getLT:@"23" desc:@"Trap." order:1];
    [arr addObject:lt];
    
    lt = [LT_Shape  getLT:@"24" desc:@"Bullets" order:2];
    [arr addObject:lt];
    
    lt = [LT_Shape  getLT:@"25" desc:@"Hex" order:3];
    [arr addObject:lt];
    
    lt = [LT_Shape  getLT:@"26" desc:@"Lozenge" order:4];
    [arr addObject:lt];   
    
    lt = [LT_Shape  getLT:@"29" desc:@"Pent" order:1];
    [arr addObject:lt];
    
    lt = [LT_Shape  getLT:@"28" desc:@"Rose" order:2];
    [arr addObject:lt];
    
    lt = [LT_Shape  getLT:@"29" desc:@"Shield" order:3];
    [arr addObject:lt];
    
    lt = [LT_Shape  getLT:@"30" desc:@"Square" order:4];
    [arr addObject:lt];   
    
    lt = [LT_Shape  getLT:@"31" desc:@"Trianglr" order:1];
    [arr addObject:lt];
    
    lt = [LT_Shape  getLT:@"32" desc:@"Briolette" order:2];
    [arr addObject:lt];
    
    lt = [LT_Shape  getLT:@"33" desc:@"Octagonal" order:3];
    [arr addObject:lt];
    //[lt release];       
    
    return arr;
    //[LT_Helper openDatabase];
    //return [LT_Helper get:kTableName];
}

+(NSMutableDictionary*)getLT:(NSString*)val desc:(NSString*)desc order:(NSInteger)order
{
    NSMutableDictionary *lt;
    
    lt = [[NSMutableDictionary alloc] init];
    [lt setObject:val forKey:kValueElementName];
    [lt setObject:desc forKey:kDescriptionElementName];
   // [lt setObject:order forKey:kListOrderElementName];
    
    return lt;
}

+(void)addToDatabase:(NSMutableArray*)arr
{
    NSString *value;
    NSString *description;
    NSString *listOrder;
    
    [LT_Helper openDatabase];
    
    [LT_Shape deleteAll];
    
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
