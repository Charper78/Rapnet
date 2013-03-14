//
//  NewsTopicParser.h
//  Rapnet
//
//  Created by NEHA SINGH on 17/05/11.
//  Copyright 2011 TechAhead. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol getNewsTopicDelegate
-(void)webserviceCallFinished;
@end

@interface NewsTopicParser : NSObject<NSXMLParserDelegate>
{
	id<getNewsTopicDelegate> delegate;
	
	NSMutableData *webData;
	NSXMLParser *xmlParser;
	NSMutableDictionary *data;
	NSMutableArray *results;
	NSMutableString *currentElement;
	NSMutableString *strkey;
	NSMutableString *strValue;
}

@property(retain, nonatomic) id<getNewsTopicDelegate> delegate;
@property(nonatomic, retain) NSXMLParser *xmlParser;
@property(nonatomic, retain) NSMutableData *webData;

-(void)connectToParser:(NSMutableData *)xmldata;
-(void)getNewsTopics;
-(NSMutableArray*)getResults;

@end