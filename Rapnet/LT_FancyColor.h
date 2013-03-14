//
//  LT_FancyColor.h
//  Rapnet
//
//  Created by Itzik on 18/05/12.
//  Copyright (c) 2012 coolban@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LT_Helper.h"
#import "LT_Base.h"

@interface LT_FancyColor : LT_Base
{
    
}

+(void)deleteAll;
+(NSMutableArray *)get;
+(void)addToDatabase:(NSMutableArray*)arr;

@end
