//
//  LT_Color.h
//  Rapnet
//
//  Created by Itzik on 11/05/12.
//  Copyright (c) 2012 coolban@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LT_Base.h"

@interface LT_Color : LT_Base

+(void)deleteAll;
+(NSMutableArray *)get;
+(void)addToDatabase:(NSMutableArray*)arr;

@end
