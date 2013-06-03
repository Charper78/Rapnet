//
//  SetReadMessagesRead.h
//  Rapnet
//
//  Created by Home on 6/3/13.
//  Copyright (c) 2013 coolban@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol setReadMessagesReadDelegate
-(void)setReadMessagesReadFinished:(NSArray*)ids;

@end

@interface SetReadMessagesRead : NSObject<NSXMLParserDelegate>
{
    id<setReadMessagesReadDelegate> _delegate;
    
    NSMutableData *_webData;
	NSXMLParser *_xmlParser;
	NSString *_currentElement;
    
    NSMutableString *data;
    NSMutableString *result;
    
    NSArray *notificationIds;
}

@property(retain, nonatomic) id<setReadMessagesReadDelegate> delegate;

@property(nonatomic, retain) NSXMLParser *xmlParser;
@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, retain) NSString *currentElement;

-(void)setReadMessagesRead:(NSString*)deviceID ids:(NSArray*)ids;
@end
