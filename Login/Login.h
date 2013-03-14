//
//  LoginParser.h
//  Rapnet
//
//  Created by Itzik on 18/07/12.
//  Copyright (c) 2012 coolban@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Enums.h"
#import "LoginHelper.h"

@interface Login : NSObject<NSXMLParserDelegate>
{
    NSMutableData *webData;
	NSXMLParser *xmlParser;
	NSMutableDictionary *data;
	NSString *currentElement;
	NSString *strTicket;
}

@property(nonatomic, retain) NSXMLParser *xmlParser;
@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, retain) NSString *currentElement;
@property(nonatomic, retain) NSString *strTicket;

-(NSString*)login:(LoginTypes)l;

@end
