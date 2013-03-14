//
//  GetEditorParser.h
//  Rapnet
//
//  Created by NEHA SINGH on 20/05/11.
//  Copyright 2011 TechAhead. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol getEditorDelegate
-(void)webserviceCallFinished;

@end

@interface GetEditorParser : NSObject<NSXMLParserDelegate>

{
	id<getEditorDelegate> delegate;
	
	NSMutableData *webData;
	NSXMLParser *xmlParser;
	NSMutableDictionary *data;
	NSMutableArray *results;
	NSMutableString *currentElement;
	NSMutableString *articleID;
	NSMutableString *title;
	
	NSMutableString *author;
	NSMutableString *date;
	NSMutableString *articleTyp;
	NSMutableString *imageURL;
	NSMutableString *videoURL;
	NSMutableString *articleURL;
	NSMutableString *IsAuthenticated;
}

@property(retain, nonatomic) id<getEditorDelegate> delegate;
@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, retain) NSXMLParser *xmlParser;

-(void)connectToParser:(NSMutableData *)xmldata;
-(void)GetEditorsChoiceArticles;
-(NSMutableArray*)getResults;

@end