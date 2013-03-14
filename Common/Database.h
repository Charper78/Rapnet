//
//  Database.h
//  Rapnet
//  Created by NEHA SINGH on 20/05/11.
//  Copyright 2011 TechAhead. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "LT_Const.h"

@interface Database : NSObject {
    //NSString *timeString;
}

//LT_Helper
+(void)insert:(NSString *)tbl value:(NSString*)value description:(NSString *)description listOrder:(NSString*)listOrder;
+(void)deleteAll:(NSString*)tbl;
+(NSMutableArray *)get:(NSString*)tbl;
//End LT_Helper



+(NSString *)getDBPath;
+(void)insertArticles:(NSString*)dbPath articleID:(NSString*)articleID thumbID:(NSString*)thumbID title:(NSString*)title subTitle:(NSString*)subTitle articleTxt:(NSString*)articleTxt author:(NSString*)author date:(NSString*)date articleTyp:(NSString*)articleTyp imageURL:(NSString*)imageURL videoURL:(NSString*)videoURL articleURL:(NSString*)articleURL;
+(void)fetchArticles:(NSString*)dbPath;
+(void)checkDuplicateArticle:(NSString*)dbPath arg2:(NSString*)ID;
+(void)deleteArticle:(NSString*)dbPath arg2:(NSInteger)articleID;


+(void)openDatabase;
+(void)closeDatabase;

+(void)insertDiamonds:(NSString*)dbPath fileName:(NSString*)name time:(NSString*)time ID:(NSString*)ID shape:(NSString*)shape size:(NSString*)size color:(NSString*)color clarity:(NSString*)clarity rapPercent:(NSString*)percent perCarat:(NSString*)percarat totalPrice:(NSString *)totalPrice rapPriceList:(NSString *)rapPrice totalRapPrice:(NSString *)totalRP avgPrice:(NSString *)avgPrice avgDiscount:(NSString *)avgDisc bestPrice:(NSString *)bestP bestDiscount:(NSString *)bestDisc;
+(void)fetchDiamonds:(NSString*)dbPath;
+(void)deleteDiamonds:(NSString*)dbPath arg2:(NSString *)time;
+(void)deleteDiamondWithIndex:(NSInteger)index;
+(void)updateDiamonds:(NSString*)dbPath arg2:(NSString *)time fileName:(NSString *)name;
+(void)updateDiamond:(NSString*)dbPath fileName:(NSString*)name time:(NSString*)time ID:(NSString*)ID shape:(NSString*)shape size:(NSString*)size color:(NSString*)color clarity:(NSString*)clarity rapPercent:(NSString*)percent perCarat:(NSString*)percarat totalPrice:(NSString *)totalPrice rapPriceList:(NSString *)rapPrice totalRapPrice:(NSString *)totalRP avgPrice:(NSString *)avgPrice avgDiscount:(NSString *)avgDisc bestPrice:(NSString *)bestP bestDiscount:(NSString *)bestDisc diamondIndex:(NSInteger)index;


+(int)insertWorkAreaDiamonds:(NSString*)ID shape:(NSString*)shape size:(NSString*)size color:(NSString*)color clarity:(NSString*)clarity rapPercent:(NSString*)percent perCarat:(NSString*)percarat totalPrice:(NSString *)totalPrice rapPriceList:(NSString *)rapPrice totalRapPrice:(NSString *)totalRP avgPrice:(NSString *)avgPrice avgDiscount:(NSString *)avgDisc bestPrice:(NSString *)bestP bestDiscount:(NSString *)bestDisc;
+(void)fetchWorkAreaDiamonds;
+(void)deleteWorkAreaDiamonds:(NSInteger)index;
+(void)deleteAllWorkAreaDiamonds;
+(void)updateWorkAreaDiamond:(NSString*)ID shape:(NSString*)shape size:(NSString*)size color:(NSString*)color clarity:(NSString*)clarity rapPercent:(NSString*)percent perCarat:(NSString*)percarat totalPrice:(NSString *)totalPrice rapPriceList:(NSString *)rapPrice totalRapPrice:(NSString *)totalRP avgPrice:(NSString *)avgPrice avgDiscount:(NSString *)avgDisc bestPrice:(NSString *)bestP bestDiscount:(NSString *)bestDisc diamondIndex:(NSInteger)index;

+(NSString*)getLastUpdateDate;
+(BOOL)checkForUpdates;
+(void)updateCheckerTable:(NSString*)dbPath arg2:(NSString *)time updateFlag:(NSString *)flag;
+(void)insertClarityWithID:(NSString *)ID Title:(NSString *)title;
+(void)insertColorsWithID:(NSString *)ID Title:(NSString *)title;
+(void)insertShapesWithID:(NSString *)ID Title:(NSString *)title shortTitle:(NSString*)st;
+(void)insertPricesWithGridSizeID:(NSString *)ID Shape:(NSString *)shape Color:(NSString*)color Clarity:(NSString *)clarity Price:(NSString*)price;

+(void)deleteAllShapes:(NSString*)dbPath;
+(void)deleteAllClarity:(NSString*)dbPath;
+(void)deleteAllColor:(NSString*)dbPath;
+(void)deleteAllPriceList;

+(NSMutableArray *)fetchShapes;
+(NSMutableArray *)fetchColors;
+(NSMutableArray *)fetchClaritys;
//+(float)fetchPriceWithGridID:(NSString *)ID Shape:(NSString *)shape Color:(NSString*)color Clarity:(NSString *)clarity;

@end
