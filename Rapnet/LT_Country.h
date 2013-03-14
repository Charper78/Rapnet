//
//  LT_Location.h
//  Rapnet
//
//  Created by Itzik on 11/05/12.
//  Copyright (c) 2012 appdev@diamonds.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LT_Base.h"

@interface LT_Country : LT_Base

+(void)deleteAll;
+(NSMutableArray *)get;
+(void)addToDatabase:(NSMutableArray*)arr;
//+(NSMutableDictionary*)getLT:(NSString*)val desc:(NSString*)desc order:(NSInteger)order;
@end
