//
//  LT_Base.m
//  Rapnet
//
//  Created by Itzik Kramer on 2/7/13.
//  Copyright (c) 2013 coolban@gmail.com. All rights reserved.
//

#import "LT_Base.h"

@implementation LT_Base

+(NSMutableDictionary*)getLT:(NSString*)val desc:(NSString*)desc order:(NSInteger)order
{
    NSMutableDictionary *lt;
    
    lt = [[NSMutableDictionary alloc] init];
       
    [lt setObject:[NSNumber numberWithInt:order] forKey:kListOrderElementName];
    [lt setObject:val forKey:kValueElementName];
    [lt setObject:desc forKey:kDescriptionElementName];
    
    
    return lt;
}

@end
