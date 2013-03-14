//
//  GetGridSizeParser.h
//  RapnetPriceModule
//
//  Created by Nikhil Bansal on 12/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@protocol getGridSizeDelegate
-(void)webserviceCallGridSizeFinished;

@end

@interface GetGridSizeParser : NSObject<NSXMLParserDelegate> {
    id<getGridSizeDelegate> delegate;
	
	NSMutableData *webData;
	NSXMLParser *xmlParser;
	NSMutableDictionary *data;
	NSMutableArray *results;
	NSMutableString *currentElement;
}

@property(retain, nonatomic) id<getGridSizeDelegate> delegate;
@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, retain) NSXMLParser *xmlParser;
@property(nonatomic, retain) NSMutableArray *results;

-(void)connectToParser:(NSMutableData *)xmldata;
-(void)GetGridSize;
-(NSMutableArray*)getResults;

@end
