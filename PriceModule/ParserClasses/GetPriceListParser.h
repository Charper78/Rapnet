//
//  GetPriceList.h
//  RapnetPriceModule
//
//  Created by Nikhil Bansal on 12/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "Database.h"

@protocol getPriceListDelegate
-(void)webserviceCallPriceListFinished:(NSMutableArray *)results;
-(void)finishedDownloading;
@end

@interface GetPriceListParser : NSObject<NSXMLParserDelegate> {
    id<getPriceListDelegate> delegate;
	
	NSMutableData *webData;
	NSXMLParser *xmlParser;
	NSMutableDictionary *data;
	NSMutableArray *results;
	NSMutableString *currentElement;
    
    BOOL flag;
    NSMutableDictionary *dic;
    
    NSString *gridID,*shapes,*color,*clarity,*price;
}

@property(retain, nonatomic) id<getPriceListDelegate> delegate;
@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, retain) NSXMLParser *xmlParser;
@property(nonatomic, retain) NSMutableArray *results;

-(void)connectToParser:(NSMutableData *)xmldata;
-(void)GetPriceList:(NSString *)ticket ShapeType:(NSString *)sID GridSizeID:(int)ID;
-(NSMutableArray*)getResults;

-(NSInteger)checkIndex:(NSInteger)type:(NSString *)item:(NSInteger)indexSearch;

@end
