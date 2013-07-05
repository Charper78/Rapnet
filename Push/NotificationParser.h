//
//  NotificationParser.h
//  Rapnet
//
//  Created by Home on 5/16/13.
//  Copyright (c) 2013 coolban@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "Notification.h"
#import "Functions.h"
#import "NotificationsHelper.h"
#import "SetMessagesDownloadedParser.h"

@protocol getNotificationsDelegate
-(void)getNotificationsFinished:(NSMutableArray*)res total:(NSInteger)total;

@end

@interface NotificationParser : NSObject<NSXMLParserDelegate>
{
    id<getNotificationsDelegate> _delegate;
    
    NSMutableData *_webData;
	NSXMLParser *_xmlParser;
	
	NSString *_currentElement;
    
    Notification *notification;
    NSMutableArray *results;
    NSMutableString *notificationID;
    NSMutableString *messageData;
    NSMutableString *messageDate;
    
    NSString *curDeviceID;
    
    NSMutableString *downloadedIds;
}

@property(retain, nonatomic) id<getNotificationsDelegate> delegate;
@property(nonatomic, retain) NSXMLParser *xmlParser;
@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, retain) NSString *currentElement;
@property(nonatomic, retain) NSString *strTicket;
//@property(nonatomic, retain) NSMutableArray *results;

-(void)getNotifications:(NSString*)deviceID;
@end
