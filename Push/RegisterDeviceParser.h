//
//  RegisterDeviceParser.h
//  Rapnet
//
//  Created by Home on 3/12/13.
//  Copyright (c) 2013 coolban@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Foundation/Foundation.h>
#import "GetUserPermissions.h"
#import "Constants.h"

@interface RegisterDeviceParser : NSObject<NSXMLParserDelegate>
{
    
    NSMutableData *webData;
	NSXMLParser *xmlParser;
	//NSMutableDictionary *data;
	NSString *currentElement;
    BOOL result;
    
    NSMutableString *resultString;
}

@property(nonatomic, retain) NSXMLParser *xmlParser;
@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, retain) NSString *currentElement;
@property(nonatomic, retain) NSString *strTicket;

-(bool)registerDevice:(NSString*)appName appVersion:(NSString*)appVersion clientID:(NSString*)clientID
          deviceToken:(NSString*)deviceToken
          deviceModel:(NSString*)deviceModel deviceVersion:(NSString*)deviceVersion pushBadge:(BOOL)pushBadge
            pushAlert:(BOOL)pushAlert pushSound:(BOOL)pushSound;

-(bool)registerDevice:(NSString*)appName appVersion:(NSString*)appVersion clientID:(NSString*)clientID
 deviceToken:(NSString*)deviceToken 
deviceModel:(NSString*)deviceModel deviceVersion:(NSString*)deviceVersion pushBadge:(BOOL)pushBadge
pushAlert:(BOOL)pushAlert pushSound:(BOOL)pushSound notifyPriceChange:(BOOL)notifyPriceChange;

@end

///ter erte rtert