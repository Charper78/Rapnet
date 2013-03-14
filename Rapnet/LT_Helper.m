//
//  DatabaseHelper.m
//  Rapnet
//
//  Created by Itzik on 10/05/12.
//  Copyright (c) 2012 coolban@gmail.com. All rights reserved.
//

#import "LT_Helper.h"

@implementation LT_Helper

//static sqlite3 *database = nil;

+(NSString *)getDBPath
{
	NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths1 objectAtIndex:0];
	return [documentsDir stringByAppendingPathComponent:@"RapnetDB.sqlite"];	
}

+(void)openDatabase{
    //NSString *dbPth = [self getDBPath];
   /* int i = sqlite3_open_v2( [[self getDBPath] UTF8String], &database, 
                            SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE | SQLITE_OPEN_AUTOPROXY | SQLITE_OPEN_FULLMUTEX, NULL); 
    if(i == SQLITE_OK)

    {
        
    }
    else
    {
        sqlite3_close(database);
    }*/
    [Database openDatabase];
}


+(void)closeDatabase{
   // if (database) sqlite3_close(database);
    [Database closeDatabase];
}

+(void)insert:(NSString *)tbl value:(NSString*)value description:(NSString *)description listOrder:(NSString*)listOrder
{
    [Database insert:tbl value:value description:description listOrder:listOrder];
    
   /* sqlite3_stmt *addStmt = nil;
	if (database)
	{
		NSString *myQuery = [NSString stringWithFormat:@"Insert Into %@(\"value\",\"description\",\"listOrder\") Values(?,?,?)", tbl];
        
		const char *sql = [myQuery UTF8String];
		
		if(sqlite3_prepare_v2(database, sql, -1, &addStmt, NULL) == SQLITE_OK)
		{
			sqlite3_bind_text(addStmt, 1, [value UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(addStmt, 2, [description UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_int(addStmt, 3, [listOrder intValue]);
			
		}
		
		if(SQLITE_DONE != sqlite3_step(addStmt))
			NSAssert1(0, @"Error while updating. '%s'", sqlite3_errmsg(database));
	}
    //else
    //	sqlite3_close(database);
	if(addStmt) sqlite3_finalize(addStmt);*/

}

+(void)deleteAll:(NSString*)tbl
{
    [Database deleteAll:tbl];
   /* sqlite3_stmt *deleteStmt = nil;
    if (database)
    {
        NSString *myQuery = [NSString stringWithFormat:@"DELETE FROM %@", tbl];	
        //NSString *myQuery = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS LT_Shapes (id text,description text,listOrder integer)"];
        const char *sql = [myQuery UTF8String];
        
        char *err;
        
        if(sqlite3_prepare_v2(database, sql, -1, &deleteStmt, NULL) == SQLITE_OK)
        //if(sqlite3_exec(database, sql, NULL, NULL, &err) == SQLITE_OK)
        {            
            sqlite3_bind_null(deleteStmt, -1);
        }
        int i = sqlite3_step(deleteStmt);
        if(SQLITE_DONE != i)
            NSAssert1(0, @"Error while updating. '%s'", sqlite3_errmsg(database));
    }
    else
    {
        //  sqlite3_close(database);
    }	
    if(deleteStmt) sqlite3_finalize(deleteStmt);*/
}

+(NSMutableArray *)get:(NSString*)tbl
{
    return [Database get:tbl];
    
  /*  NSMutableArray *arr = [[NSMutableArray alloc]init ];
    
    [LT_Helper openDatabase];
    
	if (database) {	
        NSString *query = [NSString stringWithFormat:@"select * FROM %@ order by listOrder", tbl];	
		
		sqlite3_stmt *selectstmt;
		
		const char *sql = [query UTF8String];
        
		//if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK) 
        if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK)
		{            
           
			while(sqlite3_step(selectstmt) <= SQLITE_ROW) 
			{                                  
                
                NSMutableDictionary *diamonds = [[NSMutableDictionary alloc] init];
                [diamonds setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt,0)] forKey:kValueElementName];
                [diamonds setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt,1)]forKey:kDescriptionElementName];
                [diamonds setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt,2)]forKey:kListOrderElementName];                
                
                [arr addObject:diamonds];                
                [diamonds release];                  
				
			}
            
            
		}
	}
    
    [LT_Helper closeDatabase];
    return arr;
*/
}
@end
