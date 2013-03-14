//
//  GetArticleParser.h
//  Rapnet
//
//  Created by NEHA SINGH on 18/05/11.
//  Copyright 2011 TechAhead. All rights reserved.
//


#import <Foundation/Foundation.h>

@protocol getArticleDelegate
-(void)webserviceCallFinished;

@end

@interface GetArticleParser : NSObject<NSXMLParserDelegate>
{
	id<getArticleDelegate> delegate;

	NSMutableData *webData;
	NSXMLParser *xmlParser;
	NSMutableDictionary *data;
	NSMutableArray *results;
	NSMutableString *currentElement;
	
	//NSMutableString *articleID;
	NSMutableString *title;
	NSMutableString *articleTxt;
	NSMutableString *author;
	NSMutableString *date;
	NSMutableString *articleTyp;
	//NSMutableString *imageURL;
	NSMutableString *videoURL;
	NSMutableString *articleURL;
	NSMutableString *IsAuthenticated;
	
}

@property(retain, nonatomic) id<getArticleDelegate> delegate;
@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, retain) NSXMLParser *xmlParser;

-(void)connectToParser:(NSMutableData *)xmldata;
-(void)getNewsWithArticleId:(NSInteger)articleId;
-(NSMutableArray*)getResults;

@end
