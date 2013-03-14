//
//  LoginParser.h
//  Rapnet
//
//  Created by NEHA SINGH on 17/05/11.
//  Copyright 2011 TechAhead. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol getAuthTicketDelegate
-(void)webserviceCallFinished;
@end

@interface LoginParser: NSObject<NSXMLParserDelegate>
{
    id<getAuthTicketDelegate> delegate;
	
	NSMutableData *webData;
	NSXMLParser *xmlParser;
	NSMutableDictionary *data;
	NSMutableArray *results;
	NSString *currentElement;
	NSString *strTicket;
}


@property(retain, nonatomic) id<getAuthTicketDelegate> delegate;
@property(nonatomic, retain) NSXMLParser *xmlParser;
@property(nonatomic, retain) NSMutableArray *results;
@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, retain) NSString *currentElement;
@property(nonatomic, retain) NSString *strTicket;

-(void)connectToParser:(NSMutableData *)xmldata;
-(void)authenticateWithUserName:(NSString*)userName password:(NSString*)password;
-(NSMutableArray*)getResults;

@end
