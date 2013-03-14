//
//  NotifySeller.h
//  Rapnet
//
//  Created by Itzik on 26/11/12.
//  Copyright (c) 2012 coolban@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "Functions.h"

@interface NotifySeller : NSObject<NSXMLParserDelegate>
{
    NSMutableData *webData;
    NSXMLParser *xmlParser;
    NSMutableDictionary *data;
    NSString *currentElement;
    NSString *strTicket;
    NSMutableString *resData;
    BOOL res;
    
}

@property(nonatomic, retain) NSXMLParser *xmlParser;
@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, retain) NSString *currentElement;

-(BOOL)notify:(NSString*)diamondIds body:(NSString*)body;
//-(NSString*)notify:(NSString*)diamondIds from:(NSString*)from body:(NSString*)body subject:(NSString*)subject reference:(NSString*)reference;
-(BOOL)notify:(NSString*)diamondIds body:(NSString*)body subject:(NSString*)subject reference:(NSString*)reference;
-(NSString*)getTagValue:(NSString*)tag val:(NSString*)val;
@end

/*
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
*/