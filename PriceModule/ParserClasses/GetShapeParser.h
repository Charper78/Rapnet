//
//  GetShapeParser.h
//  RapnetPriceModule
//
//  Created by Nikhil Bansal on 11/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

/*@protocol getShapeDelegate
-(void)webserviceCallShapeFinished;

@end*/

@interface GetShapeParser : NSObject <NSXMLParserDelegate>{
   // id<getShapeDelegate> delegate;
	
	NSMutableData *webData;
	NSXMLParser *xmlParser;
	NSMutableDictionary *data;
	NSMutableArray *results;
	NSMutableString *currentElement;
	
	NSMutableString *shapeName;
    NSMutableString *shapeTitle;
    NSMutableString *shapeShortTitle;
}

//@property(retain, nonatomic) id<getShapeDelegate> delegate;
@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, retain) NSXMLParser *xmlParser;
@property(nonatomic, retain) NSMutableArray *results;

-(void)connectToParser:(NSMutableData *)xmldata;
-(NSMutableArray*)GetShapeList;
//-(NSMutableArray*)getResults;

@end
