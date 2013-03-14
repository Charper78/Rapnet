//
//  LoginParser.h
//  Rapnet
//
//  Created by Nikhil Bansal on 17/11/11.
//  Copyright 2011 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@protocol getAuthTicketDelegate
-(void)webserviceCallLoginFinished:(NSMutableArray *)results;
@end

@interface LoginPriceParser: NSObject<NSXMLParserDelegate>
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
