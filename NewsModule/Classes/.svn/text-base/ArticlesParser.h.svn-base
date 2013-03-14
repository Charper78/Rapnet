//
//  ArticlesParser.h
//  Rapnet
//
//  Created by NEHA SINGH on 17/05/11.
//  Copyright 2011 TechAhead. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol getAllArticlesDelegate
-(void)webserviceCallFinished;

@end

@interface ArticlesParser : NSObject<NSXMLParserDelegate>

{
	id<getAllArticlesDelegate> delegate;
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
	NSMutableString *totalCount;
	NSMutableString *IsAuthenticated;
	NSMutableString *articleURL;
	NSMutableString *videoURL;
	
}


@property(retain, nonatomic) id<getAllArticlesDelegate> delegate;
@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, retain) NSXMLParser *xmlParser;

-(void)connectToParser:(NSMutableData *)xmldata;
-(void)getNewsWithSearchString:(NSInteger)startRow endRow:(NSInteger)endRow articleTopic:(NSInteger)articleTopic languageId:(NSInteger)languageId;
-(void)getNewsWithSearchString:(NSInteger)startRow endRow:(NSInteger)endRow languageId:(NSInteger)languageId;
-(void)getNewsWithSearchString:(NSInteger)startRow endRow:(NSInteger)endRow articleType:(NSInteger)articleType languageId:(NSInteger)languageId;
-(NSMutableArray*)getResults;

@end
	

