//
//  LT_Location.m
//  Rapnet
//
//  Created by Itzik on 11/05/12.
//  Copyright (c) 2012 appdev@diamonds.net. All rights reserved.
//

#import "LT_Country.h"
#import "LT_Helper.h"

@implementation LT_Country

static NSString * const kTableName = @"LT_Country";

+(void)deleteAll
{
    [LT_Helper deleteAll:kTableName];
}

+(NSMutableArray *)get
{
    NSMutableDictionary *lt;
    NSMutableArray *arr = [[NSMutableArray alloc]init ];
    
    
    lt = [LT_Country  getLT:@"1" desc:@"USA" order:1];
    [arr addObject:lt];
    
    lt = [LT_Country  getLT:@"217" desc:@"India" order:2];
    [arr addObject:lt];
    
    lt = [LT_Country  getLT:@"232" desc:@"Israel" order:3];
    [arr addObject:lt];
    
    lt = [LT_Country  getLT:@"204" desc:@"HK" order:4];
    [arr addObject:lt];   
    
    lt = [LT_Country  getLT:@"88" desc:@"Belgium" order:1];
    [arr addObject:lt];
    
    lt = [LT_Country  getLT:@"243" desc:@"UK" order:2];
    [arr addObject:lt];
    
    lt = [LT_Country  getLT:@"208" desc:@"China" order:3];
    [arr addObject:lt];
    
    lt = [LT_Country  getLT:@"162" desc:@"Australia" order:4];
    [arr addObject:lt];  
    
    lt = [LT_Country  getLT:@"8" desc:@"Canada" order:1];
    [arr addObject:lt];
    
    lt = [LT_Country  getLT:@"231" desc:@"U A E" order:2];
    [arr addObject:lt];
    
    lt = [LT_Country  getLT:@"118" desc:@"Italy" order:3];
    [arr addObject:lt];
    
    lt = [LT_Country  getLT:@"80" desc:@"S.Africa" order:4];
    [arr addObject:lt];   
    
    lt = [LT_Country  getLT:@"168" desc:@"Thailand" order:1];
    [arr addObject:lt];
    
    lt = [LT_Country  getLT:@"89" desc:@"France" order:2];
    [arr addObject:lt];
    
    lt = [LT_Country  getLT:@"120" desc:@"Switzlnd" order:3];
    [arr addObject:lt];
    
    lt = [LT_Country  getLT:@"130" desc:@"Germany" order:4];
    [arr addObject:lt];  
    
    lt = [LT_Country  getLT:@"215" desc:@"Taiwan" order:1];
    [arr addObject:lt];
    
    lt = [LT_Country  getLT:@"167" desc:@"Singapore" order:2];
    [arr addObject:lt];
    
    lt = [LT_Country  getLT:@"200" desc:@"Japan" order:3];
    [arr addObject:lt];
    
    lt = [LT_Country  getLT:@"216" desc:@"Turkey" order:4];
    [arr addObject:lt];  
    
    lt = [LT_Country  getLT:@"146" desc:@"Brazil" order:1];
    [arr addObject:lt];
    
    lt = [LT_Country  getLT:@"164" desc:@"Indonsia" order:2];
    [arr addObject:lt];
    
    lt = [LT_Country  getLT:@"142" desc:@"Mexico" order:3];
    [arr addObject:lt];
    
    lt = [LT_Country  getLT:@"90" desc:@"Spain" order:4];
    [arr addObject:lt];  
    
    lt = [LT_Country  getLT:@"94" desc:@"Ireland" order:1];
    [arr addObject:lt];
    
    lt = [LT_Country  getLT:@"201" desc:@"S.Korea" order:2];
    [arr addObject:lt];
    
    lt = [LT_Country  getLT:@"166" desc:@"N.Zealand" order:3];
    [arr addObject:lt];
    
    lt = [LT_Country  getLT:@"124" desc:@"Austria" order:4];
    [arr addObject:lt];   
    
    lt = [LT_Country  getLT:@"161" desc:@"Malaysia" order:1];
    [arr addObject:lt];
    
    lt = [LT_Country  getLT:@"223" desc:@"Lebanon" order:2];
    [arr addObject:lt];
    
    lt = [LT_Country  getLT:@"228" desc:@"Saudi" order:3];
    [arr addObject:lt];
    
    lt = [LT_Country  getLT:@"195" desc:@"Russia" order:4];
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
    
    [LT_Country deleteAll];
    
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
