//
//  GetClarityParser.h
//  RapnetPriceModule
//
//  Created by Nikhil Bansal on 11/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
/*
@protocol getClarityDelegate
-(void)webserviceCallClarityFinished;

@end
*/
@interface GetClarityParser : NSObject <NSXMLParserDelegate>{
   // id<getClarityDelegate> delegate;
	
	NSMutableData *webData;
	NSXMLParser *xmlParser;
	NSMutableDictionary *data;
	NSMutableArray *results;
	NSMutableString *currentElement;
	
	NSMutableString *clarityName;
    NSMutableString *clarityTitle;
}

//@property(retain, nonatomic) id<getClarityDelegate> delegate;
@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, retain) NSXMLParser *xmlParser;
@property(nonatomic, retain) NSMutableArray *results;

-(void)connectToParser:(NSMutableData *)xmldata;
-(NSMutableArray*)GetClarityList;
//-(NSMutableArray*)getResults;

@end
