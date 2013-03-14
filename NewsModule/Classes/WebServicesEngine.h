//
//  WebServicesEngine.h
//  HoodHang
//
//  Created by Saurabh Verma on 21/02/11.
//  Copyright 2011 TechAhead. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum
{
    RequestTypeNewsLogin = 0,
    RequestTypeGetNewsTopics,
    RequestTypeGetNewsTypes,
    RequestTypeGetNews,
    RequestTypeGetNewsDetails
}RequestType;

@interface WebServicesEngine : NSObject<NSXMLParserDelegate>

{

    NSMutableData *webData;
	NSXMLParser *xmlParser;
	NSString * strTicket;
    RequestType requestType;
	
}


+ (WebServicesEngine*) sharedInstance;

-(void)authenticateWithUserName:(NSString*)userName password:(NSString*)password;
-(void)getNewsTopics;
-(void)getNewsType;
-(void)getNewsWithSearchString:(NSInteger)startRow endRow:(NSInteger)endRow articleType:(NSInteger)articleType articleTopic:(NSInteger)articleTopic languageId:(NSInteger)languageId;
-(void)getNewsWithArticleId:(NSInteger)articleId;

@end
