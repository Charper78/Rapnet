//
//  GetAuthArticle.h
//  Rapnet
//
//  Created by NEHA SINGH on 20/06/11.
//  Copyright 2011 Tech. All rights reserved.
//


#import <Foundation/Foundation.h>
@protocol getAuthArticleDelegate
-(void)webserviceCallFinished;

@end

@interface GetAuthArticleParser : NSObject<NSXMLParserDelegate>
{
	id<getAuthArticleDelegate> delegate;
	
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
	NSMutableString *videoURL;
	NSMutableString *articleURL;
	NSMutableString *IsAuthenticated;
	
}

@property(retain, nonatomic) id<getAuthArticleDelegate> delegate;
@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, retain) NSXMLParser *xmlParser;

-(void)connectToParser:(NSMutableData *)xmldata;
-(void)getAuthNews:(NSInteger)articleId;
-(NSMutableArray*)getResults;

@end
