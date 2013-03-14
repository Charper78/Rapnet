//
//  DatabaseHelper.h
//  Rapnet
//
//  Created by Itzik on 10/05/12.
//  Copyright (c) 2012 coolban@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "LT_Const.h"
#import "Database.h"

@interface LT_Helper : NSObject

+(void)openDatabase;
+(void)closeDatabase;
+(void)insert:(NSString *)tbl value:(NSString*)value description:(NSString *)description listOrder:(NSString*)listOrder;
+(void)deleteAll:(NSString*)tbl;
+(NSMutableArray *)get:(NSString*)tbl;

@end
