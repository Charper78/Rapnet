//
//  ForgotPasswordParser.h
//  Rapnet
//
//  Created by NEHA SINGH on 22/06/11.
//  Copyright 2011 Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol getPasswordDelegate
-(void)serviceCallFinished;

@end

@interface ForgotPasswordParser : NSObject<NSXMLParserDelegate>

{
	id<getPasswordDelegate> delegate;
	
	NSMutableData *webData;
	NSXMLParser *xmlParser;
	NSMutableDictionary *data;
	NSMutableArray *results;
	NSMutableString *currentElement;
	NSMutableString *strSucceed;
	NSMutableString *strMsg;
}

@property(retain, nonatomic) id<getPasswordDelegate> delegate;
@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, retain) NSXMLParser *xmlParser;

-(void)connectToParser:(NSMutableData *)xmldata;
-(void)GetForgotPassword:(NSString*)email;
-(NSMutableArray*)getResults;

@end