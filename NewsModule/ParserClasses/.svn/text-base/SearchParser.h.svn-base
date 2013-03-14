//
//  SearchParser.h
//  Rapnet
//
//  Created by NEHA SINGH on 18/05/11.
//  Copyright 2011 TechAhead. All rights reserved.
//



#import <Foundation/Foundation.h>

@protocol searchDelegate
-(void)searchServiceCallFinished;

@end

@interface SearchParser : NSObject<NSXMLParserDelegate>

{
	id<searchDelegate> delegate;

	NSMutableData *webData;
	NSXMLParser *xmlParser;
	NSMutableDictionary *data;
	NSMutableArray *results;
	NSMutableString *currentElement;
	
	NSMutableString *articleID;
	NSMutableString *title;
	NSMutableString *articleTxt;
	NSMutableString *author;
	NSMutableString *date;
	NSMutableString *articleTyp;
	NSMutableString *imageURL;
	NSMutableString *IsAuthenticated;
	NSMutableString *articleURL;
}

@property(retain, nonatomic) id<searchDelegate> delegate;
@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, retain) NSXMLParser *xmlParser;

-(void)connectToParser:(NSMutableData *)xmldata;
-(void)getNewsWithSearchString:(NSString *)searchStr startRow:(NSInteger)startRow endRow:(NSInteger)endRow  articleType:(NSInteger)articleType languageId:(NSInteger)languageId;
-(NSMutableArray*)getResults;

@end


