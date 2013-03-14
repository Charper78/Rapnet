//
//  MostViewedParser.h
//  Rapnet
//
//  Created by NEHA SINGH on 18/05/11.
//  Copyright 2011 TechAhead. All rights reserved.
//


#import <Foundation/Foundation.h>

@protocol mostViewedDelegate
-(void)webserviceCallFinished;

@end

@interface MostViewedParser : NSObject<NSXMLParserDelegate>

{
	id<mostViewedDelegate> delegate;
	
	NSMutableData *webData;
	NSXMLParser *xmlParser;
	NSMutableDictionary *data;
	NSMutableArray *results;
	NSMutableString *currentElement;
	
	NSMutableString *articleID;
	NSMutableString *title;
	NSMutableString *viewings;
	NSMutableString *author;
	NSMutableString *IsAuthenticated;
	NSMutableString *articleURL;
	NSMutableString *date;
	NSMutableString *articleTyp;
	NSMutableString *imageURL;
	NSMutableString *videoURL;
}

@property(retain, nonatomic) id<mostViewedDelegate> delegate;
@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, retain) NSXMLParser *xmlParser;

-(void)connectToParser:(NSMutableData *)xmldata;
-(void)GetMostViewedArticles;
-(NSMutableArray*)getResults;

@end


