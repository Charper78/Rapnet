//
//  GetTradeScreenParser.h
//  RapnetPriceModule
//
//  Created by Nikhil Bansal on 11/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@protocol getTradeScreenDelegate
-(void)webserviceCallTradeScreenFinished;
@end

@interface GetTradeScreenParser : NSObject <NSXMLParserDelegate>{
    id<getTradeScreenDelegate> delegate;
	
	NSMutableData *webData;
	NSXMLParser *xmlParser;
	NSMutableDictionary *data;
	NSMutableArray *results;
	NSMutableString *currentElement;
    
    BOOL flag;
    NSMutableDictionary *dic;
}

@property(retain, nonatomic) id<getTradeScreenDelegate> delegate;
@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, retain) NSXMLParser *xmlParser;
@property(nonatomic, retain) NSMutableArray *results;

-(void)connectToParser:(NSMutableData *)xmldata;
-(void)GetTradeScreenList:(NSString *)ticket ShapeID:(int)sID Weight:(float)w;
-(NSMutableArray*)getResults;

@end
