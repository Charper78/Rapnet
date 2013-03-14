//
//  GetPriceChangeParser.h
//  RapnetPriceModule
//
//  Created by Nikhil Bansal on 12/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@protocol getPriceChangeDelegate
-(void)webserviceCallPriceChangeFinished:(NSMutableArray *)results;

@end

@interface GetPriceChangeParser : NSObject <NSXMLParserDelegate>{
    id<getPriceChangeDelegate> delegate;
	
	NSMutableData *webData;
	NSXMLParser *xmlParser;
	NSMutableDictionary *data;
	NSMutableArray *results;
	NSMutableString *currentElement;
}

@property(retain, nonatomic) id<getPriceChangeDelegate> delegate;
@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, retain) NSXMLParser *xmlParser;
@property(nonatomic, retain) NSMutableArray *results;

-(void)connectToParser:(NSMutableData *)xmldata;
-(void)GetPriceChange:(NSString *)ticket withPriceType:(NSString *)type;
-(NSMutableArray*)getResults;

@end
