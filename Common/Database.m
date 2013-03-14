//
//  Database.m
//  Rapnet
//
//  Created by NEHA SINGH on 20/05/11.
//  Copyright 2011 TechAhead. All rights reserved.
//

#import "Database.h"
#import "StoredData.h"
#import "ObjSavedArticles.h"

@implementation Database
static sqlite3 *database = nil;


+(void)insertArticles:(NSString*)dbPath articleID:(NSString*)articleID thumbID:(NSString*)thumbID title:(NSString*)title subTitle:(NSString*)subTitle articleTxt:(NSString*)articleTxt author:(NSString*)author date:(NSString*)date articleTyp:(NSString*)articleTyp imageURL:(NSString*)imageURL videoURL:(NSString*)videoURL articleURL:(NSString*)articleURL;
{
	sqlite3_stmt *addStmt = nil;
	if (database)
	{
		NSString *myQuery = [NSString stringWithFormat:@"Insert Into savedArticle(\"article_ID\",\"thumb_ID\",\"title\",\"subTitle\",\"articleTxt\",\"author\",\"date\",\"articleTyp\",\"imageURL\",\"videoURL\",\"articleURL\") Values(?,?,?,?,?,?,?,?,?,?,?)"];
		const char *sql = [myQuery UTF8String];
		
		if(sqlite3_prepare_v2(database, sql, -1, &addStmt, NULL) == SQLITE_OK)
		{
			sqlite3_bind_text(addStmt, 1, [articleID UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(addStmt, 2, [thumbID UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(addStmt, 3, [title UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(addStmt, 4, [subTitle UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(addStmt, 5, [articleTxt UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(addStmt, 6, [author UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(addStmt, 7, [date UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(addStmt, 8, [articleTyp UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(addStmt, 9, [imageURL UTF8String],-1, SQLITE_TRANSIENT);
			sqlite3_bind_text(addStmt, 10,[videoURL UTF8String],-1, SQLITE_TRANSIENT);
			sqlite3_bind_text(addStmt, 11,[articleURL UTF8String],-1, SQLITE_TRANSIENT);
		}
		
		if(SQLITE_DONE != sqlite3_step(addStmt))
			NSAssert1(0, @"Error while updating. '%s'", sqlite3_errmsg(database));
	}
	//else
    //sqlite3_close(database);
	if(addStmt) sqlite3_finalize(addStmt);
	//if (database) sqlite3_close(database);
}


+(void)fetchArticles:(NSString*)dbPath
{
	if (database) {
		
		const char *sql = "select * from savedArticle";
		sqlite3_stmt *selectstmt = nil;
		
		if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK) 
		{
			while(sqlite3_step(selectstmt) <= SQLITE_ROW) 
			{
				ObjSavedArticles* myArticles = [[ObjSavedArticles alloc] init];
				myArticles.articleID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt,1)];
				myArticles.thumbID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt,2)];
				myArticles.title = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt,3)];
				myArticles.subTitle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 4)];
				myArticles.articleTxt = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 5)];
				myArticles.author = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 6)];
				myArticles.date = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 7)];
				myArticles.articleType = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 8)];
				myArticles.imageURL = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 9)];
				myArticles.videoURL = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 10)];
				myArticles.articleURL = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 11)];
				[[StoredData sharedData].arrSavedArticle addObject:myArticles];
				[myArticles release];
			}
		}
        if(selectstmt) sqlite3_finalize(selectstmt);
	}
	//else
    //sqlite3_close(database);
}




+(void)checkDuplicateArticle:(NSString*)dbPath arg2:(NSString*)ID
{
	
	if (database) {
		
		NSString* query = [NSString stringWithFormat:@"SELECT id FROM savedArticle Where article_ID='%@'",ID];
		const char *sql = [query UTF8String];
		sqlite3_stmt *selectstmt = nil;
		
		if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK) 
		{
			while(sqlite3_step(selectstmt) <= SQLITE_ROW) 
			{
				[[StoredData sharedData].arrDuplicateChk addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt,0)]];
			}
		}
        if(selectstmt) sqlite3_finalize(selectstmt);
	}
	//else
    //sqlite3_close(database);
}



+(void)deleteArticle:(NSString*)dbPath arg2:(NSInteger)articleID
{
    sqlite3_stmt *deleteStmt = nil;
    if (database)
    {
        NSString *myQuery = [NSString stringWithFormat:@"DELETE FROM savedArticle Where article_ID=?"];		
        const char *sql = [myQuery UTF8String];
        
        if(sqlite3_prepare_v2(database, sql, -1, &deleteStmt, NULL) == SQLITE_OK)
        {
            sqlite3_bind_int(deleteStmt, 1, articleID);
        }
        if(SQLITE_DONE != sqlite3_step(deleteStmt))
            NSAssert1(0, @"Error while updating. '%s'", sqlite3_errmsg(database));
    }
    /*else
     {
     sqlite3_close(database);
     }	*/
    if(deleteStmt) sqlite3_finalize(deleteStmt);
}


+(void)openDatabase{
    int i = sqlite3_open_v2( [[self getDBPath] UTF8String], &database, 
                            SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE | SQLITE_OPEN_AUTOPROXY | SQLITE_OPEN_FULLMUTEX, NULL); 
    if(i == SQLITE_OK)
    {
        
    }
    else
    {
        sqlite3_close(database);
    }
}


+(void)closeDatabase{
    if (database) sqlite3_close(database);
}


+(void)insertDiamonds:(NSString*)dbPath fileName:(NSString*)name time:(NSString*)time ID:(NSString*)ID shape:(NSString*)shape size:(NSString*)size color:(NSString*)color clarity:(NSString*)clarity rapPercent:(NSString*)percent perCarat:(NSString*)percarat totalPrice:(NSString *)totalPrice rapPriceList:(NSString *)rapPrice totalRapPrice:(NSString *)totalRP avgPrice:(NSString *)avgPrice avgDiscount:(NSString *)avgDisc bestPrice:(NSString *)bestP bestDiscount:(NSString *)bestDisc
{
    sqlite3_stmt *addStmt = nil;
	if (database)
	{
		NSString *myQuery = [NSString stringWithFormat:@"Insert Into savedDiamonds(\"filename\",\"time\",\"ID\",\"shape\",\"size\",\"color\",\"clarity\",\"rapPercent\",\"percarat\",\"rapPriceList\",\"totalRapPriceList\",\"totalPrice\",\"avgDiscount\",\"avgPrice\",\"bestDiscount\",\"bestPrice\") Values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"];
		const char *sql = [myQuery UTF8String];
		
		if(sqlite3_prepare_v2(database, sql, -1, &addStmt, NULL) == SQLITE_OK)
		{
			sqlite3_bind_text(addStmt, 1, [name UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(addStmt, 2, [time UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(addStmt, 3, [ID UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(addStmt, 4, [shape UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(addStmt, 5, [size UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(addStmt, 6, [color UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(addStmt, 7, [clarity UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(addStmt, 8, [percent UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(addStmt, 9, [percarat UTF8String], -1, SQLITE_TRANSIENT);	
            sqlite3_bind_text(addStmt, 10, [rapPrice UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(addStmt, 11, [totalRP UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(addStmt, 12, [totalPrice UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(addStmt, 13, [avgDisc UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(addStmt, 14, [avgPrice UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(addStmt, 15, [bestDisc UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(addStmt, 16, [bestP UTF8String], -1, SQLITE_TRANSIENT);
		}
		
		if(SQLITE_DONE != sqlite3_step(addStmt))
			NSAssert1(0, @"Error while updating. '%s'", sqlite3_errmsg(database));
	}
	//else
	//	sqlite3_close(database);
	if(addStmt) sqlite3_finalize(addStmt);
	//if (database) sqlite3_close(database);
}


+(void)fetchDiamonds:(NSString*)dbPath
{
    if ([[StoredData sharedData].dbSavedDiamondsArr count]>0) {
        [[StoredData sharedData].dbSavedDiamondsArr removeAllObjects];
    }
    
    //NSLog(@"T = ");
    
	if (database) {
		
		const char *sql = "select * from savedDiamonds ORDER BY FileName";
		sqlite3_stmt *selectstmt = nil;
		
		if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK) 
		{
            NSString *timeString = @"";
            NSString *fileName = @"";
            BOOL flag = TRUE;
            NSMutableArray *arr = [[NSMutableArray alloc]init ];
			while(sqlite3_step(selectstmt) <= SQLITE_ROW) 
			{
                
                if (flag) {
                    //timeString = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt,1)];
                    fileName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt,0)];
                    if ([arr count]>0) {
                        [arr removeAllObjects];
                    }
                    flag = FALSE;
                }
                
                
                
                //NSString *str = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt,1)];
                NSString *str = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt,0)];
                
                //if ([str isEqualToString:timeString]) {
                if ([str isEqualToString:fileName]) {
                    NSMutableDictionary *diamonds = [[NSMutableDictionary alloc] init];
                    [diamonds setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt,0)] forKey:@"FileName"];
                    [diamonds setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt,1)]forKey:@"Time"];
                    [diamonds setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt,2)]forKey:@"ID"];
                    [diamonds setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 3)]forKey:@"Shape"];
                    [diamonds setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 4)]forKey:@"Size"];
                    [diamonds setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 5)]forKey:@"Color"];
                    [diamonds setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 6)]forKey:@"Clarity"];
                    [diamonds setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 7)]forKey:@"rapPercent"];
                    [diamonds setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 8)]forKey:@"PricePerCarat"];
                    [diamonds setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt,9)] forKey:@"RapPriceList"];
                    [diamonds setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt,10)]forKey:@"TotalRapPriceList"];
                    [diamonds setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt,11)]forKey:@"PriceTotal"];
                    [diamonds setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 12)]forKey:@"AvgDiscount"];
                    [diamonds setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 13)]forKey:@"AvgPrice"];
                    [diamonds setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 14)]forKey:@"BestDiscount"];
                    [diamonds setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 15)]forKey:@"BestPrice"];
                    [diamonds setObject:[NSString stringWithFormat:@"%d",(char *)sqlite3_column_int(selectstmt, 16)]forKey:@"DiamondIndex"];
                    
                     NSLog(@"D===%@",diamonds);
                    
                    [arr addObject:diamonds];
                    
                    [diamonds release];
                }else{
                    //NSLog(@"T1 = %@",arr);
                    [[StoredData sharedData].dbSavedDiamondsArr addObject:arr];
                    
                    ReleaseObject(arr);
                    arr  = [[NSMutableArray alloc]init ];
                    
                    //  NSLog(@"%@",[StoredData sharedData].dbSavedDiamondsArr);
                    timeString = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt,1)];
                    fileName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt,0)];
                    
                    NSMutableDictionary *diamonds = [[NSMutableDictionary alloc] init];
                    [diamonds setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt,0)] forKey:@"FileName"];
                    [diamonds setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt,1)]forKey:@"Time"];
                    [diamonds setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt,2)]forKey:@"ID"];
                    [diamonds setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 3)]forKey:@"Shape"];
                    [diamonds setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 4)]forKey:@"Size"];
                    [diamonds setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 5)]forKey:@"Color"];
                    [diamonds setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 6)]forKey:@"Clarity"];
                    [diamonds setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 7)]forKey:@"rapPercent"];
                    [diamonds setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 8)]forKey:@"PricePerCarat"];
                    [diamonds setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt,9)] forKey:@"RapPriceList"];
                    [diamonds setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt,10)]forKey:@"TotalRapPriceList"];
                    [diamonds setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt,11)]forKey:@"PriceTotal"];
                    [diamonds setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 12)]forKey:@"AvgDiscount"];
                    [diamonds setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 13)]forKey:@"AvgPrice"];
                    [diamonds setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 14)]forKey:@"BestDiscount"];
                    [diamonds setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 15)]forKey:@"BestPrice"];
                    [diamonds setObject:[NSString stringWithFormat:@"%d",(char *)sqlite3_column_int(selectstmt, 16)]forKey:@"DiamondIndex"];
                    
                    NSLog(@"%@",diamonds);
                    
                    [arr addObject:diamonds];
                    
                    [diamonds release];
                }
                
				
			}
            
            if ([arr count]>0) {
                [[StoredData sharedData].dbSavedDiamondsArr addObject:arr];
                
                ReleaseObject(arr);
            }
            
            ReleaseObject(arr);
            
		}
        if(selectstmt) sqlite3_finalize(selectstmt);
	}
	//else
    //sqlite3_close(database);
}

//+(void)deleteDiamonds:(NSString*)dbPath arg2:(NSString *)time{
+(void)deleteDiamonds:(NSString*)dbPath arg2:(NSString *)fileName{
    sqlite3_stmt *deleteStmt = nil;
    if (database)
    {
        //NSString *myQuery = [NSString stringWithFormat:@"DELETE FROM savedDiamonds Where Time=?"];
        NSString *myQuery = [NSString stringWithFormat:@"DELETE FROM savedDiamonds Where filename=?"];
        const char *sql = [myQuery UTF8String];
        
        if(sqlite3_prepare_v2(database, sql, -1, &deleteStmt, NULL) == SQLITE_OK)
        {
            
            sqlite3_bind_text(deleteStmt, 1, [fileName UTF8String], -1, SQLITE_TRANSIENT);
        }
        if(SQLITE_DONE != sqlite3_step(deleteStmt))
            NSAssert1(0, @"Error while updating. '%s'", sqlite3_errmsg(database));
    }
    /* else
     {
     sqlite3_close(database);
     }	*/
    if(deleteStmt) sqlite3_finalize(deleteStmt);
}


+(void)deleteDiamondWithIndex:(NSInteger)index{
    
    sqlite3_stmt *deleteStmt = nil;
    if (database)
    {
        NSString *myQuery = [NSString stringWithFormat:@"DELETE FROM savedDiamonds Where DiamondIndex=?"];	
        
        const char *sql = [myQuery UTF8String];
        
        if(sqlite3_prepare_v2(database, sql, -1, &deleteStmt, NULL) == SQLITE_OK)
        {
            
            sqlite3_bind_int(deleteStmt, 1, index);
        }
        if(SQLITE_DONE != sqlite3_step(deleteStmt))
            NSAssert1(0, @"Error while updating. '%s'", sqlite3_errmsg(database));
    }
    
    if(deleteStmt) sqlite3_finalize(deleteStmt);
}

+(void)updateDiamonds:(NSString*)dbPath arg2:(NSString *)time fileName:(NSString *)name{
    
    
    sqlite3_stmt *deleteStmt = nil;
    if (database)
    {
        NSString *myQuery = [NSString stringWithFormat:@"UPDATE savedDiamonds SET FileName=? Where Time=?"];	
        
        const char *sql = [myQuery UTF8String];
        
        if(sqlite3_prepare_v2(database, sql, -1, &deleteStmt, NULL) == SQLITE_OK)
        {
            sqlite3_bind_text(deleteStmt, 1, [name UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(deleteStmt, 2, [time UTF8String], -1, SQLITE_TRANSIENT);
        }
        if(SQLITE_DONE != sqlite3_step(deleteStmt))
            NSAssert1(0, @"Error while updating. '%s'", sqlite3_errmsg(database));
    }
    /* else
     {
     sqlite3_close(database);
     }	*/
    if(deleteStmt) sqlite3_finalize(deleteStmt);
}


+(void)updateDiamond:(NSString*)dbPath fileName:(NSString*)name time:(NSString*)time ID:(NSString*)ID shape:(NSString*)shape size:(NSString*)size color:(NSString*)color clarity:(NSString*)clarity rapPercent:(NSString*)percent perCarat:(NSString*)percarat totalPrice:(NSString *)totalPrice rapPriceList:(NSString *)rapPrice totalRapPrice:(NSString *)totalRP avgPrice:(NSString *)avgPrice avgDiscount:(NSString *)avgDisc bestPrice:(NSString *)bestP bestDiscount:(NSString *)bestDisc diamondIndex:(NSInteger)index
{
    
    sqlite3_stmt *deleteStmt = nil;
    if (database)
    {
        NSString *myQuery = [NSString stringWithFormat:@"UPDATE savedDiamonds SET FileName=?,time=?,ID=?,shape=?,size=?,color=?,clarity=?,rapPercent=?,percarat=?,rapPriceList=?,totalRapPriceList=?,totalPrice=?,avgDiscount=?,avgPrice=?,bestDiscount=?,bestPrice=? Where DiamondIndex=?"];	
        
        const char *sql = [myQuery UTF8String];
        
        if(sqlite3_prepare_v2(database, sql, -1, &deleteStmt, NULL) == SQLITE_OK)
        {
            sqlite3_bind_text(deleteStmt, 1, [name UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(deleteStmt, 2, [time UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(deleteStmt, 3, [ID UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(deleteStmt, 4, [shape UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(deleteStmt, 5, [size UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(deleteStmt, 6, [color UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(deleteStmt, 7, [clarity UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(deleteStmt, 8, [percent UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(deleteStmt, 9, [percarat UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(deleteStmt, 10, [rapPrice UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(deleteStmt, 11, [totalRP UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(deleteStmt, 12, [totalPrice UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(deleteStmt, 13, [avgDisc UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(deleteStmt, 14, [avgPrice UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(deleteStmt, 15, [bestDisc UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(deleteStmt, 16, [bestP UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_int(deleteStmt, 17, index);           
        }
        
        if(SQLITE_DONE != sqlite3_step(deleteStmt))
            NSAssert1(0, @"Error while updating. '%s'", sqlite3_errmsg(database));
    }
    
    if(deleteStmt) sqlite3_finalize(deleteStmt);
}


+(int)insertWorkAreaDiamonds:(NSString*)ID shape:(NSString*)shape size:(NSString*)size color:(NSString*)color clarity:(NSString*)clarity rapPercent:(NSString*)percent perCarat:(NSString*)percarat totalPrice:(NSString *)totalPrice rapPriceList:(NSString *)rapPrice totalRapPrice:(NSString *)totalRP avgPrice:(NSString *)avgPrice avgDiscount:(NSString *)avgDisc bestPrice:(NSString *)bestP bestDiscount:(NSString *)bestDisc
{
    // NSLog(@"D===%@",percent);
    sqlite3_stmt *addStmt = nil;
	if (database)
	{
		NSString *myQuery = [NSString stringWithFormat:@"Insert Into savedWorkAreaDiamonds(\"ID\",\"shape\",\"size\",\"color\",\"clarity\",\"rapPercent\",\"percarat\",\"rapPriceList\",\"totalRapPriceList\",\"totalPrice\",\"avgDiscount\",\"avgPrice\",\"bestDiscount\",\"bestPrice\") Values(?,?,?,?,?,?,?,?,?,?,?,?,?,?)"];
		const char *sql = [myQuery UTF8String];
		
		if(sqlite3_prepare_v2(database, sql, -1, &addStmt, NULL) == SQLITE_OK)
		{
			
            sqlite3_bind_text(addStmt, 1, [ID UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(addStmt, 2, [shape UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(addStmt, 3, [size UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(addStmt, 4, [color UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(addStmt, 5, [clarity UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(addStmt, 6, [percent UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(addStmt, 7, [percarat UTF8String], -1, SQLITE_TRANSIENT);	
            sqlite3_bind_text(addStmt, 8, [rapPrice UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(addStmt, 9, [totalRP UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(addStmt, 10, [totalPrice UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(addStmt, 11, [avgDisc UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(addStmt, 12, [avgPrice UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(addStmt, 13, [bestDisc UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(addStmt, 14, [bestP UTF8String], -1, SQLITE_TRANSIENT);
		}
		
		if(SQLITE_DONE != sqlite3_step(addStmt))
			NSAssert1(0, @"Error while updating. '%s'", sqlite3_errmsg(database));
	}
	
	if(addStmt) sqlite3_finalize(addStmt);
    
    return [Database getMaxWorkAreaDiamondsDiamondIndex];
}

+(void)fetchWorkAreaDiamonds{
    if ([[StoredData sharedData].savedDiamondsArr count]>0) {
        [[StoredData sharedData].savedDiamondsArr removeAllObjects];
    }
    
	if (database) {
		
		const char *sql = "select * from savedWorkAreaDiamonds";
		sqlite3_stmt *selectstmt = nil;
		
		if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK)
		{
            
			while(sqlite3_step(selectstmt) <= SQLITE_ROW)
			{
                
                NSMutableDictionary *diamonds = [[NSMutableDictionary alloc] init];
                
                [diamonds setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt,0)]forKey:@"ID"];
                [diamonds setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 1)]forKey:@"Shape"];
                [diamonds setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 2)]forKey:@"Size"];
                [diamonds setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 3)]forKey:@"Color"];
                [diamonds setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 4)]forKey:@"Clarity"];
                [diamonds setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 5)]forKey:@"rapPercent"];
                [diamonds setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 6)]forKey:@"PricePerCarat"];
                [diamonds setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt,7)] forKey:@"RapPriceList"];
                [diamonds setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt,8)]forKey:@"TotalRapPriceList"];
                [diamonds setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt,9)]forKey:@"PriceTotal"];
                [diamonds setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 10)]forKey:@"AvgDiscount"];
                [diamonds setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 11)]forKey:@"AvgPrice"];
                [diamonds setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 12)]forKey:@"BestDiscount"];
                [diamonds setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 13)]forKey:@"BestPrice"];
                [diamonds setObject:[NSString stringWithFormat:@"%d",(char *)sqlite3_column_int(selectstmt, 14)]forKey:@"DiamondIndex"];
                
                [[StoredData sharedData].savedDiamondsArr addObject:diamonds];
                
                [diamonds release];
                
                
                
				
			}
            
		}
        if(selectstmt) sqlite3_finalize(selectstmt);
	}
    
    //  NSLog(@"diam == %@",[StoredData sharedData].savedDiamondsArr);
}


+(NSInteger)getMaxWorkAreaDiamondsDiamondIndex{
    
    int diamondIndex = 0;
    
	if (database) {
		
		const char *sql = "select max(DiamondIndex) from savedWorkAreaDiamonds";
		sqlite3_stmt *selectstmt = nil;
		
		if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK) 
		{
            
			while(sqlite3_step(selectstmt) <= SQLITE_ROW) 
			{
                    diamondIndex = sqlite3_column_int(selectstmt, 0);
            }
            
		}
        if(selectstmt) sqlite3_finalize(selectstmt);
	}
    return diamondIndex;
    //  NSLog(@"diam == %@",[StoredData sharedData].savedDiamondsArr);
}


+(void)deleteWorkAreaDiamonds:(NSInteger)index{
    sqlite3_stmt *deleteStmt = nil;
    NSLog(@"index = %d",index);
    if (database)
    {
        NSString *myQuery = [NSString stringWithFormat:@"DELETE FROM savedWorkAreaDiamonds Where diamondIndex=?"];	
        
        const char *sql = [myQuery UTF8String];
        
        if(sqlite3_prepare_v2(database, sql, -1, &deleteStmt, NULL) == SQLITE_OK)
        {
            
            sqlite3_bind_int(deleteStmt, 1,index);
        }
        if(SQLITE_DONE != sqlite3_step(deleteStmt))
            NSAssert1(0, @"Error while updating. '%s'", sqlite3_errmsg(database));
    }
    
    if(deleteStmt) sqlite3_finalize(deleteStmt);
}


+(void)deleteAllWorkAreaDiamonds{
    sqlite3_stmt *deleteStmt = nil;
    if (database)
    {
        NSString *myQuery = [NSString stringWithFormat:@"DELETE FROM savedWorkAreaDiamonds"];	
        
        const char *sql = [myQuery UTF8String];
        
        if(sqlite3_prepare_v2(database, sql, -1, &deleteStmt, NULL) == SQLITE_OK)
        {
            
            
        }
        if(SQLITE_DONE != sqlite3_step(deleteStmt))
            NSAssert1(0, @"Error while updating. '%s'", sqlite3_errmsg(database));
    }
    
    if(deleteStmt) sqlite3_finalize(deleteStmt);
}


+(void)updateWorkAreaDiamond:(NSString*)ID shape:(NSString*)shape size:(NSString*)size color:(NSString*)color clarity:(NSString*)clarity rapPercent:(NSString*)percent perCarat:(NSString*)percarat totalPrice:(NSString *)totalPrice rapPriceList:(NSString *)rapPrice totalRapPrice:(NSString *)totalRP avgPrice:(NSString *)avgPrice avgDiscount:(NSString *)avgDisc bestPrice:(NSString *)bestP bestDiscount:(NSString *)bestDisc diamondIndex:(NSInteger)index
{
    NSLog(@"Index=%d",index);
    sqlite3_stmt *deleteStmt = nil;
    if (database)
    {
        NSString *myQuery = [NSString stringWithFormat:@"UPDATE savedWorkAreaDiamonds SET ID=?,shape=?,size=?,color=?,clarity=?,rapPercent=?,percarat=?,rapPriceList=?,totalRapPriceList=?,totalPrice=?,avgDiscount=?,avgPrice=?,bestDiscount=?,bestPrice=? Where DiamondIndex=?"];	
        
        const char *sql = [myQuery UTF8String];
        
        if(sqlite3_prepare_v2(database, sql, -1, &deleteStmt, NULL) == SQLITE_OK)
        {
            
            sqlite3_bind_text(deleteStmt, 1, [ID UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(deleteStmt, 2, [shape UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(deleteStmt, 3, [size UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(deleteStmt, 4, [color UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(deleteStmt, 5, [clarity UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(deleteStmt, 6, [percent UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(deleteStmt, 7, [percarat UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(deleteStmt, 8, [rapPrice UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(deleteStmt, 9, [totalRP UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(deleteStmt, 10, [totalPrice UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(deleteStmt, 11, [avgDisc UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(deleteStmt, 12, [avgPrice UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(deleteStmt, 13, [bestDisc UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(deleteStmt, 14, [bestP UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_int(deleteStmt, 15, index);           
        }
        
        if(SQLITE_DONE != sqlite3_step(deleteStmt))
            NSAssert1(0, @"Error while updating. '%s'", sqlite3_errmsg(database));
    }
    
    if(deleteStmt) sqlite3_finalize(deleteStmt);
}


+(BOOL)checkForUpdates{
    //NSString *dbPath = [self getDBPath];
    
    if (database) {
		
		NSString* query = [NSString stringWithFormat:@"SELECT updateFlag FROM updateChecker"];
		const char *sql = [query UTF8String];
		sqlite3_stmt *selectstmt = nil;
		
		if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK) 
		{
			while(sqlite3_step(selectstmt) <= SQLITE_ROW) 
			{
                NSString *str = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt,0)];
                //  NSLog(@"str = %@",str);
				if ([str isEqualToString:@"NO"]) {
                    if(selectstmt) sqlite3_finalize(selectstmt);
                    return YES;
                }
			}
		}
        if(selectstmt) sqlite3_finalize(selectstmt);
	}
	/*else
     sqlite3_close(database);*/
    
    return NO;
}

+(NSString*)getLastUpdateDate
{
    
    
    //NSString *dbPath = [self getDBPath];
    NSString *str;
    
    if (database) {
		
		NSString* query = [NSString stringWithFormat:@"SELECT updateTime FROM updateChecker"];
		const char *sql = [query UTF8String];
		sqlite3_stmt *selectstmt = nil;
		
		if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK) 
		{
			while(sqlite3_step(selectstmt) <= SQLITE_ROW) 
			{
                str = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt,0)];
                //  NSLog(@"str = %@",str);
			}
		}
        if(selectstmt) sqlite3_finalize(selectstmt);
	}
    return str;
}

+(void)updateCheckerTable:(NSString*)dbPath arg2:(NSString *)time updateFlag:(NSString *)flag{
    sqlite3_stmt *deleteStmt = nil;
    if (database)
    {
        NSString *myQuery = [NSString stringWithFormat:@"UPDATE updateChecker SET updateFlag=?,updateTime=?"];	
        
        const char *sql = [myQuery UTF8String];
        
        if(sqlite3_prepare_v2(database, sql, -1, &deleteStmt, NULL) == SQLITE_OK)
        {
            sqlite3_bind_text(deleteStmt, 1, [flag UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(deleteStmt, 2, [time UTF8String], -1, SQLITE_TRANSIENT);
        }
        if(SQLITE_DONE != sqlite3_step(deleteStmt))
            NSAssert1(0, @"Error while updating. '%s'", sqlite3_errmsg(database));
    }
    else
    {
        // sqlite3_close(database);
    }	
    if(deleteStmt) sqlite3_finalize(deleteStmt);
    
}

+(void)insertShapesWithID:(NSString *)ID Title:(NSString *)title shortTitle:(NSString*)st{
   // NSString *dbPath = [self getDBPath];
    //  [self deleteAllShapes:dbPath];
    
    sqlite3_stmt *addStmt = nil;
	if (database)
	{
		NSString *myQuery = [NSString stringWithFormat:@"Insert Into Shapes(\"ID\",\"Title\",\"ShortTitle\") Values(?,?,?)"];
		const char *sql = [myQuery UTF8String];
		
		if(sqlite3_prepare_v2(database, sql, -1, &addStmt, NULL) == SQLITE_OK)
		{
			sqlite3_bind_text(addStmt, 1, [ID UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(addStmt, 2, [title UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(addStmt, 3, [st UTF8String], -1, SQLITE_TRANSIENT);
			
		}
		
		if(SQLITE_DONE != sqlite3_step(addStmt))
			NSAssert1(0, @"Error while updating. '%s'", sqlite3_errmsg(database));
	}
    //else
    //	sqlite3_close(database);
	if(addStmt) sqlite3_finalize(addStmt);
    //if (database) sqlite3_close(database);
}

+(void)insertColorsWithID:(NSString *)ID Title:(NSString *)title{
    
    sqlite3_stmt *addStmt = nil;
	if (database)
	{
		NSString *myQuery = [NSString stringWithFormat:@"Insert Into Color(\"ID\",\"Title\") Values(?,?)"];
		const char *sql = [myQuery UTF8String];
		
		if(sqlite3_prepare_v2(database, sql, -1, &addStmt, NULL) == SQLITE_OK)
		{
			sqlite3_bind_text(addStmt, 1, [ID UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(addStmt, 2, [title UTF8String], -1, SQLITE_TRANSIENT);
			
		}
		
		if(SQLITE_DONE != sqlite3_step(addStmt))
			NSAssert1(0, @"Error while updating. '%s'", sqlite3_errmsg(database));
	}
	/*else
     sqlite3_close(database);*/
	if(addStmt) sqlite3_finalize(addStmt);
	
}

+(void)insertClarityWithID:(NSString *)ID Title:(NSString *)title{    
    
    sqlite3_stmt *addStmt = nil;
	if (database)
	{
		NSString *myQuery = [NSString stringWithFormat:@"Insert Into Clarity(\"ID\",\"Title\") Values(?,?)"];
		const char *sql = [myQuery UTF8String];
		
		if(sqlite3_prepare_v2(database, sql, -1, &addStmt, NULL) == SQLITE_OK)
		{
			sqlite3_bind_text(addStmt, 1, [ID UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(addStmt, 2, [title UTF8String], -1, SQLITE_TRANSIENT);
			
		}
		
		if(SQLITE_DONE != sqlite3_step(addStmt))
			NSAssert1(0, @"Error while updating. '%s'", sqlite3_errmsg(database));
	}
	
	if(addStmt) sqlite3_finalize(addStmt);
	
}

+(void)insertPricesWithGridSizeID:(NSString *)ID Shape:(NSString *)shape Color:(NSString*)color Clarity:(NSString *)clarity Price:(NSString*)price{
    
    sqlite3_stmt *addStmt = nil;
	if (database)
	{
		NSString *myQuery = [NSString stringWithFormat:@"Insert Into PriceList(\"GridID\",\"Shape\",\"Color\",\"Clarity\",\"Price\") Values(?,?,?,?,?)"];
		const char *sql = [myQuery UTF8String];
		
		if(sqlite3_prepare_v2(database, sql, -1, &addStmt, NULL) == SQLITE_OK)
		{
			sqlite3_bind_text(addStmt, 1, [ID UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(addStmt, 2, [shape UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(addStmt, 3, [color UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(addStmt, 4, [clarity UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(addStmt, 5, [price UTF8String], -1, SQLITE_TRANSIENT);
			
		}
		
		if(SQLITE_DONE != sqlite3_step(addStmt))
			NSAssert1(0, @"Error while updating. '%s'", sqlite3_errmsg(database));
	}
	
	if(addStmt) sqlite3_finalize(addStmt);
}

+(void)deleteAllShapes:(NSString*)dbPath{
    
    sqlite3_stmt *deleteStmt = nil;
    if (database)
    {
        NSString *myQuery = [NSString stringWithFormat:@"DELETE FROM Shapes"];	
        
        const char *sql = [myQuery UTF8String];
        
        if(sqlite3_prepare_v2(database, sql, -1, &deleteStmt, NULL) == SQLITE_OK)
        {
            
            sqlite3_bind_null(deleteStmt, -1);
        }
        if(SQLITE_DONE != sqlite3_step(deleteStmt))
            NSAssert1(0, @"Error while updating. '%s'", sqlite3_errmsg(database));
    }
    else
    {
        //  sqlite3_close(database);
    }	
    if(deleteStmt) sqlite3_finalize(deleteStmt);
}

+(void)deleteAllClarity:(NSString*)dbPath{
    sqlite3_stmt *deleteStmt = nil;
    if (database)
    {
        NSString *myQuery = [NSString stringWithFormat:@"DELETE FROM Clarity"];	
        
        const char *sql = [myQuery UTF8String];
        
        if(sqlite3_prepare_v2(database, sql, -1, &deleteStmt, NULL) == SQLITE_OK)
        {
            
            sqlite3_bind_null(deleteStmt, -1);
        }
        if(SQLITE_DONE != sqlite3_step(deleteStmt))
            NSAssert1(0, @"Error while updating. '%s'", sqlite3_errmsg(database));
    }
    else
    {
        //  sqlite3_close(database);
    }	
    if(deleteStmt) sqlite3_finalize(deleteStmt);
}

+(void)deleteAllColor:(NSString*)dbPath{
    sqlite3_stmt *deleteStmt = nil;
    if (database)
    {
        NSString *myQuery = [NSString stringWithFormat:@"DELETE FROM Color"];	
        
        const char *sql = [myQuery UTF8String];
        
        if(sqlite3_prepare_v2(database, sql, -1, &deleteStmt, NULL) == SQLITE_OK)
        {
            
            sqlite3_bind_null(deleteStmt, -1);
        }
        if(SQLITE_DONE != sqlite3_step(deleteStmt))
            NSAssert1(0, @"Error while updating. '%s'", sqlite3_errmsg(database));
    }
    else
    {
        //  sqlite3_close(database);
    }	
    if(deleteStmt) sqlite3_finalize(deleteStmt);
}

+(void)deleteAllPriceList{
    sqlite3_stmt *deleteStmt = nil;
    if (database)
    {
        NSString *myQuery = [NSString stringWithFormat:@"DELETE FROM PriceList"];	
        
        const char *sql = [myQuery UTF8String];
        
        if(sqlite3_prepare_v2(database, sql, -1, &deleteStmt, NULL) == SQLITE_OK)
        {
            
            sqlite3_bind_null(deleteStmt, -1);
        }
        if(SQLITE_DONE != sqlite3_step(deleteStmt))
            NSAssert1(0, @"Error while updating. '%s'", sqlite3_errmsg(database));
    }
    
    if(deleteStmt) sqlite3_finalize(deleteStmt);
}

+(NSMutableArray *)fetchShapes{    
    NSMutableArray *arr = [[NSMutableArray alloc]init ];
	if (database) {		
		const char *sql = "select * from Shapes";
		sqlite3_stmt *selectstmt = nil;
		
		if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK) 
		{            
            
			while(sqlite3_step(selectstmt) <= SQLITE_ROW) 
			{                                  
                
                NSMutableDictionary *diamonds = [[NSMutableDictionary alloc] init];
                [diamonds setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt,0)] forKey:@"ShapeID"];
                [diamonds setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt,1)]forKey:@"ShapeTitle"];
                [diamonds setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt,2)]forKey:@"ShapeShortTitle"];                
                
                [arr addObject:diamonds];                
                [diamonds release];                  
				
			}
            
            
		}
        if(selectstmt) sqlite3_finalize(selectstmt);
	}
    
    return arr;
}

+(NSMutableArray *)fetchColors{
    NSMutableArray *arr = [[NSMutableArray alloc]init ];
	if (database) {		
		const char *sql = "select * from Color";
		sqlite3_stmt *selectstmt = nil;
		
		if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK) 
		{            
            
			while(sqlite3_step(selectstmt) <= SQLITE_ROW) 
			{                                  
                
                NSMutableDictionary *diamonds = [[NSMutableDictionary alloc] init];
                [diamonds setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt,0)] forKey:@"ColorID"];
                [diamonds setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt,1)]forKey:@"ColorTitle"];              
                
                [arr addObject:diamonds];                
                [diamonds release];                  
				
			}
            
            
		}
        if(selectstmt) sqlite3_finalize(selectstmt);
	}
    
    return arr;
}

+(NSMutableArray *)fetchClaritys{
    NSMutableArray *arr = [[NSMutableArray alloc]init ];
	if (database) {		
		const char *sql = "select * from Clarity";
		sqlite3_stmt *selectstmt = nil;
		
		if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK) 
		{            
            
			while(sqlite3_step(selectstmt) <= SQLITE_ROW) 
			{                                  
                
                NSMutableDictionary *diamonds = [[NSMutableDictionary alloc] init];
                [diamonds setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt,0)] forKey:@"ClarityID"];
                [diamonds setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt,1)]forKey:@"ClarityTitle"];               
                
                [arr addObject:diamonds];                
                [diamonds release];                  
				
			}
            
            
		}
        if(selectstmt) sqlite3_finalize(selectstmt);
	}
    
    return arr;
}
/*
+(float)fetchPriceWithGridID:(NSString *)ID Shape:(NSString *)shape Color:(NSString*)color Clarity:(NSString *)clarity{
    
    float finalPrice;
    if (database) {		
		const char *sql = "select Price from PriceList where GridID=? and Shape=? and Color=? and Clarity=?";
		sqlite3_stmt *selectstmt=nil;
		
		if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK) 
		{     
            sqlite3_bind_text(selectstmt, 1, [ID UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(selectstmt, 2, [shape UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(selectstmt, 3, [color UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(selectstmt, 4, [clarity UTF8String], -1, SQLITE_TRANSIENT);
            
			if(sqlite3_step(selectstmt) <= SQLITE_ROW) 
			{    
                NSString *str = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt,0)];                
				finalPrice = [str floatValue];
			}
            
            
		}
        if(selectstmt) sqlite3_finalize(selectstmt);
	}
    
    return finalPrice;
    
}
*/
+(NSString *)getDBPath
{
	NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths1 objectAtIndex:0];
	return [documentsDir stringByAppendingPathComponent:@"RapnetDB.sqlite"];	
}


- (void)finalizeStatements
{
	if (database) sqlite3_close(database);
}




+(void)insert:(NSString *)tbl value:(NSString*)value description:(NSString *)description listOrder:(NSString*)listOrder
{
    [Database openDatabase];
    sqlite3_stmt *addStmt = nil;
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
	if(addStmt) sqlite3_finalize(addStmt);
    
}

+(void)deleteAll:(NSString*)tbl
{
    sqlite3_stmt *deleteStmt = nil;
    [Database openDatabase];
    if (database)
    {
        NSString *myQuery = [NSString stringWithFormat:@"DELETE FROM %@", tbl];	
        //NSString *myQuery = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS LT_Shapes (id text,description text,listOrder integer)"];
        const char *sql = [myQuery UTF8String];
        
        if(sqlite3_prepare_v2(database, sql, -1, &deleteStmt, NULL) == SQLITE_OK)
            //if(sqlite3_exec(database, sql, NULL, NULL, &err) == SQLITE_OK)
        {            
            sqlite3_bind_null(deleteStmt, -1);
        }
        if(SQLITE_DONE != sqlite3_step(deleteStmt))
            NSAssert1(0, @"Error while updating. '%s'", sqlite3_errmsg(database));
    }
    else
    {
        //  sqlite3_close(database);
    }	
    if(deleteStmt) sqlite3_finalize(deleteStmt);
}

+(NSMutableArray *)get:(NSString*)tbl
{
    NSMutableArray *arr = [[NSMutableArray alloc]init ];
    sqlite3_stmt *selectstmt = nil;
    //[LT_Helper openDatabase];
    [Database openDatabase];
    
	if (database) {	
        NSString *query = [NSString stringWithFormat:@"select * FROM %@ order by listOrder", tbl];	
		
		
		
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
    
    //[LT_Helper closeDatabase];
    if(selectstmt) sqlite3_finalize(selectstmt);
    // [Database closeDatabase];
    return arr;
    
}
@end

