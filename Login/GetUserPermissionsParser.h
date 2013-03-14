//
//  GetUserPermissionsParser.h
//  Rapnet
//
//  Created by Itzik on 04/08/12.
//  Copyright (c) 2012 coolban@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GetUserPermissions.h"
#import "Constants.h"

@interface GetUserPermissionsParser : NSObject<NSXMLParserDelegate>
{
    
    NSMutableData *webData;
	NSXMLParser *xmlParser;
	NSMutableDictionary *data;
	NSString *currentElement;
	NSString *strTicket;
    GetUserPermissions *userPermissions;
    
    NSMutableString *rapnet;
    NSMutableString *weeklyPrices;
    NSMutableString *monthlyPrices;
    NSMutableString *individual;
}

@property(nonatomic, retain) NSXMLParser *xmlParser;
@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, retain) NSString *currentElement;
@property(nonatomic, retain) NSString *strTicket;

-(GetUserPermissions*)hasPermissions:(NSString*)ticket;

@end
