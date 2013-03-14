//
//  RelatedArticleParser.h
//  Rapnet
//
//  Created by NEHA SINGH on 31/05/11.
//  Copyright 2011 Tech. All rights reserved.
//


#import <Foundation/Foundation.h>
@protocol getRelArticleDelegate
-(void)webserviceCallFinished;

@end

@interface RelatedArticleParser : NSObject<NSXMLParserDelegate>
{
	id<getRelArticleDelegate> delegate;
	
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
	NSMutableString *IsAuthenticated;
	NSMutableString *articleURL;
	
}

@property(retain, nonatomic) id<getRelArticleDelegate> delegate;
@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, retain) NSXMLParser *xmlParser;

-(void)connectToParser:(NSMutableData *)xmldata;
-(void)getRelatedArticle:(NSInteger)articleId;
-(void)getRelatedVideos:(NSInteger)articleId;
-(NSMutableArray*)getResults;

@end