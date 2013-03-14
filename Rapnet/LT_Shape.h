//
//  Shape.h
//  Rapnet
//
//  Created by Itzik on 10/05/12.
//  Copyright (c) 2012 coolban@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LT_Shape : NSObject
{
    
}

//+(void)insert:(NSString *)value description:(NSString *)description listOrder:(NSString*)listOrder;
+(void)deleteAll;
+(NSMutableArray *)get;
+(void)addToDatabase:(NSMutableArray*)arr;
+(NSMutableDictionary*)getLT:(NSString*)val desc:(NSString*)desc order:(NSInteger)order;
@end
