//
//  LoginMain.h
//  Rapnet
//
//  Created by Itzik on 18/05/12.
//  Copyright (c) 2012 coolban@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol loginMainDelegate

-(void)loginCompleted:(BOOL)res;

@end

@interface LoginMain : NSObject<NSXMLParserDelegate>
{
    id<loginMainDelegate> delegate;
    
    NSMutableData *webData;
	NSXMLParser *xmlParser;
	NSMutableDictionary *data;
	NSString *currentElement;
	NSString *strTicket;
}

@property(retain, nonatomic) id<loginMainDelegate> delegate;
@property(nonatomic, retain) NSXMLParser *xmlParser;
@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, retain) NSString *currentElement;
@property(nonatomic, retain) NSString *strTicket;

-(void)connectToParser:(NSMutableData *)xmldata;
-(void)login;
@end
