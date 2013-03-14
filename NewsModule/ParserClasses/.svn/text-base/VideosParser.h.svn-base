//
//  VideosParser.h
//  Rapnet
//
//  Created by NEHA SINGH on 18/05/11.
//  Copyright 2011 TechAhead. All rights reserved.
//



#import <Foundation/Foundation.h>

@protocol getVideosDelegate
-(void)webserviceCallFinished;

@end

@interface VideosParser : NSObject<NSXMLParserDelegate>
{
	id<getVideosDelegate> delegate;

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

@property(retain, nonatomic) id<getVideosDelegate> delegate;
@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, retain) NSXMLParser *xmlParser;

-(void)connectToParser:(NSMutableData *)xmldata;
-(void)getNewsWithSearchString:(NSInteger)startRow endRow:(NSInteger)endRow  articleType:(NSInteger)articleType languageId:(NSInteger)languageId;
-(NSMutableArray*)getResults;

@end


