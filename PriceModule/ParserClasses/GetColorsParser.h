//
//  GetColorsParser.h
//  RapnetPriceModule
//
//  Created by Nikhil Bansal on 11/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
/*
@protocol getColorDelegate
-(void)webserviceCallColorsFinished;

@end
*/
@interface GetColorsParser : NSObject<NSXMLParserDelegate> {
    //id<getColorDelegate> delegate;
	
	NSMutableData *webData;
	NSXMLParser *xmlParser;
	NSMutableDictionary *data;
	NSMutableArray *results;
	NSMutableString *currentElement;
	
	NSMutableString *colorName;
    NSMutableString *colorTitle;
    
}


//@property(retain, nonatomic) id<getColorDelegate> delegate;
@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, retain) NSXMLParser *xmlParser;
@property(nonatomic, retain) NSMutableArray *results;

-(void)connectToParser:(NSMutableData *)xmldata;
-(NSMutableArray*)GetColorList;
//-(NSMutableArray*)getResults;

@end
